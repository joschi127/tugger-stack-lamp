FROM debian:7.5

MAINTAINER Joschi 127 "127.joschi@gmail.com"

RUN apt-get -y update
RUN apt-get -y --force-yes upgrade
RUN apt-get -y install build-essential python libxml2-dev libxslt-dev git vim nano wget curl autoconf sudo openssh-server bash-completion
RUN adduser --disabled-password --gecos "" webserver
RUN usermod -a -G sudo webserver
RUN echo 'root:qweqwe'|chpasswd
RUN echo 'webserver:qweqwe'|chpasswd

# chef version is given in tugger 'lib/tugger-container-init/provision' and in tugger-stack 'Dockerfile'
RUN curl -L https://www.chef.io/chef/install.sh | bash -s -- -v 12.21.1
RUN echo "gem: --no-ri --no-rdoc" > ~/.gemrc
RUN /opt/chef/embedded/bin/gem install berkshelf
