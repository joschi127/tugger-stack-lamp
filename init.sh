#!/bin/bash

#
# This script will be used as init script within the docker container when the container is started. (the container
# will be started with '/bin/bash /path/to/init.sh' as command)
#

# exit on error
set -e

# set variables
D_PROVISION=0
if [ "$1" == "--provision" ]; then
    D_PROVISION=1
fi
D_DIR="$(dirname "$0")"
D_IP_ADDRESS="$(hostname --ip-address)"

# run chef-solo / berkshelf provisioning
if [ "$D_PROVISION" = "1" ]; then
    echo
    echo "Running chef-solo / berkshelf provisioning ..."
    echo
    rm -rf /chef
    cp -r -Pav "$D_DIR" /chef
    cd /chef
    rm -f Berksfile.lock
    /opt/chef/embedded/bin/berks vendor /chef/cookbooks
    chef-solo -c "/chef/chef.rb" -j "/chef/chef.json"
    echo
    echo "Provisioning completed."
    echo
fi

# start services
echo
echo "Starting services ..."
echo
/etc/init.d/mysql restart
/etc/init.d/apache2 restart
echo
echo "Services started. Server IP is: $D_IP_ADDRESS"
echo

# show
su webserver -l
