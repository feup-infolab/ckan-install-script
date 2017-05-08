#!/usr/bin/env bash

site_url="ckan-rdm.up.pt"
site_alias="www.ckan-rdm.up.com"

sudo cp /etc/ckan/default/development.ini /etc/ckan/default/production.ini
sudo apt-get -y install apache2 libapache2-mod-wsgi libapache2-mod-rpaf

#need to stop apache or else nginx gives error while installing
sudo systemctl stop apache2.service
sudo apt-get -y install nginx
sudo systemctl start apache2.service

#Install Nginx (a web server) which will proxy the content from Apache and add a layer of caching
sudo apt-get install postfix

#ckan wsgi file
printf "import os
activate_this = os.path.join('/usr/lib/ckan/default/bin/activate_this.py')
execfile(activate_this, dict(__file__=activate_this))

from paste.deploy import loadapp
config_filepath = os.path.join(os.path.dirname(os.path.abspath(__file__)), 'production.ini')
from paste.script.util.logging_config import fileConfig
fileConfig(config_filepath)
application = loadapp('config:%s' % config_filepath)\n" | sudo tee /etc/ckan/default/apache.wsgi

#apache VHosts file
printf "<VirtualHost 127.0.0.1:5000>
    ServerName $site_url
    ServerAlias $site_alias
    WSGIScriptAlias / /etc/ckan/default/apache.wsgi

    # Pass authorization info on (needed for rest api).
    WSGIPassAuthorization On

    # Deploy as a daemon (avoids conflicts between CKAN instances).
    WSGIDaemonProcess ckan_default display-name=ckan_default processes=2 threads=15

    WSGIProcessGroup ckan_default

    ErrorLog /var/log/apache2/ckan_default.error.log
    CustomLog /var/log/apache2/ckan_default.custom.log combined

    <IfModule mod_rpaf.c>
        RPAFenable On
        RPAFsethostname On
        RPAFproxy_ips 127.0.0.1
    </IfModule>

    <Directory />
        Require all granted
    </Directory>

</VirtualHost>" | sudo tee /etc/apache2/sites-available/ckan_default.conf

#modify apache ports.conflicts
sudo vim /etc/apache2/ports.conf
#replace Listen 80 with Listen 5000, save and quit

#create nginx configuration

printf "proxy_cache_path /tmp/nginx_cache levels=1:2 keys_zone=cache:30m max_size=250m;
proxy_temp_path /tmp/nginx_proxy 1 2;

server {
    client_max_body_size 100M;
    location / {
        proxy_pass http://127.0.0.1:5000/;
        proxy_set_header X-Forwarded-For \$remote_addr;
        proxy_set_header Host \$host;
        proxy_cache cache;
        proxy_cache_bypass \$cookie_auth_tkt;
        proxy_no_cache \$cookie_auth_tkt;
        proxy_cache_valid 30m;
        proxy_cache_key \$host\$scheme\$proxy_host\$request_uri;
        # In emergency comment out line to force caching
        # proxy_ignore_headers X-Accel-Expires Expires Cache-Control;
    }

}" | sudo tee /etc/nginx/sites-available/ckan

sudo a2ensite ckan_default
sudo a2dissite 000-default
sudo rm -vi /etc/nginx/sites-enabled/default
sudo ln -s /etc/nginx/sites-available/ckan /etc/nginx/sites-enabled/ckan_default
sudo service apache2 reload
sudo service nginx reload

#disable default homepage
sudo a2dissite 000-default &&
sudo service apache2 reload
#simply restarting apache is not enough, you need to reboot the machine!
sudo reboot now

#install cli browser to check if things are ok
sudo apt-get -y install lynx &&
lynx http://127.0.0.1

#see list of enabled sites
apache2ctl -S
