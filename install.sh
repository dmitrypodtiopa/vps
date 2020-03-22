#!/bin/sh

LOG_PIPE=log.pipe
rm -f LOG_PIPE
mkfifo ${LOG_PIPE}
LOG_FILE=log.file
rm -f LOG_FILE
tee < ${LOG_PIPE} ${LOG_FILE} &

exec  > ${LOG_PIPE}
exec  2> ${LOG_PIPE}

MIRROR='http://cdn.bspanel.ru'
IPVDS=$(echo "${SSH_CONNECTION}" | awk '{print $3}')
VER=`cat /etc/issue.net | awk '{print $1$3}'`

Infon() {
	printf "\033[1;32m$@\033[0m"
}
Info()
{
	Infon "$@\n"
}
Error()
{
	printf "\033[1;33m$@\033[0m\n"
}
Error_n()
{
	Error "- - - $@"
}
Error_s()
{
	Error "- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - "
}
log_s()
{
	Info "- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - "
}
log_n()
{
	Info "\033[1;34m$@\033[0m\n"
}
log_red()
{
	Info "\033[1;31m$@\033[0m\n"
}
log_t()
{
	log_s
	Info "- - - $@"
	log_s
}
lines()
{
	Info "${green}------------------------------------------------------------------------"
}
wow()
{
	lines
}
wow1()
{
	lines
}
infomenu()
{
	Info "${yellow}------------- | ${CYAN}Добро пожаловать, в установочное меню ${red}BSPanel${blue} | --------------"
}
info()
{
	printf "\033[1;33m$@\033[0m\n"
}
info_n()
{
	info "- - - $@"
}
lines_1()
{
	lines_2 "- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - "
}
lines_2()
{
	printf "\033[1;33m$@\033[0m\n"
}
log_n11()
{
	Info "- - - $@"
}
log_tt()
{
	Info "• —————————————————————————— ${red}$@${green} ——————————————————————————— • "
}

red=$(tput setf 4)
green=$(tput setf 2)
reset=$(tput sgr0)
toend=$(tput hpa $(tput cols))$(tput cub 6)

install_check()
{
	if [ -f "/var/www/host.rp-mygame.ru/system/data/config.php" ]; then
		echo "Панель управления уже установлена"
		exit
	else
		install_bspanel
	fi
}
install_bspanel()
{
	clear
echo "${LIME_YELLOW}-------------------------------------------------------------------------------"
	Info "Здравствуйте, данный скрипт поможет Вам установить ${red}BSPanel${blue} на Debian 8
Вам после установки, ни чего делать не надо.
Только надо установить MCE(для работы MySQL), и игры с нашего автоустановщика которые вам нужны!
Тарифы в панели уже созданы для всех игр и всех версий билдов. 
Скрипт за Вас всё установить кроме игр!"
echo "${LIME_YELLOW}-------------------------------------------------------------------------------"
while true; do
	read -p "${green}Вы уверены, что хотите установить полностью ${red}BSPanel${green}?(${red}Y${green}/${red}N${green}): " yn
	case $yn in
		[Yy]* ) break;;
		[Nn]* ) menu;;
		* ) echo "Ответьте, пожалуйста ${red}Y${green} или ${red}N${green}.";;
	esac
