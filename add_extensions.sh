#!/bin/bash

#activate pyenv
su ckan #enter password
virtualenv --no-site-packages /usr/lib/ckan/default
. /usr/lib/ckan/default/bin/activate

#install dependencies
pip install git+https://github.com/ckan/ckanext-scheming.git
pip install git+https://github.com/ckan/ckantoolkit.git
pip install git+https://github.com/ckan/ckanapi.git
pip install git+https://github.com/eawag-rdm/ckanext-repeating.git
pip install git+https://github.com/espona/ckanext-composite.git
pip install git+https://github.com/espona/ckanext-restricted.git

#fetch the json schema for permissions management
sudo su ckan
cd /home/ckan/ckanext-scheming/ckanext/scheming
wget https://raw.githubusercontent.com/feup-infolab/ckanext-envidat_schema/master/ckanext/envidat_schema/datacite_dataset.json

#add the word 'restricted' (without the '' quotes) to ckan.plugins in the /etc/ckan/default/development.ini file
vim /etc/ckan/default/development.ini

# after:
## Plugins Settings

## Note: Add ``datastore`` to enable the CKAN DataStore
##       Add ``datapusher`` to enable DataPusher
##               Add ``resource_proxy`` to enable resorce proxying and get around the
##               same origin policy
# ckan.plugins = stats text_view image_view recline_view datastore repeating composite restricted scheming_datasets
# scheming.dataset_schemas = /etc/ckan/default/datacite_dataset.json
# scheming.presets = ckanext.scheming:presets.json
# scheming.dataset_fallback = false


cd /usr/lib/ckan/default/src/ckan
paster serve /etc/ckan/default/development.ini

exit #exit ckan user in the shell, go back to your shell so you can sudo
sudo service jetty8 restart

