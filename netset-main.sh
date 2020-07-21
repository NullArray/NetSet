#!/bin/bash
#____   ____             __
#\   \ /   /____   _____/  |_  ___________
# \   Y   // __ \_/ ___\   __\/  _ \_  __ \
#  \     /\  ___/\  \___|  | (  <_> )  | \/
#   \___/  \___  >\___  >__|  \____/|__|
#              \/     \/
#--Licensed under GNU GPL 3
#----Authored by Vector/NullArray
##############################################

# Coloring scheme for notfications and logo
ESC="\x1b["
RESET=$ESC"39;49;00m"
CYAN=$ESC"33;36m"
RED=$ESC"31;01m"
GREEN=$ESC"32;01m"

# Working dir
CWD=$(pwd)
# Date
NOW=$(date +"%d_%m_%Y")
# Active connected interface
IFACES=$(ip link | awk -F: '$0 !~ "lo|vir|wl|^[^0-9]"{print $2;getline}')

# Default value for this var should be 0
# When started with the --status arg set
# value to 1 in order to print logo and
# exit after one operation
stus=0

# Declare associative array for tip of the day feature
declare -A TotD

TotD[0]="\nTip: Starting the script with '-t' or '--terminal' starts a terminal\nmultiplexer where all sessions are routed through Tor\n"
TotD[1]="\nTip: Starting the script with '-s' or '--status' shows the operational\nstatus of NetSet security utilities\n"
TotD[2]="\nTip: Starting the script with '-i' or '--install' will run installation\nand auto-config procedures for NetSet\n"
TotD[3]="\nTip: Choosing option 1 in the main menu loop will print\nextended usage information\n"
TotD[4]="\nTip: For other offensive and defensive security utilities\nvisit github.com/NullArray\n"
TotD[5]="\nTip: Operational Security isn't just a matter of having the\nright utilities.\n It's also about discipline in thought, action,\nand careful information consideration and management.\n"
TotD[6]="\nTip: If you want to know more about how you can improve your\nOPSEC beyond what NetSet offers\n select the 'OPSEC Resources'\noption from the main menu and start learning!\n"
TotD[7]="\nTip: You can change the resolvers that DNSCrypt-proxy uses\nby adding them to the 'server_names' array which can be\nfound in /etc/dnscrypt-proxy/dnscrypt-proxy.toml\n"
TotD[8]="\nTip: Looking for more resolvers? Select 'OPSEC Resources'\nin the main menu Then from the next menu select\n'DNSCrypt Resolvers' to open a list in your browser\n"
TotD[9]="\nTip: The 'depconf.sh' script has installed 'proxychains' as well\nRun 'man proxychains' for details and usage."

# Declare associative array for Version Display
declare -A VeR

VeR[0]="Version 1.1.0"             # Official Version is 1.1.0 but for fun we have;
VeR[1]="The Crypto Drome Edition." # Some catchy catchphrases,
VeR[2]="More Secure, Less Hassle"  # And pseudo serious slogans

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
	rng=$[ $RANDOM % 3 ]
	clear
	echo -e "\n $CYAN

  ███╗   ██╗███████╗████████╗███████╗███████╗████████╗
  ████╗  ██║██╔════╝╚══██╔══╝██╔════╝██╔════╝╚══██╔══╝
  ██╔██╗ ██║█████╗     ██║   ███████╗█████╗     ██║
  ██║╚██╗██║██╔══╝     ██║   ╚════██║██╔══╝     ██║
  ██║ ╚████║███████╗   ██║   ███████║███████╗   ██║
  ╚═╝  ╚═══╝╚══════╝   ╚═╝   ╚══════╝╚══════╝   ╚═╝
  # ${VeR[$rng]}
  ###################################################
$CYAN  #$GREEN--|Operational Security Utility
$CYAN  #$GREEN--|Authored by Vector/NullArray
$CYAN  #$GREEN--|
$CYAN  #$GREEN----License:
$CYAN  #$GREEN--------GNU GPL 3
$RESET  \n"
	}