done
	read -p "${CYAN}Пожалуйста, введите ${red}домен ${CYAN}или ${red}IP${green}: ${yellow}" DOMAIN
	read -p "${CYAN}Введите пароль от root${green}: ${yellow}" VPASS
	echo "• Начинаем установку ${red}BSPanel${green} •"
	echo "• Обновляем пакеты •"
	apt-get update > /dev/null 2>&1
    if [ $? -eq 0 ]; then
		echo " \033[1;32m [OK] \033[0m\n"
		tput sgr0
    else
		echo "\033[1;31m [FAIL] \033[0m\n"
		tput sgr0
    fi
    echo "• Устанавливаем пакеты ${red}apt-utils pwgen wget dialog sudo! •"
	apt-get install -y apt-utils pwgen wget dialog sudo > /dev/null 2>&1
    if [ $? -eq 0 ]; then
		echo "\033[1;32m [OK] \033[0m\n"
		tput sgr0
    else
		echo "\033[1;31m [FAIL] \033[0m\n"
		tput sgr0
    fi
	MYPASS=$(pwgen -cns -1 16)
	MYPASS2=$(pwgen -cns -1 16)
	OS=$(lsb_release -s -i -c -r | xargs echo |sed 's; ;-;g' | grep Ubuntu)
	if [ "$OS" = "Debian8" ]; then
		echo "• Добавляем репозиторий •"
		echo "deb http://ftp.ru.debian.org/debian/ jessie main" > /etc/apt/sources.list
		echo "deb-src http://ftp.ru.debian.org/debian/ jessie main" >> /etc/apt/sources.list
		echo "deb http://security.debian.org/ jessie/updates main" >> /etc/apt/sources.list
		echo "deb-src http://security.debian.org/ jessie/updates main" >> /etc/apt/sources.list
		echo "deb http://ftp.ru.debian.org/debian/ jessie-updates main" >> /etc/apt/sources.list
		echo "deb-src http://ftp.ru.debian.org/debian/ jessie-updates main" >> /etc/apt/sources.list
	fi
	if [ "$OS" = "Debian7" ]; then
		log_t "• Добавляем репозиторий •"
		echo "deb http://ftp.ru.debian.org/debian/ wheezy main" > /etc/apt/sources.list
		echo "deb-src http://ftp.ru.debian.org/debian/ wheezy main" >> /etc/apt/sources.list
		echo "deb http://security.debian.org/ wheezy/updates main" >> /etc/apt/sources.list
		echo "deb-src http://security.debian.org/ wheezy/updates main" >> /etc/apt/sources.list
		echo "deb http://ftp.ru.debian.org/debian/ wheezy-updates main" >> /etc/apt/sources.list
		echo "deb-src http://ftp.ru.debian.org/debian/ wheezy-updates main" >> /etc/apt/sources.list
	fi
	if [ "$OS" = "Debian9" ]; then
		echo "• Добавляем репозиторий •"
		echo "deb http://ftp.ru.debian.org/debian/ stretch main" > /etc/apt/sources.list
		echo "deb-src http://ftp.ru.debian.org/debian/ stretch main" >> /etc/apt/sources.list
		echo "deb http://security.debian.org/ stretch/updates main" >> /etc/apt/sources.list
		echo "deb-src http://security.debian.org/ stretch/updates main" >> /etc/apt/sources.list
		echo "deb http://ftp.ru.debian.org/debian/ stretch-updates main" >> /etc/apt/sources.list
		echo "deb-src http://ftp.ru.debian.org/debian/ stretch-updates main" >> /etc/apt/sources.list
		wget http://www.dotdeb.org/dotdeb.gpg
		apt-key add dotdeb.gpg
		rm dotdeb.gpg
	fi
	echo "• Обновляем пакеты •"
	apt-get update -y > /dev/null 2>&1
	apt-get upgrade -y > /dev/null 2>&1
	echo mysql-server mysql-server/root_password select "$MYPASS" | debconf-set-selections
	echo mysql-server mysql-server/root_password_again select "$MYPASS" | debconf-set-selections
    if [ $? -eq 0 ]; then
		echo "\033[1;32m [OK] \033[0m\n"
		tput sgr0
    else
		echo "\033[1;31m [FAIL] \033[0m\n"
		tput sgr0
    fi
	echo "• Устанавливаем пакеты 
	${red}apache2 php5 php5-dev cron unzip sudo nano php5-curl php5-memcache 
	php5-json memcached mysql-server php5-mysql libapache2-mod-php5 php-pear •"
	apt-get install -y apache2 php5 php5-dev cron unzip sudo nano php5-curl php5-memcache php5-json memcached mysql-server php5-mysql libapache2-mod-php5 php-pear > /dev/null 2>&1
    if [ $? -eq 0 ]; then
		echo "\033[1;32m [OK] \033[0m\n"
		tput sgr0
    else
		echo "\033[1;31m [FAIL] \033[0m\n"
		tput sgr0
    fi
	echo "• Включаем модуль ${red}Apache2${green} •"
	a2enmod php5 > /dev/null 2>&1
	service apache2 restart > /dev/null 2>&1
    if [ $? -eq 0 ]; then
		echo "\033[1;32m [OK] \033[0m\n"
		tput sgr0
    else
		echo "\033[1;31m [FAIL] \033[0m\n"
		tput sgr0
    fi
	echo "• Устанавливаем ${red}phpMyAdmin${green} •"
	echo "phpmyadmin phpmyadmin/dbconfig-install boolean true" | debconf-set-selections
	echo "phpmyadmin phpmyadmin/mysql/admin-user string root" | debconf-set-selections
	echo "phpmyadmin phpmyadmin/mysql/admin-pass password $MYPASS" | debconf-set-selections
	echo "phpmyadmin phpmyadmin/mysql/app-pass password $MYPASS" |debconf-set-selections
	echo "phpmyadmin phpmyadmin/app-password-confirm password $MYPASS" | debconf-set-selections
	echo 'phpmyadmin phpmyadmin/reconfigure-webserver multiselect apache2' | debconf-set-selections
	apt-get install -y phpmyadmin > /dev/null 2>&1
    if [ $? -eq 0 ]; then
		echo "\033[1;32m [OK] \033[0m\n"
		tput sgr0
    else
		echo "\033[1;31m [FAIL] \033[0m\n"
		tput sgr0
    fi
	echo  "• Устанавливаем ${red}mysql-server ${red}5${green}.${red}6${green} •"
	echo mysql-apt-config mysql-apt-config/select-server select mysql-5.6 | debconf-set-selections
	echo mysql-apt-config mysql-apt-config/select-product select Ok | debconf-set-selections
	wget https://dev.mysql.com/get/mysql-apt-config_0.8.7-1_all.deb > /dev/null 2>&1
	export DEBIAN_FRONTEND=noninteractive
	dpkg -i mysql-apt-config_0.8.7-1_all.deb > /dev/null 2>&1
    apt-get update > /dev/null 2>&1
	apt-get --yes --force-yes install mysql-server > /dev/null 2>&1
	sudo mysql_upgrade -u root -p$MYPASS --force --upgrade-system-tables > /dev/null 2>&1
	service mysql restart > /dev/null 2>&1
	rm mysql-apt-config_0.8.7-1_all.deb > /dev/null 2>&1
	cd ~ > /dev/null 2>&1
	sudo mysql_upgrade -u root -p$MYPASS --force --upgrade-system-tables > /dev/null 2>&1
	service mysql restart > /dev/null 2>&1
    if [ $? -eq 0 ]; then
		echo "\033[1;32m [OK] \033[0m\n"
		tput sgr0
    else
		echo "\033[1;31m [FAIL] \033[0m\n"
		tput sgr0
    fi
	echo "• Устанавливаем библиотеку ${red}SSH2${green} •"
	if [ "$OS" = "" ]; then
	apt-get install -y curl php5-ssh2 > /dev/null 2>&1
	else
	apt-get install -y libssh2-php > /dev/null 2>&1
	fi
    if [ $? -eq 0 ]; then
		echo "\033[1;32m [OK] \033[0m\n"
		tput sgr0
    else
		echo "\033[1;31m [FAIL] \033[0m\n"
		tput sgr0
    fi
	echo "• Создаем хост в ${red}Apache2${green} - создание файлов виртуальных хостов •"
	mv /etc/apache2/sites-available/000-default.conf /etc/apache2/sites-available/.000-default.conf
	FILE='/etc/apache2/sites-available/000-default.conf'
		echo "<VirtualHost *:80>">$FILE
		echo "	ServerName $DOMAIN">>$FILE
		echo "	DocumentRoot /var/www">>$FILE
		echo "	<Directory /var/www/host.rp-mygame.ru/>">>$FILE
		echo "	Options Indexes FollowSymLinks MultiViews">>$FILE
		echo "	AllowOverride All">>$FILE
		echo "	Order allow,deny">>$FILE
		echo "	allow from all">>$FILE
		echo "	</Directory>">>$FILE
		echo "	ErrorLog \${APACHE_LOG_DIR}/error.log">>$FILE
		echo "	LogLevel warn">>$FILE
		echo "	CustomLog \${APACHE_LOG_DIR}/access.log combined">>$FILE
		echo "</VirtualHost>">>$FILE

    if [ $? -eq 0 ]; then
		echo "\033[1;32m [OK] \033[0m\n"
		tput sgr0
    else
		echo "\033[1;31m [FAIL] \033[0m\n"
		tput sgr0
    fi
	echo "• Включаем модуль ${red}mod_rewrite${green} для ${red}Apache2${green} •"
	a2enmod rewrite > /dev/null 2>&1
    if [ $? -eq 0 ]; then
		echo "\033[1;32m [OK] \033[0m\n"
		tput sgr0
    else
		echo "\033[1;31m [FAIL] \033[0m\n"
		tput sgr0
    fi
	echo "• Перезагружаем ${red}Apache2${green} •"
	service apache2 restart	> /dev/null 2>&1
    if [ $? -eq 0 ]; then
		echo "\033[1;32m [OK] \033[0m\n"
		tput sgr0
    else
		echo "\033[1;31m [FAIL] \033[0m\n"
		tput sgr0
    fi

	DIR="/var/www"
	CRONKEY=$(pwgen -cns -1 6)
 	CRONPANEL="/etc/crontab"

	echo "• Добавляем ${red}сron задания${green} •"

	sed -i "s/320/0/g" $CRONPANEL
	echo "">>$CRONPANEL
	echo "*/2 * * * * screen -dmS scan_servers bash -c 'cd ${DIR} && php cron.php ${CRONKEY} threads scan_servers'">>$CRONPANEL
	echo "*/5 * * * * screen -dmS scan_servers_load bash -c 'cd ${DIR} && php cron.php ${CRONKEY} threads scan_servers_load'">>$CRONPANEL
	echo "*/5 * * * * screen -dmS scan_servers_route bash -c 'cd ${DIR} && php cron.php ${CRONKEY} threads scan_servers_route'">>$CRONPANEL
	echo "* * * * * screen -dmS scan_servers_down bash -c 'cd ${DIR} && php cron.php ${CRONKEY} threads scan_servers_down'">>$CRONPANEL
	echo "*/10 * * * * screen -dmS notice_help bash -c 'cd ${DIR} && php cron.php ${CRONKEY} notice_help'">>$CRONPANEL
	echo "*/15 * * * * screen -dmS scan_servers_stop bash -c 'cd ${DIR} && php cron.php ${CRONKEY} threads scan_servers_stop'">>$CRONPANEL
	echo "*/15 * * * * screen -dmS scan_servers_copy bash -c 'cd ${DIR} && php cron.php ${CRONKEY} threads scan_servers_copy'">>$CRONPANEL
	echo "*/30 * * * * screen -dmS notice_server_overdue bash -c 'cd ${DIR} && php cron.php ${CRONKEY} notice_server_overdue'">>$CRONPANEL
	echo "*/30 * * * * screen -dmS preparing_web_delete bash -c 'cd ${DIR} && php cron.php ${CRONKEY} preparing_web_delete'">>$CRONPANEL
	echo "0 * * * * screen -dmS scan_servers_admins bash -c 'cd ${DIR} && php cron.php ${CRONKEY} threads scan_servers_admins'">>$CRONPANEL
	echo "* * * * * screen -dmS control_delete bash -c 'cd ${DIR} && php cron.php ${CRONKEY} control_delete'">>$CRONPANEL
	echo "* * * * * screen -dmS control_install bash -c 'cd ${DIR} && php cron.php ${CRONKEY} control_install'">>$CRONPANEL
	echo "*/2 * * * * screen -dmS scan_control bash -c 'cd ${DIR} && php cron.php ${CRONKEY} scan_control'">>$CRONPANEL
	echo "*/2 * * * * screen -dmS control_scan_servers bash -c 'cd ${DIR} && php cron.php ${CRONKEY} control_threads control_scan_servers'">>$CRONPANEL
	echo "*/5 * * * * screen -dmS control_scan_servers_route bash -c 'cd ${DIR} && php cron.php ${CRONKEY} control_threads control_scan_servers_route'">>$CRONPANEL
	echo "* * * * * screen -dmS control_scan_servers_down bash -c 'cd ${DIR} && php cron.php ${CRONKEY} control_threads control_scan_servers_down'">>$CRONPANEL
	echo "0 * * * * screen -dmS control_scan_servers_admins bash -c 'cd ${DIR} && php cron.php ${CRONKEY} control_threads control_scan_servers_admins'">>$CRONPANEL
	echo "*/15 * * * * screen -dmS control_scan_servers_copy bash -c 'cd ${DIR} && php cron.php ${CRONKEY} control_threads control_scan_servers_copy'">>$CRONPANEL
	echo "0 0 * * * screen -dmS graph_servers_day bash -c 'cd ${DIR} && php cron.php ${CRONKEY} threads graph_servers_day'">>$CRONPANEL
	echo "0 * * * * screen -dmS graph_servers_hour bash -c 'cd ${DIR} && php cron.php ${CRONKEY} threads graph_servers_hour'">>$CRONPANEL
	echo "#">>$CRONPANEL
	crontab -u root /etc/crontab

	echo "• Перезагружаем ${red}крон!•"
	service cron restart > /dev/null 2>&1
    if [ $? -eq 0 ]; then
		echo "\033[1;32m [OK] \033[0m\n"
		tput sgr0
    else
		echo "\033[1;31m [FAIL] \033[0m\n"
		tput sgr0
    fi
	echo "• Перезагружаем ${red}Apache2 •"
	service apache2 restart > /dev/null 2>&1
    if [ $? -eq 0 ]; then
		echo "\033[1;32m [OK] \033[0m\n"
		tput sgr0
    else
		echo "\033[1;31m [FAIL] \033[0m\n"
		tput sgr0
    fi
	echo "• • Началась установка ${red}BSPanel${green} в каталог ${red}/var/www${green} • •"
	cd ~ > /dev/null 2>&1
	cd /var/www/host.rp-mygame.ru/ > /dev/null 2>&1
	wget $MIRROR/files/debian/bspanel.zip > /dev/null 2>&1
	unzip bspanel.zip > /dev/null 2>&1
	rm bspanel.zip > /dev/null 2>&1
	cd ~ > /dev/null 2>&1
    if [ $? -eq 0 ]; then
		echo "\033[1;32m [OK] \033[0m\n"
		tput sgr0
    else
		echo "\033[1;31m [FAIL] \033[0m\n"
		tput sgr0
    fi

	echo "• Выдаем права на файлы •"
	chown -R www-data:www-data /var/www/host.rp-mygame.ru/ > /dev/null 2>&1
	chmod -R 775 /var/www/host.rp-mygame.ru/ > /dev/null 2>&1
    if [ $? -eq 0 ]; then
		echo "\033[1;32m [OK] \033[0m\n"
		tput sgr0
    else
		echo "\033[1;31m [FAIL] \033[0m\n"
		tput sgr0
    fi
	echo "• Настраиваем время на сервере •"
	echo "Europe/Moscow" > /etc/timezone 
	dpkg-reconfigure tzdata -f noninteractive > /dev/null 2>&1
	sudo sed -i -r 's~^;date\.timezone =$~date.timezone = "Europe/Moscow"~' /etc/php5/cli/php.ini > /dev/null 2>&1
	sudo sed -i -r 's~^;date\.timezone =$~date.timezone = "Europe/Moscow"~' /etc/php5/apache2/php.ini > /dev/null 2>&1
    if [ $? -eq 0 ]; then
		echo "\033[1;32m [OK] \033[0m\n"
		tput sgr0
    else
		echo "\033[1;31m [FAIL] \033[0m\n"
		tput sgr0
    fi
	echo "• Создаем базу данных и загружаем дамп базы данных от ${red}BSPanel${green} •"
	wget $MIRROR/files/debian/bspanel.sql > /dev/null 2>&1
	MP=$MYPASS
	VP=$VPASS
	IP=$DOMAIN
	IP1=$IPVDS
	new_pass=$(pwgen -cns -1 7)
	account_pass=`wget -qO- http://system.bspanel.ru/api/md5.php?passwd=${new_pass} | sed -e 's/<[^>]*>//g'`
	sed -i "s/mysqlp/${MP}/g" /var/www/host.rp-mygame.ru/system/data/mysql.php
	sed -i "s/bspanel_addr/${IP1}/g" /var/www/host.rp-mygame.ru/system/data/web.php
	sed -i "s/bspanel_pass/${VP}/g" /var/www/host.rp-mygame.ru/system/data/web.php
	sed -i "s/bspanel_pm/${IP}/g" /var/www/host.rp-mygame.ru/system/data/web.php
	sed -i "s/bspanel_dm/${IP}/g" /var/www/host.rp-mygame.ru/system/data/web.php
	sed -i "s/domain_bsp/${IP}/g" /var/www/host.rp-mygame.ru/system/data/config.php
	sed -i "s/IPADDR/${IP1}/g" /var/www/host.rp-mygame.ru/system/data/config.php
	sed -i "s/key123/${CRONKEY}/g" /var/www/host.rp-mygame.ru/system/data/config.php
	sed -i "s/bspanel_random_passwd/${new_pass}/g" /var/www/host.rp-mygame.ru/system/data/config.php
	sed -i "s/domain_bsp/${IP}/g" /root/bspanel.sql
	sed -i "s/IPADDR/${IP1}/g" /root/bspanel.sql
	sed -i "s/sqlpass/${MP}/g" /root/bspanel.sql
	# sed -i "s/sshpass/${VP}/g" /root/bspanel.sql
	sed -i "s/new_pass_account/${account_pass}/g" /root/bspanel.sql
	sed -i "$IP1 $DOMAIN" /etc/hosts
	mysql -u root -p$MYPASS -e "CREATE DATABASE bspanel CHARACTER SET utf8 COLLATE utf8_general_ci;" > /dev/null 2>&1
	mysql -u root -p$MYPASS bspanel < bspanel.sql > /dev/null 2>&1
	rm bspanel.sql > /dev/null 2>&1
    if [ $? -eq 0 ]; then
		echo "\033[1;32m [OK] \033[0m\n"
		tput sgr0
    else
		echo "\033[1;31m [FAIL] \033[0m\n"
		tput sgr0
    fi

    cd /var/www/host.rp-mygame.ru/system/sections/license > /dev/null 2>&1
    rm index.php > /dev/null 2>&1
    wget cdn.bspanel.ru/files/fix/license.zip > /dev/null 2>&1
    unzip license.zip > /dev/null 2>&1
    rm license.zip > /dev/null 2>&1
    cd ~
    cd /var/www/host.rp-mygame.ru/system/acp > /dev/null 2>&1
    rm distributor.php > /dev/null 2>&1
    wget cdn.bspanel.ru/files/fix/distributor.zip > /dev/null 2>&1
    unzip distributor.zip > /dev/null 2>&1
    rm distributor.zip > /dev/null 2>&1
    cd ~

	echo "• Устанавливаем необходимые пакеты для ${red}серверной части​${green} •"
	apt-get install -y lsb-release > /dev/null 2>&1
	apt-get install -y lib32stdc++6 > /dev/null 2>&1
	apt-get install -y libreadline5 > /dev/null 2>&1
	OS=$(lsb_release -s -i -c -r | xargs echo |sed 's; ;-;g' | grep Ubuntu)
	if [ "$OS" = "" ]; then
		sudo dpkg --add-architecture i386 > /dev/null 2>&1
		sudo apt-get update > /dev/null 2>&1
		sudo apt-get install -y gcc-multilib > /dev/null 2>&1
	else
		cd /etc/apt/sources.list.d > /dev/null 2>&1
		echo "deb http://old-releases.ubuntu.com/ubuntu/ raring main restricted universe multiverse" >ia32-libs-raring.list > /dev/null 2>&1
		apt-get update > /dev/null 2>&1
		sudo apt-get install -y gcc-multilib > /dev/null 2>&1
	fi
	apt-get install -y sudo screen htop nano tcpdump ethstatus ssh zip unzip mc qstat gdb lib32gcc1 nload ntpdate lsof > /dev/null 2>&1
	apt-get install -y lib32z1 > /dev/null 2>&1
    if [ $? -eq 0 ]; then
		echo "\033[1;32m [OK] \033[0m\n"
		tput sgr0
    else
		echo "\033[1;31m [FAIL] \033[0m\n"
		tput sgr0
    fi
	echo "• Приступаем к установке ${red}Java 8${green} •"
	wget javadl.sun.com/webapps/download/AutoDL?BundleId=106240 -O jre-linux.tar.gz > /dev/null 2>&1
	tar xvfz jre-linux.tar.gz > /dev/null 2>&1
	mkdir /usr/lib/jvm > /dev/null 2>&1
	mv jre1.8.0_45 /usr/lib/jvm/jre1.8.0_45 > /dev/null 2>&1
	update-alternatives --install /usr/bin/java java /usr/lib/jvm/jre1.8.0_45/bin/java 1 > /dev/null 2>&1
	update-alternatives --config java> /dev/null 2>&1
	rm jre-linux.tar.gz
    if [ $? -eq 0 ]; then
		echo "\033[1;32m [OK] \033[0m\n"
		tput sgr0
    else
		echo "\033[1;31m [FAIL] \033[0m\n"
		tput sgr0
    fi
	echo "• Устанавливаем и настраиваем ${red}iptables${green} + ${red}rclocal${green} •"
	wget -O rclocal $MIRROR/files/debian/rclocal/rclocal.txt > /dev/null 2>&1
	sed -i '14d' /etc/rc.local > /dev/null 2>&1
	cat rclocal >> /etc/rc.local > /dev/null 2>&1
	touch /root/iptables_block > /dev/null 2>&1
	echo "UseDNS no" >> /etc/ssh/sshd_config 
	echo "UTC=no" >> /etc/default/rcS
	rm -rf rclocal > /dev/null 2>&1
    if [ $? -eq 0 ]; then
		echo "\033[1;32m [OK] \033[0m\n"
		tput sgr0
    else
		echo "\033[1;31m [FAIL] \033[0m\n"
		tput sgr0
    fi
	echo "• Устанавливаем и настраиваем ${red}iptables${green} + ${red}geoip${green} •"
	sudo apt-get --yes --force-yes install xtables-addons-common > /dev/null 2>&1
	sudo apt-get --yes --force-yes install libtext-csv-xs-perl libxml-csv-perl libtext-csv-perl unzip > /dev/null 2>&1
	sudo mkdir -p /usr/share/xt_geoip/ > /dev/null 2>&1
	mkdir geoiptmp > /dev/null 2>&1
	cd geoiptmp /usr/lib/xtables-addons/xt_geoip_dl > /dev/null 2>&1
	sudo /usr/lib/xtables-addons/xt_geoip_build GeoIPv6.csv GeoIPCountryWhois.csv -D /usr/share/xt_geoip > /dev/null 2>&1
	cd ~
	rm -rf geoiptmp > /dev/null 2>&1
    if [ $? -eq 0 ]; then
		echo "\033[1;32m [OK] \033[0m\n"
		tput sgr0
    else
		echo "\033[1;31m [FAIL] \033[0m\n"
		tput sgr0
    fi
	echo "• Включаем ${red}Nginx${green} для модуля ${red}FastDL${green} •"
	wget -O nginx $MIRROR/files/debian/nginx/nginx.txt > /dev/null 2>&1
	service apache2 stop > /dev/null 2>&1
	apt-get install -y nginx > /dev/null 2>&1
	mkdir -p /var/nginx/ > /dev/null 2>&1
	rm -rf /etc/nginx/nginx.conf > /dev/null 2>&1
	mv nginx /etc/nginx/nginx.conf > /dev/null 2>&1
	service nginx restart > /dev/null 2>&1
	service apache2 start > /dev/null 2>&1
	rm -rf nginx > /dev/null 2>&1
    if [ $? -eq 0 ]; then
		echo "\033[1;32m [OK] \033[0m\n"
		tput sgr0
    else
		echo "\033[1;31m [FAIL] \033[0m\n"
		tput sgr0
    fi
	echo "• Устанавливаем и настраиваем ${red}ProFTPd${green} •"
	wget -O proftpd $MIRROR/files/debian/proftpd/proftpd.txt > /dev/null 2>&1
	wget -O proftpd_modules $MIRROR/files/debian/proftpd/proftpd_modules.txt > /dev/null 2>&1
	wget -O proftpd_sql $MIRROR/files/debian/proftpd/proftpd_sql.txt > /dev/null 2>&1
	echo PURGE | debconf-communicate proftpd-basic > /dev/null 2>&1
	echo proftpd-basic shared/proftpd/inetd_or_standalone select standalone | debconf-set-selections
	apt-get install -y proftpd-basic proftpd-mod-mysql > /dev/null 2>&1
	rm -rf /etc/proftpd/proftpd.conf > /dev/null 2>&1
	rm -rf /etc/proftpd/modules.conf > /dev/null 2>&1
	rm -rf /etc/proftpd/sql.conf > /dev/null 2>&1
	mv proftpd /etc/proftpd/proftpd.conf > /dev/null 2>&1
	mv proftpd_modules /etc/proftpd/modules.conf > /dev/null 2>&1
	mv proftpd_sql /etc/proftpd/sql.conf > /dev/null 2>&1
	rm -rf proftpd > /dev/null 2>&1
	rm -rf proftpd_modules > /dev/null 2>&1
	rm -rf proftpd_sql > /dev/null 2>&1
	mkdir -p /copy /servers /servers/cs /servers/cssold /servers/css /servers/csgo /servers/samp /servers/crmp /servers/mta /servers/mc /path/steam /var/nginx
	mkdir -p /path/cs /path/css /path/cssold /path/csgo /path/samp /path/crmp /path/mta /path/mc
	mkdir -p /path/update/cs /path/update/css /path/update/cssold /path/update/csgo /path/update/samp /path/update/crmp /path/update/mta /path/update/mc
	cd /path/steam && wget http://media.steampowered.com/client/steamcmd_linux.tar.gz > /dev/null 2>&1 && tar xvfz steamcmd_linux.tar.gz > /dev/null 2>&1 && rm steamcmd_linux.tar.gz > /dev/null 2>&1
	cd ~
	groupmod -g 998 `cat /etc/group | grep :1000 | awk -F":" '{print $1}'` > /dev/null 2>&1
	groupadd -g 1000 servers; > /dev/null 2>&1
	chmod 711 /servers
	chown root:servers /servers
	chmod 711 /servers/cs
	chown root:servers /servers/cs
	chmod 711 /servers/cssold
	chown root:servers /servers/cssold
	chmod 711 /servers/css
	chown root:servers /servers/css
	chmod 711 /servers/csgo
	chown root:servers /servers/csgo
	chmod 711 /servers/samp
	chown root:servers /servers/samp
	chmod 711 /servers/crmp
	chown root:servers /servers/crmp
	chmod 711 /servers/mta
	chown root:servers /servers/mta
	chmod 711 /servers/mc
	chown root:servers /servers/mc
	chmod -R 755 /path
	chown root:servers /path
	chmod -R 750 /copy
	chown root:root /copy
	chmod -R 750 /etc/proftpd
	wget -O proftpd_sqldump $MIRROR/files/debian/proftpd/proftpd_sqldump.txt > /dev/null 2>&1
	mysql -uroot -p$MYPASS -e "CREATE DATABASE ftp;"; > /dev/null 2>&1
	mysql -uroot -p$MYPASS -e "CREATE USER 'ftp'@'localhost' IDENTIFIED BY '$MYPASS2';"; > /dev/null 2>&1
	mysql -uroot -p$MYPASS -e "GRANT ALL PRIVILEGES ON ftp . * TO 'ftp'@'localhost';"; > /dev/null 2>&1
	mysql -uroot -p$MYPASS ftp < proftpd_sqldump; > /dev/null 2>&1
	rm -rf proftpd_sqldump > /dev/null 2>&1
	sed -i 's/passwdfor/'$MYPASS'/g' /etc/proftpd/sql.conf > /dev/null 2>&1
    if [ $? -eq 0 ]; then
		echo "\033[1;32m [OK] \033[0m\n"
		tput sgr0
    else
		echo "\033[1;31m [FAIL] \033[0m\n"
		tput sgr0
    fi
	log_t "• Приступаем к установке ${red}Ioncube Loader${green} •"
	MODULES=$(php -i | grep extension_dir | awk '{print $NF}')
	PHP_VERSION=$(php -r "echo PHP_MAJOR_VERSION.'.'.PHP_MINOR_VERSION;")
	ARCH=$(getconf LONG_BIT)

	# Если 32-бит
	if [ $ARCH == "32" ]; then 
		echo "${Cyan} Скачивание Ioncube Loader.. ${Color_Off}" 
		wget http://downloads3.ioncube.com/loader_downloads/ioncube_loaders_lin_x86.tar.gz > /dev/null 2>&1

		echo "${Cyan} Распаковка Ioncube Loader.. ${Color_Off}" 
		tar xvfz ioncube_loaders_lin_x86.tar.gz > /dev/null 2>&1
	# Если 64-бит 
	else 
		echo "${Cyan} • Скачивание Ioncube Loader • ${Color_Off}" 
		wget http://downloads3.ioncube.com/loader_downloads/ioncube_loaders_lin_x86-64.tar.gz > /dev/null 2>&1
	    if [ $? -eq 0 ]; then
			echo "\033[1;32m [OK] \033[0m\n"
			tput sgr0
	    else
			echo "\033[1;31m [FAIL] \033[0m\n"
			tput sgr0
	    fi
		echo "${Cyan} • Распакуем файл • ${Color_Off}" 
		tar xvfz ioncube_loaders_lin_x86-64.tar.gz > /dev/null 2>&1
	    if [ $? -eq 0 ]; then
			echo "\033[1;32m [OK] \033[0m\n"
			tput sgr0
	    else
			echo "\033[1;31m [FAIL] \033[0m\n"
			tput sgr0
	    fi
	fi 
	rm /root/ioncube_loaders_lin_x86-64.tar.gz /root/ioncube_loaders_lin_x86.tar.gz > /dev/null 2>&1
	echo "${Cyan} • Копирования файлов Ioncube Loader • ${Color_Off}" 
    if [ $? -eq 0 ]; then
		echo "\033[1;32m [OK] \033[0m\n"
		tput sgr0
    else
		echo "\033[1;31m [FAIL] \033[0m\n"
		tput sgr0
    fi
	sudo cp /root/ioncube/ioncube_loader_lin_${PHP_VERSION}.so $MODULES > /dev/null 2>&1
	sed -i "3i\zend_extension = ${MODULES}/ioncube_loader_lin_${PHP_VERSION}.so" /etc/php5/apache2/php.ini > /dev/null 2>&1
	rm -r /root/ioncube > /dev/null 2>&1
	echo "${Cyan} Копирования успешно прошла!${Color_Off}"

    if [ $? -eq 0 ]; then
		echo "\033[1;32m [OK] \033[0m\n"
		tput sgr0
    else
		echo "\033[1;31m [FAIL] \033[0m\n"
		tput sgr0
    fi

	echo "• Перезагружаем ${red}FTP, MySQL, Apache2${green} •"
	service proftpd restart > /dev/null 2>&1
    if [ $? -eq 0 ]; then
		echo "\033[1;32m [OK] \033[0m\n"
		tput sgr0
    else
		echo "\033[1;31m [FAIL] \033[0m\n"
		tput sgr0
    fi
	echo "• Обновляем пакеты и веб сервисы •"
	apt-get update > /dev/null 2>&1
	service apache2 restart > /dev/null 2>&1
	service mysql restart > /dev/null 2>&1
	ln -s /usr/share/phpmyadmin /var/www/host.rp-mygame.ru/pma > /dev/null 2>&1
    if [ $? -eq 0 ]; then
		echo "\033[1;32m [OK] \033[0m\n"
		tput sgr0
    else
		echo "\033[1;31m [FAIL] \033[0m\n"
		tput sgr0
    fi
    echo "• Удаляем папку ${red}html${green} [var/www/html] •"
   	rm -r /var/www/host.rp-mygame.ru/html > /dev/null 2>&1
   	echo "\033[1;32m [OK] \033[0m\n"
   	
	log_t "• Завершаем установку ${red}BSPanel${green} на Debian 8 •"
		lines_1
		info_n "••••••••••••••••••••••••••••••••••••••••••••••••••••••••••"
		info_n "• Панель управления ${red}BSPanel ${YELLOW}установлена!"
		info_n "••••••••••••••••••••••••••••••••••••••••••••••••••••••••••"
		info_n "• Данные для входа в ${red}phpMyAdmin${YELLOW} и ${red}MySQL${green}:"
		info_n "• ${red}Логин${green}: ${YELLOW}root"
		info_n "• ${red}Пароль${green}: ${YELLOW}$MYPASS"
		info_n "••••••••••••••••••••••••••••••••••••••••••••••••••••••••••"
		info_n "• ${red}FTP пароль${YELLOW} от ${red}MySQL${green}: ${YELLOW}$MYPASS2"
		info_n "••••••••••••••••••••••••••••••••••••••••••••••••••••••••••"
		info_n "• Ссылка на ${red}BSPanel${green}: ${YELLOW}http://$DOMAIN/"
		info_n "• Ссылка на ${red}PhpMyAdmin${green}: ${YELLOW}http://$DOMAIN/phpmyadmin"
		info_n "••••••••••••••••••••••••••••••••••••••••••••••••••••••••••"
		info_n "• Данные для входа в панель управления${green}:"
		info_n "• ${red}Логин${green}: ${YELLOW}admin"
		info_n "• ${red}Пароль${green}: ${YELLOW}${new_pass}"
		info_n "• ${red}Ссылка${green}: ${YELLOW}http://$DOMAIN/acp"
		info_n "••••••••••••••••••••••••••••••••••••••••••••••••••••••••••"
		info_n "• ${red}Обязательно смените email и пароль после авторизации!"
		lines_1
	Info
	log_t "Спасибо, что установили ${red}BSPanel${green}, Не забудьте сохранить данные"
	Info "• ${red}1${green} - Установить игры"
	Info "• ${red}0${green} - В главное меню"
	Info
	read -p "Пожалуйста, введите номер меню: " case
	case $case in
		1) install_games;;
		0) menu;;
	esac
}
settings_location()
{
echo "${YELLOW}-------------------------------------------------------------------------------"
	Info "Здравствуйте, данный скрипт Вам настроить полностью Локацию под ${red}BSPanel${green}
Вам после настройки Локации:
1)Нужно установить игры с нашего автоустановщика
2)После добавить локацию через Админ Панель
Тарифы в панели уже созданы для всех игр и всех версий билдов.
Если вы устанавливали панель вручную и не через наш автоустановщик тогда:
3)Вам нужно для каждой игры создавать тариф через Админ Панель"
echo "${YELLOW}-------------------------------------------------------------------------------"
while true; do
    read -p "${green}Вы уверены, что хотите настроить локацию под ${red}BSPanel${green}?(${red}Yes${green}/${red}No${green}) (на одной машине не выполнять!)" yn
    case $yn in
        [Yy]* ) break;;
        [Nn]* ) exit;;
        * ) echo "Ответьте, пожалуйста ${red}Yes${green} или ${red}No${green}.";;
    esac
