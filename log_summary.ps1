cat > log_summary.ps1 << 'EOF'
param(
    [Parameter(Mandatory=$true)]
    [string[]]$LogFiles
)

foreach ($LogFile in $LogFiles) {
    if (-not (Test-Path $LogFile)) {
        Write-Host "Skipping: $LogFile not found"
        continue
    }

    Write-Host "===== $LogFile ====="
    Write-Host "-- Log levels --"
    Get-Content $LogFile |
        ForEach-Object { ($_ -split '\s+')[2] } |
        Where-Object { $_ -ne "" } |
        Group-Object |
        Sort-Object Count -Descending |
        Format-Table Count, Name -AutoSize

    Write-Host "-- Top errors --"
    Select-String -Path $LogFile -Pattern "ERROR" |
        ForEach-Object { ($_.Line -split '\s+', 4)[3] } |
        Group-Object |
        Sort-Object Count -Descending |
        Format-Table Count, Name -AutoSize

    Write-Host ""
}
EOFgit add log_summary.ps1
git commit -m "Add PowerShell version of log summary script"
git push
