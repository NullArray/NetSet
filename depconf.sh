#!/bin/bash
#____   ____             __
#\   \ /   /____   _____/  |_  ___________
# \   Y   // __ \_/ ___\   __\/  _ \_  __ \
#  \     /\  ___/\  \___|  | (  <_> )  | \/
#   \___/  \___  >\___  >__|  \____/|__|
#              \/     \/
#--Licensed under GNU GPL 3
#----Authored by Vector/NullArray for NetSet
##############################################

# Coloring scheme for notfications and logo
ESC="\x1b["
RESET=$ESC"39;49;00m"
CYAN=$ESC"33;36m"
RED=$ESC"31;01m"
GREEN=$ESC"32;01m"

# Warning
function warning(){
	echo -e "\n$RED [!] $1 $RESET\n"
	}

# Green notification
function notification() {
	echo -e "\n$GREEN [+] $1 $RESET\n"
	}

# Cyan notification
function notification_b() {
	echo -e "\n$CYAN [-] $1 $RESET\n"
	}

function logo(){
	clear
	echo -e "\n $CYAN

  ███╗   ██╗███████╗████████╗███████╗███████╗████████╗
  ████╗  ██║██╔════╝╚══██╔══╝██╔════╝██╔════╝╚══██╔══╝
  ██╔██╗ ██║█████╗     ██║   ███████╗█████╗     ██║
  ██║╚██╗██║██╔══╝     ██║   ╚════██║██╔══╝     ██║
  ██║ ╚████║███████╗   ██║   ███████║███████╗   ██║
  ╚═╝  ╚═══╝╚══════╝   ╚═╝   ╚══════╝╚══════╝   ╚═╝
  ###################################################
$CYAN  #$GREEN--| DEPENDENCY & CONFIG SETUP
$CYAN  #$GREEN--|Authored by Vector/NullArray
$CYAN  #$GREEN--|
$CYAN  #$GREEN----License:
$CYAN  #$GREEN--------GNU GPL 3
$RESET "
	}

function dns_test(){
	notification "Testing DNSCrypt-proxy configuration" && sleep 2

	# Check if we can resolve github.com
	dnscrypt-proxy -resolve github.com > /dev/null || dcheck=1

	if [[ $dcheck == 1 ]]; then
		warning "Unable to resolve hosts with DNSCrypt-proxy"
		echo -e "Auto-Config Failed." && sleep 3 && clear
		notification_b "Print instructions on manually configuring DNSCrypt?"
		read -p '[Y]es/[N]o: ' choice
		if [[ $choice == 'y' || $choice == 'Y' ]]; then
			echo -e "
1. Open your NetworkManager and navigate to your connection.
2. Select the option that allows you to edit the settings.
3. Navigate to IPv4 Settings.
4. Click on the drop-down menu labeled 'Method'
5. From there select the option called:
   Automatic(DHCP Addresses Only)
6. In the 'DNS Servers' field enter the following value:
   127.0.2.1
7. Click 'Save' and exit the NetworkManager\n"
			read -p 'Press any button to continue ' null && clear
			notification_b "Restarting appropriate services"
			sudo systemctl restart NetworkManager
			sudo systemctl restart dnscrypt-proxy && notification "DNSCrypt Configuration Complete"
		else
			warning "Aborted"
		fi
	else
		notification "DNSCrypt configuration and installation complete"
	fi

	}

function resolv_conf(){
	# Creating resolv.conf overide
	echo "nameserver 127.0.2.1" | sudo tee /etc/resolv.conf.override
	sudo chmod 0777 /etc/resolv.conf.override
	sudo chown root:root /etc/resolv.conf.override

	# Create NetMan script
	touch 20-resolv.conf.override
	echo -e "
#########
#!/bin/sh
cp -f /etc/resolv.conf.override" > tmp.log
	tail -n 2 tmp.log > 20-resolv-conf-override
	# Move to appropriate directory
	sudo mv -f 20-resolv-conf-override /etc/NetworkManager/dispatcher.d/
	# Set appropriate permissions
	# sudo chmod 0755 /etc/NetworkManager/dispatcher.d/20-resolv-conf-override
	sudo chown root:root /etc/NetworkManager/dispatcher.d/20-resolv-conf-override
	# Symlink
	sudo ln -f /etc/NetworkManager/dispatcher.d/20-resolv-conf-override /etc/NetworkManager/dispatcher.d/pre-up.d/
	# Restart affected services
	sudo systemctl restart NetworkManager
	sudo systemctl restart dnscrypt-proxy
	}

