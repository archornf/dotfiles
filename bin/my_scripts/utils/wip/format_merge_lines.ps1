function Check-FirstLine($line) {
    $tempLine = $line.Trim()
    return ($tempLine -eq "" -or $tempLine.StartsWith("/") -or $tempLine.StartsWith("*")) -and -not $tempLine.StartsWith("#")
}

function Check-ForComment($line) {
    $trimmedLine = $line.Trim()
    return $trimmedLine.StartsWith("/") -or $trimmedLine.StartsWith("*")
}

function Check-ForContent($line) {
    $trimmedLine = $line.Trim()
    return -not [string]::IsNullOrEmpty($trimmedLine) -and -not (Check-ForComment $trimmedLine) -and -not $trimmedLine.StartsWith("#")
}

function Check-ForParen($line) {
    return $line.Contains("(")
}

function Check-ForEndParen($line) {
    return $line.Trim().EndsWith(")")
}

function Check-ForFuncStart($line) {
    return $line.Replace("`n", "").StartsWith("{")
}

function Process-File($filename) {
    $lines = Get-Content $filename
    $newLines = @()
    $changeCounter = 0
    $i = 0

    while ($i -lt $lines.Length) {
        if ($i -lt $lines.Length - 3 -and (Check-FirstLine $lines[$i]) -and (Check-ForContent $lines[$i + 1]) -and (Check-ForEndParen $lines[$i + 2]) -and (Check-ForFuncStart $lines[$i + 3])) {
            $newLines += $lines[$i]
            $newLines += $lines[$i + 1].Trim() + " " + $lines[$i + 2].Trim()
            $newLines += $lines[$i + 3]
            $i += 4
            $changeCounter++
        } else {
            $newLines += $lines[$i]
            $i++
        }
    }

    $newLines | Out-File $filename
    return $changeCounter
}

$dirPath = "./" # Current directory
$totalChangeCount = 0

Get-ChildItem $dirPath -Filter *.c | ForEach-Object {
    Write-Host "Processing file: $($_.Name)"
    $fileChangeCount = Process-File $_.FullName
    Write-Host "Done! Changes done: $fileChangeCount"
    $totalChangeCount += $fileChangeCount
}

Write-Host "Done processing files! Total changes done: $totalChangeCount"
