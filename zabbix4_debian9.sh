#!/bin/bash
# Script feito por Bernardo Gonçalves em 08/01/2019

# Baixando o Repositorio do Zabbix

wget https://repo.zabbix.com/zabbix/4.0/debian/pool/main/z/zabbix-release/zabbix-release_4.0-2+stretch_all.deb 

# Instalando o Repositorio do Zabbix

dpkg -i zabbix-release_4.0-2+stretch_all.deb

# Baixando o Repositorio do MySQL

wget https://repo.mysql.com/mysql-apt-config_0.8.11-1_all.deb

# Instalando o Repositorio do MySQL

dpkg -i mysql-apt-config_0.8.11-1_all.deb

# Atualizando o Repositorio

apt update && apt upgrade -y

# Instalando o MySQL

apt install mysql-server -y

# Instalando os Pacotes do Zabbix

apt install zabbix-server-mysql zabbix-frontend-php zabbix-get zabbix-agent -y 

# Instalando os Pacotes do SNMP e Nmap

apt install snmp snmp-mibs-downloader nmap -y

# Instalando Pacotes do Sistema 

apt install net-tools htop build-essential -y 

# Configurando o MySQL

mysql -uroot -pP@22w0rd -e "CREATE DATABASE zabbix CHARACTER SET utf8 COLLATE utf8_bin";
mysql -uroot -pP@22w0rd -e "CREATE USER zabbix@localhost identified with mysql_native_password by 'P@22w0rd'";
mysql -uroot -pP@22w0rd -e "GRANT ALL ON zabbix.* TO zabbix@localhost";
mysql -uroot -pP@22w0rd -e "SHOW DATABASES";
mysql -uroot -pP@22w0rd -e "SELECT host, user FROM mysql.user";
mysql -uroot -pP@22w0rd -e "SHOW GRANTS FOR zabbix@localhost";

# Criar as tabelas da Base de Dados do Zabbix

zcat /usr/share/doc/zabbix-server-mysql/create.sql.gz | mysql -uzabbix -pP@22w0rd zabbix

# Adicionar o Metodo de Autenticação no MySQL

echo "default-authentication-plugin = mysql_native_password" >> /etc/mysql/mysql.conf.d/mysqld.cnf

# Reiniciar o Serviço do MySQL

systemctl restart mysql 

# Configurando o Zabbix Server

sed -i 's/# DBPassword=/DBPassword=P@22w0rd/g' /etc/zabbix/zabbix_server.conf

sed -i 's/# StartVMwareCollectors=0/StartVMwareCollectors=2/g' /etc/zabbix/zabbix_server.conf

sed -i 's/# CacheSize=8M/CacheSize=128M/g' /etc/zabbix/zabbix_server.conf

sed -i 's/# StartPollers=5/StartPollers=10/g' /etc/zabbix/zabbix_server.conf

sed -i 's/# StartPingers=1/StartPingers=5/g' /etc/zabbix/zabbix_server.conf

# Configurando o Apache

sed -i 's/# php_value date.timezone Europe\/Riga/php_value date.timezone America\/Recife/g' /etc/zabbix/apache.conf

sed -i 's/\/var\/www\/html/\/usr\/share\/zabbix/g' /etc/apache2/sites-available/000-default.conf

# Reiniciando o Apache e Habilitando a Inicializacao com o Sistema

systemctl enable apache2 && systemctl restart apache2

# Reiniciando o Zabbix Server e Habilitando a Inicializacao com o Sistema

systemctl enable zabbix-server && systemctl restart zabbix-server 

# Reiniciando o Zabbix Agent e Habilitando a Inicializacao com o Sistema

systemctl enable zabbix-agent && systemctl restart zabbix-agent 

# Instalando as Dependências do Grafana

apt install adduser libfontconfig -y

# Baixando os Pacotes do Grafana

wget https://dl.grafana.com/oss/release/grafana_5.4.2_amd64.deb 

# Instalando os Pacotes do Grafana 

dpkg -i grafana_5.4.2_amd64.deb 

# Instalando o Plugin do Zabbix

grafana-cli plugins install alexanderzobnin-zabbix-app

# Reiniciando o serviço do Grafana e Configurando a Inicializacao com o Sistema

systemctl daemon-reload && systemctl enable grafana-server && systemctl restart grafana-server 

