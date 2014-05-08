#!/usr/bin/env bash

USER=vagrant
USERHOME=/home/vagrant
NGINX_VERSION="1.4.7"
NGINX_PATH=/data/program/nginx
NODE_VERSION="0.10.28"

apt-get update
apt-get install -y build-essential curl git vim nmap

chown -R $USER $USERHOME

mkdir -p /data/logs /data/program

# install nginx
apt-get install -y gcc libpcre3 libpcre3-dev zlib1g zlib1g-dev libssl-dev ntp
cd ~

wget http://nginx.org/download/nginx-${NGINX_VERSION}.tar.gz
tar xzvf nginx-${NGINX_VERSION}.tar.gz

cd nginx-${NGINX_VERSION}
./configure --prefix=${NGINX_PATH}-${NGINX_VERSION} \
--error-log-path=/data/logs/nginx/error.log \
--http-log-path=/data/logs/nginx/access.log \
--with-http_ssl_module \
--with-http_stub_status_module

make && make install
ln -s ${NGINX_PATH}-${NGINX_VERSION} ${NGINX_PATH}

chown -R $USER $NGINX_PATH/conf
chown -R $USER $NGINX_PATH/html

cd ${NGINX_PATH}

# install nvm

git clone https://github.com/creationix/nvm.git /home/$USER/.nvm
echo "source /home/$USER/.nvm/nvm.sh" >> /home/$USER/.profile

chown -R $USER /home/$USER

USERDO="su - $USER sh -c"
${USERDO} "nvm install $NODE_VERSION"
${USERDO} "nvm alias default $NODE_VERSION"
