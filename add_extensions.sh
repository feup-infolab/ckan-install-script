#!/bin/bash

#activate pyenv
#sudo su ckan

activate_pyenv()
{
  echo "activating virtualenv"
  virtualenv --no-site-packages /usr/lib/ckan/default
  source /usr/lib/ckan/default/bin/activate
}

activate_pyenv

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

source ./utils.sh

#install extensions

install_extension "https://github.com/ckan/ckanext-scheming.git" "ckanext-scheming" &&
install_extension "https://github.com/eawag-rdm/ckanext-repeating.git" "ckanext-repeating" &&
install_extension "https://github.com/espona/ckanext-composite.git" "ckanext-composite" "74888af4bbd16fc3be7e796012a5e163dcfdd655" &&
install_extension "https://github.com/espona/ckanext-restricted.git" "ckanext-restricted"

  if [ -d "$checkout_folder_abs_path" ]
  then
    rm -rf "$checkout_folder_abs_path"
  fi

  #pip install -e git+git://github.com/ckan/ckanext-datastorer.git#egg=ckanext-datastorer
  pip install -e "git+$github_url#egg=$checkout_foldername" &&
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

  cd "$CKAN_EXTENSIONS_PATH" || die_on_bad_cd "$CKAN_EXTENSIONS_PATH"
}

#install dependencies

install_extension "https://github.com/ckan/ckanext-scheming.git" "ckanext-scheming" "scheming" &&
install_extension "https://github.com/ckan/ckantoolkit.git" "ckantoolkit" &&
install_extension "https://github.com/ckan/ckanapi.git" "ckanapi" &&
install_extension "https://github.com/eawag-rdm/ckanext-repeating.git" "ckanext-repeating" "repeating" &&
install_extension "https://github.com/espona/ckanext-composite.git" "ckanext-composite" "composite" &&
install_extension "https://github.com/espona/ckanext-restricted.git" "ckanext-restricted" "restricted"

exit
sudo /etc/init.d/apache2 restart
sudo su ckan
activate_pyenv

#fetch the json schema for permissions management
cd "$CKAN_EXTENSIONS_PATH/scheming" || die_on_bad_cd "$CKAN_EXTENSIONS_PATH"
wget https://raw.githubusercontent.com/feup-infolab/ckanext-envidat_schema/master/ckanext/envidat_schema/datacite_dataset.json

#add the word 'restricted' (without the '' quotes) to ckan.plugins in the /etc/ckan/default/development.ini file
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
