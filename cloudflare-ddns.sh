#!/bin/bash

# Cloudflare API credentials
apiKey=""
email=""

# Domain and record name
domain="example.com"
recordName="example"

# Get zone ID
zoneId=$(curl -s -X GET "https://api.cloudflare.com/client/v4/zones?name=$domain" -H "X-Auth-Email: $email" -H "X-Auth-Key: $apiKey" -H "Content-Type: application/json" | jq -r '.result[0].id')

# Get record ID
recordId=$(curl -s -X GET "https://api.cloudflare.com/client/v4/zones/$zoneId/dns_records?type=A&name=$recordName.$domain" -H "X-Auth-Email: $email" -H "X-Auth-Key: $apiKey" -H "Content-Type: application/json" | jq -r '.result[0].id')

# Get current IPv6 address
ipv6Address=$(ip -6 addr show scope global | awk '/inet6/{print $2}' | grep '^2' | cut -d '/' -f 1)

# Cloudflare API URL
apiUrl="https://api.cloudflare.com/client/v4/zones/$zoneId/dns_records/$recordId"

# Headers
headers="X-Auth-Email: $email\nX-Auth-Key: $apiKey\nContent-Type: application/json"

# Data for updating record
data="{\"type\":\"AAAA\",\"name\":\"$recordName.$domain\",\"content\":\"$ipv6Address\",\"ttl\":1,\"proxied\":false}"

# Send request to update DNS record
response=$(curl -s -X PUT -H "$headers" -d "$data" "$apiUrl")

echo "$response"