function intro(){
	echo -e "$CYAN
+--------------------------------------------------+
|$RESET General Usage and Overview $CYAN           |$RESET
+--------------------------------------------------+$RESET
$CYAN|$RESET NetSet is designed to automate a number of
$CYAN|$RESET operations that will help the user securing their
$CYAN|$RESET network traffic. It also provides an easy way to
$CYAN|$RESET gather proxies and run utilities through Tor.
$CYAN|$RESET
$CYAN|$RESET Furthermore; included with this script is a
$CYAN|$RESET selection of easily accessible online resources
$CYAN|$RESET where the user can go to learn more about the
$CYAN|$RESET techniques one can employ above and beyond
$CYAN|$RESET the technical aspects.
$CYAN|$RESET
$CYAN|$RESET In a lot of ways, OPSEC is a state of mind.
$CYAN|$RESET
$CYAN|$RESET To get started select 'Usage' in the main menu.
$CYAN+---------------------------->$RESET
	"
	}

function usage(){
	echo -e "$CYAN
+------------------------------------------------------>
|	$RESET Options Overview $RESET $CYAN
+------------------------------------------>
$CYAN|$RESET CLI Arguments
$CYAN|$RESET    '-t' or '--terminal' Starts
$CYAN|$RESET    terminal multiplexer with all
$CYAN|$RESET    connections routed through Tor
$CYAN|$RESET
$CYAN|$RESET    '-s' or '--status' prints a status
$CYAN|$RESET     overview of NetSet related network
$CYAN|$RESET     utilities and their current state.
$CYAN|$RESET
$CYAN|$RESET    '-i' or '--install' runs a script
$CYAN|$RESET    designed to install all of NetSet's
$CYAN|$RESET    dependencies and configures them
$CYAN|$RESET
$CYAN|$RESET Menu Options
$CYAN|$RESET
$CYAN|$RESET 'Usage'          - Print options overview
$CYAN|$RESET 'Status'         - Print Status overview
$CYAN|$RESET 'Spoof MAC       - Spoof MAC Address
$CYAN|$RESET 'Random Proxies' - Scrape random proxies
$CYAN|$RESET 'GeoSort Proxies'- Scrape GeoSorted proxies
$CYAN|$RESET 'ProtonVPN'      - Start ProtonVPN
$CYAN|$RESET 'Tor Terminal'   - Start terminal multi-
$CYAN|$RESET                    plexer, with all sessions
$CYAN|$RESET                    routed through Tor
$CYAN|$RESET 'Tor Wall'       - Configures iptables to
$CYAN|$RESET                    force all connections
$CYAN|$RESET                    through Tor.
$CYAN|$RESET 'Veracrypt'      - Start encryption and
$CYAN|$RESET		   	password gen menu
$CYAN|$RESET 'OPSEC Resources'- Display NetSet's included
$CYAN|$RESET                    list of web resources.
$CYAN|$RESET  			Select an entry to open
$CYAN|$RESET                    it in your default browser
$CYAN|$RESET
$CYAN+----------------------------> $RESET
	"
	}

function vpn_ops(){
	# Run VPN
	notification_b "Starting ProtonVPN menu"
	sudo protonvpn connect || warning "Something went wrong"
	notification "Done" && sleep 2
	menu
	}

function r_proxies(){
	# Random proxies
	notification_b "Fetching random proxies..." && sleep 2
	wget -O proxies/random-proxies.log https://raw.githubusercontent.com/clarketm/proxy-list/master/proxy-list.txt | sed '1,3d; $d; s/\s.*//; /^$/d' > random-proxies.log
	notification "Done" && sleep 2
	menu
	}

function chmac(){
	# Spoof to random/custom MAC
	notification_b "Use a random MAC Address or custom?"
	read -p '[R]andom/[C]ustom ' choice
	if [[ $choice == 'r' || $choice == 'R' ]]; then
		for x in $IFACES; do sudo macchanger --random $x; done
		notification "Done" && sleep 4
	else
		if [[ $choice == 'c' || $choice == 'C' ]]; then
			read -p 'Enter Custom MAC: ' value
			for x in $IFACES; do sudo macchanger --mac=$value $x; done
                        notification "Done" && sleep 4
		else
			warning "Unhandled Option"
		fi
	fi
	menu
	}


