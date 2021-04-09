#!/bin/bash
clear
backbot=$1
[[ -z $backbot ]] && {
	IP=$(wget -qO- ipv4.icanhazip.com)
	apchon () {
		if netstat -nltp|grep 'dropbear' > /dev/null; then
			[[ ! -d /var/www/html ]] && mkdir /var/www/html
			[[ ! -d /var/www/html/backup ]] && mkdir /var/www/html/backup
			touch /var/www/html/backup/index.html
			/etc/init.d/apache2 restart
		else
			apt-get install apache2 zip -y
			sed -i "s/Listen 80/Listen 81/g" /etc/apache2/ports.conf
			service apache2 restart
			[[ ! -d /var/www/html ]] && mkdir /var/www/html
			[[ ! -d /var/www/html/backup ]] && mkdir /var/www/html/backup
			touch /var/www/html/backup/index.html
			chmod -R 755 /var/www
			/etc/init.d/apache2 restart
		fi
	}
	fun_temp () {
		helice () {
			apchon > /dev/null 2>&1 & 
			tput civis
			while [ -d /proc/$! ]
			do
				for i in / - \\ \|
				do
					sleep .1
					echo -ne "\e[1D$i"
				done
			done
			tput cnorm
		}
		echo -ne "\033[1;33mWaiting\033[1;31m.\033[1;32m.\033[1;33m. \033[1;32m"
		helice
		echo -e "\e[1DOk"
	}
	geralink () {
		if [ -d /var/www/html/backup ]; then
			rm -rf /var/www/html/backup/backup.vps > /dev/null 2>&1
			cp $HOME/backup.vps /var/www/html/backup/backup.vps
			sleep 2
		fi
	}
	fun_temp2 () {
		helice () {
			geralink > /dev/null 2>&1 & 
			tput civis
			while [ -d /proc/$! ]
			do
				for i in / - \\ \|
				do
					sleep .1
					echo -ne "\e[1D$i"
				done
			done
			tput cnorm
		}
		echo -ne "\033[1;33mGENERATING LINK\033[1;31m.\033[1;32m.\033[1;33m. \033[1;32m"
		helice
		echo -e "\e[1DOk"
	}
	figlet Rolka | lolcat
	echo -e "\E[44;1;37m             Backup Manager              \E[0m"
	echo ""
	echo -e "\033[1;31m[\033[1;36m1\033[1;31m] \033[1;37m• \033[1;33mCREATE BACKUP"
	echo -e "\033[1;31m[\033[1;36m2\033[1;31m] \033[1;37m• \033[1;33mRESTORE BACKUP"
	echo -e "\033[1;31m[\033[1;36m3\033[1;31m] \033[1;37m• \033[1;33mBACK\033[1;37m"
	echo ""
	echo -ne "\033[1;32mWHAT DO YOU WANT TO DO\033[1;31m ?\033[1;37m : "; read opcao
	if [[ "$opcao" = '1' ]]; then
		if [ -f "/root/usuarios.db" ]
		then
			rm -rf $HOME/backup.vps > /dev/null 2>&1
			sleep 1
			tar cvf /root/backup.vps /root/usuarios.db /etc/shadow /etc/passwd /etc/group /etc/gshadow > /dev/null 2>&1
			echo ""
			echo -e "\033[1;32mSUCCESSFUL BACKUP !\033[0m"
			echo ""
			echo -ne "\033[1;32mGENERATE DOWNLOAD LINK \033[1;31m? \033[1;33m[s/n]:\033[1;37m "; read resp
			if [[ "$resp" = "s" ]]; then
				echo ""
				fun_temp
				echo ""
				fun_temp2
				echo ""
				if [ -e /var/www/html/backup/backup.vps ]; then
					if [[ "$VERSION_ID" = 'VERSION_ID="14.04"' ]]; then
						echo -e "\033[1;32mLINK\033[1;37m: \033[1;36m$IP:81/html/backup/backup.vps\033[0m"
					else
						echo -e "\033[1;32mLINK\033[1;37m: \033[1;36m$IP:81/backup/backup.vps\033[0m"
					fi
				else
					echo -e "\033[1;32mAvailable in\033[1;31m" ~/"backup.vps\033[0m"
				fi
			else
				echo -e "\n\033[1;32mAvailable in\033[1;31m" ~/"backup.vps\033[0m"
				sleep 2
				menu
			fi
		else
			echo ""
			echo -e "\033[1;32mCreating backup...\033[0m"
			echo ""
			tar cvf /root/backup.vps /etc/shadow /etc/passwd /etc/group /etc/gshadow > /dev/null 2>&1
			sleep 2s
			echo ""
			echo -e "\033[1;33mO Arquivo \033[1;32mbackup.vps"
			echo -e "\033[1;33mwas successfully created in the directory \033[1;31m/root\033[0m"
			echo ""
		fi
	fi
	if [[ "$opcao" = '2' ]]; then
		if [ -f "/root/backup.vps" ]
		then
			echo ""
			echo -e "\033[1;36mRestoring Backup..."
			echo ""
			sleep 2s
			cp /root/backup.vps /backup.vps
			cd /
			tar -xvf backup.vps
			rm /backup.vps
			echo ""
			echo -e "\033[1;36mUsers and\033[1;36m successfully imported passwords.\033[0m"
			echo ""
			exit
		else
			echo ""
			echo -e "\033[1;33mThe file \033[1;32mbackup.vps \033[1;33mnão foi encontrado!\033[0m"
			echo -e "\033[1;33mMake sure it is located in the directory. /root/ com o nome \033[1;32mbackup.vps\033[0m"
			echo ""
			exit
		fi
	fi
	if [[ "$opcao" = '3' ]]; then
		menu
	fi
} || {
	rm /root/backup.vps 1>/dev/null 2>/dev/null
	tar cvf /root/backup.vps /root/usuarios.db /etc/shadow /etc/passwd /etc/group /etc/gshadow /etc/bot 1>/dev/null 2>/dev/null
	[[ -d "/etc/SSHPlus/backups" ]] && mv /root/backup.vps /etc/SSHPlus/backups/backup.vps
	exit
}


