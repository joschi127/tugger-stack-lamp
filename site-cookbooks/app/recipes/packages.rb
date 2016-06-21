#
# Cookbook Name:: app
# Recipe:: packages
#
# Copyright 2013, Mathias Hansen
#

# Install app packages
node['app']['packages'].each do |a_package|
  package a_package
end
