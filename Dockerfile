# Base Apache2 Server for Running Django Apps
FROM ubuntu:16.04

LABEL maintainer="e_ben_75-python@yahoo.com" \
      important-stopping-note="Stop the server by running apache2ctl stop, this will keep from process hang" \
      description="This is a base Apache2, Python 3.5.2, Python3 MySQL-Connector, and mod_wsgi for py3 web server for Django." \
      image-version="1.0" \
      django-version="1.11.2" \
      django-localflavor-version="1.5.1" \
      mysql-connector-version="2.0.4"

RUN apt-get update && apt-get install -y apache2 \
    python3 \
    python3-pip \
    python3-mysql.connector \
    libapache2-mod-wsgi-py3 \
    && apt-get clean \
    && mkdir /DjangoSites \
    && chmod 755 /DjangoSites \
    && pip3 install --upgrade pip \
    && pip3 install Django==1.11.2 \
    && pip3 install django-localflavor==1.5.1

EXPOSE 80 443

ENTRYPOINT ["apache2ctl", "-D", "FOREGROUND"]