function status(){
	# This function provides a quick overview of the network status
	if [[ stus == 1 ]]; then logo; fi

	notification "Loading status information..." && sleep 2

	echo -e "Status on $NOW \n\n"
	echo -e "\n$CYAN Current MAC. $RESET\n"
	for x in $IFACES; do echo $x && sudo macchanger -s $x; done && sleep 3.5
	echo -e "\n$CYAN Current External IP $RESET\n"
	curl https://api.myip.com && sleep 3.5
	echo -e "\n\n$CYAN Current VPN Status$RESET\n"
	protonvpn status && sleep 3.5 || warning "ProtonVPN not configured"
	notification "Loading relevant services status..." && sleep 2

        sudo systemctl status tor.service
	tr=$(sudo systemctl status tor.service)
	case $tr in
		# Does the var contain the string below?
		*"Active: inactive (dead)"*)
		t=1
		;;
	esac

        sudo systemctl status openvpn.service
	ovpn=$(sudo systemctl status openvpn.service)
	case $ovpn in
		# Does the var contain the string below?
		*"Active: inactive (dead)"*)
		o=1
		;;
	esac

        sudo systemctl status dnscrypt-proxy.service
	dnsc=$(sudo systemctl status dnscrypt-proxy.service)
	case $dnsc in
		# Does the var contain the string below?
		*"Active: inactive (dead)"*)
		d=1
		;;
	esac


	# Report and activate inactive services
	if [[ $d == 1 ]]; then
		warning "DNS Crypt Service is inactive"
		sudo systemctl restart dnscrypt-proxy && notification "Service Restarted" || warning "An error was encountered while trying to start the DNS Crypt Service"
	fi

	if [[ $o == 1 ]]; then
		warning "OpenVPN Service is inactive"
		sudo systemctl restart openvpn && notification "Service Restarted" || warning "An error was encountered while trying to start the OpenVPN Service"
	fi

	if [[ $t == 1 ]]; then
		warning "Tor Service is inactive"
		sudo systemctl restart tor && notification "Service Restarted" || warning "An error was encountered while trying to start the Tor Service"
	fi

	# CLI arg status operation ends here
	if [[ $stus == 1 ]]; then notification_b "Status check completed" && exit 0; fi

	notification "Done."
	read -p 'Enter any button to continue: ' null

	clear && menu

	}

function proxy_ops(){
	notification_b "Select Area"
	echo -e "\n
[1] North America
[2] South America
[3] Europe
[4] Eastern Europe
[5] Asia
[Q] Quit to Main Menu\n"
	read -p 'Enter Choice: ' choice
	if [[ $choice == '1' ]]; then python proxies/fetch.py --country='canada|united states|greenland|australia|new zealand' --max-latency=3 --anonymity='elite|anonymous' --output=North-American.log; fi
	if [[ $choice == '2' ]]; then python proxies/fetch.py --country='mexico|argentina|venezuela|colombia|brazil|cuba|ecuador' --max-latency=3 --anonymity='elite|anonymous' --output=South-American.log; fi
	if [[ $choice == '3' ]]; then python proxies/fetch.py --country='germany|belgium|britain|holland|france|italy|switzerland|austria|spain' --max-latency=3 --anonymity='elite|anonymous' --output=Western-Europe.log; fi
	if [[ $choice == '4' ]]; then python proxies/fetch.py --country='russia|ukraine|belarus|moldova|latvia|hungary|estonia' --max-latency=3 --anonymity='elite|anonymous' --output=Eastern-Europe.log; fi
	if [[ $choice == '5' ]]; then python proxies/fetch.py --country='china|japan|korea|thailand|india|bangladesh|hong kong' --max-latency=3 --anonymity='elite|anonymous' --output=Asia.log; fi

	if [[ $choice == 'Q' || $choice == 'q' ]]; then
		echo -e "Returning to main menu..."
		sleep 2 && menu
	else
		warning "Unhandled Option"
		echo -e "Returning to main menu..."
		sleep 2 && menu

	fi
	}


