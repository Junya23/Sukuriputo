#!/bin/bash

# Cloudflare API
apiKey=""
email=""

# Domain
domain=""

# Get zone ID
zoneId=$(curl -s -X GET "https://api.cloudflare.com/client/v4/zones?name=$domain" \
        -H "X-Auth-Email: $email" \
        -H "X-Auth-Key: $apiKey" \
        -H "Content-Type: application/json" | jq -r '.result[0].id')

# Get record ID
recordId=$(curl -s -X GET "https://api.cloudflare.com/client/v4/zones/$zoneId/dns_records?type=AAAA&name=$domain" \
          -H "X-Auth-Email: $email" \
          -H "X-Auth-Key: $apiKey" \
          -H "Content-Type: application/json" | jq -r '.result[0].id')

# Get current IPv6 address
ipv6Address=$(ip -6 addr show scope global | awk '/inet6/{print $2}' | grep '^2' | cut -d '/' -f 1)

# Cloudflare API URL
apiUrl="https://api.cloudflare.com/client/v4/zones/$zoneId/dns_records/$recordId"

# Data for updating record
data="{\"type\":\"AAAA\",\
\"name\":\"$domain\",\
\"content\":\"$ipv6Address\",\
\"ttl\":1,\
\"proxied\":false}"

# Send request to update DNS record
response=$(curl -s -X PUT -d "$data" "$apiUrl" \
           -H "X-Auth-Email: $email" \
           -H "X-Auth-Key: $apiKey" \
           -H "Content-Type: application/json"
)

echo "$response"
