


function get_region {    
    $ipapi = ""
    $region = "Unknown"
    foreach ($url in ("https://dash.cloudflare.com/cdn-cgi/trace", "https://developers.cloudflare.com/cdn-cgi/trace", "https://1.0.0.1/cdn-cgi/trace")) {
        try {
            $ipapi = Invoke-RestMethod -Uri $url -TimeoutSec 5 -UseBasicParsing
            if ($ipapi -match "loc=(\w+)" ) {
                $region = $Matches[1]
                break
            }
        }
        catch {
            Write-Host "Error occurred while querying $url : $_"
        }
    }
    return $region
}

function get_proxy_url {
    param (
        # Parameter help description
        [Parameter(AttributeValues)]
        [string]
        $url
    )

    $region = get_region
    if ($region -ne "CN") {
        $proxy_url = "https://fastly.jsdelivr.net/gh/nezhahq/proxy/proxy_$region.zip"
    }
    else {
        $proxy_url = "https://fastly.jsdelivr.net/gh/nezhahq/proxy/proxy.zip"
    }
    return $proxy_url
}

$url_dl = get_proxy_url
# Invoke-WebRequest $url_dl -OutFile "C:\nezha.zip"
Write-Host $url_dl 

$region = get_region 
Write-Host $region 