done
Info "Здравствуйте, скопируйте ${red}IP${green} от Putty, и вставьте правой кнопкой мышь 
Либо Ведите с клавиатурой"
read -p "${CYAN}Пожалуйста, введите ${red}IP${CYAN} от Putty${green}:${yellow}" ipaddress
Info "Пожалуйста, скопируйте ${red}пароль${green} от Putty, и вставьте правой кнопкой мышь
Либо Ведите с клавиатурой"
read -p "${CYAN}Введите пароль от Putty${green}:${yellow}" VPASS
log_t "• Начинаем настраивать локацию под ${red}BSPanel${green} •"
	log_t "• Обновляем пакеты •"
	apt-get update
    log_t "• Устанавливаем пакеты! •"
	apt-get install -y apt-utils
	apt-get install -y pwgen
	apt-get install -y dialog
	MYPASS=$(pwgen -cns -1 16)
	MYPASS2=$(pwgen -cns -1 16)
	OS=$(lsb_release -s -i -c -r | xargs echo |sed 's; ;-;g' | grep Ubuntu)
	if [ "$OS" = "Debian8" ]; then
		log_t "• Добавляем репозиторий •"
		echo "deb http://ftp.ru.debian.org/debian/ jessie main" > /etc/apt/sources.list
		echo "deb-src http://ftp.ru.debian.org/debian/ jessie main" >> /etc/apt/sources.list
		echo "deb http://security.debian.org/ jessie/updates main" >> /etc/apt/sources.list
		echo "deb-src http://security.debian.org/ jessie/updates main" >> /etc/apt/sources.list
		echo "deb http://ftp.ru.debian.org/debian/ jessie-updates main" >> /etc/apt/sources.list
		echo "deb-src http://ftp.ru.debian.org/debian/ jessie-updates main" >> /etc/apt/sources.list
		log_t "• Обновляем пакеты •"
		apt-get update
	fi
	if [ "$OS" = "Debian7" ]; then
		log_t "• Добавляем репозиторий •"
		echo "deb http://ftp.ru.debian.org/debian/ wheezy main" > /etc/apt/sources.list
		echo "deb-src http://ftp.ru.debian.org/debian/ wheezy main" >> /etc/apt/sources.list
		echo "deb http://security.debian.org/ wheezy/updates main" >> /etc/apt/sources.list
		echo "deb-src http://security.debian.org/ wheezy/updates main" >> /etc/apt/sources.list
		echo "deb http://ftp.ru.debian.org/debian/ wheezy-updates main" >> /etc/apt/sources.list
		echo "deb-src http://ftp.ru.debian.org/debian/ wheezy-updates main" >> /etc/apt/sources.list
		log_t "• Обновляем пакеты •"
		apt-get update
	fi
	if [ "$OS" = "Debian9" ]; then
		log_t "• Добавляем репозиторий •"
		echo "deb http://ftp.ru.debian.org/debian/ stretch main" > /etc/apt/sources.list
		echo "deb-src http://ftp.ru.debian.org/debian/ stretch main" >> /etc/apt/sources.list
		echo "deb http://security.debian.org/ stretch/updates main" >> /etc/apt/sources.list
		echo "deb-src http://security.debian.org/ stretch/updates main" >> /etc/apt/sources.list
		echo "deb http://ftp.ru.debian.org/debian/ stretch-updates main" >> /etc/apt/sources.list
		echo "deb-src http://ftp.ru.debian.org/debian/ stretch-updates main" >> /etc/apt/sources.list
		wget http://www.dotdeb.org/dotdeb.gpg
		apt-key add dotdeb.gpg
		rm dotdeb.gpg
		log_t "• Обновляем пакеты •"
		apt-get update
    fi
	log_t "• Обновляем пакеты •"
	apt-get upgrade -y
	echo mysql-server mysql-server/root_password select "$MYPASS" | debconf-set-selections
	echo mysql-server mysql-server/root_password_again select "$MYPASS" | debconf-set-selections
	log_t "• Устанавливаем пакеты! •"
	apt-get install -y apache2 php5 php5-dev cron unzip sudo nano php5-curl php5-memcache php5-json memcached mysql-server php5-mysql libapache2-mod-php5 php-pear
	log_t "• Включаем модуль ${red}Apache2${green} •"
	a2enmod php5
	service apache2 restart
	log_t "• Устанавливаем ${red}phpMyAdmin${green} •"
	echo "phpmyadmin phpmyadmin/dbconfig-install boolean true" | debconf-set-selections
	echo "phpmyadmin phpmyadmin/mysql/admin-user string root" | debconf-set-selections
	echo "phpmyadmin phpmyadmin/mysql/admin-pass password $MYPASS" | debconf-set-selections
	echo "phpmyadmin phpmyadmin/mysql/app-pass password $MYPASS" |debconf-set-selections
	echo "phpmyadmin phpmyadmin/app-password-confirm password $MYPASS" | debconf-set-selections
	echo "phpmyadmin phpmyadmin/reconfigure-webserver multiselect apache2" | debconf-set-selections
	apt-get install -y phpmyadmin
	log_t "• Устанавливаем ${red}mysql-server ${red}5${green}.${red}6${green} •"
	echo mysql-apt-config mysql-apt-config/select-server select mysql-5.6 | debconf-set-selections
	echo mysql-apt-config mysql-apt-config/select-product select Ok | debconf-set-selections
	wget https://dev.mysql.com/get/mysql-apt-config_0.8.7-1_all.deb
	export DEBIAN_FRONTEND=noninteractive
	dpkg -i mysql-apt-config_0.8.7-1_all.deb 
    apt-get update
	apt-get --yes --force-yes install mysql-server
	sudo mysql_upgrade -u root -p$MYPASS --force --upgrade-system-tables
	service mysql restart
	rm mysql-apt-config_0.8.7-1_all.deb
	cd ~
	log_t "• Настраиваем время на сервере •"
	echo "Europe/Moscow" > /etc/timezone
	dpkg-reconfigure tzdata -f noninteractive
	sudo sed -i -r 's~^;date\.timezone =$~date.timezone = "Europe/Moscow"~' /etc/php5/cli/php.ini
    sudo sed -i -r 's~^;date\.timezone =$~date.timezone = "Europe/Moscow"~' /etc/php5/apache2/php.ini
	log_t "• Устанавливаем необходимые пакеты для ${red}серверной части​${green} •"
	apt-get install -y lsb-release
	apt-get install -y lib32stdc++6
	apt-get install -y libreadline5
	OS=$(lsb_release -s -i -c -r | xargs echo |sed 's; ;-;g' | grep Ubuntu)
	if [ "$OS" = "" ]; then
		sudo dpkg --add-architecture i386
		sudo apt-get update 
		sudo apt-get install -y ia32-libs
		sudo apt-get install -y gcc-multilib
	else
		cd /etc/apt/sources.list.d
		echo "deb http://old-releases.ubuntu.com/ubuntu/ raring main restricted universe multiverse" >ia32-libs-raring.list
		apt-get update
		apt-get install -y ia32-libs
		sudo apt-get install -y gcc-multilib
	fi
	apt-get install -y sudo screen htop nano tcpdump ethstatus ssh zip unzip mc qstat gdb lib32gcc1 nload ntpdate lsof
	apt-get install -y lib32z1
	log_t "• Приступаем к установке ${red}Java 8${green} •"
	wget javadl.sun.com/webapps/download/AutoDL?BundleId=106240 -O jre-linux.tar.gz ///
	tar xvfz jre-linux.tar.gz 
	mkdir /usr/lib/jvm 
	mv jre1.8.0_45 /usr/lib/jvm/jre1.8.0_45 
	update-alternatives --install /usr/bin/java java /usr/lib/jvm/jre1.8.0_45/bin/java 1 
	update-alternatives --config java
	log_t "• Обновляем пакеты •"	
	apt-get update	
	log_t "• Устанавливаем ${red}Java 8${green} •"
	sudo apt-get -y install oracle-java8-installer
	log_t "• Устанавливаем и настраиваем ${red}iptables${green} + ${red}rclocal${green} •"
	rm rclocal; wget -O rclocal $MIRROR/files/debian/rclocal/rclocal.txt
	sed -i '14d' /etc/rc.local
	cat rclocal >> /etc/rc.local
	touch /root/iptables_block
	echo "UseDNS no" >> /etc/ssh/sshd_config
	echo "UTC=no" >> /etc/default/rcS
	rm -rf rclocal
	log_t "• Устанавливаем и настраиваем ${red}iptables${green} + ${red}geoip${green} •"
	sudo apt-get --yes --force-yes install xtables-addons-common
	sudo apt-get --yes --force-yes install libtext-csv-xs-perl libxml-csv-perl libtext-csv-perl unzip
	sudo mkdir -p /usr/share/xt_geoip/
	mkdir geoiptmp
	cd geoiptmp
	/usr/lib/xtables-addons/xt_geoip_dl
	sudo /usr/lib/xtables-addons/xt_geoip_build GeoIPv6.csv GeoIPCountryWhois.csv -D /usr/share/xt_geoip
	cd ~
	rm -rf geoiptmp
	log_t "• Включаем ${red}Nginx${green} для модуля ${red}FastDL${green} •"
	rm nginx; wget -O nginx $MIRROR/files/debian/nginx/nginx.txt
	service apache2 stop
	apt-get install -y nginx
	mkdir -p /var/nginx/ 
	rm -rf /etc/nginx/nginx.conf
	mv nginx /etc/nginx/nginx.conf
	service nginx restart
	service apache2 start
	rm -rf nginx
	log_t "• Устанавливаем и настраиваем ${red}ProFTPd${green} •"
	rm proftpd; wget -O proftpd $MIRROR/files/debian/proftpd/proftpd.txt
	rm proftpd_modules; wget -O proftpd_modules $MIRROR/files/debian/proftpd/proftpd_modules.txt
	rm proftpd_sql; wget -O proftpd_sql $MIRROR/files/debian/proftpd/proftpd_sql.txt
	echo PURGE | debconf-communicate proftpd-basic
	echo proftpd-basic shared/proftpd/inetd_or_standalone select standalone | debconf-set-selections
	apt-get install -y proftpd-basic proftpd-mod-mysql
	rm -rf /etc/proftpd/proftpd.conf
	rm -rf /etc/proftpd/modules.conf
	rm -rf /etc/proftpd/sql.conf
	mv proftpd /etc/proftpd/proftpd.conf
	mv proftpd_modules /etc/proftpd/modules.conf
	mv proftpd_sql /etc/proftpd/sql.conf
	rm -rf proftpd
	rm -rf proftpd_modules
	rm -rf proftpd_sql
	mkdir -p /copy /servers /path/steam /var/nginx
	cd /path/steam && wget http://media.steampowered.com/client/steamcmd_linux.tar.gz
	tar xvfz steamcmd_linux.tar.gz && rm steamcmd_linux.tar.gz
	cd ~
	groupmod -g 998 `cat /etc/group | grep :1000 | awk -F":" '{print $1}'`
    groupadd -g 1000 servers;
	chmod 711 /servers
	chown root:servers /servers
	chmod -R 755 /path
	chown root:servers /path
	chmod -R 750 /copy
	chown root:root /copy
	chmod -R 750 /etc/proftpd
	rm proftpd_sqldump; wget -O proftpd_sqldump $MIRROR/files/debian/proftpd/proftpd_sqldump.txt
	mysql -uroot -p$MYPASS -e "CREATE DATABASE ftp;";
	mysql -uroot -p$MYPASS -e "CREATE USER 'ftp'@'localhost' IDENTIFIED BY '$MYPASS2';";#
	mysql -uroot -p$MYPASS -e "GRANT ALL PRIVILEGES ON ftp . * TO 'ftp'@'localhost';";
	mysql -uroot -p$MYPASS ftp < proftpd_sqldump;
	rm -rf proftpd_sqldump
	sed -i 's/passwdfor/'$MYPASS'/g' /etc/proftpd/sql.conf
	log_t "• Перезагружаем ${red}FTP MySQL${green} •"
	service proftpd restart
	log_t "• Обновляем пакеты и веб сервисы •"
	apt-get update
	service restart apache2
	service mysql restart
	log_t "• Завершаем настройку локации под ${red}BSPanel${green}  • •"
		lines_1
		info_n "••••••••••••••••••••••••••••••••••••••••••••••••••••••••••"
		info_n "• Локация успешно настроена под ${red}BSPanel"
		info_n "••••••••••••••••••••••••••••••••••••••••••••••••••••••••••"
		info_n "• Данные для входа в ${red}phpMyAdmin${YELLOW} и ${red}MySQL${green}:"
		info_n "• ${red}Логин${green}: ${YELLOW}root"
		info_n "• ${red}Пароль${green}: ${YELLOW}$MYPASS"
		info_n "• ${red}Пароль${YELLOW} от базы данных ${red}ftp${green}:${YELLOW}$MYPASS2"
		info_n "• Ссылка на ${red}PhpMyAdmin${green}:${YELLOW}http://$DOMAIN/phpmyadmin"
		info_n "••••••••••••••••••••••••••••••••••••••••••••••••••••••••••"
		info_n "• Данные адреса и пароля:"
		info_n "• Адрес${green}: ${YELLOW}$ipaddress${green}:${YELLOW}22"
		info_n "• Пароль${green}: ${YELLOW}$VPASS"
		info_n "••••••••••••••••••••••••••••••••••••••••••••••••••••••••••"
		info_n "• Данные от FTP:"
		info_n "• ${red}SQL_Логин${green}: ${YELLOW}root"
		info_n "• ${red}SQL_Пароль${green}: ${YELLOW}$MYPASS"
		info_n "• ${red}SQL_FileTP${green}: ${YELLOW}ftp"
		info_n "• ${red}SQL_Порт${green}: ${YELLOW}3306"
		info_n "••••••••••••••••••••••••••••••••••••••••••••••••••••••••••"
		info_n "• ${yellow}Скопируйте все данные и сохраните в файле .txt"
		info_n "• ${red}Данные вам пригодятся при добавлении Локации через Админ Панель"
		lines_1
	Info
	log_t "Спасибо, что настроили Локацию под ${red}BSPanel${green}, Не забудьте сохранить данные"
	Info "• ${red}1${green} - Установить игры"
	Info "• ${red}0${green} - Выйти из установщик"
	Info
	read -p "Пожалуйста, введите номер меню:" case
	case $case in
	    1) install_games;;
		0) exit;;
	esac
}
install_games()
{
	clear
	wow
	log_tt "Список доступных игр"
	Info "• 1 - SteamCMD - обязательно!"
	Info "• 2 - Counter-Strike: 1.6"
	Info "• 3 - Counter-Strike: Source"
	Info "• 4 - Counter-Strike: Source v34"
	Info "• 5 - Counter-Strike: GO"
	Info "• 6 - Multi Theft Auto"
	Info "• 7 - San Andreas Multiplayer"
	Info "• 8 - Crminal Russia Multiplayer"
	Info "• 9 - Minecraft"
	Info "• 0 - В главное меню"
	wow1
	Info
	read -p "Пожалуйста, введите пункт меню: " case
	case $case in
		1)
			mkdir -p /path /path/steam /path/maps /servers
			chmod -R 711 /servers
			chmod -R 755 /path
			chown root:servers /servers /path
			groupmod -g 998 `cat /etc/group | grep :1000 | awk -F":" '{print $1}'`
			groupadd -g 1000 servers;
			cd /path/steam/
			wget http://media.steampowered.com/client/steamcmd_linux.tar.gz
			tar xvzf steamcmd_linux.tar.gz
			rm steamcmd_linux.tar.gz
			install_games
		;;
		2)
			cs_version
		;;
		3)
			if [ -f "/path/steam/steamcmd.sh" ]; then
				cd /path/steam/
				./steamcmd.sh +login anonymous +force_install_dir /path/css/steam/ +app_update 232330 validate +quit
				install_games
			else
				echo "SteamCMD не установлена"
				sleep 2
				Info "Устанавливаем SteamCMD..."
				mkdir -p /path /path/steam /path/maps /servers > /dev/null 2>&1
				chmod -R 711 /servers > /dev/null 2>&1
				chmod -R 755 /path > /dev/null 2>&1
				chown root:servers /servers /path > /dev/null 2>&1
				groupmod -g 998 `cat /etc/group | grep :1000 | awk -F":" '{print $1}'` > /dev/null 2>&1
				groupadd -g 1000 servers; > /dev/null 2>&1
				cd /path/steam/ > /dev/null 2>&1
				wget http://media.steampowered.com/client/steamcmd_linux.tar.gz > /dev/null 2>&1
				tar xvzf steamcmd_linux.tar.gz > /dev/null 2>&1
				rm steamcmd_linux.tar.gz > /dev/null 2>&1

			    if [ $? -eq 0 ]; then
					echo "\033[1;32m [OK] \033[0m\n"
					tput sgr0
			    else
					echo "\033[1;31m [FAIL] \033[0m\n"
					tput sgr0
			    fi
				Info "Устанавливаем CSS..."
				cd /path/steam/
				./steamcmd.sh +login anonymous +force_install_dir /path/css/steam/ +app_update 232330 validate +quit
				install_games
			fi
		;;
		4)
			mkdir -p /path/cssold/
			cd /path/cssold/
			wget $MIRROR/games/cssold/cssold.zip
			unzip cssold.zip
			rm cssold.zip
			install_games
		;;
		5)
			if [ -f "/path/steam/steamcmd.sh" ]; then
				cd /path/steam/
				./steamcmd.sh +login anonymous +force_install_dir /path/csgo/ +app_update 740 validate +quit
				install_games
			else
				echo "SteamCMD не установлена"
				sleep 2
				Info "Устанавливаем SteamCMD..."
				mkdir -p /path /path/steam /path/maps /servers > /dev/null 2>&1
				chmod -R 711 /servers > /dev/null 2>&1
				chmod -R 755 /path > /dev/null 2>&1
				chown root:servers /servers /path > /dev/null 2>&1
				groupmod -g 998 `cat /etc/group | grep :1000 | awk -F":" '{print $1}'` > /dev/null 2>&1
				groupadd -g 1000 servers; > /dev/null 2>&1
				cd /path/steam/ > /dev/null 2>&1
				wget http://media.steampowered.com/client/steamcmd_linux.tar.gz > /dev/null 2>&1
				tar xvzf steamcmd_linux.tar.gz > /dev/null 2>&1
				rm steamcmd_linux.tar.gz > /dev/null 2>&1

			    if [ $? -eq 0 ]; then
					echo "\033[1;32m [OK] \033[0m\n"
					tput sgr0
			    else
					echo "\033[1;31m [FAIL] \033[0m\n"
					tput sgr0
			    fi
			    cd /path/steam/
				./steamcmd.sh +login anonymous +force_install_dir /path/csgo/ +app_update 740 validate +quit
				install_games
			fi
		;;
		6)
			mta_version
		;;
		7)
			samp_version
		;;
		8)
			crmp_version
		;;
		9)
			mc_version
		;;
		0) menu;;
	esac
}
cs_version()
{
	clear
	Info
	log_t "Список доступных версий ${red}CS 1.6"
	Info "• ${red}1${green} ♦ Установить ${red}Build REHLDS"
	Info "• ${red}2${green} ♦ Установить ${red}Build 7559"
	Info "• ${red}3${green} ♦ Установить ${red}Build 6153"
	Info "• ${red}4${green} ♦ Установить ${red}Build 5787"
	Info "• • • • • • • • • • • • • • • • • •"
	Info "•  ${red}0${green}  -> Вернутся в список Игр"
	log_s
	Info
	read -p "Пожалуйста, введите пункт меню:" case
	case $case in
	1)
		mkdir -p /path/cs/rehlds/
		cd /path/cs/rehlds/
		wget $MIRROR/files/games/CSv16/rehlds.zip
		unzip rehlds.zip
		rm rehlds.zip
		cs_version
		;;
		2)
		mkdir -p /path/cs/7559/
		cd /path/cs/7559/
		wget $MIRROR/files/games/CSv16/7559.zip
		unzip 7559.zip
		rm 7559.zip
		cs_version
		;;
		3)
		mkdir -p /path/cs/6153/
		cd /path/cs/6153/
		wget $MIRROR/files/games/CSv16/6153.zip
		unzip 6153.zip
		rm 6153.zip
		cs_version
		;;
		4)
		mkdir -p /path/cs/5787/
		cd /path/cs/5787/
		wget $MIRROR/files/games/CSv16/5787.zip
		unzip 5787.zip
		rm 5787.zip
		cs_version
		;;
		0) install_games;;
	esac
}

