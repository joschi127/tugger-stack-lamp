Encoding.default_external = "UTF-8"

source "https://api.berkshelf.com"

cookbook 'apache2'
cookbook 'apt'
cookbook 'build-essential'
cookbook 'memcached'
cookbook 'mysql', git: 'https://github.com/haad/mysql.git'  # fork fixed for docker, see https://github.com/opscode-cookbooks/mysql/issues/194
cookbook 'postgresql'
cookbook 'elasticsearch', git: 'https://github.com/elastic/cookbook-elasticsearch.git', tag: 'f206b836473f291ecfca678c4ffbb4dfd187bbfe'     # upcoming version 4
cookbook 'openssl'
cookbook 'php', git: 'https://github.com/priestjim/chef-php.git'
cookbook 'composer'
cookbook 'postfix'
cookbook 'hostsfile'
cookbook 'app', path: './site-cookbooks/app'

