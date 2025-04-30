function Get-QBittorrentLatestVersionFromRss {
    param (
        [string]$RssUrl = "https://sourceforge.net/projects/qbittorrent/rss"
    )

    try {
        # 加载 RSS XML
        $rssXml = Invoke-RestMethod -Uri $RssUrl # -UseBasicParsing
        write-host $rssXml.content[0].url

        # 提取所有条目的标题
        $titles = $rssXml.content.rss.channel.item.title
        write-host $rssXml

        # 提取可能的版本号（例如 "qBittorrent v4.5.5 released"）
        $versionPattern = "v?(\d+\.\d+(\.\d+)?)"
        $versions = @()

        foreach ($title in $titles) {
            if ($title -match $versionPattern) {
                $versions += [version]$matches[1]
            }
        }

        # 返回最新版本号
        if ($versions.Count -gt 0) {
            return ($versions | Sort-Object -Descending)[0]
        } else {
            Write-Warning "未在 RSS 中找到版本信息"
            return $null
        }
    } catch {
        Write-Error "发生错误：$_"
        return $null
    }
}

$latest = Get-QBittorrentLatestVersionFromRss
Write-Host "qBittorrent 最新版本是：$latest"