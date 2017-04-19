#!/bin/bash

#activate pyenv
sudo su ckan
virtualenv --no-site-packages /usr/lib/ckan/default
. /usr/lib/ckan/default/bin/activate

cd ~ || die_on_bad_cd "$HOME"
pip install -e 'git+https://github.com/ckan/ckan.git@ckan-2.5.2#egg=ckan'
pip install -r /usr/lib/ckan/default/src/ckan/requirements.txt --allow-all-external

export CKAN_EXTENSIONS_PATH=/usr/lib/ckan/default/src/ckan/ckanext

source ./utils.sh

#install extensions

install_extension "https://github.com/ckan/ckanext-scheming.git" "ckanext-scheming" &&
install_extension "https://github.com/eawag-rdm/ckanext-repeating.git" "ckanext-repeating" &&
install_extension "https://github.com/espona/ckanext-composite.git" "ckanext-composite" &&
install_extension "https://github.com/espona/ckanext-restricted.git" "ckanext-restricted"

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
