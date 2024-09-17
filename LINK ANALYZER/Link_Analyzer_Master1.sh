#!/bin/bash

# Set the link as an argument
link=$1

# Trace network and device
whois_output=$(whois -h whois.arin.net $link)
if [ $? -ne 0 ]; then
  echo '{"error": "Failed to retrieve WHOIS information"}'
  exit 1
fi
netrange=$(echo "$whois_output" | grep -oP '(?<=NetRange: ).*')
orgname=$(echo "$whois_output" | grep -oP '(?<=OrgName: ).*')

# Trace country
country=$(geoiplookup $link)
if [ $? -ne 0 ]; then
  echo '{"error": "Failed to retrieve GeoIP information"}'
  exit 1
fi

# Check IP validity
ip=$(dig +short $link)
if [ $? -ne 0 ]; then
  echo '{"error": "Failed to retrieve DNS information"}'
  exit 1
fi
if [ -n "$ip" ]; then
  ip_validity="valid"
else
  ip_validity="not valid"
fi

# Scan for malware
clamscan_output=$(clamscan -i $link)
if [ $? -ne 0 ]; then
  echo '{"error": "Failed to scan for malware"}'
  exit 1
fi
if [ -n "$clamscan_output" ]; then
  malware_detection="detected"
else
  malware_detection="not detected"
fi

# Detect SQL injection
sqlmap_output=$(sqlmap -u $link --batch)
if [ $? -ne 0 ]; then
  echo '{"error": "Failed to detect SQL injection"}'
  exit 1
fi
if [ -n "$sqlmap_output" ]; then
  sql_injection_detection="detected"
else
  sql_injection_detection="not detected"
fi

# Display timestamp
timestamp=$(date)

# Output JSON data
echo "{
  \"link\": \"$link\",
  \"netrange\": \"$netrange\",
  \"orgname\": \"$orgname\",
  \"country\": \"$country\",
  \"ip_validity\": \"$ip_validity\",
  \"malware_detection\": \"$malware_detection\",
  \"sql_injection_detection\": \"$sql_injection_detection\",
  \"timestamp\": \"$timestamp\"
}"