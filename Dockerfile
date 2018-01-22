# Base Apache2 Server for Running Django Apps for docker hub auto build
FROM ubuntu:16.04

LABEL maintainer="e_ben_75-python@yahoo.com" \
      important-stopping-note="Stop the server by running apache2ctl stop, this will keep from process hang" \
      description="This is a base Apache2, Python 3.5.2, Python3 mysqlclient, and mod_wsgi for py3 web server for Django." \
      package-name="apache-py3-django" \
      image-version="1.3" \
      django-version="1.11.2" \
      django-localflavor-version="1.5.1" \
      mysqlclient-version="1.3.10"

# Copies the apache conf python script and shell script

COPY  ./apache-site-conf.py /bin/
COPY  ./apache-site-conf.sh /bin/

# Environment variables for Apache conf file builder script if not used, they will use default settings
# SITE_SERVER_NAME=www.example.com
# SITE_SERVER_ADMIN=webmaster@localhost
# SITE_DIRECTORY_NAME=MySiteDir
ENV SITE_SERVER_NAME
ENV SITE_SERVER_ADMIN
ENV SITE_DIRECTORY_NAME

# Directory where Django Sites go

WORKDIR /DjangoSites

RUN chmod 755 /bin/apache-site-conf.py \
    && chmod 755 /bin/apache-site-conf.sh

RUN apt-get update && apt-get install -y apache2 \
    python3 \
    python3-pip \
    libmysqlclient-dev \
    libapache2-mod-wsgi-py3 \
    && apt-get clean \
    && chmod 755 /DjangoSites \
    && chmod 755 /bin/apache-site-conf.py \
    && pip3 install --upgrade pip \
    && pip3 install Django==1.11.2 \
    && pip3 install django-localflavor==1.5.1 \
    && pip3 install mysqlclient==1.3.10

EXPOSE 80 443

ENTRYPOINT ["apache2ctl", "-D", "FOREGROUND"]
