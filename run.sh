#!/bin/bash
if [ "$ALLOW_OVERRIDE" = "**False**" ]; then
    unset ALLOW_OVERRIDE
else
    sed -i "s/AllowOverride None/AllowOverride All/g" /etc/apache2/apache2.conf
    a2enmod rewrite
fi
chown www-data:www-data /webdir -R
chmod a+x /webdir/install_prod.sh

sed -i "s/_DATABASE_NAME/$MYSQL_DATABASE/g" /webdir/app/config/parameters.yml
sed -i "s/_DATABASE_HOST/$MYSQL_HOST/g" /webdir/app/config/parameters.yml
sed -i "s/_DATABASE_PORT/$MYSQL_PORT/g" /webdir/app/config/parameters.yml
sed -i "s/_DATABASE_USER/$MYSQL_USER/g" /webdir/app/config/parameters.yml
sed -i "s/_DATABASE_PASS/$MYSQL_PASSWORD/g" /webdir/app/config/parameters.yml

/webdir/install_prod.sh

source /etc/apache2/envvars
tail -F /var/log/apache2/* &
exec apache2 -D FOREGROUND
