#!/usr/bin/env bash
export LC_ALL=en_US.UTF-8
export LC_CTYPE=en_US.UTF-8
virtualenv --no-site-packages /usr/lib/ckan/default
source /usr/lib/ckan/default/bin/activate
paster serve /etc/ckan/default/development.ini | tee /var/log/ckan_port_5000.log
