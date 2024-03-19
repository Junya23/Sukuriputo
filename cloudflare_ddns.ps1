# Cloudflare API
$apiKey = ""
$email = ""
$zoneId = ""
$recordId = ""

# Get current IPv6 address
$ipv6Address = Get-NetIPAddress -AddressFamily IPv6 -AddressState Preferred -PrefixOrigin RouterAdvertisement -SuffixOrigin Link | Where-Object { $_.IPAddress -like '24*' } | Select-Object -ExpandProperty IPAddress

$apiUrl = "https://api.cloudflare.com/client/v4/zones/$zoneId/dns_records/$recordId"
$headers = @{
    "X-Auth-Email" = $email
    "X-Auth-Key" = $apiKey
    "Content-Type" = "application/json"
}
$data = @{
    type = "AAAA"  # AAAA for ipv6, A for ipv4
    name = ""  # Your domain
    content = $ipv6Address
    ttl = 1  # Auto
    proxied = $false
} | ConvertTo-Json
# $data
$response = Invoke-RestMethod -Uri $apiUrl -Method Put -Headers $headers -Body $data
$response
