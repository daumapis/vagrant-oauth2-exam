#!/usr/bin/env bash

USER=vagrant
USERHOME=/home/vagrant
PROGRAM_PATH=/data/program
LOG_PATH=/data/logs

apt-get update
apt-get install -y build-essential curl git vim nmap

chown -R $USER $USERHOME

mkdir -p ${LOG_PATH} ${PROGRAM_PATH}

# install nginx
NGINX_VERSION="1.4.7"
NGINX_PATH=$PROGRAM_PATH/nginx

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
NODE_VERSION="0.10.28"
git clone https://github.com/creationix/nvm.git /home/$USER/.nvm
echo "source /home/$USER/.nvm/nvm.sh" >> /home/$USER/.profile

chown -R $USER /home/$USER

USERDO="su - $USER sh -c"
${USERDO} "nvm install $NODE_VERSION"
${USERDO} "nvm alias default $NODE_VERSION"

# install express-generator
${USERDO} "npm install -g express-generator"