function conf_dnsmasq(){
	notification "Creating backups for original configuration"
	sudo cp /etc/dnsmasq.d backup-*
	notification "Writing new configuration"
	echo -e"# Redirect everything to dnscrypt-proxy
server=127.0.2.1
no-resolv
proxy-dnssec" | sudo tee /etc/dnsmasq.d/dnscrypt-proxy

	}

function conf_netman(){
	notification "Creating backups for original configuration"
	sudo cp /etc/NetworkManager/NetworkManager.conf backup-*
	notification "Writing new configuration"
	echo -e "[main]
plugins=ifupdown,keyfile,ofono
#dns=dnsmasq

[ifupdown]
managed=false" | sudo tee /etc/NetworkManager/NetworkManager.conf


	}

function dnscrypt(){
	notification "Installing and configuring DNSCrypt-proxy"
	dnscv=$(dnscrypt-proxy --version)
	case $dnscv in
		*"2.0.19"*)
		pv=1
		;;
	esac

	if [[ $pv != 1 ]]; then
		sudo apt purge dnscrypt-proxy > /dev/null
		sudo apt install -y dnscrypt-proxy
		stat /etc/dnsmasq.d/dnscrypt-proxy > /dev/null || notification "Configuring dnsmasq" && conf_dnsmasq
		notification "Configuring resolvconf"
		resolv_conf
	fi

	if [[ -z $(which dnscrypt-proxy) ]]; then
		os=$(uname -a)
		case $os in
			# Does $os contain 'Debian'?
			*"Debian"*)
			d=1
			;;
		esac
		if [[ d=1 ]]; then
			# It is essential to add these sources in order to
			# properly install and configure DNSCrypt-proxy on Debian
			echo "deb https://deb.debian.org/debian/ testing main" | sudo tee /etc/apt/sources.list.d/testing.list
			echo "deb https://deb.debian.org/debian/ unstable main" | sudo tee /etc/apt/sources.list.d/unstable.list

			# It is equally essential to pin them in order not to
			# install utilities that would otherwise be incompatible
			# or undesirable on the system in question
			notification "Creating 'pinning.conf' backup"
			sudo cp /etc/apt/preferences.d/pinning.pref backup-*
			notification "Writing new configuration"
			echo -e "
Package: *
Pin: release a=stable
Pin-Priority: 900

Package: *
Pin: release a=testing
Pin-Priority: 500

Package: *
Pin: release a=unstable
Pin-Priority: 100 " > pinning.pref
			sudo mv -f pinning.pref /etc/apt/preferences.d/
			warning "IMPORTANT [!]" && sleep 1
			echo "While the applied config procedures originate"
			echo "from DNSCrypt-proxy's official documentation."
			echo "Should you find that when next you perform an"
			echo "upgrade, unwanted packages are being included."
			echo -e "Restore the backup file from the backup dir.\n"
			echo -e "For more information run: man apt_preferences\n"

			read -p 'Enter any button to to continue: ' null && clear
			notification "Preparations complete. Installing."
			sudo apt update && sudo apt install -y testing dnscrypt-proxy
            		sudo apt install -y unstable dnscrypt-proxy
			notification "Operations Completed"
		else
			os=$(uname -a)
			case $os in
				# Does $os contain 'Ubuntu'?
				*"Ubuntu"*)
				u=1
				;;
			esac

			if [[ $u != 1 ]]; then warning "Only Debian and Ubuntu configurations supported at this time." && exit 0; fi
			if [[ $u == 1 ]]; then
				notification "Installing and configuring DNSCrypt-proxy"
				# The reason we're adding this repository is because
				# it has a version compatible with most Ubuntu OS Versions
				sudo add-apt-repository ppa:shevchuk/dnscrypt-proxy
				sudo apt-get update
				sudo apt-get -y install dnscrypt-proxy
				if [[ -z $(which dnsmasq) ]]; then
					notification "Configuring Network Manager"
					conf_netman
					notification "Configuring resolvconv"
					resolv_conf
				else
					stat /etc/dnsmasq.d/dnscrypt-proxy > /dev/null || notification "Configuring dnsmasq" && conf_dnsmasq
					notification "Configuring resolvconv"
					resolv_conf
				fi
			fi
		fi
	fi

	notification "Task Completed"

	}

