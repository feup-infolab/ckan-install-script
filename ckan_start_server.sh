#!/usr/bin/env bash

#activate python virtualenv
su ckan
virtualenv --no-site-packages /usr/lib/ckan/default
. /usr/lib/ckan/default/bin/activate

#start server
cd /usr/lib/ckan/default/src/ckan &&
paster serve /etc/ckan/default/development.ini
