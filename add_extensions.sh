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

#install dependencies
export CKAN_EXTENSIONS_PATH=/usr/lib/ckan/default/src/ckan/ckanext
#ln -s A B #2nd is the linkname

# ckanext-scheming
rm -rf $CKAN_EXTENSIONS_PATH/ckanext-scheming &&
git clone https://github.com/ckan/ckanext-scheming.git && 
cd $CKAN_EXTENSIONS_PATH/ckanext-scheming && 
python setup.py develop && 
pip install -r dev-requirements.txt && 
cd "$CKAN_EXTENSIONS_PATH" && 
ln -s $CKAN_EXTENSIONS_PATH/ckanext-scheming $CKAN_EXTENSIONS_PATH/scheming

# ckantoolkit
rm -rf $CKAN_EXTENSIONS_PATH/ckantoolkit &&
git clone https://github.com/ckan/ckantoolkit.git && 
cd $CKAN_EXTENSIONS_PATH/ckantoolkit && 
python setup.py develop && 
pip install -r dev-requirements.txt && 
cd "$CKAN_EXTENSIONS_PATH" && 

# ckanapi
rm -rf $CKAN_EXTENSIONS_PATH/ckanapi &&
git clone https://github.com/ckan/ckanapi.git && 
cd $CKAN_EXTENSIONS_PATH/ckanapi && 
python setup.py develop && 
pip install -r dev-requirements.txt &&
cd $CKAN_EXTENSIONS_PATH

# ckanext-repeating
rm -rf $CKAN_EXTENSIONS_PATH/ckanext-repeating &&
git clone https://github.com/eawag-rdm/ckanext-repeating.git && 
cd $CKAN_EXTENSIONS_PATH/ckanext-repeating && 
python setup.py develop && 
pip install -r dev-requirements.txt && 
cd "$CKAN_EXTENSIONS_PATH" && 
ln -s $CKAN_EXTENSIONS_PATH/ckanext-repeating $CKAN_EXTENSIONS_PATH/repeating

# ckanext-composite
rm -rf $CKAN_EXTENSIONS_PATH/ckanext-composite &&
git clone https://github.com/espona/ckanext-composite.git && 
cd $CKAN_EXTENSIONS_PATH/ckanext-composite && 
python setup.py develop && 
pip install -r dev-requirements.txt && 
cd "$CKAN_EXTENSIONS_PATH" && 
ln -s $CKAN_EXTENSIONS_PATH/ckanext-composite $CKAN_EXTENSIONS_PATH/composite && 

# ckanext-restricted
rm -rf $CKAN_EXTENSIONS_PATH/ckanext-restricted &&
git clone https://github.com/espona/ckanext-restricted.git && 
cd $CKAN_EXTENSIONS_PATH/ckanext-restricted && 
python setup.py develop && 
pip install -r dev-requirements && 
cd "$CKAN_EXTENSIONS_PATH" && 
ln -s $CKAN_EXTENSIONS_PATH/ckanext-restricted $CKAN_EXTENSIONS_PATH/restricted

# ckantoolkit
rm -rf ckantoolkit
git clone https://github.com/ckan/ckantoolkit.git && 
cd ckantoolkit && 
python setup.py develop && 
pip install -r dev-requirements.txt && 
cd "$CKAN_EXTENSIONS_PATH" && 
ln -s ckanext-ckantoolkit ckantoolkit 

# ckanapi
rm -rf ckanapi
git clone https://github.com/ckan/ckanapi.git && 
cd ckanapi && 
python setup.py develop && 
pip install -r dev-requirements.txt && 
cd "$CKAN_EXTENSIONS_PATH" && 
ln -s ckanext-ckanapi ckanapi

# ckanext-repeating
rm -rf $CKAN_EXTENSIONS_PATH/ckanext-repeating
git clone https://github.com/eawag-rdm/ckanext-repeating.git && 
cd $CKAN_EXTENSIONS_PATH/ckanext-repeating && 
python setup.py develop && 
pip install -r dev-requirements.txt && 
cd "$CKAN_EXTENSIONS_PATH" && 
ln -s $CKAN_EXTENSIONS_PATH/ckanext-repeating $CKAN_EXTENSIONS_PATH/repeating

# ckanext-composite
rm -rf ckanext-composite
git clone https://github.com/espona/ckanext-composite.git && 
cd ckanext-composite && 
python setup.py develop && 
pip install -r dev-requirements.txt && 
cd "$CKAN_EXTENSIONS_PATH" && 
ln -s ckanext-composite composite && 

# ckanext-restricted
rm -rf ckanext-restricted
git clone https://github.com/espona/ckanext-restricted.git && 
cd ckanext-restricted && 
python setup.py develop && 
pip install -r dev-requirements && 
cd "$CKAN_EXTENSIONS_PATH" && 
ln -s ckanext-restricted restricted

#fetch the json schema for permissions management
cd /usr/lib/ckan/default/src/ckan/ckanext/scheming
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

cd /usr/lib/ckan/default/src/ckan
paster serve /etc/ckan/default/development.ini

exit #exit ckan user in the shell, go back to your shell so you can sudo
sudo service jetty8 restart