function torwall(){
	notification "TorWall uses IPTables and Tor as a Transparant SOCKS proxy."
	echo -e "Please remember that this is not the most secure way of using Tor\n"
	echo -e "It is recommended to at least have DNSCrypt-proxy running as well."
	echo -e "Or start a Tor Terminal Session instead."
	sleep 2
	# Tor user id
	_tor_uid=$(id -u debian-tor)
	# Add regular user to tor-uid
	usermod --append -G $_tor_uid

	_trans_port=9040

	# Destinations that will not be routed through tor
	_non_tor="127.0.0.0/8 10.0.0.0/8 172.16.0.0/12 192.168.0.0/16"

	notification_b "Writing new FireWall rules."
	#IPT=$(sudo /sbin/iptables)

	sudo iptables -F
	sudo iptables -X
	sudo iptables -t nat -F
	sudo iptables -t nat -X
	sudo iptables -t mangle -F
	sudo iptables -t mangle -X
	sudo iptables -P INPUT ACCEPT
	sudo iptables -P FORWARD ACCEPT
	sudo iptables -P OUTPUT ACCEPT

	# Allow established connections
	sudo iptables -A INPUT -m state --state RELATED,ESTABLISHED -j ACCEPT
	sudo iptables -A OUTPUT -m state --state RELATED,ESTABLISHED -j ACCEPT

	# Allow traffic on loopback interface
	sudo iptables -A INPUT -i lo -j ACCEPT

	# Allow all tor traffic
	sudo iptables -t nat -A OUTPUT -m owner --uid-owner $_tor_uid -j RETURN

	# Route DNS queries through tor
	# sudo iptables -t nat -A OUTPUT -p udp --dport 53 -j REDIRECT --to-ports 53

	# Allow direct destinations
	for i in $_non_tor; do
		sudo iptables -t nat -A OUTPUT -d $i -j RETURN
		sudo iptables -A OUTPUT -d $i -j RETURN
	done

	# Route all traffic through tor
	sudo iptables -t nat -A OUTPUT -p tcp --syn -j REDIRECT --to-ports $_trans_port
	sudo iptables -A OUTPUT ! -o lo ! -d 127.0.0.1 ! -s 127.0.0.1 -p tcp -m tcp --tcp-flags ACK,FIN ACK,FIN -j LOG --log-prefix "Transproxy leak blocked: " --log-uid
	sudo iptables -A OUTPUT ! -o lo ! -d 127.0.0.1 ! -s 127.0.0.1 -p tcp -m tcp --tcp-flags ACK,RST ACK,RST -j LOG --log-prefix "Transproxy leak blocked: " --log-uid
	sudo iptables -A OUTPUT ! -o lo ! -d 127.0.0.1 ! -s 127.0.0.1 -p tcp -m tcp --tcp-flags ACK,FIN ACK,FIN -j DROP
	sudo iptables -A OUTPUT ! -o lo ! -d 127.0.0.1 ! -s 127.0.0.1 -p tcp -m tcp --tcp-flags ACK,RST ACK,RST -j DROP

	sudo iptables -A OUTPUT -m owner --uid-owner $_tor_uid -j ACCEPT

	sudo iptables -A OUTPUT -j REJECT to $UID

	notification "Done" && sleep 2
	status
	menu
	}


