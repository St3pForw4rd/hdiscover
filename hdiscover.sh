#!/bin/bash


# **
#* This script has been made for discover all active hosts on a LAN
#* 
#* After the scan the script also does name resolution, this identifies the name of active hosts as well other hosts not connected at the moment of the scan
#* 
#* For ping scan use -p option
#* For arp scan use -a option
#* 
#* In order to run this script you need: arping, ping, nslookup
#*
#* arping github download: https://github.com/ThomasHabets/arping
#*
#* This script works only for IPV4
#*
#* The arping -w option is set by default to 15 (so it will wait 15 seconds to receive a response), this can be changed.


subnet_value=$(ip -o -f inet addr show | awk '/scope global/ {print $4}'| cut -d "/" -f 2) 
host_number=$(((2**(32-subnet_value))-2)) 
f3bytes=$(ip -o -f inet addr show | awk '/scope global/ {print $4}'| cut -d "." -f 1,2,3)  

	if [ "$1" == "" ]
	then
	 echo "Insert first argument!"
	 
	elif [ "$1" == "-h" ] || [ "$1" == "--help" ]
	then
         echo "Usage"
         echo "./hdiscover.sh [options]"
         echo ""
         echo "Options:"
         echo "-p 		ping scan e.g ./hdiscover.sh -p"
         echo "-a              using arp scan e.g ./hdiscover.sh -a"
         echo "-h or --help 	for help"
         
        elif [ "$1" == "-p" ]
        then
        
    	    echo "HDISCOVER v1.0"
	    echo ""
	    echo "-----PING SCAN-----"
	    echo ""
	    
            for ip in `seq 1 $host_number`; do
            ping -c 1 $f3bytes.$ip | grep "64 bytes" | cut -d " " -f 4 | tr -d ":" | sed 's/^/IP->/' | sed 's/$/ host is up/'  & #execute ping and parse output
            done
            wait
            
            echo ""
            echo "resolving host names..."
            echo ""
            
            for ip in `seq 1 254`; do
            nslookup $f3bytes.$ip | grep "name" &        
            done
            wait
            
            echo ""
            echo "Scan completed"
                                
        elif [ "$1" == "-a" ]
        then
        
            echo "HDISCOVER v1.0"
	    echo ""
	    echo "-----ARP SCAN-----"
	    echo ""
	    
            for ip in `seq 1 $host_number`; do
            #change -w option to change wait time
            arping  $f3bytes.$ip -w 15 | grep -m 1 "bytes from" | cut -d " " -f 4,5 | sed 's/.$//' |tr -d "(" | tr -d ")" | sed 's/^/MAC->/' | sed 's/^\( *[^ ]\+\)/\1 IP->/' | sed 's/$/  host is up/' & #execute arping and parse output
            done
            wait
            
            echo ""
            echo "resolving host names..."
            echo ""
            
            for ip in `seq 1 254`; do
            nslookup $f3bytes.$ip | grep "name" &        
            done
            wait
            
            echo ""
            echo "Scan completed"
          
        else 
          echo "incorrect input, type -h or --help for reference"        
        fi   

	wait
