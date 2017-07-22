FROM ubuntu:16.04 as temp1

LABEL maintainer="e_ben_75-python@yahoo.com" \
      important-stopping-note="Stop the server by running apache2ctl stop, this will keep from process hang" \
      description="This is a base Apache2, Python 3.5.2, Python3 mysqlclient, and mod_wsgi for py3 web server for Django." \
      package-name="apache-py3-django" \
      image-version="1.1" \
      django-version="1.11.2" \
      django-localflavor-version="1.5.1" \
      mysqlclient-version="1.3.10"

# Copies the apache conf python script

COPY ./apache-site-conf.py /bin/

# Arguments for Apache conf file builder script if not used, they will use default settings
# SITE_SERVER_NAME = ServerName
# SITE_SERVER_ADMIN = ServerAdmin

ARG SITE_SERVER_NAME
ARG SITE_SERVER_ADMIN

# Directory where Django Sites go

WORKDIR /DjangoSites

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

FROM temp1 as temp2

LABEL image-version="1.2"

# Copies the apache conf python script and shell script

COPY ./apache-site-conf.sh /bin/

RUN chmod 755 /bin/apache-site-conf.sh
