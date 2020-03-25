# wireshark-tips-n-tricks
This reporsitory containing scripts, tips and tricks for Wireshark / tshark usage and PCAP handling which I have noticed frequently used when I'm working in telecom

## makeHostsFile.sh
Script will parse IP addresses from PCAP and try to find reverse names for those from DNS. From that information it will generate hosts file which can be sent along with PCAP for thirt party e.g. to be used with Wireshark

**Requirements:**
- tshark and dig installed
- access to DNS which can be used for reverse queries

**Usage:**
```
./makeHostsFile.sh [PCAP file] [hosts file] [server]

PCAP file - PCAP to be parsed
hosts file - file to be created
server - DNS server to be used for resolving the names (if not defined, will use OS own resolver)
```

**Example:**
```
./makeHostsFile.sh my-important-trace.pcap my-hosts-file-for-pcap.txt
```
