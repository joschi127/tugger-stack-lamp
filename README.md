Docker LAMP Stack
=================

A simple LAMP stack designed for running a local development environment
for Apache, MySQL, PHP in a Docker container.

It is based on a Debian image and will use chef-solo / berkshelf
provisioning to setup the web server environment.

Build image
-----------

To build the image from the Dockerfile run:

    docker build -t docker_lamp_stack .

Create and run new container image
----------------------------------

To create a container running the image use the following command:

    docker run --name my_project_name -v $(dirname $(pwd)):/var/www/s5-distribution/ -i -t docker_lamp_stack /bin/bash -c "/etc/init.d/mysql restart; /etc/init.d/apache2 restart; su webserver -l"

Stop container
--------------

To stop the running container use:

    docker stop my_project_name

Start existing container
------------------------

To restart an existing container use:

    docker start -i my_project_name /bin/bash -c "/etc/init.d/mysql restart; /etc/init.d/apache2 restart; su webserver -l"

Delete container
----------------

To delete a container:

    docker rm my_project_name

Show running containers and running processes
---------------------------------------------

To show the running containers use:

    docker ps

To show all containers, including stopped containers: (add `-s` to show the size)

    docker ps -a

To show the processes in a running counteiner you can use:

    docker top my_project_name
