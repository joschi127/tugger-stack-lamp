Docker LAMP Stack
=================

A simple LAMP stack designed for running a local development environment for Apache, MySQL, PHP in a Docker container.

It is based on a Debian image and will use chef-solo / berkshelf provisioning to setup the web server environment.

Build Docker image
------------------

To build the image from the Dockerfile run:

    docker build -t docker_lamp_stack .

This has to be done once only. You can use the created Docker image for several projects by creating one container
per project.

Create and run new container
----------------------------

To create a container running the image use the following command:

    docker run --name my_project_name --hostname my_project_name -v $(dirname $(pwd)):/var/www/my_project_name/ -i -t docker_lamp_stack /bin/bash /var/www/my_project_name/Docker/init.sh --provision

Save the state as image:

    docker commit my_project_name my_project_name_image

Run again from saved state:

    docker run --name my_project_name --hostname my_project_name -v $(dirname $(pwd)):/var/www/my_project_name/ -i -t my_project_name_image /bin/bash /var/www/my_project_name/Docker/init.sh

Stop running container
----------------------

To stop a running container use:

    docker stop my_project_name

Start existing container
------------------------

To restart an existing container use:

    docker start -i my_project_name

Delete container
----------------

To delete a container:

    docker rm my_project_name

Show running containers and running processes
---------------------------------------------

To show the running containers use:

    docker ps

To show the latest container, no matter if running or stopped:

    docker ps -l

To show all containers, including stopped containers: (add `-s` to show the size)

    docker ps -a

To show the processes in a running container you can use:

    docker top my_project_name
