#!/usr/bin/env bash

source ./utils.sh

#wget https://github.com/JetBrains/intellij-community/blob/162.1628/python/testData/debug/pycharm-debug.egg#c12bbfe12f264e78adb80c683b53b0f6607c2d78
wget https://github.com/JetBrains/intellij-community/raw/c12bbfe12f264e78adb80c683b53b0f6607c2d78/python/testData/debug/pycharm-debug.egg

vim  /etc/ckan/default/development.ini
#Add  to development.ini and remove the hash to uncomment
# debug.remote = true
# debug.host.port = 7890

install_extension "https://github.com/NaturalHistoryMuseum/ckanext-dev.git" "ckanext-dev"

# Add 'dev' to development.ini, ckan.plugins section
#ckan.plugins = .... dev

#start ckan in debug mode
paster serve /etc/ckan/default/development.ini
