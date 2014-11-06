FROM debian:7.5

MAINTAINER Joschi 127 "127.joschi@gmail.com"

RUN apt-get -y update
RUN apt-get -y upgrade
RUN apt-get -y install build-essential libxml2-dev libxslt-dev git vim nano wget curl autoconf sudo openssh-server bash-completion
RUN adduser --disabled-password --gecos "" webserver
RUN usermod -a -G sudo webserver
RUN echo 'root:qweqwe'|chpasswd
RUN echo 'webserver:qweqwe'|chpasswd

RUN curl -L https://www.opscode.com/chef/install.sh | bash
RUN echo "gem: --no-ri --no-rdoc" > ~/.gemrc
RUN /opt/chef/embedded/bin/gem install berkshelf
