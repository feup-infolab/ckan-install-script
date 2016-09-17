# ckan-install-script
A Bash script to (partially!) automate [CKAN](http://ckan.org/) installation

**Don't just run the script!**
It is intended as a record of an installation of CKAN 2.5 on Ubuntu Server 16.04.
Copy and paste every line while following the [tutorial](http://docs.ckan.org/en/latest/maintaining/installing/index.html).

Several minor (but important) changes had to be introduced to the tutorial for this Ubuntu distro, namely:

##Jetty

The config file is /etc/default/jetty8 instead of /etc/default/jetty

##Startup as a service

systemd script added to start [CKAN](http://ckan.org/) as a service. This is intended to allow the python virtualenv to be loaded on service startup.
