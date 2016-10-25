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
NGINX_VERSION=1.8.1
wget http://nginx.org/download/nginx-${NGINX_VERSION}.tar.gz
tar -xvzf nginx-${NGINX_VERSION}.tar.gz
cd nginx-${NGINX_VERSION}/
./configure --add-module=/home/ec2-user/ngx_pagespeed-release-${NPS_VERSION}-beta --with-http_gzip_static_module --with-http_realip_module --with-http_ssl_module --http-client-body-temp-path=/var/lib/nginx/tmp/client_body --http-proxy-temp-path=/var/lib/nginx/tmp/proxy --http-fastcgi-temp-path=/var/lib/nginx/tmp/fastcgi --http-uwsgi-temp-path=/var/lib/nginx/tmp/uwsgi --http-scgi-temp-path=/var/lib/nginx/tmp/scgi --pid-path=/var/run/nginx.pid --lock-path=/var/lock/subsys/nginx --user=nginx --group=nginx --with-ipv6 --with-http_ssl_module --with-http_spdy_module --with-http_realip_module --with-http_addition_module  --with-http_sub_module --with-http_dav_module --with-http_flv_module --with-http_mp4_module --with-http_gunzip_module --with-http_gzip_static_module --with-http_random_index_module --with-http_secure_link_module --with-http_degradation_module --with-http_stub_status_module --with-mail --with-mail_ssl_module --with-pcre --with-pcre-jit --with-debug --with-cc-opt='-O2 -g -pipe -Wall -Wp,-D_FORTIFY_SOURCE=2 -fexceptions -fstack-protector --param=ssp-buffer-size=4 -m64 -mtune=generic' --with-ld-opt=' -Wl,-E'
make
make install
cd

# Download the Nginx configuration files
mkdir -p /var/lib/nginx/tmp/client_body
mkdir -p /usr/local/nginx/conf
touch /usr/local/nginx/conf/nginx.conf
touch /usr/local/nginx/conf/webapp.conf
touch /etc/init.d/nginx

# wget https://raw.githubusercontent.com/leocosta/elasticbeanstalk-ngx_pagespeed/master/conf/nginx/eb-nginx.conf -O /usr/local/nginx/conf/nginx.conf
wget https://raw.githubusercontent.com/leocosta/elasticbeanstalk-ngx_pagespeed/master/conf/nginx/nginx.conf -O /usr/local/nginx/conf/nginx.conf
wget https://raw.githubusercontent.com/leocosta/elasticbeanstalk-ngx_pagespeed/master/conf/nginx/webapp.conf -O /usr/local/nginx/conf/webapp.conf
wget https://raw.githubusercontent.com/leocosta/elasticbeanstalk-ngx_pagespeed/master/conf/nginx/nginx.init.txt -O /etc/init.d/nginx

chmod +x /etc/init.d/nginx
chkconfig nginx on

# Remove install files
/bin/rm -rf /root/nginx-1.8.1
/bin/rm -rf /root/nginx-1.8.1.tar.gz
/bin/rm -rf /root/ngx_pagespeed-release-1.9.32.4-beta
/bin/rm -rf /root/release-1.9.32.4-beta.zip

# Stop Apache
# service httpd stop

sleep 5

# Replace the httpd process with an empty process
# mv /usr/sbin/httpd /usr/sbin/httpd.disabled
# touch /usr/sbin/httpd
# echo '#!/bin/bash' >> /usr/sbin/httpd
# chmod 755 /usr/sbin/httpd

# Starting services
service nginx start
chkconfig nginx on

echo "COMPLETE."