mta_version()
{
	clear
	Info
	log_t "Список доступных версия ${red}MTA"
	Info "• ${red}1${green} ♦ Установить ${red}MTA 1.5.5 R2 x64"
	Info "• ${red}2${green} ♦ Установить ${red}MTA 1.5.4 R3 x64"
	Info "• • • • • • • • • • • • • • • • • •"
	Info "•  ${red}0${green}  -> Вернутся в список Игр"
	log_s
	Info
	read -p "Пожалуйста, введите пункт меню: " case
	case $case in
		1)
		mkdir -p /path/mta/mta155/
		cd /path/mta/mta155/
		wget $MIRROR/files/games/MTA/MTA_1.5.5_R2_x64.zip
		unzip MTA_1.5.5_R2_x64.zip
		rm MTA_1.5.5_R2_x64.zip
		mta_version
		;;
		2)
		mkdir -p /path/mta/mta154/
		cd /path/mta/mta154/
		wget $MIRROR/files/games/MTA/MTA_1.5.4_R3_x64.zip
		unzip MTA_1.5.4_R3_x64.zip
		rm MTA_1.5.4_R3_x64.zip
		mta_version
		;;
		0) install_games;;
	esac
}

samp_version()
{
	clear
	Info
	log_t "Список доступных версия ${red}SA:MP"
	Info "• ${red}1${green} ♦ Установить ${red}SA:MP 0.3.7-R2"
	Info "• ${red}2${green} ♦ Установить ${red}SA:MP 0.3z R4"
	Info "• ${red}3${green} ♦ Установить ${red}SA:MP 0.3x-R2"
	Info "• ${red}4${green} ♦ Установить ${red}SA:MP 0.3e-R2"
	Info "• ${red}5${green} ♦ Установить ${red}SA:MP 0.3d-R2"
	Info "• ${red}6${green} ♦ Установить ${red}SA:MP 0.3c-R5"
	Info "• ${red}7${green} ♦ Установить ${red}SA:MP 0.3b-R2"
	Info "• ${red}8${green} ♦ Установить ${red}SA:MP 0.3a-R8"
	Info "• • • • • • • • • • • • • • • • • •"
	Info "•  ${red}0${green} -> Вернутся в список Игр"
	log_s
	Info
	read -p "Пожалуйста, введите пункт меню: " case
	case $case in
		1)
		mkdir -p /path/samp/samp037r2/
		cd /path/samp/samp037r2/
		wget $MIRROR/files/games/SAMP/samp037svr_R2-1.zip
		unzip samp037svr_R2-1.zip
		rm samp037svr_R2-1.zip
		samp_version
		;;
		2)
		mkdir -p /path/samp/samp03zr4/
		cd /path/samp/samp03zr4/
		wget $MIRROR/files/games/SAMP/samp03zsvr_R4.zip
		unzip samp03zsvr_R4.zip
		rm samp03zsvr_R4.zip
		samp_version
		;;
		3)
		mkdir -p /path/samp/samp03xr2/
		cd /path/samp/samp03xr2/
		wget $MIRROR/files/games/SAMP/samp03xsvr_R2.zip
		unzip samp03xsvr_R2.zip
		rm samp03xsvr_R2.zip
		samp_version
		;;
		4)
		mkdir /path/samp/samp03er2/
		cd /path/samp/samp03er2/
		wget $MIRROR/files/games/SAMP/samp03esvr_R2.zip
		unzip samp03esvr_R2.zip
		rm samp03esvr_R2.zip
		samp_version
		;;
		5)
		mkdir -p /path/samp/samp03dr2/
		cd /path/samp/samp03dr2/
		wget $MIRROR/files/games/SAMP/samp03dsvr_R2.zip
		unzip samp03dsvr_R2.zip
		rm samp03dsvr_R2.zip
		samp_version
		;;
		6)
		mkdir -p /path/samp/samp03cr5/
		cd /path/samp03cr5/
		wget $MIRROR/files/games/SAMP/samp03csvr_R5.zip
		unzip samp03csvr_R5.zip
		rm samp03csvr_R5.zip
		samp_version
		;;
		7)
		mkdir -p /path/samp/samp03br2/
		cd /path/samp03br2/
		wget $MIRROR/files/games/SAMP/samp03bsvr_R2.zip
		unzip samp03bsvr_R2.zip
		rm samp03bsvr_R2.zip
		samp_version
		;;
		8)
		mkdir -p /path/samp/samp03ar8/
		cd /path/samp03ar8/
		wget $MIRROR/files/games/SAMP/samp03asvr_R8.zip
		unzip samp03asvr_R8.zip
		rm samp03asvr_R8.zip
		samp_version
		;;
		0) install_games;;
	esac
}

