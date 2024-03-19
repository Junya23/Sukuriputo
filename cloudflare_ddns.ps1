# Cloudflare API
$apiKey = ""
$email = ""

# Domain and record name
$domain = ""
$recordName = ""

# Get current IPv6 address
$ipv6Address = Get-NetIPAddress -AddressFamily IPv6 -AddressState Preferred -PrefixOrigin RouterAdvertisement -SuffixOrigin Link `
    | Where-Object { $_.IPAddress -like '24*' } `
    | Select-Object -ExpandProperty IPAddress

# Get zone ID
$zone = Invoke-RestMethod -Uri "https://api.cloudflare.com/client/v4/zones?name=$domain" `
    -Method Get `
    -Headers @{"X-Auth-Email"=$email; "X-Auth-Key"=$apiKey; "Content-Type"="application/json"}
$zoneId = $zone.result[0].id

# Get record ID
$record = Invoke-RestMethod -Uri "https://api.cloudflare.com/client/v4/zones/$zoneId/dns_records?type=AAAA&name=$recordName.$domain" `
    -Method Get `
    -Headers @{"X-Auth-Email"=$email; "X-Auth-Key"=$apiKey; "Content-Type"="application/json"}
$recordId = $record.result[0].id

# Cloudflare API URL
$apiUrl = "https://api.cloudflare.com/client/v4/zones/$zoneId/dns_records/$recordId"

# Headers
$headers = @{
    "X-Auth-Email" = $email
    "X-Auth-Key" = $apiKey
    "Content-Type" = "application/json"
}

# Data for updating record
$data = @{
    type = "AAAA"
    name = "$recordName.$domain"
    content = $ipv6Address
    ttl = 1
    proxied = $false
} | ConvertTo-Json

# Send request to update DNS record
$response = Invoke-RestMethod -Uri $apiUrl -Method Put -Headers $headers -Body $data

$response
