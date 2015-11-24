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
  dir '/usr/local' # where to install
  owner 'elasticsearch' # user and group to install under
  group 'elasticsearch'
  version '1.6.0'
  source_url "https://download.elasticsearch.org/elasticsearch/elasticsearch/elasticsearch-1.6.0.tar.gz"
  source_checksum "dc336c83394b2f2f72f362e0f959a4cfdec2109aa3de15668401afeab0b02d2e"    # sha256sum

  action :install # could be :remove as well
end

elasticsearch_configure 'my_elasticsearch' do
  dir '/usr/local'
  user 'elasticsearch'
  group 'elasticsearch'
  logging({:"action" => 'INFO'})

  #allocated_memory '123m'
  #thread_stack_size '512k'
  #
  #env_options '-DFOO=BAR'
  #gc_settings <<-CONFIG
  #              -XX:+UseParNewGC
  #              -XX:+UseConcMarkSweepGC
  #              -XX:CMSInitiatingOccupancyFraction=75
  #              -XX:+UseCMSInitiatingOccupancyOnly
  #              -XX:+HeapDumpOnOutOfMemoryError
  #              -XX:+PrintGCDetails
  #            CONFIG

  configuration ({
    'node.name' => 'webproject'
  })

  action :manage
end

#elasticsearch_plugin 'mobz/elasticsearch-head' do
#  plugin_dir '/usr/local/awesome/elasticsearch-1.5.0/plugins'
#end

elasticsearch_service 'elasticsearch' do
  node_name 'webproject'
  path_conf '/usr/local/etc/elasticsearch'
  pid_path '/usr/local/var/run'
  user 'elasticsearch'
  group 'elasticsearch'
end
