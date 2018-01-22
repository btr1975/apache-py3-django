#!/usr/bin/env python3
import os
import subprocess as sub
__author__ = 'Benjamin P. Trachtenberg'
__copyright__ = "Copyright (c) 2017, Benjamin P. Trachtenberg"
__credits__ = None
__license__ = 'The MIT License (MIT)'
__status__ = 'prod'
__version_info__ = (1, 0, 1, __status__)
__version__ = '.'.join(map(str, __version_info__))
__maintainer__ = 'Benjamin P. Trachtenberg'
__email__ = 'e_ben_75-python@yahoo.com'


def create_conf(folder_name, dir_count):
    """
    Function to create apache conf files for loaded sites
    Currently only non-SSL Sites
    :param
        folder_name: The folder name of the site
        dir_count: Count of dirs
    :return:
    """
    temp_list = list()
    temp_list.append('<VirtualHost *:80>')
    if os.environ.get('SITE_SERVER_NAME') and dir_count == 1:
        temp_list.append('    ServerName %s' % (os.environ.get('SITE_SERVER_NAME'),))

    else:
        temp_list.append('    # ServerName www.example.com')

    if os.environ.get('SITE_SERVER_ADMIN') and dir_count == 1:
        temp_list.append('    ServerAdmin %s' % (os.environ.get('SITE_SERVER_ADMIN'),))

    else:
        temp_list.append('    ServerAdmin webmaster@localhost')
    temp_list.append('')
    temp_list.append('    Alias /media/ /DjangoSites/%s/media/' % (folder_name,))
    temp_list.append('')
    temp_list.append('    <Directory /DjangoSites/%s/media>' % (folder_name,))
    temp_list.append('    Order deny,allow')
    temp_list.append('    Require all granted')
    temp_list.append('    </Directory>')
    temp_list.append('')
    temp_list.append('    Alias /static/ /DjangoSites/%s/static/site/' % (folder_name,))
    temp_list.append('')
    temp_list.append('    <Directory /DjangoSites/%s/static/site>' % (folder_name,))
    temp_list.append('    Order deny,allow')
    temp_list.append('    Require all granted')
    temp_list.append('    </Directory>')
    temp_list.append('')
    temp_list.append('    WSGIScriptAlias / /DjangoSites/%s/apache/django.wsgi process-group=%s' % (folder_name,
                                                                                                    folder_name))
    temp_list.append('    WSGIDaemonProcess %s' % (folder_name,))
    temp_list.append('    WSGIProcessGroup %s' % (folder_name,))
    temp_list.append('')
    temp_list.append('    <Directory /DjangoSites/%s/apache>' % (folder_name,))
    temp_list.append('    Order deny,allow')
    temp_list.append('    Require all granted')
    temp_list.append('    </Directory>')
    temp_list.append('')
    temp_list.append('    # Available loglevels: trace8, ..., trace1, debug, info, notice, warn,')
    temp_list.append('    # error, crit, alert, emerg.')
    temp_list.append('    # It is also possible to configure the loglevel for particular')
    temp_list.append('    # modules, e.g.')
    temp_list.append('    LogLevel info')
    temp_list.append('')
    temp_list.append('    ErrorLog ${APACHE_LOG_DIR}/error.log')
    temp_list.append('    CustomLog ${APACHE_LOG_DIR}/access.log combined')
    temp_list.append('')
    temp_list.append('</VirtualHost>')
    temp_list.append('')
    temp_list.append('# vim: syntax=apache ts=4 sw=4 sts=4 sr noet')

    def output_file(orig_list, file_name):
        """
        Function to output the file
        :param orig_list:
        :param file_name:
        :return: file_name
        """

        file_name = '%s.conf' % ('-'.join(file_name.split()).lower(), )

        def add_line_break(list_line):
            """
            Create a line break at the end of a string
            Args:
                list_line: string
            Returns: A string with a line break
            """
            list_line = ('%s\n' % (list_line,))
            return list_line

        write_file = open('/etc/apache2/sites-available/%s' % (file_name, ), "a")
        for orig_list_line in orig_list:
            write_file.write(add_line_break(str(orig_list_line)))
        write_file.close()

        return file_name

    site_to_enable = output_file(temp_list, folder_name)

    sub.call('a2ensite %s > /dev/null' % (site_to_enable,), stderr=sub.STDOUT, shell=True)


def count_dir():
    """
    Function to count how many dirs in a dir
    :return:
        An integer of how many dirs
    """
    temp_list_count = list()

    for item_name in os.listdir(os.getcwd()):
        if os.path.isdir(item_name):
            temp_list_count.append(item_name)

    return len(temp_list_count)


def main():
    """
    Main script function
    :return: None

    """
    dir_count = count_dir()
    
    if os.environ.get('SITE_DIRECTORY_NAME'):
        create_conf(os.environ.get('SITE_DIRECTORY_NAME'), 1)

    else:
        for item_name in os.listdir(os.getcwd()):
            if os.path.isdir(item_name):
                create_conf(item_name, dir_count)

    sub.call('a2dissite 000-default.conf > /dev/null', stderr=sub.STDOUT, shell=True)


main()
