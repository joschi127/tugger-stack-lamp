#
# Cookbook Name:: app
# Recipe:: elasticsearch
#
# Copyright 2015, joschi127
#

elasticsearch_user 'elasticsearch' do
  username 'elasticsearch'
  groupname 'elasticsearch'
  shell '/bin/bash'
  comment 'Elasticsearch User'

  action :create
end

elasticsearch_install 'my_es_installation' do
  type :tarball # type of install
  version '1.7.2'
  action :install # could be :remove as well
end

elasticsearch_configure 'my_elasticsearch' do
  logging({:"action" => 'INFO'})

  configuration ({
    'node.name' => 'webproject'
  })

  action :manage
end

#elasticsearch_plugin 'mobz/elasticsearch-head' do
#  plugin_dir '/usr/local/awesome/elasticsearch-1.5.0/plugins'
#end

elasticsearch_service 'elasticsearch' do
end
