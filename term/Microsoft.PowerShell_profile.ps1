oh-my-posh init pwsh --config C:\dev\assets\omp\kx.omp.json | Invoke-Expression

Import-Module -Name Terminal-Icons
Import-Module -Name PSReadLine

Set-PSReadLineOption -PredictionSource History
Set-PSReadLineOption -PredictionViewStyle ListView
Set-PSReadLineOption -EditMode Windows

function slc {
    [CmdletBinding()] # enables param use
        param (
                [string]$Dir,
                [switch]$keys 
              )
            if($keys) {
                Write-Host "DIR keys:"
                    Write-Host "backups"
                    return
            }

    switch -wildcard ($Dir) {
        "backups" {
            Set-Location 'D:\backups\'
                break
        }
        Default {
            if ($Dir) {
                Write-Host "Does not match any known dir, attempting to cd to $Dir"
                    try {
                        Set-Location $Dir
                    }
                catch {
                    Write-Host "Could not cd to $Dir, provide a valid directory or use the keys param to list available dirs"
                }
            }
        }
    }
}

# Unix Time Stamp

function unixTimeStamp {
    $numTimestamps = 3
        for ($i = 1; $i -le $numTimestamps; $i++) {
            $UTS = [Math]::Round((Get-Date).ToUniversalTime().Subtract((Get-Date "1/1/1970")).TotalSeconds)
                Write-Host $UTS
                Start-Sleep -Seconds 1
                if ($numTimestamps - $i -eq 0) {
                    $UTS | clip
                }            
        }
}

function dlp {
    param (
            [string]$link,
            [string]$param,
            [switch]$live,
            [string]$wait,
            [switch]$cookies
          )

        $formatData = "-f 'bestvideo[height<=1080][ext=mp4]+bestaudio[ext=m4a]/best[ext=mp4]/best'"
        $baseExpression = "yt-dlp $formatData --parse-metadata ""%(uploader|)s:%(meta_artist)s"" --embed-metadata $link"
        $userInput = ""

        if ($param -match "--x") {
            $baseExpression = "yt-dlp -f ba -x --audio-format mp3 --embed-thumbnail -o '%(title)s' --parse-metadata ""%(uploader|)s:%(meta_artist)s"" --embed-metadata $link"
        }
    if ($param -match "--b") {
        $baseExpression = "yt-dlp -f bestvideo[height<=1080][ext=mp4]+bestaudio[ext=m4a]/best[ext=mp4]/best --embed-thumbnail -o '%(title)s.mp4' --parse-metadata ""%(uploader|)s:%(meta_artist)s"" --embed-metadata $link"
    }
    if ($live) {
        $baseExpression += " --live-from-start"
    }
    if ($wait) {
        if ($wait -match "\d{2}:\d{2}:\d{2}:\d{2}") {
            $timeParts = $wait.Split(":")
                $totalSeconds = [timespan]::FromHours($timeParts[0]).TotalSeconds + [timespan]::FromMinutes($timeParts[1]).TotalSeconds + [timespan]::FromSeconds($timeParts[2]).TotalSeconds + [timespan]::FromMilliseconds($timeParts[3]).TotalSeconds
                $baseExpression += " --wait-for-video $totalSeconds"
        } else {
            $baseExpression += " --wait-for-video $wait"
        }
    }
    if ($cookies) {
        $baseExpression += " --cookies-from-browser edge"
    }
    if ($param -match "--xp.*") {
        $playlistStart = $param -replace "--xp s", ""
            $playlistItems = $param -replace "--xp i", ""
            $playlistEnd = $param -replace "--xp e", ""
            $playlistRange = $param -replace "--xp r", ""

            if ($playlistRange -ne $param) {
                $range = $playlistRange.Split("-")
                    $userInput = "--playlist-start $($range[0]) --playlist-end $($range[1])"
            } elseif ($playlistStart -ne $param) {
                $userInput = "--playlist-start $playlistStart"
            } elseif ($playlistItems -ne $param) {
                $userInput = "--playlist-items $playlistItems"
            } elseif ($playlistEnd -ne $param) {
                $userInput = "--playlist-end $playlistEnd"
            }

        $baseExpression += " -ciw $userInput"
    }
    if ($param -match "--bp.*") {
        $playlistStart = $param -replace "--bp s", ""
            $playlistItems = $param -replace "--bp i", ""
            $playlistEnd = $param -replace "--bp e", ""
            $playlistRange = $param -replace "--bp r", ""

            if ($playlistRange -ne $param) {
                $range = $playlistRange.Split("-")
                    $userInput = "--playlist-start $($range[0]) --playlist-end $($range[1])"
            } elseif ($playlistStart -ne $param) {
                $userInput = "--playlist-start $playlistStart"
            } elseif ($playlistItems -ne $param) {
                $userInput = "--playlist-items $playlistItems"
            } elseif ($playlistEnd -ne $param) {
                $userInput = "--playlist-end $playlistEnd"
            }

        $baseExpression += " -ciw $userInput"
    }

    Write-Host "Constructed Command: $baseExpression"
        Invoke-Expression -Command $baseExpression
}

# Function to merge two audio or video files
function ffmerge {
    param (
            [Parameter(Position = 0, Mandatory = $true, ValueFromPipeline = $true)]
            [string]$File1,

            [Parameter(Position = 1, Mandatory = $true)]
            [string]$File2,

            [Parameter(Position = 2, Mandatory = $true)]
            [string]$OutputFile
          )

        $file1Duration = & 'ffprobe' -v error -show_entries format=duration -of default=noprint_wrappers=1:nokey=1 $File1
        $file2Duration = & 'ffprobe' -v error -show_entries format=duration -of default=noprint_wrappers=1:nokey=1 $File2

        $combinedDuration = [math]::Max($file1Duration, $file2Duration)

        $ffmpegParams = @{
            '-i' = @($File1, $File2)
                '-filter_complex' = "[0:a]adelay=delays=0|0[track1];[1:a]adelay=delays=${file1Duration}|${file1Duration}[track2];[track1][track2]amix=inputs=2[a]"
                '-map' = "[a]"
        }

    & 'ffmpeg' @ffmpegParams -c:v copy $OutputFile
}

# Function to transcode a file while retaining metadata
function fftrans {
    param (
            [Parameter(Position = 0, Mandatory = $true, ValueFromPipeline = $true)]
            [string]$InputFile,

            [Parameter(Position = 1, Mandatory = $true)]
            [string]$OutputFile
          )

        $ffmpegParams = @{
            '-i' = $InputFile
                '-map_metadata' = '0'
        }

    & 'ffmpeg' @ffmpegParams $OutputFile
}

function startUpMsg {
#    sleep -mill 1000
    gc "C:\Users\Kontingent\Documents\PowerShell\banner.txt" | Write-Host -ForegroundColor DarkYellow
}
startUpMsg