crmp_version()
{
		clear
		Info
		log_t "Список доступных версия ${red}CR:MP"
		Info "• ${red}1${green} ♦ Установить ${red}CR:MP 0.3.7 C5"
		Info "• ${red}2${green} ♦ Установить ${red}CR:MP 0.3e C3"
		Info "• • • • • • • • • • • • • • • •"
		Info "• ${red}0${green} ♦ Вернутся в список Игр"
		log_s
		Info
		read -p "Пожалуйста, введите пункт меню: " case
		case $case in
		1)
			mkdir -p /path/crmp/crmp037/
			cd /path/crmp/crmp037/
			wget $MIRROR/files/games/CRMP/CRMP_0.3.7_C5.zip
			unzip CRMP_0.3.7_C5.zip
			rm CRMP_0.3.7_C5.zip
			crmp_version
		;;
		2)	
			mkdir -p /path/crmp/crmp03e/
			cd /path/crmp/crmp03e/
			wget $MIRROR/files/games/CRMP/CRMP_0.3e_C3.zip
			unzip CRMP_0.3e_C3.zip
			rm CRMP_0.3e_C3.zip
			crmp_version
		;;
		0) install_games;;
	esac
}

mc_version()
{
		clear
		Info
		log_t "Список доступных версий ${red}Minecraft"
		Info "•  ${red}1${green} ¦ Установить ${red}craftbukkit-1.12-R0.1"
		Info "•  ${red}2${green} ¦ Установить ${red}craftbukkit-1.11.2-R0.1"
		Info "•  ${red}3${green} ¦ Установить ${red}craftbukkit-1.11-R0.1"
		Info "•  ${red}4${green} ¦ Установить ${red}craftbukkit-1.10.2-R0.1"
		Info "•  ${red}5${green} ¦ Установить ${red}craftbukkit-1.8.5-R0.1"
		Info "•  ${red}6${green} ¦ Установить ${red}craftbukkit-1.8-R0.1"
		Info "•  ${red}7${green} ¦ Установить ${red}craftbukkit-1.7.9-R0.2"
		Info "•  ${red}8${green} ¦ Установить ${red}craftbukkit-1.6.4-R1.0"
		Info "•  ${red}9${green} ¦ Установить ${red}craftbukkit-1.5.2-R1.0"
		Info "• ${red}10${green} ¦ Установить ${red}craftbukkit-1.5-R0.1"
		Info "• • • • • • • • • • • • • • • • • • • • • •"
		Info "• ${red}0${green} ♦ Вернутся в список Игр"
		log_s
		Info
		read -p "Пожалуйста, введите пункт меню: " case
		case $case in
		1)
			mkdir -p /path/mc/mc112/
			cd /path/mc/mc112/
			wget $MIRROR/files/games/Minecraft/craftbukkit-1.12-R0.1.zip
			unzip craftbukkit-1.12-R0.1.zip
			rm craftbukkit-1.12-R0.1.zip
			mc_version
		;;
		2)	
			mkdir -p /path/mc/mc1112/
			cd /path/mc/mc1112/
			wget $MIRROR/files/games/Minecraft/craftbukkit-1.11.2-R0.1.zip
			unzip craftbukkit-1.11.2-R0.1.zip
			rm craftbukkit-1.11.2-R0.1.zip
			mc_version
		;;
		3)	
			mkdir -p /path/mc/mc111/
			cd /path/mc/mc111/
			wget $MIRROR/files/games/Minecraft/craftbukkit-1.11-R0.1.zip
			unzip craftbukkit-1.11-R0.1.zip
			rm craftbukkit-1.11-R0.1.zip
			mc_version
		;;
		4)	
			mkdir -p /path/mc/mc1102/
			cd /path/mc/mc1102/
			wget $MIRROR/files/games/Minecraft/craftbukkit-1.10.2-R0.1.zip
			unzip craftbukkit-1.10.2-R0.1.zip
			rm craftbukkit-1.10.2-R0.1.zip
			mc_version
		;;
		5)	
			mkdir -p /path/mc/mc185/
			cd /path/mc/mc185/
			wget $MIRROR/files/games/Minecraft/craftbukkit-1.8.5-R0.1.zip
			unzip craftbukkit-1.8.5-R0.1.zip
			rm craftbukkit-1.8.5-R0.1.zip
			mc_version
		;;
		6)	
			mkdir -p /path/mc/mc18/
			cd /path/mc/mc18/
			wget $MIRROR/files/games/Minecraft/craftbukkit-1.8-R0.1.zip
			unzip craftbukkit-1.8-R0.1.zip
			rm craftbukkit-1.8-R0.1.zip
			mc_version
		;;
		7)	
			mkdir -p /path/mc/mc179/
			cd /path/mc/mc179/
			wget $MIRROR/files/games/Minecraft/craftbukkit-1.7.9-R0.2.zip
			unzip craftbukkit-1.7.9-R0.2.zip
			rm craftbukkit-1.7.9-R0.2.zip
			mc_version
		;;
		8)	
			mkdir -p /path/mc/mc164/
			cd /path/mc/mc164/
			wget $MIRROR/files/games/Minecraft/craftbukkit-1.6.4-R1.0.zip
			unzip craftbukkit-1.6.4-R1.0.zip
			rm craftbukkit-1.6.4-R1.0.zip
			mc_version
		;;
		9)	
			mkdir -p /path/mc/mc152/
			cd /path/mc/mc152/
			wget $MIRROR/files/games/Minecraft/craftbukkit-1.5.2-R1.0.zip
			unzip craftbukkit-1.5.2-R1.0.zip
			rm craftbukkit-1.5.2-R1.0.zip
			mc_version
		;;
		10)	
			mkdir -p /path/mc/mc15/
			cd /path/mc/mc15/
			wget $MIRROR/files/games/Minecraft/craftbukkit-1.5-R0.1.zip
			unzip craftbukkit-1.5-R0.1.zip
			rm craftbukkit-1.5-R0.1.zip
			mc_version
		;;
		0) install_games;;
	esac
}

