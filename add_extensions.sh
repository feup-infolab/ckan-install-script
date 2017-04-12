#!/bin/bash

#activate pyenv
su ckan #enter password
virtualenv --no-site-packages /usr/lib/ckan/default
. /usr/lib/ckan/default/bin/activate

#install dependencies
pip install git+https://github.com/ckan/ckanext-scheming.git
pip install git+https://github.com/eawag-rdm/ckanext-repeating.git
pip install git+https://github.com/espona/ckanext-composite.git
pip install git+https://github.com/espona/ckanext-restricted.git

#add the word 'restricted' (without the '' quotes) to ckan.plugins in the /etc/ckan/default/development.ini file
vim /etc/ckan/default/development.ini

exit #exit ckan user in the shell, go back to your shell so you can sudo
sudo service jetty8 restart
