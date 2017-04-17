#!/bin/bash

#activate pyenv
sudo su ckan
virtualenv --no-site-packages /usr/lib/ckan/default
. /usr/lib/ckan/default/bin/activate

#update pip, install setuptools
pip install setuptools==30.4.0
pip install setuptools==31.0.0
pip install pip==8.1.0
pip install -U sentry
pip install --upgrade pip

cd ~ || die_on_bad_cd "$HOME"
pip install -e 'git+https://github.com/ckan/ckan.git@ckan-2.5.2#egg=ckan'
pip install -r /usr/lib/ckan/default/src/ckan/requirements.txt --allow-all-external

export CKAN_EXTENSIONS_PATH=/usr/lib/ckan/default/src/ckan/ckanext

die_on_bad_cd()
{
  local folder=$1
  echo "Unable to cd to $folder"
  #exit 1
}

install_extension()
{
  local github_url=$1
  local checkout_foldername=$2
  local softlink_name=$3

  local checkout_folder_abs_path="$CKAN_EXTENSIONS_PATH/$checkout_foldername"
  local softlink_abs_path="$CKAN_EXTENSIONS_PATH/$softlink_name"

  if [ -d "$checkout_folder_abs_path" ]
  then
    rm -rf "$checkout_folder_abs_path"
  fi

  git clone "$github_url" "$checkout_folder_abs_path"
  cd "$checkout_folder_abs_path" &&
  python setup.py develop

  if [ -f "$checkout_folder_abs_path/dev-requirements.txt" ]
  then
    pip install -r dev-requirements.txt
  fi

  cd "$CKAN_EXTENSIONS_PATH" || die_on_bad_cd "$CKAN_EXTENSIONS_PATH"

  echo "oftlink_abs_path $softlink_abs_path"
  echo "checkout_destination_abs_path $checkout_destination_abs_path"

  if [ "$softlink_name" != "" ] && [ "$softlink_abs_path" != "$checkout_destination_abs_path" ]
  then
    #ln -s A B #2nd is the linkname
    echo "removing link $softlink_abs_path"
    rm -rf $softlink_abs_path

    echo "adding link $checkout_folder_abs_path to $softlink_abs_path"
    ln -s $checkout_folder_abs_path $softlink_abs_path
  fi

  cd "$CKAN_EXTENSIONS_PATH" || die_on_bad_cd "$CKAN_EXTENSIONS_PATH"
}

#install dependencies

#install_extension "https://github.com/ckan/ckanext-scheming.git" "ckanext-scheming" "scheming" &&
#install_extension "https://github.com/ckan/ckantoolkit.git" "ckantoolkit" &&
#install_extension "https://github.com/ckan/ckanapi.git" "ckanapi" &&
install_extension "https://github.com/eawag-rdm/ckanext-repeating.git" "ckanext-repeating" "repeating" &&
install_extension "https://github.com/espona/ckanext-composite.git" "ckanext-composite" "composite" &&
install_extension "https://github.com/espona/ckanext-restricted.git" "ckanext-restricted" "restricted"

#fetch the json schema for permissions management
cd "$CKAN_EXTENSIONS_PATH/scheming" || die_on_bad_cd "$CKAN_EXTENSIONS_PATH"
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

cd /usr/lib/ckan/default/src/ckan || die_on_bad_cd "$CKAN_EXTENSIONS_PATH"
paster serve /etc/ckan/default/development.ini

exit #exit ckan user in the shell, go back to your shell so you can sudo
sudo service jetty8 restart
