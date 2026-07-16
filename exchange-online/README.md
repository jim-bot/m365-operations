# Exchange Online Operations

Operational runbooks, troubleshooting procedures and PowerShell tooling for Exchange Online administration.

This section focuses on practical investigation and remediation workflows for real-world Exchange Online incidents.

## Scope

Content in this section may cover:

- Mail flow investigations
- Message tracing
- Exchange Online Protection
- Mailbox permissions
- Shared and delegated mailboxes
- Online Archive
- Transport rules
- Outbound spam controls
- Mailbox lifecycle and offboarding
- Exchange Online PowerShell
- Outlook behaviour where it relates to Exchange Online

## Operational approach

Each runbook should aim to document:

1. Symptoms
2. Environment and prerequisites
3. Initial checks
4. Investigation methodology
5. Evidence gathered
6. Root cause
7. Resolution
8. Validation
9. Rollback considerations
10. Microsoft references

Production-specific information must be sanitised before publication.

Do not include:

- Real tenant names
- Customer domains
- User email addresses
- Folder IDs
- Message IDs
- Access tokens
- Credentials
- Internal ticket numbers
- Sensitive message subjects or content

Use example values such as:

```text
user@contoso.com
shared-mailbox@contoso.com
example-recipient@example.net
```

## Current runbooks

### Archive Calendar Remediation

Investigation and remediation of shared or delegated calendar folders appearing within a user's Online Archive in Outlook Classic.

[Open the runbook](./archive-calendar-remediation/)

## Planned runbooks

### Outbound Spam Investigation

Investigating suspicious outbound mail notifications, user restrictions and outbound spam policy behaviour.

Planned content:

- Hosted outbound spam filter policies
- Policy and rule precedence
- Restricted users
- Defender Explorer
- Message tracing
- Notification recipients
- Escalation to Microsoft Support

### Message Trace V2

Repeatable PowerShell and portal workflow for tracing messages through Exchange Online.

Planned content:

- `Get-MessageTraceV2`
- Sender and recipient filtering
- Date ranges
- Message status interpretation
- Extended trace data
- Comparing Message Trace and Defender Explorer

### Mailbox Offboarding

Operational process for securing and preserving a mailbox when a user leaves the organisation.

Planned content:

- Disable sign-in
- Revoke sessions
- Reset authentication methods
- Mailbox delegation
- Shared mailbox conversion
- Licence retention
- OneDrive handover
- Retention and legal hold considerations

### Mailbox Permissions

Reviewing mailbox and calendar permissions without making unnecessary changes.

Planned content:

- Full Access
- Send As
- Send on Behalf
- Calendar folder permissions
- Automapping
- Permission validation
- Least-privilege considerations

### Transport Rules

Designing, testing and validating Exchange Online mail flow rules.

Planned content:

- Rule precedence
- Conditions and exceptions
- Audit mode
- User notifications
- Reporting
- Rollback
- Change control

## PowerShell requirements

Most scripts in this section require:

- PowerShell 7 where supported
- ExchangeOnlineManagement module
- An active Exchange Online PowerShell session
- Appropriate Exchange Online RBAC permissions

Example connection:

```powershell
Connect-ExchangeOnline -UserPrincipalName admin@contoso.com
```

Confirm the active connection:

```powershell
Get-ConnectionInformation
```

Confirm the loaded module version:

```powershell
Get-Module ExchangeOnlineManagement |
    Select-Object Name, Version
```

## Disclaimer

Scripts and procedures in this repository must be reviewed and tested before use in production.

Microsoft 365 features, interfaces and PowerShell cmdlets may change over time. Validate current Microsoft documentation before implementing changes.
