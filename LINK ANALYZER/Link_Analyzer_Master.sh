#!/bin/bash

# Set the link as an argument
link=$1

# Trace network and device
whois_output=$(whois -h whois.arin.net $link)
echo "Network: $(echo "$whois_output" | grep -oP '(?<=NetRange: ).*')"
echo "Device: $(echo "$whois_output" | grep -oP '(?<=OrgName: ).*')"

# Trace country
country=$(geoiplookup $link | awk '{print $4}')
echo "Country: $country"

# Check IP validity
ip=$(dig +short $link)
if [ -n "$ip" ]; then
  echo "IP is valid: $ip"
else
  echo "IP is not valid"
fi

# Scan for malware
clamscan_output=$(clamscan -i $link)
if [ -n "$clamscan_output" ]; then
  echo "Malware detected: $clamscan_output"
else
  echo "No malware detected"
fi

# Detect SQL injection
sqlmap_output=$(sqlmap -u $link --batch)
if [ -n "$sqlmap_output" ]; then
  echo "SQL injection detected: $sqlmap_output"
else
  echo "No SQL injection detected"
fi

# Display timestamp
echo "Timestamp: $(date)"