# Install VeraCrypt and pwgen
function vera(){
	logo
	echo -e "\n
Welcome to the config and dependency manager for NetSet.

The latest release adds VeraCrypt. This provides the user
with the means to create encrypted volumes and keep data
safe. This version also installs 'pwgen' in order to
generate secure passwords conveniently.\n"
	read -p 'Start installation? [Y]es/[N]o: ' choice
	if [[ $choice == 'y' || $choice == 'Y' ]]; then
		notification "Installing VeraCrypt" && sleep 2
		# Create dir to extract tar to
		mkdir veracrypt && cd veracrypt
		wget -O veracrypt.tar.bz2 https://launchpad.net/veracrypt/trunk/1.23/+download/veracrypt-1.23-setup.tar.bz2
		tar -xvjf veracrypt.tar.bz2 || warning "Something went wrong" && exit 1

		MACHINE_TYPE=`uname -m`
		if [[ ${MACHINE_TYPE} == 'x86_64' ]]; then
			chmod +x veracrypt-1.23-setup-gui-x64
			./veracrypt-1.23-setup-gui-x64 && notification "Installed VeraCrypt"
		else
			chmod +x veracrypt-1.23-setup-gui-x86
			./veracrypt-1.23-setup-gui-x86 && notification "Installed VeraCrypt"
		fi
		# Back to depconf dir
		cd ..

		# Install pwgen for secure password generation
		if [[ -z $(which pwgen) ]]; then
			notification "Installing 'pwgen' for secure password generation." && sleep 2
			sudo apt-get -y pwgen || warning "Something went wrong" && exit 1
		fi
	fi
	}

function start(){
	# Print banner
	logo
	echo -e "\n
Welcome to the config and dependency manager for NetSet.
All third party utilities employed by NetSet will be
automatically installed and configured by this script.

Before making changes all relevant config files will
be backed up in a directory labeled: 'backup- $(date) '\n"
	read -p 'Start installation? [Y]es/[N]o: ' choice
	if [[ $choice == 'y' || $choice == 'Y' ]]; then
        # Install utilities
		notification "Checking system utilities." && sleep 2
		if [[ -z $(which pymux) ]]; then pip install pymux; fi
		if [[ -z $(which tor) ]]; then sudo apt-get -y install tor; fi
		if [[ -z $(which nmcli) ]]; then sudo apt-get -y install nmcli; fi
	    	if [[ -z $(which torsocks) ]]; then sudo apt-get -y install torsocks; fi
		if [[ -z $(which openvpn) ]]; then sudo apt-get -y install openvpn; fi
		if [[ -z $(which iptables) ]]; then sudo apt-get -y install iptables; fi
		if [[ -z $(which macchanger) ]]; then sudo apt-get -y install macchanger; fi
		if [[ -z $(which proxychains) ]]; then
			sudo apt-get -y install proxychains
			notification_b "Proxychains has been installed, run 'man proxychains' for details."

        	fi

		notification "Packages checked."

		# Install and config DNSCrypt
		dnscrypt && dns_test
		echo "DNSCrypt-proxy installed and configured" > installed.log

		# Install proxy fetcher
		wget -O proxies/fetch.py https://raw.githubusercontent.com/stamparm/fetch-some-proxies/master/fetch.py && echo "Proxy Fetcher installed" >> installed.log

		if [[ -z $(which protonvpn) ]]; then
			echo -e "Would you like to install ProtonVPN?"
			read -p '[Y]es/[N]o ' choice
			if [[ $choice == 'y' || $choice == 'Y' ]]; then
				notification_b "You need an account at Proton before you can use ProtonVPN"
				echo -e "Open registration page with web browser?"
				read -p '[Y]es/[N]o ' choice
				if [[ $choice == 'y' || $choice == 'Y' ]]; then
					python -m webbrowser https://protonvpn.com/free-vpn
				else
					warning "Skipping Account Creation"
					if [[ -z $(which dialog) ]]; then sudo apt-get install -y dialog; fi

					pip3 install protonvpn-cli || sudo pip3 install protonvpn-cli
					protonvpn init
					
				fi
			fi
		fi

	else
		warning "Installation Aborted"
	fi

	# Install VeraCrypt
	vera

	}

# Check to see if we only need to install VeraCrypt
if [[ "$1" != "" ]]; then
    	case $1 in
		'--crypto' )
		vera
	esac
else
	# Install all
	start
fi
