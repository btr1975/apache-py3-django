#!/bin/bash

# This script is to build apache conf files for Django apps
# Version: 1.0 Prod
# Author: Benjamin P. Trachtenberg
# Contact: e_ben_75-python@yahoo.com

declare -r apachedirname="/etc/apache2/sites-available"
apacheconfname=""
declare -r djangodirname="/DjangoSites"

# Check for DjangoSites Directory
if [[ ! -d $djangodirname ]]; then
    echo "No DjangoSites Directory Found!"
    exit 1
fi

# Check for Apache sites-available directory
if [[ ! -d $apachedirname ]]; then
    echo "No Apache sites-available Directory Found!"
    exit 1
fi

if [[ -f "/etc/apache2/sites-enabled/000-default.conf" ]]; then
    a2dissite 000-default.conf > /dev/null
fi

for directory in $(ls $djangodirname); do
    if [[ -d $djangodirname/$directory ]]; then
        apacheconfname="${directory,,}.conf"
        if [[ ! -f "$apachedirname/$apacheconfname" ]]; then
            echo "Creating apache config $apachedirname/$apacheconfname"
            echo "<VirtualHost *:80>" >> $apachedirname/$apacheconfname

            if [[ $(ls -d $djangodirname/*/ | wc -l) = 1 && $SITE_SERVER_NAME ]]; then
                echo " ServerName $SITE_SERVER_NAME" >> $apachedirname/$apacheconfname

            else
                echo " # ServerName www.example.com" >> $apachedirname/$apacheconfname

            fi

            if [[ $(ls -d $djangodirname/*/ | wc -l) = 1 && $SITE_SERVER_ADMIN ]]; then
                echo " ServerAdmin $SITE_SERVER_ADMIN" >> $apachedirname/$apacheconfname

            else
                echo " ServerAdmin webmaster@localhost" >> $apachedirname/$apacheconfname

            fi

            echo "" >> $apachedirname/$apacheconfname
            echo " Alias /media/ /DjangoSites/$directory/media/" >> $apachedirname/$apacheconfname
            echo "" >> $apachedirname/$apacheconfname
            echo " <Directory /DjangoSites/$directory/media>" >> $apachedirname/$apacheconfname
            echo " Order deny,allow" >> $apachedirname/$apacheconfname
            echo " Require all granted" >> $apachedirname/$apacheconfname
            echo " </Directory>" >> $apachedirname/$apacheconfname
            echo "" >> $apachedirname/$apacheconfname
            echo " Alias /static/ /DjangoSites/$directory/static/site/" >> $apachedirname/$apacheconfname
            echo "" >> $apachedirname/$apacheconfname
            echo " <Directory /DjangoSites/$directory/static/site>" >> $apachedirname/$apacheconfname
            echo " Order deny,allow" >> $apachedirname/$apacheconfname
            echo " Require all granted" >> $apachedirname/$apacheconfname
            echo " </Directory>" >> $apachedirname/$apacheconfname
            echo "" >> $apachedirname/$apacheconfname
            echo " WSGIScriptAlias / /DjangoSites/$directory/apache/django.wsgi process-group=$directory" >> $apachedirname/$apacheconfname
            echo " WSGIDaemonProcess $directory" >> $apachedirname/$apacheconfname
            echo " WSGIProcessGroup $directory" >> $apachedirname/$apacheconfname
            echo "" >> $apachedirname/$apacheconfname
            echo " <Directory /DjangoSites/$directory/apache>" >> $apachedirname/$apacheconfname
            echo " Order deny,allow" >> $apachedirname/$apacheconfname
            echo " Require all granted" >> $apachedirname/$apacheconfname
            echo " </Directory>" >> $apachedirname/$apacheconfname
            echo "" >> $apachedirname/$apacheconfname
            echo " # Available loglevels: trace8, ..., trace1, debug, info, notice, warn," >> $apachedirname/$apacheconfname
            echo " # error, crit, alert, emerg." >> $apachedirname/$apacheconfname
            echo " # It is also possible to configure the loglevel for particular" >> $apachedirname/$apacheconfname
            echo " # modules, e.g." >> $apachedirname/$apacheconfname
            echo " LogLevel info" >> $apachedirname/$apacheconfname
            echo "" >> $apachedirname/$apacheconfname
            echo " ErrorLog ${APACHE_LOG_DIR}/error.log" >> $apachedirname/$apacheconfname
            echo " CustomLog ${APACHE_LOG_DIR}/access.log combined" >> $apachedirname/$apacheconfname
            echo "" >> $apachedirname/$apacheconfname
            echo "</VirtualHost>" >> $apachedirname/$apacheconfname
            echo "" >> $apachedirname/$apacheconfname
            echo "# vim: syntax=apache ts=4 sw=4 sts=4 sr noet" >> $apachedirname/$apacheconfname

            a2ensite $apacheconfname > /dev/null

        else
            echo "Can not create apache config $apachedirname/$apacheconfname"
            echo "It already exists remove it and run the script again"

        fi
    fi
done
