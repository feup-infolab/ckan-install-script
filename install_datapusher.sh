#!/usr/bin/env bash


sudo apt-get -y install python-dev python-virtualenv build-essential libxslt1-dev libxml2-dev zlib1g-dev git libffi-dev
cd ~
git clone https://github.com/ckan/datapusher
cd datapusher

#activate virtual env
virtualenv --no-site-packages /usr/lib/ckan/default
. /usr/lib/ckan/default/bin/activate

pip install -r requirements.txt
pip install -e .

echo "press ctrl c to stop datapusher after it runs..."
python datapusher/main.py deployment/datapusher_settings.py

# enable datapusher in development.ini

# # EDIT - Disable recline_view because of data proxy issues 19-03-2018
# # ckan.plugins = datastore stats image_view recline_view
# ckan.plugins = datastore stats image_view recline_view datapusher

#exit virtualenv
deactivate

#upgrade ckan
sudo dpkg -i ~/python-ckan_2.7-xenial_amd64.deb
