<#
.SYNOPSIS
Verifies archive calendar folders after remediation.

.DESCRIPTION
Retrieves the current calendar folders from an Exchange Online archive
mailbox and optionally compares them with a previously exported baseline.

The script identifies folders that are:

- Still present
- No longer returned
- Newly returned
- Changed in item count

.PARAMETER Mailbox
The primary SMTP address or user principal name of the affected mailbox.

.PARAMETER BaselinePath
Optional path to a baseline CSV created by
Get-ArchiveCalendarBaseline.ps1.

.PARAMETER OutputPath
Optional path for exporting the current post-remediation state.

.EXAMPLE
.\Verify-ArchiveCalendarRemediation.ps1 `
    -Mailbox User@Domain.com

.EXAMPLE
.\Verify-ArchiveCalendarRemediation.ps1 `
    -Mailbox User@Domain.com `
    -BaselinePath C:\Temp\User-ArchiveCalendars-Before.csv `
    -OutputPath C:\Temp\User-ArchiveCalendars-After.csv

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
    [ValidateScript({
        if (-not (Test-Path -Path $_ -PathType Leaf)) {
            throw "Baseline file not found: $_"
        }

        $true
    })]
    [string]$BaselinePath,

    [Parameter()]
    [ValidateNotNullOrEmpty()]
    [string]$OutputPath
)

$ErrorActionPreference = 'Stop'

try {
    if (-not (Get-Command Get-EXOMailboxFolderStatistics -ErrorAction SilentlyContinue)) {
        throw 'Get-EXOMailboxFolderStatistics is unavailable. Import ExchangeOnlineManagement and connect to Exchange Online first.'
    }

    Write-Verbose "Retrieving current archive calendar folders for $Mailbox"

    $currentFolders = Get-EXOMailboxFolderStatistics `
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

    if (-not $currentFolders) {
        Write-Warning "No IPF.Appointment folders were returned from the archive mailbox for $Mailbox."
    }
    else {
        Write-Host 'Current archive calendar folders:'
        $currentFolders | Format-Table -AutoSize
    }

    if ($OutputPath) {
        $outputDirectory = Split-Path -Path $OutputPath -Parent

        if ($outputDirectory -and -not (Test-Path -Path $outputDirectory)) {
            New-Item -Path $outputDirectory -ItemType Directory -Force | Out-Null
        }

        $currentFolders |
            Export-Csv `
                -Path $OutputPath `
                -NoTypeInformation `
                -Encoding UTF8

        Write-Host ''
        Write-Host "Current state exported to: $OutputPath"
    }

    if (-not $BaselinePath) {
        Write-Host ''
        Write-Host 'No baseline was supplied. Current state retrieval completed.'
        return
    }

    $baselineFolders = Import-Csv -Path $BaselinePath

    $comparison = foreach ($baselineFolder in $baselineFolders) {
        $currentFolder = $currentFolders |
            Where-Object {
                $_.FolderId -eq $baselineFolder.FolderId
            } |
            Select-Object -First 1

        if (-not $currentFolder) {
            [pscustomobject]@{
                Status             = 'No longer returned'
                Name               = $baselineFolder.Name
                FolderPath         = $baselineFolder.FolderPath
                FolderId           = $baselineFolder.FolderId
                BaselineItemCount  = $baselineFolder.VisibleItemsInFolder
                CurrentItemCount   = $null
            }

            continue
        }

        $status = if (
            [int64]$currentFolder.VisibleItemsInFolder -eq
            [int64]$baselineFolder.VisibleItemsInFolder
        ) {
            'Still present - unchanged'
        }
        else {
            'Still present - item count changed'
        }

        [pscustomobject]@{
            Status             = $status
            Name               = $currentFolder.Name
            FolderPath         = $currentFolder.FolderPath
            FolderId           = $currentFolder.FolderId
            BaselineItemCount  = $baselineFolder.VisibleItemsInFolder
            CurrentItemCount   = $currentFolder.VisibleItemsInFolder
        }
    }

    foreach ($currentFolder in $currentFolders) {
        $baselineMatch = $baselineFolders |
            Where-Object {
                $_.FolderId -eq $currentFolder.FolderId
            } |
            Select-Object -First 1

        if (-not $baselineMatch) {
            $comparison += [pscustomobject]@{
                Status             = 'New folder'
                Name               = $currentFolder.Name
                FolderPath         = $currentFolder.FolderPath
                FolderId           = $currentFolder.FolderId
                BaselineItemCount  = $null
                CurrentItemCount   = $currentFolder.VisibleItemsInFolder
            }
        }
    }

    Write-Host ''
    Write-Host 'Comparison with baseline:'

    $comparison |
        Sort-Object Status, FolderPath |
        Format-Table -AutoSize
}
catch {
    Write-Error "Unable to verify archive calendar remediation. $($_.Exception.Message)"
    exit 1
}
