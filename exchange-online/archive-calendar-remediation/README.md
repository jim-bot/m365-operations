# Archive Calendar Remediation

## Overview

This procedure covers the investigation and remediation of shared or delegated calendar folders unexpectedly appearing beneath a user's Online Archive in Outlook Classic.

The issue may initially appear to be related to mailbox delegation or a corrupt Outlook profile. However, Exchange Online folder statistics can confirm that the additional calendars genuinely exist as folders within the affected user's archive mailbox.

## Symptoms

Affected users may report that:

- Multiple calendars unexpectedly appear beneath **My Calendars**
- The calendars belong to colleagues, managers or team members
- The entries are labelled as Online Archive calendars
- The calendars appear in Outlook Classic but not Outlook on the web
- The user cannot remove the entries using the normal **Remove Calendar** option
- Calendar Properties show that the folders are located beneath the user's Online Archive

## Important distinction

These folders are archived copies located within the affected user's archive mailbox.

They are not necessarily live views of the source users' current calendars.

Removing or hiding an archive calendar folder must therefore be treated separately from changing live calendar permissions or mailbox delegation.

## Investigation workflow

1. Confirm the issue in Outlook Classic
2. Check whether the entries appear in Outlook on the web
3. Review live calendar permissions
4. Confirm the affected user has an Online Archive
5. Enumerate calendar folders in the archive mailbox
6. Export a baseline before making changes
7. Agree which calendars are genuinely unwanted
8. Test remediation against a low-risk duplicate
9. Restart Outlook
10. Verify that live calendar access remains unaffected

## Prerequisites

- Exchange Online PowerShell
- Exchange Administrator or equivalent permissions
- ExchangeOnlineManagement PowerShell module
- Outlook Classic installed on the affected device
- Access to the affected user's Windows and Outlook profile
- MFCMAPI, where the documented hide procedure is required

## Security considerations

- Do not store user credentials in scripts
- Do not remove live calendar permissions unless separately approved
- Do not disable the user's archive mailbox as a remediation step
- Do not delete archive folders until the contents and business requirement have been reviewed
- Test against a low-value duplicate folder first
- Record the FolderId and item count before remediation

## Capture a baseline

Use:

```powershell
.\Get-ArchiveCalendarBaseline.ps1 `
    -Mailbox sophiew@contoso.com `
    -OutputPath C:\Temp\Sophie-ArchiveCalendars-Before.csv
```

The baseline includes:

- Folder name
- Folder path
- Folder ID
- Item count
- Folder size
- Creation time
- Last modified time

## Remediation

The exact remediation depends on the confirmed scenario.

Where Microsoft-supported guidance recommends hiding the archive calendar, use MFCMAPI from within the affected user's Outlook profile.

Use a low-risk folder for the controlled test, such as:

- A clear duplicate
- A folder containing very few items
- A folder the user confirms is no longer needed

Do not start with a heavily populated historical calendar.

## Validation

After remediation:

1. Close and restart Outlook Classic
2. Confirm that the unwanted archive calendar no longer appears
3. Confirm the user's live shared calendar remains available
4. Run the verification script
5. Compare the result against the baseline
6. Record the outcome and any remaining archive calendars

Example:

```powershell
.\Verify-ArchiveCalendarRemediation.ps1 `
    -Mailbox sophiew@contoso.com `
    -BaselinePath C:\Temp\Sophie-ArchiveCalendars-Before.csv
```

## Rollback considerations

Hiding a folder through MFCMAPI is preferable to destructive deletion where supported, because the folder and its contents remain present in the mailbox.

Before changing any MAPI property:

- Record the original property value
- Record the folder name and FolderId
- Capture screenshots
- Make only one controlled change at a time

## Known limitations

Outlook on the web does not provide the same visibility into archive calendar folders as Outlook Classic.

A clean Outlook on the web view does not prove that the archive calendar folders do not exist.

## External tools

MFCMAPI should be downloaded from its official GitHub project release page.

Do not store downloaded MFCMAPI executables in this repository. Treat the tool as an external prerequisite and follow the organisation's software approval process.

## References

Add the Microsoft support and product documentation used during each investigation here.
