#!/bin/bash

if [ "$EUID" -ne 0 ]; then
	echo "Please run as root or with sudo"
	exit 1
fi

read -p "Enter the site name: " siteName

apache_config_dir="/etc/apache2/sites-available"
config_file="${apache_config_dir}/${siteName}.conf"
if [ -f "$config_file" ]; then
	echo 'Error: Config file for '"$siteName"' already exists.'
	exit 1
fi

echo '<VirtualHost *:80>
ServerName '"$siteName"'
DocumentRoot /var/www/html/'"$siteName"'/
ErrorLog \${APACHE_LOG_DIR}/'"$siteName"'_error.log
CustomLog \${APACHE_LOG_DIR}/'"$siteName"'_access.log combined
</VirtualHost>' > "$config_file"

if [ $? -eq 0 ]; then 
	echo 'Successfully created '$config_file
else
	echo 'Could not create '$config_file
	exit 1
fi
