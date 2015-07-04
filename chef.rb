root = File.absolute_path(File.dirname(__FILE__))

Chef::Config[:no_lazy_load] = true

file_cache_path root
cookbook_path [
  root + '/cookbooks',
  root + '/site-cookbooks'
]
