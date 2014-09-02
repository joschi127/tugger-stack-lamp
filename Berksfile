source "https://api.berkshelf.com"

cookbook 'apache2'
cookbook 'apt'
cookbook 'build-essential'
cookbook 'memcached'
cookbook 'mysql', git: 'https://github.com/haad/mysql.git'  # fork fixed for docker, see https://github.com/opscode-cookbooks/mysql/issues/194
cookbook 'postgresql'
cookbook 'openssl'
cookbook 'php', git: 'https://github.com/priestjim/chef-php.git'
cookbook 'composer'
cookbook 'postfix'
cookbook 'app', path: './site-cookbooks/app'

