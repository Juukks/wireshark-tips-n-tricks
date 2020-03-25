#!/bin/bash

display_usage() { 
	echo -e "\nUsage: $0 [PCAP file] [hosts file] [server] \n" 
	echo -e "\tPCAP file - PCAP to be parsed"
	echo -e "\thosts file - file to be created"
	echo -e "\tserver - DNS server to be used for resolving the names\n"
} 

# if less than two arguments supplied, display usage 
if [  $# -le 1 ] 
then 
	display_usage
	exit 1
fi 

# check whether user had supplied -h or --help . If yes display usage 
if [[ ( $# == "--help" ) ||  $# == "-h" ]] 
then 
	display_usage
	exit 0
fi

PCAPFILE=$1
HOSTSFILE=$2
SERVER=$3

# Creating temporary file for temporary IP list
tmpfile=$(mktemp /tmp/makeHostsFile.XXXXXX)

#Parsing source and destination IPs of packets from PCAP
# - Getting IPs to each row
# - sorting those to the order
# - getting only uniq IPs
# - Discarding blank lines

tshark -r $PCAPFILE -T fields -e ip.src -e ip.dst | awk -F " " '{print $1"\n"$2"\n"}' | sort | uniq | grep -v "^$" > $tmpfile

#Looping through the IP list
while IFS= read -r line
do
	#If DNS server given, use that, if not use OS own to perform the reverse query
	if [ "$SERVER" == "" ]
	then
		dig=$(dig -x $line +short)
	else
		dig=$(dig @${SERVER} -x $line +short)
	fi
	
	#If we got results, print those to the file
	if [ "$dig" != "" ]
	then
		echo -n "$line "
		echo $dig | awk -F " " '{print $1}'
	fi
	 
done < $tmpfile > $HOSTSFILE

# Removing temporary file
rm $tmpfile

exit 0
