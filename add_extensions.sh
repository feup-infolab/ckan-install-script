#!/bin/bash

#activate pyenv
sudo su ckan
virtualenv --no-site-packages /usr/lib/ckan/default
. /usr/lib/ckan/default/bin/activate

cd ~ || die_on_bad_cd "$HOME"
pip install -e 'git+https://github.com/ckan/ckan.git@ckan-2.5.2#egg=ckan'
pip install -r /usr/lib/ckan/default/src/ckan/requirements.txt --allow-all-external

export CKAN_EXTENSIONS_PATH=/usr/lib/ckan/default/src/ckan/ckanext

die_on_bad_cd()
{
  local folder=$1
  echo "Unable to cd to $folder"
  exit 1
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

  if [ -f "$checkout_folder_abs_path/requirements.txt" ]
  then
    pip install -r requirements.txt
  fi
}

#install extensions

install_extension "https://github.com/ckan/ckanext-scheming.git" "ckanext-scheming" "scheming" &&
install_extension "https://github.com/eawag-rdm/ckanext-repeating.git" "ckanext-repeating" "repeating" &&
install_extension "https://github.com/espona/ckanext-composite.git" "ckanext-composite" "composite" &&
install_extension "https://github.com/espona/ckanext-restricted.git" "ckanext-restricted" "restricted"

#replace the text in the /etc/ckan/default/development.ini file
vim /etc/ckan/default/development.ini

#replace from
## Plugins Settings
#to
#ckan.views.default_views = image_view text_view recline_view
#with the text in the plugin_settings.ini file

cd /usr/lib/ckan/default/src/ckan || die_on_bad_cd "$CKAN_EXTENSIONS_PATH"
paster serve /etc/ckan/default/development.ini

exit #exit ckan user in the shell, go back to your shell so you can sudo
sudo service jetty8 restart
