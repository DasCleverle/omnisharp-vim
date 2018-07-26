# OmniSharp-roslyn Management tool
#
# Works on: Linux, macOS & Cygwin/WSL

# Options:
# -v | version to use (otherwise use latest)
# -l | where to install the server
# -u | help / usage info
# -H | install the HTTP version of the server

[CmdletBinding()]
Param(
    [Parameter()][Alias('v')][string]$version = "",
    [Parameter()][Alias('l')][string]$location = "C:\omnisharp\",
    [Parameter()][Alias('u')][switch]$usage,
    [Parameter()][Alias('H')][switch]$http_check
)

if ($usage) {
    Write-Host "usage:" $MyInvocation.MyCommand.Name "[-Hu] [-v version] [-l location]"
    exit
}

function get_latest_version() {
    $tmp = Invoke-RestMethod -Uri "https://api.github.com/repos/OmniSharp/omnisharp-roslyn/releases/latest"
    return $tmp.tag_name
}

if ([string]::IsNullOrEmpty($version)) {
    $version = get_latest_version
}

if ($http_check) {
    $http = ".http"
} else {
    $http = ""
}

if ([Environment]::Is64BitOperatingSystem) {
    $machine = "x64"
} else {
    $machine = "x86"
}

$url = "https://github.com/OmniSharp/omnisharp-roslyn/releases/download/$($version)/omnisharp$($http)-win-$($machine).zip"
$out = "$($location)\omnisharp$($http)-win-$($machine).zip"

Remove-Item $location -Force -Recurse
New-Item -ItemType Directory -Force -Path $location

Invoke-WebRequest -Uri $url -OutFile $out
Expand-Archive $out -DestinationPath $location -Force