function ip_tabs(){
	# Make preperations for TorWall
	notification_b "Start or Stop TorWall?"
	read -p '[start]/[stop] ' choice
	if [[ $choice == 'Start' || $choice == 'start' ]]; then
		sudo iptables-save > ip_table_backup/my.active.firewall.rules
		torwall
	else
		if [[ $choice == 'Stop' || $choice == 'stop' ]]; then
			# Reverse changes
			sudo iptables -F
			sudo iptables -X
			sudo iptables -Z
			sudo iptables -t nat -F
			sudo iptables -t nat -X
			sudo iptables -t nat -Z
			sudo iptables-restore ip_table_backup/my.active.firewall.rules
			notification "Done" && sleep 2

			menu
		else
			warning "Unhandled Option"
		fi
	fi
	}

# Password generation menu
function pw_ops(){
    logo
    PS3='Please enter your choice: '
    options=("Generate 16char password" "Generate 32char password" "Generate 16char batch" "Generate 32char batch" "Quit")
    select opt in "${options[@]}"
    do
    	case $opt in
		"Generate 16char password")
		clear && pwgen --secure 16 1
		read -p "Enter any button to continue..." null && logo
		echo -e "
1) Generate 16char password  3) Generate 16char batch	  5) Quit
2) Generate 32char password  4) Generate 32char batch\n"
		printf "%b \n"
			;;
		"Generate 32char password")
		clear && pwgen --secure 32 1
		read -p "Enter any button to continue..." null && logo
		echo -e "
1) Generate 16char password  3) Generate 16char batch	  5) Quit
2) Generate 32char password  4) Generate 32char batch\n"
		printf "%b \n"
			;;
		"Generate 16char batch")
		clear && pwgen --secure 16 28
		read -p "Enter any button to continue..." null && logo
		echo -e "
1) Generate 16char password  3) Generate 16char batch	  5) Quit
2) Generate 32char password  4) Generate 32char batch\n"
		printf "%b \n"
			;;
		"Generate 32char batch")
		clear && pwgen --secure 32 14
		read -p "Enter any button to continue..." null && logo
		echo -e "
1) Generate 16char password  3) Generate 16char batch	  5) Quit
2) Generate 32char password  4) Generate 32char batch\n"
		printf "%b \n"
			;;
		"Quit")
		break
			;;
		*) echo invalid option;;
	esac
    done

    menu

	}

# Launch and manage all disk encryption and password ops
function cryptodrome(){
	logo
	echo -e "Please select an action\n
[1] Password Generation
[2] Invoke online VeraCrypt documentation
[3] Invoke VeraCrypt Graphical User Interface
[Q] Quit to Main Menu\n"
	read -p "Enter Choice " choice
	if [[ $choice == '1' ]]; then pw_ops; fi
	if [[ $choice == '2' ]]; then python -m webbrowser https://www.veracrypt.fr/en/Documentation.html; fi
	if [[ $choice == '3' ]]; then veracrypt; fi
	if [[ $choice == 'Q' || $choice == 'q' ]]; then
		echo -e "Returning to main menu..."
		sleep 2 && menu

	fi

	echo -e "Returning to main menu..."
	sleep 2 && menu

	}

function resources(){
	# Online resources
	logo
        notification "View OPSEC related resources in your browser."
	PS3='Please enter your choice: '
	options=("Valid MAC Addresses" "HiddenWall - Kernel Module FireWall" "OPSEC Resources - GreySec" "OPSEC Resources - TheGrugq" "OPSEC Presentations - TheGrugq"  "Personal Security Guide - CryptoSeb" "OPSEC Blog - B3RN3D" "OPSEC & Privacy e-book - @CryptoCypher" "Quit")
	select opt in "${options[@]}"
	do
		case $opt in
			"Valid MAC Addresses")
			python -m webbrowser https://gist.github.com/NullArray/0380871a42b608830357f998df735e71
			printf "%b \n"
				;;
			"DNSCrypt Resolvers")
			python -m webbrowser https://gist.github.com/NullArray/e9961cb5574656ecf0d35b09c6567e2c
			printf "%b \n"
				;;
			"HiddenWall - Kernel Module FireWall")
			python -m webbrowser https://github.com/CoolerVoid/HiddenWall
			printf "%b \n"
				;;
			"OPSEC Resources - GreySec")
			python -m webbrowser https://greysec.net/forumdisplay.php?fid=10
			printf "%b \n"
				;;
			"OPSEC Resources - TheGrugq")
			python -m webbrowser https://grugq.github.io/resources
			printf "%b \n"
				;;
			"OPSEC Presentations - TheGrugq")
			python -m webbrowser https://grugq.github.io/presentations/
			printf "%b \n"
				;;
			"Personal Security Guide - CryptoSeb")
			python -m webbrowser https://github.com/cryptoseb/CryptoPaper
			printf "%b \n"
				;;
			"OPSEC Blog - B3RN3D")
			python -m webbrowser https://www.b3rn3d.com/
			printf "%b \n"
				;;
			"OPSEC & Privacy e-book - @CryptoCypher")
			python -m webbrowser https://github.com/crypto-cypher/privacy-for-identities
			printf "%b \n"
				;;
			"Quit")
                        break
				;;
			*) echo invalid option;;
		esac
	done

  	menu

	}

