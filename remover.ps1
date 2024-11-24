$event = Register-ObjectEvent -InputObject ([Microsoft.Win32.SystemEvents]) -EventName "SessionEnding" -Action {
    Exit
}

try {
    $desktopPath = [Environment]::GetFolderPath("Desktop")

    $watcher = New-Object System.IO.FileSystemWatcher
    $watcher.Path = $desktopPath
    $watcher.Filter = "*.lnk"
    $watcher.NotifyFilter = [System.IO.NotifyFilters]'FileName, LastWrite'

    $onCreated = Register-ObjectEvent -InputObject $watcher -EventName Created -Action {
        param($sender, $eventArgs)
        $filePath = $eventArgs.FullPath
        $fileName = $eventArgs.Name

        if ($fileName -eq "Roblox Player.lnk" -or $fileName -eq "Roblox Studio.lnk") {
            Start-Sleep -Seconds 1
            Remove-Item -Path $filePath -Force
        }
    }

    $watcher.EnableRaisingEvents = $true

    while ($true) { Start-Sleep -Seconds 1 }
}
finally {
    Unregister-Event -SourceIdentifier $event.Name
}
