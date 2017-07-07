# Base Apache2 Server for Running Django Apps
FROM btr1975/apache-py3-django:1.1

LABEL maintainer="e_ben_75-python@yahoo.com" \
      important-stopping-note="Stop the server by running apache2ctl stop, this will keep from process hang" \
      description="This is a base Apache2, Python 3.5.2, Python3 mysqlclient, and mod_wsgi for py3 web server for Django." \
      image-version="1.2" \
      django-version="1.11.2" \
      django-localflavor-version="1.5.1" \
      mysqlclient-version="1.3.10"

# Copies the apache conf python script and shell script

COPY  ./apache-site-conf.py /bin/
COPY  ./apache-site-conf.sh /bin/

# Arguments for Apache conf file builder script if not used, they will use default settings
# SITE_SERVER_NAME = ServerName
# SITE_SERVER_ADMIN = ServerAdmin

ARG SITE_SERVER_NAME
ARG SITE_SERVER_ADMIN

# Directory where Django Sites go

WORKDIR /DjangoSites

RUN chmod 755 /bin/apache-site-conf.py \
    && chmod 755 /bin/apache-site-conf.sh

EXPOSE 80 443

ENTRYPOINT ["apache2ctl", "-D", "FOREGROUND"]
