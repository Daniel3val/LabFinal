#SE DA LA OPCION DE UTILIZAR EL SCRIPT PARA CONFIGURAR WORDPRESS.


sudo yum update -y
sudo yum upgrade -y
sudo su


sudo amazon-linux-extras install postgresql14 -y
sudo amazon-linux-extras enable php8.2
yum clean metadata
yum install php-cli php-pdo php-fpm php-json php-mysqlnd php-pgsql php-xml php-gd php-curl php-zip php-mbstring -y
sudo yum install php php-cli php-fpm php-mysqlnd -y

systemctl daemon-reload
# Instalar Apache y configurar SSL
sudo yum install httpd -y
sudo systemctl start httpd
sudo systemctl enable httpd

#Descargar modulo PostgreSQL for WordPress
cd /var/www/html
wget https://github.com/PostgreSQL-For-Wordpress/postgresql-for-wordpress/archive/refs/tags/v3.3.1.zip
unzip v3.3.1.zip

wget https://es.wordpress.org/wordpress-6.6.2-es_ES.zip
unzip wordpress-6.6.2-es_ES.zip
cp -rp wordpress/* /var/www/html
rm -rf wordpress
rm -rf wordpress-6.6.2-es_ES.zip
cd postgresql-for-wordpress-3.3.1/
mv pg4wp /var/www/html/wp-content/
cd /var/www/html/wp-content/pg4wp
cp db.php /var/www/html/wp-content
cd /var/www/html
cp wp-config-sample.php wp-config.php
sudo yum install libapache2-mod-php8.3  #ELIMINAR
systemctl restart httpd

sudo chmod -R 755 /var/www/html


# Habilitar SSL y reescritura en Apache
sudo yum install mod_ssl -y
sudo systemctl restart httpd

# Crear certificados SSL
cd /home
mkdir certificados
cd certificados
openssl req -x509 -nodes -days 365 -newkey rsa:2048 -keyout clave.pem -out certificado.pem -subj "/C=ES/ST=Malaga/L=Malaga/O=HAB/OU=HAB/CN=*.amazonaws.com/emailAddress=labfinal@gmail.com"

# Configurar SSL en Apache
cd /etc/httpd/conf.d
sudo rm -f ssl.conf
echo '<VirtualHost *:443>
    DocumentRoot "/var/www/html"
    ServerName labfinal-alb-704354129.us-east-1.elb.amazonaws.com

    SSLEngine on
    SSLCertificateFile /home/certificados/certificado.pem
    SSLCertificateKeyFile /home/certificados/clave.pem

    SSLProtocol all -SSLv2 -SSLv3
    SSLCipherSuite HIGH:!aNULL:!MD5

    <Directory "/var/www/html">
        AllowOverride All
    </Directory>

    <FilesMatch \.php$>
        SetHandler application/x-httpd-php
    </FilesMatch>
</VirtualHost>' | sudo tee /etc/httpd/conf.d/ssl.conf


echo 'ServerRoot "/etc/httpd"
Listen 443
Include conf.modules.d/*.conf
User apache
Group apache
ServerAdmin root@localhost
<Directory />
    AllowOverride none
    Require all denied
</Directory>
DocumentRoot "/var/www/html"
<Directory "/var/www">
    AllowOverride None
    Require all granted
</Directory>
<Directory "/var/www/html">
    Options Indexes FollowSymLinks
    AllowOverride None
    Require all granted
</Directory>
<IfModule dir_module>
    DirectoryIndex index.html
</IfModule>
<Files ".ht*">
    Require all denied
</Files>
ErrorLog "logs/error_log"
LogLevel warn

<IfModule log_config_module>
    LogFormat "%h %l %u %t \"%r\" %>s %b \"%{Referer}i\" \"%{User-Agent}i\"" combined
    LogFormat "%h %l %u %t \"%r\" %>s %b" common

    <IfModule logio_module>
      LogFormat "%h %l %u %t \"%r\" %>s %b \"%{Referer}i\" \"%{User-Agent}i\" %I %O" combinedio
    </IfModule>
    CustomLog "logs/access_log" combined
</IfModule>

<IfModule alias_module>
    ScriptAlias /cgi-bin/ "/var/www/cgi-bin/"

</IfModule>
<Directory "/var/www/cgi-bin">
    AllowOverride None
    Options None
    Require all granted
</Directory>

<IfModule mime_module>
    TypesConfig /etc/mime.types

    AddType application/x-compress .Z
    AddType application/x-gzip .gz .tgz

    AddType text/html .shtml
    AddOutputFilter INCLUDES .shtml
</IfModule>
AddDefaultCharset UTF-8

<IfModule mime_magic_module>
    MIMEMagicFile conf/magic
</IfModule>

EnableSendfile on
<IfModule mod_http2.c>
    Protocols h2 h2c http/1.1
</IfModule>
IncludeOptional conf.d/*.conf' | sudo tee /etc/httpd/conf/httpd.conf

sudo systemctl restart httpd
cd /var/www/html
curl -sS https://getcomposer.org/installer -o composer-setup.php
php composer-setup.php --install-dir=/usr/local/bin --filename=composer
php /usr/local/bin/composer require aws/aws-sdk-php

sudo tee /var/www/html/wp-config.php > /dev/null << 'EOF'
<?php

/** The name of the database for WordPress */
define( 'DB_NAME', 'labfinaldb' );

/** Database username */
define( 'DB_USER', 'labfinaluser' );

/** Database password */
define( 'DB_PASSWORD', '1[it~R*d5brJu6PH>$k~2e*o8EdO' );

/** Database hostname */
define( 'DB_HOST', 'db.labfinal.internal' );

/** Database charset to use in creating database tables. */
define( 'DB_CHARSET', 'utf8' );

/** The database collate type. Don't change this if in doubt. */
define( 'DB_COLLATE', '' );

/** Unique keys and salts. */
define( 'AUTH_KEY',         'put your unique phrase here' );
define( 'SECURE_AUTH_KEY',  'put your unique phrase here' );
define( 'LOGGED_IN_KEY',    'put your unique phrase here' );
define( 'NONCE_KEY',        'put your unique phrase here' );
define( 'AUTH_SALT',        'put your unique phrase here' );
define( 'SECURE_AUTH_SALT', 'put your unique phrase here' );
define( 'LOGGED_IN_SALT',   'put your unique phrase here' );
define( 'NONCE_SALT',       'put your unique phrase here' );

/** WordPress database table prefix. */
$table_prefix = 'wp_';

/** Debugging mode. */
define( 'WP_DEBUG', false );

/** Absolute path to the WordPress directory. */
if ( ! defined( 'ABSPATH' ) ) {
    define( 'ABSPATH', __DIR__ . '/' );
}

/** Sets up WordPress vars and included files. */
require_once ABSPATH . 'wp-settings.php';

EOF

sudo chmod -R 755 /var/www/html
systemctl restart httpd

curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar
chmod +x wp-cli.phar
sudo mv wp-cli.phar /usr/local/bin/wp
echo 'export PATH=$PATH:/usr/local/bin' | sudo tee -a /etc/profile
source /etc/profile




wp core install --url="https://${alb_dns}" --title="Laboratorio final by Daniel" --admin_user="admin" --admin_password="LabfinaL3456_" --admin_email="daniel1val@hotmail.es" --allow-root