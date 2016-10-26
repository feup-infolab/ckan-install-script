#!/usr/bin/env bash

sudo mkdir -p /var/lib/ckan/default

#add line in ini file

sudo vim /etc/ckan/default/development.ini

#add after [app:main]
#ckan.storage_path = /var/lib/ckan/default

#set permissions on the uploads folder

sudo chown www-data /var/lib/ckan/default
sudo chmod u+rwx /var/lib/ckan/default

sudo service jetty8 restart
