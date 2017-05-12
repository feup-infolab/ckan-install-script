#!/usr/bin/env bash

virtualenv_location="/usr/lib/ckan/default"
ckan_location="/etc/ckan/default"

cd /etc/apache2/sites-available
sudo cp 000-default.conf ckan-repository.conf
