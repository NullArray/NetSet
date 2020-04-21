# NetSet
Operational Security utility and automator. ( Version 1.1.0 )


NetSet is designed to automate a number of operations that will help the user with securing their
network traffic. It also provides an easy way to gather proxies and run utilities through Tor.

All the utilities installed and used by NetSet will be automatically configured as well. Of course
the tool itself isn't the be all of Operational Security. Rather it is a convenient way of getting yourself
set up with the basics.

NetSet facilitates, among other things; 

A terminal multiplexer on demand, that has it's sessions routed through Tor.
Secured DNS traffic through automatic installation and configuration of DNSCrypt-proxy.
Tor Wall functionality that forces all traffic through the Tor Network.
Easy access to online OPSEC resources, the web resources in question can be opened in-script

And more.

### DNSCrypt-Proxy Config

Recently i've noticed that certain distros, even though they're Debian or Ubuntu derivatives don't seem to be able to
process the configuration file that gets downloaded through `apt` or is written out by means of NetSet's `debconf.sh`
script.

Therefore i did some testing and managed to put together a `DNSCrypt-proxy.toml` file, based on original examples by
the DNSCrypt dev that appears to work on most systems. If you're interested find it [here](https://gist.github.com/NullArray/28958795b16f8eda7a5b0a69f8ce57fe). If you're still facing some trouble, please don't hesitate to open up a ticket. And i'll get back to you as soon as i am able to, to help you troubleshoot. Thanks!  


## Usage

After cloning the repo navigate to the `NetSet` directory and run the following:
```
chmod +x *.sh
 ./netset-main.sh --install

#sudo ./netset-main.sh --install
```
This will install and configure everything you'll need for NetSet to function properly. 

### Update

From now on NetSet will install `veracrypt` and `pwgen` and provide automated operations related to those utilities on top of all the
features Version 1.0.0 provides.

Using `sudo` to start the script will execute every operation within the script as root, this means you won't be prompted for your `sudo` password when an operation requires elevated privileges. However all items written by NetSet will consequently be owned by root as well, including backup directories. Last but not least; when considering security implications, it is not recommended to run everything with super user privileges.

Starting the main script with `sudo` will be optional from now on to reflect the above considerations.

### Options

Please see an option overview below.
```
CLI Arguments                            
    '-t' or '--terminal' Starts         
    terminal multiplexer with all       
    connections routed through Tor        
										 
    '-s' or '--status' prints a status   
    overview of NetSet related network   
    utilities and their current state.

    '-i' or '--install' runs a script
    designed to install all of NetSet's
    dependencies and configures them

Menu Options

 'Usage'          - Print options overview
 'Status'         - Print Status overview
 'Spoof MAC'      - Spoof MAC Address
 'Random Proxies' - Scrape random proxies
 'GeoSort Proxies'- Scrape GeoSorted proxies
 'ProtonVPN'      - Start ProtonVPN
 'Tor Terminal'   - Start terminal multi-
                    plexer, with all sessions
                    routed through Tor
 'Tor Wall'       - Configures iptables to
                    force all connections
                    through Tor.
 'Veracrypt'      - Start encryption and
 		    password gen menu	
 'OPSEC Resources'- Display NetSet's included
                    list of web resources.
  		    Select an entry to open
                    it in your default browser
```

### Note
Tested on Ubuntu 19.04

The Python invocations to launch the web resources provided with NetSet are in 2.7 Syntax. If your OS doesn't 
have Python2.7 changing the invocation from `python -m webbrowser URL` to `python3 -m webbrowser URL` should 
remedy any compatibility issues, should you come across them in this particular regard. 

I plan on expanding this tool in the future with even more OPSEC related resources and/or operations.

Should you happen to come across a bug or have any questions regarding this tool.
Please feel free to [Open a Ticket](https://github.com/NullArray/NetSet/issues)

Thank you.


