#!/bin/bash

# Check if user is root
if [ $(id -u) != "0" ]; then
    echo "Error: You must be root to run this script, please use root to install LEMP"
    exit 1
fi

# Install Nginx and ngx_pagespeed dependencies
yum -y install wget zip unzip openssl openssl-devel git gcc-c++ pcre-dev pcre-devel zlib-devel make

# Install ngx_pagespeed module
NPS_VERSION=1.9.32.4
wget https://github.com/pagespeed/ngx_pagespeed/archive/release-${NPS_VERSION}-beta.zip
unzip release-${NPS_VERSION}-beta.zip
cd ngx_pagespeed-release-${NPS_VERSION}-beta/
wget https://dl.google.com/dl/page-speed/psol/${NPS_VERSION}.tar.gz
tar -xzvf ${NPS_VERSION}.tar.gz
cd

# Install Nginx
NGINX_VERSION=1.8.0
wget http://nginx.org/download/nginx-${NGINX_VERSION}.tar.gz
tar -xvzf nginx-${NGINX_VERSION}.tar.gz
cd nginx-${NGINX_VERSION}/
./configure --add-module=$HOME/ngx_pagespeed-release-${NPS_VERSION}-beta --with-http_gzip_static_module --with-http_realip_module --with-http_ssl_module
make
make install
cd

# Download the Nginx configuration files
touch /usr/local/nginx/conf/nginx.conf
touch /etc/init.d/nginx

wget https://raw.githubusercontent.com/leocosta/elasticbeanstalk-ngx_pagespeed/master/conf/nginx/nginx.conf -O /usr/local/nginx/conf/nginx.conf
wget https://raw.githubusercontent.com/leocosta/elasticbeanstalk-ngx_pagespeed/master/conf/nginx/nginx.init.txt -O /etc/init.d/nginx

chmod +x /etc/init.d/nginx
chkconfig nginx on

# Remove install files
/bin/rm -rf /root/nginx-1.8.0
/bin/rm -rf /root/nginx-1.8.0.tar.gz
/bin/rm -rf /root/ngx_pagespeed-release-1.9.32.4-beta
/bin/rm -rf /root/release-1.9.32.4-beta.zip

sleep 5

# Starting services
service nginx start
chkconfig nginx on

echo "COMPLETE."
