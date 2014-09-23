#!/bin/bash

#
# This script will be used as init script within the docker container when the container is started. (the container
# will be started with '/bin/bash /path/to/init.sh' as command)
#

# exit on error
set -e

# set variables
D_REPROVISION=0
if [ "$1" == "--reprovision" ] || [ "$2" == "--reprovision" ]; then
    D_REPROVISION=1
fi
D_RECREATE_BERKSFILE=0
if [ "$1" == "--recreate-berksfile" ] || [ "$2" == "--recreate-berksfile" ]; then
    D_RECREATE_BERKSFILE=1
fi
D_DIR="$(dirname "$0")"
D_IP_ADDRESS="$(hostname --ip-address)"
D_UID="$(stat -c "%u" "$0")"
D_ORIG_UID="$(id -u webserver)"

# update user id of webserver user to the owner of this init script
if [ "$D_UID" -lt "500" ] || [ "$D_UID" -gt "1999" ]; then
    echo "The init.sh script's owner user id will be used as user id for the webserver user in your container."
    echo "Please use the user id of your own local user to avoid permission issues. The user id has to be"
    echo "between 500 and 1999."
    exit 1
fi
if [ "$D_UID" != "$D_ORIG_UID" ]; then
    usermod -u $D_UID webserver
    if test -e /var/lock/apache2; then
        chown -R $D_UID /var/lock/apache2
    fi
    if test -e /var/cache/apache2; then
        chown -R $D_UID /var/cache/apache2
    fi
    if test -e /var/lib/php5/session5; then
        chown -R $D_UID /var/lib/php5/session5/*
    fi
fi

# run chef-solo / berkshelf provisioning
if ! test -e /chef.completed >/dev/null || [ "$D_REPROVISION" = "1" ]; then
    echo
    echo "Running chef-solo / berkshelf provisioning ..."
    echo
    rm -rf /chef
    cp -r -Pav "$D_DIR" /chef
    cd /chef
    if [ "$D_RECREATE_BERKSFILE" = "1" ]; then
        rm -f Berksfile.lock
    fi
    /opt/chef/embedded/bin/berks vendor /chef/cookbooks
    chef-solo -c "/chef/chef.rb" -j "/chef/chef.json"
    echo
    echo "Provisioning completed."
    echo
    touch /chef.completed
fi

# start services
echo
echo "Starting services ..."
echo
/etc/init.d/ssh restart
/etc/init.d/mysql restart
/etc/init.d/apache2 restart
echo
echo "Services started. Server IP is: $D_IP_ADDRESS"
echo
echo "To ssh into the container use: ssh webserver@$D_IP_ADDRESS"
echo
echo "The default password of the webserver user and the database root user is: qweqwe"
echo
echo "You can press Ctrl+C now to get back to your local console."
echo

# keep container running forever (or until it is being stopped)
sleep infinity
