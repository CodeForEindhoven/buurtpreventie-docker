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
sed -i "s/_DATABASE_HOST/$DB_PORT_3306_TCP_ADDR/g" /webdir/app/config/parameters.yml
sed -i "s/_DATABASE_PORT/$DB_PORT_3306_TCP_PORT/g" /webdir/app/config/parameters.yml
sed -i "s/_DATABASE_USER/$DB_ENV_MYSQL_USER/g" /webdir/app/config/parameters.yml
sed -i "s/_DATABASE_PASS/$DB_ENV_MYSQL_PASS/g" /webdir/app/config/parameters.yml
sed -i "s/__LOCALE__/$APP_LOCALE/g" /webdir/app/config/parameters.yml
sed -i "s/__SECRET__/$APP_SECRET/g" /webdir/app/config/parameters.yml
sed -i "s/__AUTHOR__/$APP_AUTHOR/g" /webdir/app/config/parameters.yml
sed -i "s/__TITLE__/$APP_TITLE/g" /webdir/app/config/parameters.yml
sed -i "s/__DESC__/$APP_DESCRIPTION/g" /webdir/app/config/parameters.yml
sed -i "s/__WALKERS__/$APP_MIN_WALKERS/g" /webdir/app/config/parameters.yml
sed -i "s/__MONTHS__/$APP_MONTHS/g" /webdir/app/config/parameters.yml
sed -i "s/__RESULT__/$APP_SHOW_RESULT/g" /webdir/app/config/parameters.yml

source /etc/apache2/envvars
tail -F /var/log/apache2/* &
exec apache2 -D FOREGROUND
