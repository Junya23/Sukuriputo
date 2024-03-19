#!/bin/bash

# Cloudflare API
apiKey=""
email=""
zoneId=""
recordId=""

# Get current IPv6 address
ipv6Address=$(ip -6 addr show scope global | awk '/inet6/{print $2}' | grep '^2' | cut -d '/' -f 1)

apiUrl="https://api.cloudflare.com/client/v4/zones/$zoneId/dns_records/$recordId"
headers="X-Auth-Email: $email\nX-Auth-Key: $apiKey\nContent-Type: application/json"
data="{\"type\":\"AAAA\",\"name\":\"example.com\",\"content\":\"$ipv6Address\",\"ttl\":1,\"proxied\":false}"

# Send request to Cloudflare API
response=$(curl -s -X PUT -H "$headers" -d "$data" "$apiUrl")

echo "$response"
