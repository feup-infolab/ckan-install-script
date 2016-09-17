# ckan-install-script
A Bash script to (partially!) automate CKAN installation

**Don't just run the script!**
It is intended as a record of an installation of CKAN 2.5 on Ubuntu Server 16.04.
Copy and paste every line while following the [http://docs.ckan.org/en/latest/maintaining/installing/index.html][tutorial]

Several minor (but important) changes had to be introduced to the tutorial for this Ubuntu distro, namely

##Jetty

The config file is /etc/default/jetty8 instead of /etc/default/jetty

##Startup as a service

systemd script added to start CKAN as a service.
