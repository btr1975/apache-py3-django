# Docker-Image: apache-py3-django

## Created By: Benjamin P. Trachtenberg 

### Contact Information:  e_ben_75-python@yahoo.com
### Send me an e-mail if you have any questions

### LinkedIn: [Ben Trachtenberg](https://www.linkedin.com/in/ben-trachtenberg-3a78496)
### Docker Hub: [Image](https://hub.docker.com/r/btr1975/apache-py3-django/)

### About

This image is for Python Django Apps written in Python 3

### Image Versions in apache-py3-django:1.0

* Python: 3.5.2
* Apache: 2.4.18 (Ubuntu) with mod_wsgi py3 version
* Django: 1.11.2
* Django-Localflavor: 1.5.1
* MySQL-Connector: 2.0.4

### Image Versions in apache-py3-django:1.1

* Python: 3.5.2
* Apache: 2.4.18 (Ubuntu) with mod_wsgi py3 version
* Django: 1.11.2
* Django-Localflavor: 1.5.1
* mysqlclient: 1.3.10

### Image Versions in apache-py3-django:1.2

* Python: 3.5.2
* Apache: 2.4.18 (Ubuntu) with mod_wsgi py3 version
* Django: 1.11.2
* Django-Localflavor: 1.5.1
* mysqlclient: 1.3.10
* apache-site-conf.py: 1.0.1.prod
* apache-site-conf.sh: 1.0 prod

### Image Versions in apache-py3-django:1.3

* Added ENV SITE_DIRECTORY_NAME, to bot conf build scripts, to helb build easier

### Docker-Image Version Tags
* latest
* 1.0
* 1.1
* 1.2
* 1.3

#### -- Version News: apache-py3-django:1.2 --
* Updated Python script that builds the apache conf file
* Added a bash script that builds the apache conf file
* Both scripts do the same thing, so use whichever you want.

### Important usage info
```
There are 3 important ENV varibales you should use when using this

ENV SITE_SERVER_NAME
ENV SITE_SERVER_ADMIN
ENV SITE_DIRECTORY_NAME

Set these befor running the apache-site-conf.py, or apache-site-conf.sh script.

```

### Example Dockerfile
```yaml
FROM btr1975/apache-py3-django:1.3

ENV SITE_SERVER_NAME="www.example.com"
ENV SITE_SERVER_ADMIN="admin@example.com"
ENV SITE_DIRECTORY_NAME="SomeDir"

COPY ./SomeDir .

RUN chmod 755 -R /DjangoSites \
    && /bin/apache-site-conf.sh

```




