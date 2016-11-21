FROM daocloud.io/library/centos:6.7
MAINTAINER Loading <dxf351@gmail.com>

RUN yum -y install  wget 

RUN wget -O /etc/yum.repos.d/CentOS-Base.repo http://mirrors.aliyun.com/repo/Centos-6.repo

RUN wget http://mirrors.sohu.com/mysql/MySQL-5.5/mysql-5.5.53.tar.gz
#解压源码包并进入目录

RUN yum -y install tar cmake make openssh-server openssh-clients vim

#确认编译环境是否具备
RUN yum -y install gcc gcc-c++ ncurses-devel

#创建mysql安装目录及数据目录
RUN mkdir -p /usr/local/mysql

#创建用户和用户组与赋予数据存放目录权限
RUN groupadd mysql
RUN useradd -g mysql mysql
RUN chown mysql.mysql -R /usr/local/mysql/

RUN tar zxvf mysql-5.5.53.tar.gz
WORKDIR mysql-5.5.53

RUN cmake -DCMAKE_INSTALL_PREFIX=/usr/local/mysql 
RUN make && make install

# 复制配置文件
RUN cp support-files/my-large.cnf /etc/my.cnf

# 配置开机自启动
RUN cp support-files/mysql.server /etc/init.d/mysqld
RUN chmod +x /etc/init.d/mysqld
#chkconfig –add mysqld
#chkconfg mysqld on


# 初始化数据库
RUN /usr/local/mysql/scripts/mysql_install_db --user=mysql --basedir=/usr/local/mysql --datadir=/usr/local/mysql/data

RUN /etc/init.d/mysqld start && /usr/local/mysql/bin/mysqladmin -u root password 'f1zzb4ck' &&  /usr/local/mysql/bin/mysql -u root -pf1zzb4ck -e "create user 'readonly'@'%' identified by 'readonly';grant select on *.* to 'readonly'@'%' identified by 'readonly';flush privileges;\q;"

WORKDIR root
RUN rm -rf mysql-5.5.53

#install supervisor and rsyslog
RUN rpm -ivh http://dl.fedoraproject.org/pub/epel/6/x86_64/epel-release-6-8.noarch.rpm
RUN yum -y install rsyslog supervisor
#
ADD supervisord.conf /etc/supervisord.conf

EXPOSE 3306  
   
#CMD ["/usr/local/mysql/bin/mysqld_safe"]
CMD ["/usr/bin/supervisord"]
#CMD ["supervisord", "-c", "/etc/supervisor/supervisord.conf"]

