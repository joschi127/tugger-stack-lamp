FROM debian:7.5

MAINTAINER Joschi 127 "127.joschi@gmail.com"

RUN apt-get -y update
RUN apt-get -y install curl build-essential libxml2-dev libxslt-dev git sudo
RUN echo -e "\n# Allow members of group sudo to execute any command\n%sudo   ALL=(ALL:ALL) ALL\n" >> /etc/sudoers
RUN adduser --disabled-password --gecos "" webserver
RUN usermod -a -G sudo webserver
RUN echo 'root:qweqwe'|chpasswd
RUN echo 'webserver:qweqwe'|chpasswd
RUN curl -L https://www.opscode.com/chef/install.sh | bash
RUN echo "gem: --no-ri --no-rdoc" > ~/.gemrc
RUN /opt/chef/embedded/bin/gem install berkshelf

ADD . /chef
RUN cd /chef && rm -f Berksfile.lock && /opt/chef/embedded/bin/berks vendor /chef/cookbooks
RUN chef-solo -c /chef/chef.rb -j /chef/chef.json