mce_pass()
{
	clear
	wow
	Info "Введите root пароль от MySQL"
	read -p "Введите пароль от phpMyAdmin: " MCE_PASS
	echo "$MCE_PASS" >/root/password.txt
	wow
	echo "${green}------------------------------------------------------"
	Info "• Внимание! Проверьте данные"
	Info "• Root пароль от MySQL: $MCE_PASS"
	Info "• Указанный пароль сохранён в файл [/root/password.txt], скопируйте пароль!"
	Info "• ${red}1${green} - Далее"
	Info "• ${red}2${green} - Изменить"
	Info "• ${red}0${green} - Выйти"
	echo "${green}------------------------------------------------------"
	echo -n "Введите пожалуйста, пункт меню: "
	read item
	case "$item" in
	1|1) echo "Далее..."
	mc_editor
		;;
	2|2) echo "Изменение..."
	mce_pass
		;;
	0|0) echo "Выйти..."
	esac
}
mc_editor()
{
	clear
	wow "Установка MySQL_Config_Editor"
	Info "Скопируйте пароль который сохранен в файл /root/password.txt"
	Info "И вставьте правой кнопкой мыши в поле Enter password: "
	Info "Или введите с клавиатурой, ваш пароль: $MCE_PASS"
	info "Как только нажали правой кнопкой мыши, нажмите Enter"
	mysql_config_editor set --login-path=local --host=localhost --user=root --password
	rm password.txt
}

