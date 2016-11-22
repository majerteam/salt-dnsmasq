salt-dnsmasq
==============

Initial config
---------------

Some values should be tweaked in salt/init.sls and each file of files.

Day to day config
------------------

All day to day config belongs in lan_hosts.sls.

What this recipe does
---------------------

Keep hosts files up to date for dnsmasq to serve them. I have 2 tld with the same contents.

You have to fill the DHCP records by hands (here, files vlan10 and vlan20).
