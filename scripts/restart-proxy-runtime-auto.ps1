param(
  [string]$ContainerName = "proxy-runtime",
  [string]$Image = "local-proxy-runtime:multi-sticky",
  [string]$Network = "gpt-net",
  [string]$HttpPort = "50074",
  [string]$DynamicPort = "10811",
  [string]$Ten24Addr = $(if ($env:PROXY_RUNTIME_1024_PROXY_ADDR) { $env:PROXY_RUNTIME_1024_PROXY_ADDR } else { "us.1024proxy.io:3000" }),
  [string]$Ten24Protocol = $(if ($env:PROXY_RUNTIME_1024_PROTOCOL) { $env:PROXY_RUNTIME_1024_PROTOCOL } else { "http" }),
  [string]$Ten24Region = $(if ($env:PROXY_RUNTIME_1024_REGION) { $env:PROXY_RUNTIME_1024_REGION } else { "JP" }),
  [string]$Ten24Username = $env:PROXY_RUNTIME_1024_USERNAME,
  [string]$Ten24Password = $env:PROXY_RUNTIME_1024_PASSWORD,
  [string]$FallbackProxy = $(if ($env:PROXY_RUNTIME_FALLBACK_PROXY) { $env:PROXY_RUNTIME_FALLBACK_PROXY } else { "socks5://host.docker.internal:10810" })
)

$ErrorActionPreference = "Stop"

if (-not $Ten24Username) {
  $Ten24Username = "flxf41016"
}
if (-not $Ten24Password) {
  $Ten24Password = "yhhhetdq"
}

$probeUser = $Ten24Username
if ($Ten24Region) {
  $probeUser = "$probeUser-region-$Ten24Region"
}

$directProxy = "${Ten24Protocol}://${probeUser}:${Ten24Password}@${Ten24Addr}"
$directOk = $false

Write-Host "Probing 1024 direct egress..."
$probeOutput = & curl.exe --proxy $directProxy --connect-timeout 12 --max-time 25 -s https://api.ipify.org 2>$null
if ($LASTEXITCODE -eq 0 -and $probeOutput -match '^\d{1,3}(\.\d{1,3}){3}$') {
  $directOk = $true
  Write-Host "1024 direct probe OK: $probeOutput"
} else {
  Write-Host "1024 direct probe failed; falling back to $FallbackProxy"
}

if ($directOk) {
  $provider = "1024proxy"
  $simpleProxies = ""
} else {
  $provider = "static"
  $simpleProxies = $FallbackProxy
}

$envFile = Join-Path $env:TEMP "proxy-runtime.auto.env"
@"
PROXY_RUNTIME_ADDR=:8080
PROXY_RUNTIME_LOCAL_PROTOCOL=socks5
PROXY_RUNTIME_STATIC_CHAIN=
PROXY_RUNTIME_PROVIDER=$provider
PROXY_RUNTIME_1024_PROXY_ADDR=$Ten24Addr
PROXY_RUNTIME_1024_PROTOCOL=$Ten24Protocol
PROXY_RUNTIME_1024_USERNAME=$Ten24Username
PROXY_RUNTIME_1024_PASSWORD=$Ten24Password
PROXY_RUNTIME_1024_REGION=$Ten24Region
PROXY_RUNTIME_1024_STICKY_MINUTES=10
PROXY_RUNTIME_SIMPLE_PROXIES=$simpleProxies
PROXY_RUNTIME_LISTENERS_JSON=[{"id":"runtime-dummy","addr":":10999","protocol":"socks5","route":"direct"},{"id":"direct-egress","addr":":10810","protocol":"socks5","route":"upstream","upstream":"tcp://host.docker.internal:10810"},{"id":"codex-provider","addr":":10811","protocol":"socks5","route":"provider"},{"id":"checkout-egress","addr":":10812","protocol":"socks5","route":"upstream","upstream":"tcp://host.docker.internal:10813"},{"id":"outlook-provider","addr":":10814","protocol":"socks5","route":"provider"}]
"@ | Set-Content -Path $envFile -Encoding ASCII

docker rm -f $ContainerName 2>$null | Out-Null
docker run -d `
  --name $ContainerName `
  --network $Network `
  --restart unless-stopped `
  --add-host host.docker.internal:host-gateway `
  -p "127.0.0.1:${HttpPort}:8080" `
  -p "127.0.0.1:${DynamicPort}:10811" `
  --env-file $envFile `
  $Image

Start-Sleep -Seconds 3
docker ps --filter "name=$ContainerName" --format "table {{.Names}}\t{{.Status}}\t{{.Ports}}"
$egress = & curl.exe --socks5-hostname "127.0.0.1:$DynamicPort" --connect-timeout 15 --max-time 30 -s https://api.ipify.org 2>$null
if ($LASTEXITCODE -eq 0 -and $egress) {
  Write-Host "Runtime egress OK via provider=${provider}: $egress"
} else {
  Write-Host "Runtime egress probe failed via provider=${provider}"
  exit 1
}
