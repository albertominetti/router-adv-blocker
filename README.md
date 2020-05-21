# Adv blocker for linux routers
This script avoids the unwanted advertising on the web by blocking the DNS resolution using dnsmasq. It block avertisings with any dnsmasq compatible router and automate downloading of the latest list once a week.

## Blocking by DNS
When a website wants to show, it just include in the webpage the url of the adv provider, then your browser has to retrieve the adv and display in the page. The browser has to know the exact IP of the adv before downloading it, and to do that it has to query the DNS server for the lookup. If you are using a router that runs its own DNS resolver as service, you are using most probably dnsmasq. With this script, when your browser ask for the IP of an adv, your dnsmasq on the router will reply with a not valid IP, that leads your browser to fail to display the advertising.

Of course on yur PC browser you can use any AdBlock extensions for the same purpose, but this requires a setup on each single browser and PC in your home network. Moreover there are several devices that cannot install additional extension or plugin, like the broswers on your mobile.

Moreover also several apps in your smartphone can benefit by this solution, as an example you should be able to avoid the annoying youtube video adv.

## Sources for hostfiles
The adv hosts are public at the following urls:
* http://winhelp2002.mvps.org/
* https://adaway.org/
* https://github.com/StevenBlack/hosts 
* https://someonewhocares.org/
* http://www.hostsfile.org

## How to install
1) Move both files on your router using scp or by copy&paste
2) include a run of `avs_dns_blocker.sh` in the startup of the router, [here](https://wiki.dd-wrt.com/wiki/index.php/Startup_Scripts) you can find the setup for DD-WRT
3) (optional) include a run of `adv_adv_blocker.sh` in the cron jobs to weekly update the adv hosts

## Compatibility
The script uses a low footprint on memory and space usage to run on low performance systems. It also uses a subset of shell commands that should be compatible with several embedded and old linux routers. Tested on [DD-WRT](https://dd-wrt.com/) v3.0 July-2015

## Montioring
* You can find the logs usilg the command  `tail -f /tmp/var/log/messages`
* The merge result of the blocked dns are in the file `/tmp/hosts0`
