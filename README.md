# hdiscover
This bash script has been made for discover all active hosts on a LAN.
After the scan the script also does name resolution, this identifies the name of active hosts as well other hosts not connected at the moment of the scan (DNS cache).

## Install 

In order to work this script needs arping, ping and nslookup. Make sure they're installed before to start.

arping github download: https://github.com/ThomasHabets/arping

## Usage 
```

sudo ./hdiscover.sh [option]

```

For ping scan use -p option
  
For arp scan use -a option 


This script works only for IPV4

The arping -w option is set by default to 15 (so it will wait 15 seconds to receive a response), this can be changed.
