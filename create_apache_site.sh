#!/bin/bash

if [ "$EUID" -ne 0 ]; then
	echo "Please run as root or with sudo"
	exit 1
fi

source .env

read -p "Enter the site name: " siteName

apache_config_dir="/etc/apache2/sites-available"
config_file="${apache_config_dir}/${siteName}.conf"
document_root="/var/www/html/$siteName"

if [ -f "$config_file" ]; then
	echo 'Error: Config file for '"$siteName"' already exists.'
	exit 1
fi

cat <<EOL >"$config_file"
<VirtualHost *:80>
ServerName $siteName
DocumentRoot /var/www/html/$siteName/
ErrorLog \${APACHE_LOG_DIR}/${siteName}_error.log
CustomLog \${APACHE_LOG_DIR}/${siteName}_access.log combined
</VirtualHost>
EOL


if [ $? -eq 0 ]; then 
	echo 'Successfully created '$config_file
else
	echo 'Could not create '$config_file
	exit 1
fi

# Create Document Root Directory
mkdir -p $document_root

# Change the ownership to www-data
chown -R www-data:www-data $document_root

# Set the permissions
chmod -R 775 www-data:www-data $document_root

# Enable the site
a2ensite "${siteName}.conf"

# Reload Apache to apply changes
systemcl reload apache2

# CREATE MySQL database, user and
mysql -u $DB_USER -p$DB_PASSWORD <<MYSQL_SCRIPT
CREATE DATABASE $siteName;
MYSQL_SCRIPT

echo "Site setup complete
