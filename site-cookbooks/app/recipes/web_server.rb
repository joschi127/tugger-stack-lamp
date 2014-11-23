#
# Cookbook Name:: app
# Recipe:: web_server
#
# Copyright 2013, Mathias Hansen
#

# Install Apache
include_recipe "openssl"
include_recipe "apache2"
include_recipe "apache2::mod_php5"
include_recipe "apache2::mod_rewrite"
include_recipe "apache2::mod_ssl"
include_recipe "apache2::mod_proxy"
include_recipe "apache2::mod_proxy_http"

# Set apache run user
bash "set-apache-run-user" do
  notifies :stop, resources("service[apache2]")
  code "sed -i -r -e 's/User www-data/User webserver/g' -e 's/Group www-data/Group webserver/g' /etc/apache2/apache2.conf; sed -i -r -e 's/APACHE_RUN_USER=www-data/APACHE_RUN_USER=webserver/g' -e 's/APACHE_RUN_GROUP=www-data/APACHE_RUN_GROUP=webserver/g' /etc/apache2/envvars; chown -R webserver /run/lock/apache2"
  notifies :start, resources("service[apache2]"), :delayed
end

# Install PHP
directory "/etc/php5/conf.d" do
  owner "root"
  group "root"
  mode 00755
  action :create
end
include_recipe "php::dotdeb"
include_recipe "php"
include_recipe "php::apache2"
include_recipe "php::module_opcache"
include_recipe "php::module_gd"
include_recipe "php::module_imap"
include_recipe "php::module_intl"
include_recipe "php::module_mbstring"
include_recipe "php::module_mcrypt"
include_recipe "php::module_memcache"
include_recipe "php::module_mysql"
#include_recipe "php::module_pgsql"
include_recipe "php::module_curl"
include_recipe "php::module_xml"
include_recipe "php::module_soap"
include_recipe "php::module_ldap"

# update the main pear channel
php_pear_channel 'pear.php.net' do
  action :update
end

# pear install xdebug
php_pear "xdebug" do
  # Specify that xdebug.so must be loaded as a zend extension
  zend_extensions ['xdebug.so']
  action :install
end
bash "enable-xdebug" do
    code <<-endofstring
        echo 'zend_extension=xdebug.so' > /etc/php5/mods-available/xdebug.ini
        echo 'xdebug.remote_enable=On' >> /etc/php5/mods-available/xdebug.ini
        echo 'xdebug.remote_connect_back=On' >> /etc/php5/mods-available/xdebug.ini
        echo 'xdebug.remote_autostart=Off' >> /etc/php5/mods-available/xdebug.ini
        echo 'xdebug.max_nesting_level=500' >> /etc/php5/mods-available/xdebug.ini
        ln -sf /etc/php5/mods-available/xdebug.ini /etc/php5/apache2/conf.d/06-xdebug.ini
        ln -sf /etc/php5/mods-available/xdebug.ini /etc/php5/cli/conf.d/06-xdebug.ini
    endofstring
end

# Fix php.ini, do not use disable_functions
bash "fix-php-ini-disable-functions" do
  code "find /etc/php5/ -name 'php.ini' -exec sed -i -re 's/^(\\s*)disable_functions(.*)/\\1;disable_functions\\2/g' {} \\;"
  notifies :restart, resources("service[apache2]"), :delayed
end

# Install Composer
include_recipe "composer"

