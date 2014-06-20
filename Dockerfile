FROM debian:7.4

MAINTAINER Joschi 127 "127.joschi@gmail.com"

RUN apt-get -y update
RUN apt-get -y install curl build-essential libxml2-dev libxslt-dev git
RUN curl -L https://www.opscode.com/chef/install.sh | bash
RUN echo "gem: --no-ri --no-rdoc" > ~/.gemrc
RUN /opt/chef/embedded/bin/gem install berkshelf

ADD . /chef
RUN cd /chef && rm -f Berksfile.lock && /opt/chef/embedded/bin/berks vendor /chef/cookbooks
RUN chef-solo -c /chef/chef.rb -j /chef/chef.json