install_web()
{
	clear
	log_t "Список доступных модулей для ${red}BSPanel"
	Info "• ${red}1${green} - Установить все модули: ${red}S:Bans, CS:Stats, CS:Bans, BPrivileges, [db.] MySQL"
	Info "• ${red}0${green} - Вернуться назад"
	log_s
	Info
	read -p "Пожалуйста, введите пункт меню:" case
	case $case in
	1)
	read -p "${CYAN}Пожалуйста, введите ${red}домен${CYAN}: ${yellow}" DOMAIN

		if [ -z "${DOMAIN}" ]; then
			echo "${green}• Пожалуйста, заполните ${CYAN}${red}*${CYAN} ${green}обязательное поле${CYAN}"
			read -p "${CYAN}Пожалуйста, введите ${red}домен${CYAN}: ${yellow}" DOMAIN
		fi

		if [ -z "${DOMAIN}" ]; then
			install_web
		fi

		mkdir -p /var/www/host.rp-mygame.ru/db
		log_t "• Создаем хост в ${red}Apache2${green} - создание файлов виртуальных хостов •"
		
		rm /etc/apache2/sites-available/db.conf > /dev/null 2>&1
		a2dissite db.conf > /dev/null 2>&1

		FILE='/etc/apache2/sites-available/db.conf' > /dev/null 2>&1
			echo "<VirtualHost *:80>">$FILE
			echo "	ServerName db.$DOMAIN">>$FILE
			echo "	DocumentRoot /var/www/host.rp-mygame.ru/db">>$FILE
			echo "	<Directory /var/www/host.rp-mygame.ru/db/>">>$FILE
			echo "	Options Indexes FollowSymLinks MultiViews">>$FILE
			echo "	AllowOverride All">>$FILE
			echo "	Order allow,deny">>$FILE
			echo "	allow from all">>$FILE
			echo "	</Directory>">>$FILE
			echo "	ErrorLog \${APACHE_LOG_DIR}/error.log">>$FILE
			echo "	LogLevel warn">>$FILE
			echo "	CustomLog \${APACHE_LOG_DIR}/access.log combined">>$FILE
			echo "</VirtualHost>">>$FILE

		if [ $? -eq 0 ]; then
			echo "\033[1;32m [OK] \033[0m\n"
			tput sgr0
	    else
			echo "\033[1;31m [FAIL] \033[0m\n"
			tput sgr0
	    fi
		log_t "• Перезагружаем ${red}Apache2${green} •"
		
		a2ensite db.conf > /dev/null 2>&1
		service apache2 restart	> /dev/null 2>&1
		if [ $? -eq 0 ]; then
			echo "\033[1;32m [OK] \033[0m\n"
			tput sgr0
	    else
			echo "\033[1;31m [FAIL] \033[0m\n"
			tput sgr0
	    fi

		rm -r /path/web > /dev/null 2>&1
		echo "${CYAN} Скачиваем ${red}Веб модулей...${CYAN}"
		wget -P /path/web $MIRROR/files/web/web.zip > /dev/null 2>&1
		if [ $? -eq 0 ]; then
			echo "\033[1;32m [OK] \033[0m\n"
			tput sgr0
	    else
			echo "\033[1;31m [FAIL] \033[0m\n"
			tput sgr0
	    fi
		cd /path/web
		echo "${CYAN} Распаковываем ${red}Веб модулей...${CYAN}"
		unzip web.zip > /dev/null 2>&1
		if [ $? -eq 0 ]; then
			echo "\033[1;32m [OK] \033[0m\n"
			tput sgr0
	    else
			echo "\033[1;31m [FAIL] \033[0m\n"
			tput sgr0
	    fi
		rm web.zip
		cd ~
		rm -r /var/www/host.rp-mygame.ru/system/library/web/free.php > /dev/null 2>&1
		cd /var/www/host.rp-mygame.ru/system/library/web/
		wget http://cdn.bspanel.ru/files/web/free.zip > /dev/null 2>&1
		unzip free.zip > /dev/null 2>&1
		rm free.zip
		gotova_web;;
		0) menu;;
	esac
}


gotova_web()
{
	clear
	Info
	log_t "• Вы успешно установили WEB модули"
	Info "${red}0${green} - Выйти"
	Info
	read -p "Пожалуйста, введите пункт меню: " case
	case $case in
	0) menu;;
	esac
}

menu()
{
	clear
	wow
	infomenu
	Info "• ${red}1${green} - Установить ${red}BSPanel${green}"
	Info "• ${red}2${green} - Настройка локации под ${red}BSPanel${green}"
	Info "• ${red}3${green} - Меню ${red}установки WEB модулей${green}"
	Info "• ${red}4${green} - Установка Mysql_Config_Editor(${red}Обязательно для работы MySQL${green})"
	Info "• ${red}5${green} - Меню установки ${red}игр${green}"
	Info "• ${red}0${green} - Выйти"
	wow1
	read -p "Пожалуйста, введите пункт меню: " case
	case $case in
		1) install_check;;
		2) settings_location;;
		3) install_web;;
		4) mce_pass;;
		5) install_games;;
		0) exit;;
	esac
}
menu
