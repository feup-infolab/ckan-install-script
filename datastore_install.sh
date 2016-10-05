#!/usr/bin/env bash

ckan_config_file"/etc/ckan/default/development.ini"
datastore_plugin_activation_line = "ckan.plugins = datastore"
grep -q -F 'datastore_plugin_activation_line' $ckan_config_file || echo 'datastore_plugin_activation_line"' >> $ckan_config_file

#create datastore user and database
sudo -u postgres createuser -S -D -R -P -l datastore_default
sudo -u postgres createdb -O ckan_default datastore_default -E utf-8

#add datastore parameters to the config file

datastore_write_url="ckan.datastore.write_url = postgresql://ckan_default:pass@localhost/datastore_default"
grep -q -F 'datastore_plugin_activation_line' $ckan_config_file || echo 'datastore_plugin_activation_line"' >> $ckan_config_file
datastore_read_url="ckan.datastore.read_url = postgresql://datastore_default:pass@localhost/datastore_default"
grep -q -F 'datastore_plugin_activation_line' $ckan_config_file || echo 'datastore_plugin_activation_line"' >> $ckan_config_file

#set permissions
su ckan
virtualenv --no-site-packages /usr/lib/ckan/default
. /usr/lib/ckan/default/bin/activate

#copy the SQL script produced by this command (without the error stacks that keep appearing...)
paster --plugin=ckan datastore set-permissions -c /etc/ckan/default/development.ini

#....and then paste it in the command line that appears after you run this command:
sudo -u postgres psql --set ON_ERROR_STOP=1
