#!/bin/bash

#activate pyenv
su ckan #enter password
virtualenv --no-site-packages /usr/lib/ckan/default
. /usr/lib/ckan/default/bin/activate

#install ckanext-scheming

pip install -E ~/var/srvc/ckan.net/pyenv git+https://github.com/ckan/ckanext-scheming.git

vim /etc/ckan/default/development.ini
#add after 
#[app:main]
# ckan.plugins = ........(there should be some other plugins here) # ADD ckanext-scheming at the end
#save and exit

exit #exit ckan user in the shell, go back to your shell so you can sudo
sudo service jetty8 restart
