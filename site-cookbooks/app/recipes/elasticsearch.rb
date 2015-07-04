#
# Cookbook Name:: app
# Recipe:: elasticsearch
#
# Copyright 2015, joschi127
#

include_recipe "elasticsearch"

elasticsearch_user 'elasticsearch' do
  username 'elasticsearch'
  groupname 'elasticsearch'
  homedir '/usr/local/elasticsearch'
  shell '/bin/bash'
  comment 'Elasticsearch User'

  action :create
end

elasticsearch_install 'my_es_installation' do
  type :source # type of install
  dir '/usr/local' # where to install
  owner 'elasticsearch' # user and group to install under
  group 'elasticsearch'
  version '1.6.0'

  action :install # could be :remove as well
end


