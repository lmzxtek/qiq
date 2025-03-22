# 禁用进度条以提升下载速度
# $ProgressPreference = 'SilentlyContinue'

function Add_Numbers { param($a, $b) $a + $b }
function Subtract_Numbers { param($a, $b) $a - $b }
function Multiply_Numbers { param($a, $b) $a * $b }
function Divide_Numbers { param($a, $b) $a / $b }

function Invoke-MathOperation {
    param(
        [double]$Number1,
        [double]$Number2,
        [ValidateSet('+', '-', '*', '/')]
        [string]$Operator
    )

    switch ($Operator) {
        '+' { return $Number1 + $Number2 }
        '-' { return $Number1 - $Number2 }
        '*' { return $Number1 * $Number2 }
        '/' {
            if ($Number2 -eq 0) { throw "除数不能为零！" }
            return $Number1 / $Number2
        }
    }
}

function Get-GitHubReleasesUrl {
    param (
        # 指定GitHub仓库名称，格式为：所有者/仓库名，例如：nezhahq/agent
        [Parameter(Mandatory=$true)]
        [ValidatePattern('^[^/]+/[^/]+$')] # 确保格式正确
        [string]$Repository
    )
    
    # 拼接GitHub API的Releases地址
    $apiUrl = "https://api.github.com/repos/$Repository/releases/latest"
    
    # Write-Host "Determining latest $Repository release" -ForegroundColor Yellow # -BackgroundColor DarkGreen 
    [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
    # $agenttag = (Invoke-WebRequest -Uri $apiUrl -UseBasicParsing | ConvertFrom-Json)[0].tag_name
    # $agenttag = (Invoke-WebRequest -Uri $apiUrl -UseBasicParsing | ConvertFrom-Json).tag_name
    $json_data = (Invoke-WebRequest -Uri $apiUrl -UseBasicParsing | ConvertFrom-Json)

    # 返回生成的URL
    return $json_data
}

function get_gh_download_url {
    param (
        [Parameter(Mandatory=$true)]
        [ValidatePattern('^[^/]+/[^/]+$')] # 确保格式正确
        [string]$repo,
        [string]$tag,
        [string]$file
    )
    
    # 拼接GitHub 下载地址 
    $url = 'https://github.com/' + $repo + '/releases/download/' + $tag + '/' + $file

    # 返回生成的URL
    return $url
}

# 使用示例
$agentRepo = "nezhahq/agent"
$agentRepo = "MatsuriDayo/nekoray"

$releasesUrl = Get-GitHubReleasesUrl -Repository $agentRepo

$fmt_date = Get-Date $releasesUrl.created_at -Format 'yyyy-MM-dd'
$tag_name = $releasesUrl.tag_name

$file = 'nekoray-' + $tag_name + '-' + $fmt_date + '-windows64.zip'
# $url_download = 'https://github.com/' + $agentRepo + '/releases/download/' + $tag_name + '/' + $file
$url_download = get_gh_download_url -repo $agentRepo -tag $tag_name -file $file

Write-Output $tag_name
Write-Output $fmt_date
Write-Output $file
Write-Output $url_download

Write-Output ''
Write-Output $releasesUrl.assets[-1].name
Write-Output $releasesUrl.assets[-1].browser_download_url
# Write-Output $releasesUrl.assets[0].name
# Write-Output $releasesUrl.assets[0].browser_download_url
# Write-Output $releasesUrl.assets[1].name
# Write-Output $releasesUrl.assets[1].browser_download_url