# Main menu
function menu(){
	# Print banner
	logo
	# Print TotD every so often
	rand=$[ $RANDOM % 10 ] && echo -e ${TotD[$rand]}

	PS3='Please enter your choice: '
	options=("Help" "Status" "Spoof MAC" "Random Proxies" "GeoSort Proxies" "ProtonVPN" "Tor Terminal" "Tor Wall" "Veracrypt" "OPSEC Resources" "Quit")
	select opt in "${options[@]}"
	do
		case $opt in
			"Help")
			usage
			printf "%b \n"
				;;
			"Status")
			status
			printf "%b \n"
				;;
			"Spoof MAC")
			chmac
			printf "%b \n"
				;;
			"Random Proxies")
			r_proxies
			printf "%b \n"
				;;
			"GeoSort Proxies")
			proxy_ops
			printf "%b \n"
				;;
			"ProtonVPN")
			vpn_ops
			printf "%b \n"
				;;
			"Tor Terminal")
			torsocks python -m pymux #|| . torsocks on
			printf "%b \n"
				;;
			"Tor Wall")
			ip_tabs
			printf "%b \n"
				;;
			"Veracrypt")
			cryptodrome
			printf "%b \n"
				;;
			"OPSEC Resources")
			resources
			printf "%b \n"
				;;
			"Quit")
			 exit 0
				;;
			*) echo invalid option;;
		esac
	done
	}

# Do not make a backup dir each run
stat backup-* > /dev/null || dir=1
if [[ $dir == 1 ]]; then
	mkdir "backup-$(date)" 2&> /dev/null
	mkdir ip_table_backup 2&> /dev/null
	mkdir proxies 2&> /dev/null
fi

# Check for command line arguments
if [[ "$1" != "" ]]; then
    	case $1 in
		'-i' | '--install' )
		bash depconf.sh && menu
	esac
fi

if [[ "$1" != "" ]]; then
	case $1 in
		'-s' | '--status' )
		stus=1 && status
	esac
fi

if [[ "$1" != "" ]]; then
	case $1 in
		'-t' | '--terminal' )
		torsocks python -m pymux #|| . torsocks on
	esac
fi


function init_x(){
    	# Print banner
    	logo
    	# print intro
    	intro
    	# menu
	menu
	
	}

# Check to see if VeraCrypt is installed
if [[ -z $(which veracrypt) ]]; then stat installed.log > /dev/null && bash depconf.sh --crypto && menu; fi

# Check for root
if [[ "$EUID" -ne 0 ]]; then
    	warning "Some operations require Root to run."
    	read -p "Continue as normal user? [Y]es/[N]o " choice
    	if [[ $choice == 'Y' || $choice == 'y' ]]; then
    		stat installed.log > /dev/null && init_x || warning "Dependencies missing, restart the script with --install" && exit 1
	else
		warning "User Aborted"
		exit 1
	fi
else
        # Check to see if depconf.sh has been succesfully executed
	stat installed.log > /dev/null && init_x || warning "Dependencies missing, restart the script with --install" && exit 1
fi
