#!/usr/bin/env bash

sudo su ckan
cd /usr/lib/ckan/default/src/ckan
. /usr/lib/ckan/default/bin/activate

admin_user='admin'
paster sysadmin add $admin_user -c /etc/ckan/default/development.ini
