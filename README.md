# lnmpv1
ubuntu14.04,nginx,mysql5.6,php5.4
A Dockerfile that installs the nginx,mysql5.6,php5-fpm,phpmyadmin on ubuntu14.04 LST.

## Installation

If you'd like to build the image yourself then:

```bash
$ git clone https://github.com/myzero1/lnmpv1.git
$ cd lampv1
$ sudo docker build -t="myzero1/lnmpv1" .
```

## Usage

To spawn a new instance of wordpress on port 80.  The -p 80:80 maps the internal docker port 80 to the outside port 80 of the host machine.

```bash
$ sudo docker run -p 80:80 --name lampv1 -d myzero1/lnmpv1
```

Start your newly created docker.

```
$ sudo docker start lnmpv1
```

After starting the docker-wordpress-nginx check to see if it started and the port mapping is correct.  This will also report the port mapping between the docker container and the host machine.

```
$ sudo docker ps

0.0.0.0:80 -> 80/tcp lnmpv1
```

You can the visit the following URL in a browser on your host machine to get started:

```
http://127.0.0.1:80
http://127.0.0.1/phpmyadmin/
```
## notice
  * The defualt user of mysql is root;
  
  * The defualt password of mysql is root;
  
  * You can change it in Dockerfile
    ```
    # add and config mysql 
    RUN echo 'mysql-server-5.6 mysql-server/root_password password root' | sudo debconf-set-selections
    RUN echo 'mysql-server-5.6 mysql-server/root_password_again password root' | sudo debconf-set-selections
    ```



