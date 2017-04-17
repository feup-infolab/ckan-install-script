#!/bin/bash

#activate pyenv
su ckan #enter password
virtualenv --no-site-packages /usr/lib/ckan/default
. /usr/lib/ckan/default/bin/activate

#update pip, install setuptools
pip install setuptools==30.4.0
pip install setuptools==31.0.0
pip install pip==8.1.0
pip install -U sentry
pip install --upgrade pip

export CKAN_EXTENSIONS_PATH=/usr/lib/ckan/default/src/ckan/ckanext

install_extension()
{
  local github_url=$1
  local checkout_foldername=$2
  local softlink_name=$3

  local checkout_folder_abs_path="${$CKAN_EXTENSIONS_PATH/$checkout_foldername}"
  local softlink_abs_path="${$CKAN_EXTENSIONS_PATH/$checkout_foldername}"

  rm -rf "$checkout_folder_abs_path" &&
  cd "$checkout_folder_abs_path" &&
  python setup.py develop &&
  pip install -r dev-requirements.txt &&
  cd "$CKAN_EXTENSIONS_PATH" &&
  if [ "$softlink_name" != "" ]
  then
    #ln -s A B #2nd is the linkname
    ln -s $checkout_folder_abs_path $softlink_abs_path
  fi
}

#install dependencies

install_extension "https://github.com/ckan/ckanext-scheming.git" "ckanext-scheming" "scheming"
install_extension "https://github.com/ckan/ckantoolkit.git" "ckantoolkit"
install_extension "https://github.com/ckan/ckanapi.git" "ckanapi"
install_extension "https://github.com/eawag-rdm/ckanext-repeating.git" "ckanext-repeating" "repeating"
install_extension "https://github.com/espona/ckanext-composite.git" "ckanext-composite" "composite"
install_extension "https://github.com/espona/ckanext-restricted.git" "ckanext-restricted" "restricted"

#fetch the json schema for permissions management
cd "$CKAN_EXTENSIONS_PATH/scheming" &&
wget https://raw.githubusercontent.com/feup-infolab/ckanext-envidat_schema/master/ckanext/envidat_schema/datacite_dataset.json

#add the word 'restricted' (without the '' quotes) to ckan.plugins in the /etc/ckan/default/development.ini file
vim /etc/ckan/default/development.ini

# START_CHANGES:

## Plugins Settings

## Note: Add ``datastore`` to enable the CKAN DataStore
##       Add ``datapusher`` to enable DataPusher
##               Add ``resource_proxy`` to enable resorce proxying and get around the
##               same origin policy
#ckan.plugins = stats text_view image_view recline_view datastore scheming scheming_datasets repeating composite restricted

#scheming.dataset_schemas = ckanext.scheming:datacite_dataset.json
#scheming.presets = ckanext.scheming:presets.json
#scheming.dataset_fallback = false

# END_CHANGES

cd /usr/lib/ckan/default/src/ckan &&
paster serve /etc/ckan/default/development.ini

exit #exit ckan user in the shell, go back to your shell so you can sudo
sudo service jetty8 restart
