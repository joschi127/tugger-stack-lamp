#
# Cookbook Name:: app
# Recipe:: web_server
#
# Copyright 2013, Mathias Hansen
# Copyright 2015, joschi127
#

# Add dotdeb apt repository
apt_repository 'dotdeb-php' do
  uri 'http://packages.dotdeb.org'
  distribution node['app']['dotdeb_distribution']
  components ['all']
  key "https://www.dotdeb.org/dotdeb.gpg"
  notifies :run, 'execute[apt-get update]', :immediately
end

# Install Apache
include_recipe "openssl"
include_recipe "apache2"
include_recipe "apache2::mod_rewrite"
include_recipe "apache2::mod_ssl"
include_recipe "apache2::mod_proxy"
include_recipe "apache2::mod_proxy_http"
include_recipe "apache2::mod_headers"
include_recipe "apache2::mod_expires"

# Install PHP
include_recipe "php"
include_recipe "php::module_gd"
include_recipe "php::module_mysql"
include_recipe "php::module_pgsql"
include_recipe "php::module_sqlite3"
include_recipe "php::module_curl"
#include_recipe "php::module_xml"
#include_recipe "php::module_soap"
include_recipe "php::module_ldap"
include_recipe "apache2::mod_php5"

# Install extra php packages
['imagemagick', 'php5-imagick', 'php5-intl', 'php5-imap', 'php5-mcrypt', 'php5-memcache', 'php5-redis', 'php5-xdebug', 'php5-dev'].each do |a_package|
  package a_package
end

# Set xdebug extra options
bash "set-xdebug-extra-options" do
  code <<-endofstring
    echo 'xdebug.remote_enable=On' > /etc/php5/mods-available/xdebug-extra-options.ini
    echo 'xdebug.remote_connect_back=On' >> /etc/php5/mods-available/xdebug-extra-options.ini
    echo 'xdebug.remote_autostart=Off' >> /etc/php5/mods-available/xdebug-extra-options.ini
    echo 'xdebug.max_nesting_level=500' >> /etc/php5/mods-available/xdebug-extra-options.ini
    ln -sf /etc/php5/mods-available/xdebug-extra-options.ini /etc/php5/apache2/conf.d/99-xdebug-extra-options.ini
    ln -sf /etc/php5/mods-available/xdebug-extra-options.ini /etc/php5/cli/conf.d/99-xdebug-extra-options.ini
  endofstring
end

# Disable xdebug for composer
bash "disable-xdebug-for-composer" do
  code <<-endofstring
    if ! grep -q "alias composer=" /home/webserver/.bashrc
    then
      echo >> /home/webserver/.bashrc
      echo "# composer without xdebug" >> /home/webserver/.bashrc
      echo "alias composer='COMPOSER_DISABLE_XDEBUG_WARN=1 php -d xdebug.remote_enable=0 -d xdebug.profiler_enable=0 -d xdebug.default_enable=0 /usr/local/bin/composer'" >> /home/webserver/.bashrc
    fi
  endofstring
end

# Fix php.ini, do not use disable_functions
bash "fix-php-ini-disable-functions" do
  code "find /etc/php5/ -name 'php.ini' -exec sed -i -re 's/^(\\s*)disable_functions(.*)/\\1;disable_functions\\2/g' {} \\;"
  notifies :restart, resources("service[apache2]"), :delayed
end

# Set php ini settings
execute "ini-settings-init" do
  command "echo -n > /etc/php5/mods-available/chef-ini-settings.ini"
end
node['php']['ini_settings'].each do |key, value|
  execute "ini-settings-add-#{key}" do
    command "echo '#{key} = #{value}' >> /etc/php5/mods-available/chef-ini-settings.ini"
  end
end
bash "ini-settings-enable" do
  code <<-endofstring
    ln -sf /etc/php5/mods-available/chef-ini-settings.ini /etc/php5/apache2/conf.d/99-chef-ini-settings.ini
    ln -sf /etc/php5/mods-available/chef-ini-settings.ini /etc/php5/cli/conf.d/99-chef-ini-settings.ini
  endofstring
end

# Install Composer
include_recipe "composer"
