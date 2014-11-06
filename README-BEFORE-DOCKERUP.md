Docker LAMP Stack
=================

A simple LAMP stack designed for running a local development environment for Apache, MySQL, PHP in a Docker container.

It is based on a Debian image and will use chef-solo / berkshelf provisioning to setup the web server environment.

Install in you project
----------------------

Clone this repo into a subfolder named `Docker` within your web project's root folder:

    cd /path/to/project-name
    git clone https://github.com/joschi127/docker-lamp-stack.git Docker

If you want to use this for several projects you have to install a copy for each project for now.

Build Docker image
------------------

To build the image from the Dockerfile run:

    cd /path/to/project-name/Docker
    docker build -t docker_lamp_stack .

This has to be done once only. You can use the created Docker image for several projects by creating one container
per project.

Create and run new container
----------------------------

To create a container running the image use the following command:

    cd /path/to/project-name/Docker
    docker run --name project-name --hostname project-name -v $HOME/.ssh/:/home/webserver/.ssh/ -v $HOME/.gitconfig:/home/webserver/.gitconfig -v $(dirname $(pwd)):/var/www/webproject/ -t docker_lamp_stack /bin/bash /var/www/webproject/Docker/init.sh

Stop running container
----------------------

To stop a running container use:

    docker stop project-name

Start existing container
------------------------

To restart an existing container use:

    docker start -i project-name

Delete container
----------------

To delete a container:

    docker rm project-name

Show running containers and running processes
---------------------------------------------

To show the running containers use:

    docker ps

To show the latest container, no matter if running or stopped:

    docker ps -l

To show all containers, including stopped containers: (add `-s` to show the size)

    docker ps -a

To show the processes in a running container you can use:

    docker top project-name

Find IP of running container
----------------------------

To find the IP of a container you can use:

    docker inspect project-name | grep IPAddress

SSH into running container
--------------------------

To access a shell in the container, use SSH like this:

    # replace 172.17.0.2 with the IP of your container
    ssh webserver@172.17.0.2

Your project folder (`/path/to/project-name` in the example commands above) will be mounted under `/var/www/webproject` in the container.

So to execute command line tools (like for example `composer`) in your container, chdir into this folder:

    cd /var/www/webproject
    # then for example you can call: composer install -o

Access webserver of running container
-------------------------------------

Just open the container IP in your browser: (from the same computer that is running the docker container)

    http://172.17.0.2

For accessing the webserver from other devices in your LAN (for example from a mobile device) you can open a SSH tunnel to map a port:

    # replace 172.17.0.2 with the IP of your container
    ssh -f -N -L *:8080:localhost:80 webserver@172.17.0.2

Then you should be able to access the webserver from other devices in your LAN by opening an URL like this:

    # replace 10.0.0.123 with the LAN IP of the machine which is running the docker container
    http://10.0.0.123:8080

Manage images
-------------

Save the state of a container as image:

    docker stop project-name
    docker commit project-name project-name-image

Run again from saved state:

    cd /path/to/project-name/Docker
    docker run --name project-name --hostname project-name -v $HOME/.ssh/:/home/webserver/.ssh/ -v $HOME/.gitconfig:/home/webserver/.gitconfig -v $(dirname $(pwd)):/var/www/webproject/ -t project-name-image /bin/bash /var/www/webproject/Docker/init.sh [ --reprovision ]

To show available images use:

    docker images

To delete an image:

    docker rmi project-name-image
