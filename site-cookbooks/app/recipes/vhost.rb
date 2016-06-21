#
# Cookbook Name:: app
# Recipe:: vhost
#
# Copyright 2013, Mathias Hansen
# Copyright 2015, joschi127
#

# Define app name
app_name = "#{node['app']['name']}"

# Enable vhost
web_app app_name do
  server_name node['app']['server_name']
  server_aliases node['app']['server_aliases']
  docroot node['app']['docroot']
  log_dir node['apache']['log_dir'] 
end

# Disable default vhost config
apache_site "000-default" do
  enable false
end

# Add server name and server aliases to /etc/hosts
hostsfile_entry '127.0.0.1' do
  hostname  'localhost'
  aliases   [ node['app']['server_name'] ].concat( node['app']['server_aliases'] )
  comment   'Updated by recipe vhost.rb'
  unique    true
  action    :append
end
