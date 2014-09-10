Docker LAMP Stack
=================

A simple LAMP stack designed for running a local development environment for Apache, MySQL, PHP in a Docker container.

It is based on a Debian image and will use chef-solo / berkshelf provisioning to setup the web server environment.

Install in you project
----------------------

Clone this repo into a subfolder named `Docker` within your web project's root folder:

    cd /path/to/your-web-project
    git clone https://github.com/joschi127/docker-lamp-stack.git Docker

If you want to use this for several projects you have to install a copy for each project for now.

Build Docker image
------------------

To build the image from the Dockerfile run:

    cd /path/to/your-web-project/Docker
    docker build -t docker_lamp_stack .

This has to be done once only. You can use the created Docker image for several projects by creating one container
per project.

Create and run new container
----------------------------

To create a container running the image use the following command:

    cd /path/to/your-web-project/Docker
    docker run --name projectname --hostname projectname -v $HOME/.ssh/:/home/webserver/.ssh/ -v $HOME/.gitconfig:/home/webserver/.gitconfig -v $(dirname $(pwd)):/var/www/webproject/ -t docker_lamp_stack /bin/bash /var/www/webproject/Docker/init.sh

Stop running container
----------------------

To stop a running container use:

    docker stop projectname

Start existing container
------------------------

To restart an existing container use:

    docker start -i projectname

Delete container
----------------

To delete a container:

    docker rm projectname

Show running containers and running processes
---------------------------------------------

To show the running containers use:

    docker ps

To show the latest container, no matter if running or stopped:

    docker ps -l

To show all containers, including stopped containers: (add `-s` to show the size)

    docker ps -a

To show the processes in a running container you can use:

    docker top projectname

Find IP of running container
----------------------------

To find the IP of a container you can use:

    docker inspect projectname | grep IPAddress

Manage images
-------------

Save the state of a container as image:

    docker stop projectname
    docker commit projectname projectname_image

Run again from saved state:

    cd /path/to/your-web-project/Docker
    docker run --name projectname --hostname projectname -v $HOME/.ssh/:/home/webserver/.ssh/ -v $HOME/.gitconfig:/home/webserver/.gitconfig -v $(dirname $(pwd)):/var/www/webproject/ -t projectname_image /bin/bash /var/www/webproject/Docker/init.sh [ --reprovision ]

To show available images use:

    docker images

To delete an image:

    docker rmi projectname_image
