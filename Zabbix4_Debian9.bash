#!/bin/bash

# Atualiza o Repositorio e os Pacotes

apt update && apt upgrade -y

# Baixa e Instala o Pacote do MySQL

wget https://repo.mysql.com/mysql-apt-config_0.8.11-1_all.deb
dpkg -i mysql-apt-config_0.8.11-1_all.deb

# Instala o MySQL

apt install mysql-server 

# Baixa e Instala o Pacote do Zabbix 4 para Debian 9

wget https://repo.zabbix.com/zabbix/4.0/debian/pool/main/z/zabbix-release/zabbix-release_4.0-2+stretch_all.deb
dpkg -i zabbix-release_4.0-2+stretch_all.deb

# Instala os Pacotes do Zabbix

apt -y install zabbix-server-mysql zabbix-frontend-php zabbix-agent zabbix-get

export DEBIAN_FRONTEND=noninteractive

mysql -uroot -e "CREATE DATABASE zabbix CHARACTER SET utf8 COLLATE utf8_bin";
mysql -uroot -e "CREATE USER 'zabbix'@'localhost'";
mysql -uroot -e "GRANT ALL ON zabbix.* TO 'zabbix'@'localhost'";

mysql -uroot -e "SHOW DATABASES";
mysql -uroot -e "SELECT host, user FROM mysql.user";
mysql -uroot -e "SHOW GRANTS FOR 'zabbix'@'localhost'";

zcat /usr/share/doc/zabbix-server-mysql/create.sql.gz | mysql -uroot zabbix

a2enconf zabbix-frontend-php 
> /var/www/html/index.html 

sed -i 's/# php_value date.timezone Europe\/Riga/php_value date.timezone America\/Sao_Paulo/g' /etc/apache2/conf-enabled/zabbix.conf

# Reinicia o Apache2 e Habilita a Inicialização com o Sistema

systemctl restart apache2 && systemctl enable apache2 

# Baixa as dependências do Grafana 

apt-get install -y adduser libfontconfig

# Baixa e instala o Pacote do Grafana  

wget https://dl.grafana.com/oss/release/grafana_5.4.2_amd64.deb && dpkg -i grafana_5.4.2_amd64.deb 

# Instala o Plugin do Zabbix 

grafana-cli plugins install alexanderzobnin-zabbix-app

# Habilitando o Grafana Iniciar com o Sistema e Reiniciar o Serviço

systemctl daemon-reload && systemctl enable grafana-server && systemctl enable grafana-server 