#!/bin/bash
export PATH=/usr/local/sbin:/usr/local/bin:/sbin:/bin:/usr/bin:/usr/sbin
installdir=$(cd `dirname $0`; pwd)
cd $installdir

function install_environment_package()
{ yum install -y gcc gcc-c++ libcurl-devel bzip2-devel gmp-devel libicu-devel readline-devel libmcrypt libmcrypt-devel recode-devel net-snmp-devel libxml2-devel curl-deve libevent libevent-devel libxslt-devel libtidy-devel libedit-devel aspell-devel unixODBC-devel -y php-devel openldap openldap-devel libicu-devel libc-client-devel freetype-devel libXpm-devel libpng-devel libjpeg-devel enchant-devel db4-devel libcurl-devel pcre-devel libxml2-devel && yum clean all
}

function install_php()
{
   verison="5.6.33" 
   php_package="php-$verison.tar.gz"
   php_download_url="http://cn2.php.net/get/php-$verison.tar.gz/from/this/mirror"
   libmcrypt_download_url="ftp://mcrypt.hellug.gr/pub/crypto/mcrypt/libmcrypt/libmcrypt-2.5.7.tar.gz"
   
   cd ${installdir}

   if [ ! -f "libmcrypt-2.5.7.tar.gz" ];then
      echo "开始下载libmcrypt-2.5.7.tar.gz软件包"
      /usr/bin/wget $libmcrypt_download_url
   fi

   if [ ! -f "$php_package" ];then
      echo "开始下载$php_package软件包"
      /usr/bin/wget -O php-$verison.tar.gz $php_download_url
   fi
   groupadd apache 
   useradd -g apache -s /sbin/nologin apache

   php_install_dir=$(cat php_install_path.txt|grep -v '#')
   echo "php安装路径为 $php_install_dir"
   
   if [ ! -d "$php_install_dir/libmcrypt-2.5.7" ];then
      tar -zxvf libmcrypt-2.5.7.tar.gz -C $php_install_dir
   fi
   
   cd $php_install_dir/libmcrypt-2.5.7 
   ./configure
   make
   make install
   cd $installdir
   if [ ! -d "$installdir/php-$verison" ];then
      tar -zxvf php-$verison.tar.gz 
   fi
   cd $installdir/php-$verison 
   ./configure --prefix=$php_install_dir/php-5.6.33 --with-config-file-path=$php_install_dir/php-5.6.33/etc --with-config-file-scan-dir=$php_install_dir/php-5.6.33/etc/conf.d --enable-fpm --with-fpm-user=apache --with-fpm-group=apache --enable-pcntl --disable-cgi --enable-mysqlnd --with-curl --with-openssl --with-readline --with-recode --with-zlib --enable-bcmath --with-bz2 --enable-zip --enable-calendar --enable-exif --enable-ftp --enable-pdo --with-gettext --with-gd --with-jpeg-dir=/usr/lib --with-png-dir --with-xpm-dir --enable-mbstring --with-mysqli=mysqlnd --with-pdo-mysql=mysqlnd --enable-intl --enable-soap --with-mcrypt --with-xsl --with-mysql --with-mysql-sock --with-libxml-dir=/usr/lib --enable-sockets --with-iconv --enable-gd-native-ttf --with-freetype-dir=/usr --enable-ctype --with-gmp --without-pdo-sqlite --enable-shmop --enable-tokenizer --enable-opcache
   make && make install
   ln -snf $php_install_dir/php-5.6.33/bin/php /usr/bin/php
   mkdir -p $php_install_dir/php-5.6.33/log/
   touch $php_install_dir/php-5.6.33/log/slow_php56.log
   touch $php_install_dir/php-5.6.33/log/error_php56.log
   yes|cp $installdir/php.ini $php_install_dir/php-5.6.33/etc/
   yes|cp $installdir/php-fpm.conf $php_install_dir/php-5.6.33/etc/
   mkdir $php_install_dir/php-5.6.33/etc/pool.d
   yes|cp $installdir/www.conf $php_install_dir/php-5.6.33/etc/pool.d
   cp $installdir/redis.so $php_install_dir/php-5.6.33/lib/php/extensions/no-debug-non-zts-20131226/
   yes | cp $installdir/php56-33-fpm /etc/init.d/ && chmod +x /etc/init.d/php56-33-fpm
   chown -R apache:apache $php_install_dir/php-5.6.33
   sed -i "s%/data/software%$php_install_dir%g"  $php_install_dir/php-5.6.33/etc/php.ini  $php_install_dir/php-5.6.33/etc/php-fpm.conf $php_install_dir/php-5.6.33/etc/pool.d/www.conf /etc/init.d/php56-33-fpm
}



install_environment_package
install_php
