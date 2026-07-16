<#
.SYNOPSIS
Exports a baseline of calendar folders in an Exchange Online archive mailbox.

.DESCRIPTION
Connects to an existing Exchange Online PowerShell session and retrieves
folders from the user's archive mailbox whose container class is
IPF.Appointment.

The results can be displayed in the console and exported to CSV before
archive-calendar remediation work is performed.

.PARAMETER Mailbox
The primary SMTP address or user principal name of the affected mailbox.

.PARAMETER OutputPath
Optional path for the CSV export.

If omitted, a timestamped CSV is created in the current directory.

.EXAMPLE
.\Get-ArchiveCalendarBaseline.ps1 `
    -Mailbox User@cDomain.com

.EXAMPLE
.\Get-ArchiveCalendarBaseline.ps1 `
    -Mailbox User@cDomain.com `
    -OutputPath C:\Temp\User-ArchiveCalendars-Before.csv

.NOTES
Requires:
- ExchangeOnlineManagement module
- An active Exchange Online PowerShell connection
- Permission to read mailbox folder statistics
#>

[CmdletBinding()]
param(
    [Parameter(Mandatory)]
    [ValidateNotNullOrEmpty()]
    [string]$Mailbox,

    [Parameter()]
    [ValidateNotNullOrEmpty()]
    [string]$OutputPath
)

$ErrorActionPreference = 'Stop'

try {
    if (-not (Get-Command Get-EXOMailboxFolderStatistics -ErrorAction SilentlyContinue)) {
        throw 'Get-EXOMailboxFolderStatistics is unavailable. Import ExchangeOnlineManagement and connect to Exchange Online first.'
    }

    if (-not $OutputPath) {
        $safeMailbox = $Mailbox -replace '[^a-zA-Z0-9.-]', '_'
        $timestamp = Get-Date -Format 'yyyyMMdd-HHmmss'
        $OutputPath = Join-Path `
            -Path (Get-Location) `
            -ChildPath "$safeMailbox-ArchiveCalendars-$timestamp.csv"
    }

    $outputDirectory = Split-Path -Path $OutputPath -Parent

    if ($outputDirectory -and -not (Test-Path -Path $outputDirectory)) {
        New-Item -Path $outputDirectory -ItemType Directory -Force | Out-Null
    }

    Write-Verbose "Retrieving archive calendar folders for $Mailbox"

    $calendarFolders = Get-EXOMailboxFolderStatistics `
        -Identity $Mailbox `
        -Archive |
        Where-Object {
            $_.ContainerClass -eq 'IPF.Appointment'
        } |
        Select-Object `
            Name,
            FolderPath,
            FolderId,
            VisibleItemsInFolder,
            FolderSize,
            CreationTime,
            LastModifiedTime |
        Sort-Object FolderPath

    if (-not $calendarFolders) {
        Write-Warning "No IPF.Appointment folders were returned from the archive mailbox for $Mailbox."
        return
    }

    $calendarFolders |
        Export-Csv `
            -Path $OutputPath `
            -NoTypeInformation `
            -Encoding UTF8

    $calendarFolders | Format-Table -AutoSize

    Write-Host ''
    Write-Host "Baseline exported to: $OutputPath"
    Write-Host "Calendar folders found: $($calendarFolders.Count)"
}
catch {
    Write-Error "Unable to capture archive calendar baseline. $($_.Exception.Message)"
    exit 1
}
