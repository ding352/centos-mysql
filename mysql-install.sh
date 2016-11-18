#!/bin/sh

## the scripts base on centos6.7 and mysql 5.5 server

yum -y install  wget

wget http://mirrors.sohu.com/mysql/MySQL-5.5/mysql-5.5.53.tar.gz

yum -y install tar cmake make openssh-server openssh-clients vim
yum -y install gcc gcc-c++ ncurses-devel

mkdir -p /usr/local/mysql
groupadd mysql
useradd -g mysql mysql
chown mysql.mysql -R /usr/local/mysql/
tar zxvf mysql-5.5.53.tar.gz

cd mysql-5.5.53

cmake -DCMAKE_INSTALL_PREFIX=/usr/local/mysql
make && make install


# 复制配置文件
cp support-files/my-medium.cnf /etc/my.cnf

# 配置开机自启动
cp support-files/mysql.server /etc/init.d/mysqld
chmod +x /etc/init.d/mysqld
#chkconfig –add mysqld
#chkconfg mysqld on


# 初始化数据库
/usr/local/mysql/scripts/mysql_install_db --user=mysql --basedir=/usr/local/mysql --datadir=/usr/local/mysql/data

# 配置root用户密码
/etc/init.d/mysqld start && /usr/local/mysql/bin/mysqladmin -u root password 'password'
