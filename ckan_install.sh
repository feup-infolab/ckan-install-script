#!/usr/bin/env bash

sudo apt-get install python-dev postgresql libpq-dev python-pip python-virtualenv git-core solr-jetty

#create ckan user
adduser ckan

mkdir -p ~/ckan/lib
sudo ln -s ~/ckan/lib /usr/lib/ckan
mkdir -p ~/ckan/etc
sudo ln -s ~/ckan/etc /etc/ckan

sudo mkdir -p /usr/lib/ckan/default
sudo chown `whoami` /usr/lib/ckan/default

export LC_ALL="en_US.UTF-8"
export LC_CTYPE="en_US.UTF-8"

virtualenv --no-site-packages /usr/lib/ckan/default
. /usr/lib/ckan/default/bin/activate

cd ~
pip install -e 'git+https://github.com/ckan/ckan.git@ckan-2.5.2#egg=ckan'

pip install -r /usr/lib/ckan/default/src/ckan/requirements.txt

##	for verification
#deactivate
#. /usr/lib/ckan/default/bin/activate

#check databases (must be utf8)
sudo -u postgres psql -l

#create postgresql user
sudo -u postgres createuser -S -D -R -P ckan_default

sudo -u postgres createdb -O ckan_default ckan_default -E utf-8

#Create a CKAN config file
sudo mkdir -p /etc/ckan/default
sudo chown -R `whoami` /etc/ckan/
sudo chown -R `whoami` ~/ckan/etc

printf "Edit Jetty config file at /etc/default/jetty8"
read 

#Replace the default schema.xml file with a symlink to the CKAN schema file included in the sources.
sudo mv /etc/solr/conf/schema.xml /etc/solr/conf/schema.xml.bak
sudo ln -s /usr/lib/ckan/default/src/ckan/ckan/config/solr/schema.xml /etc/solr/conf/schema.xml

sudo service jetty8 restart

#check if jetty runs at the correct port
telnet localhost 8983

#change solr url in ckan config file to solr_url=http://127.0.0.1:8983/solr
vim /etc/ckan/default/development.ini

#Create database tables
cd /usr/lib/ckan/default/src/ckan
pip install -I html5lib==0.9999999
paster db init -c /etc/ckan/default/development.ini

#link who.ini
ln -s /usr/lib/ckan/default/src/ckan/who.ini /etc/ckan/default/who.ini

#start server
cd /usr/lib/ckan/default/src/ckan
paster serve /etc/ckan/default/development.ini

#set up ckan service
sudo touch /var/log/ckan_port_5000.log
sudo chown ckan /var/log/ckan_port_5000.log
sudo chmod 0666 /var/log/ckan_port_5000.log

sudo rm -rf /etc/systemd/system/ckan_port_5000.service
sudo touch /etc/systemd/system/ckan_port_5000.service
sudo chmod 0655 /etc/systemd/system/ckan_port_5000.service
sudo mkdir /var/lib/ckan

#create a script file at /usr/lib/ckan/default/src/ckan/startup.sh to load it in the service. oneliner in ExecStart command was not working because you need to source the virtualenv init script???

printf "
#!/usr/bin/env bash
export LC_ALL=en_US.UTF-8
export LC_CTYPE=en_US.UTF-8
virtualenv --no-site-packages /usr/lib/ckan/default
source /usr/lib/ckan/default/bin/activate
paster serve /etc/ckan/default/development.ini
" | sudo tee /usr/lib/ckan/default/src/ckan/startup.sh

sudo chmod +x /usr/lib/ckan/default/src/ckan/startup.sh

printf "[Unit]
Description=CKAN Instance at Port 5000 
[Service]
Type=simple
Restart=on-failure
RestartSec=5s
RuntimeMaxSec=infinity
TimeoutStartSec=infinity
User=ckan
WorkingDirectory=/usr/lib/ckan/default/src/ckan
KillMode=control-group
ExecStart=/bin/bash -c '/usr/lib/ckan/default/src/ckan/startup.sh | tee /var/log/ckan_port_5000.log'
[Install]
WantedBy=multi-user.target\n" | sudo tee /etc/systemd/system/ckan_port_5000.service

sudo systemctl daemon-reload
sudo systemctl reload
sudo systemctl enable ckan_port_5000
sudo systemctl start ckan_port_5000







