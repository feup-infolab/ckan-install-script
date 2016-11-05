#!/usr/bin/env bash

sudo mkdir -p /var/lib/ckan/default

#add line in ini file

sudo vim /etc/ckan/default/development.ini

#add after [app:main]
#ckan.storage_path = /var/lib/ckan/default

#set permissions on the uploads folder

#create storage files
sudo mkdir -p /var/lib/ckan/resources
sudo chmod u+rwx /var/lib/ckan/resources

sudo mkdir -p /var/lib/ckan/default
sudo chmod u+rwx /var/lib/ckan/default

sudo chown -R ckan /var/lib/ckan/

sudo service jetty8 restart
