# m365-operations

> Operational scripts, troubleshooting guides and repeatable procedures for Microsoft 365 administration.

![PowerShell](https://img.shields.io/badge/PowerShell-7+-5391FE?logo=powershell)
![Microsoft 365](https://img.shields.io/badge/Microsoft-365-D83B01?logo=microsoft)
![Exchange Online](https://img.shields.io/badge/Exchange-Online-0078D4)
![License](https://img.shields.io/badge/License-MIT-green)

---

## Overview

This repository contains operational documentation, PowerShell scripts and engineering procedures developed whilst administering Microsoft 365 environments.

The objective is to build a reusable operational knowledgebase that captures real-world investigations, Microsoft-supported remediation methods and repeatable administration tasks.

Rather than being a collection of one-off scripts, this repository documents complete operational procedures including:

- Investigation
- Root cause analysis
- Resolution
- Validation
- Rollback considerations
- References to Microsoft documentation

---

## Scope

This repository focuses exclusively on Microsoft 365 operational engineering.

Included:

- Exchange Online
- Microsoft Entra ID
- Microsoft Intune
- Microsoft Defender XDR
- Microsoft Defender for Endpoint
- Microsoft Defender for Office 365
- Microsoft Purview
- Microsoft Teams
- SharePoint Online
- Microsoft Graph
- PowerShell automation

Not included:

- Azure Infrastructure
- Azure Networking
- Azure Security (Defender for Cloud, CSPM, Sentinel)
- Infrastructure as Code (Bicep / ARM / Terraform)

Those subjects are maintained in companion repositories.

---

## Repository Structure

```text
m365-operations/
│
├── exchange-online/
├── entra-id/
├── intune/
├── defender/
├── purview/
├── sharepoint/
├── teams/
├── graph/
└── scripts/
```

---

## Engineering Principles

Every investigation should aim to capture:

- Symptoms
- Environment
- Prerequisites
- Investigation methodology
- Root cause
- Resolution
- Validation
- Rollback
- References

Where possible, solutions should align with Microsoft best practice and avoid unsupported changes.

---

---

## Repository Contents

### Exchange Online

| Runbook | Status |
|---------|:------:|
| [Exchange Online Overview](./exchange-online/) | ✅ |
| [Archive Calendar Remediation](./exchange-online/archive-calendar-remediation/) | ✅ |
| Outbound Spam Investigation | 🚧 |
| Message Trace V2 | 🚧 |
| Mailbox Offboarding | 🚧 |
| Mailbox Permissions | 🚧 |
| Transport Rules | 🚧 |

---

### Entra ID

| Runbook | Status |
|---------|:------:|
| Entra ID Overview | 🚧 |
| Conditional Access | 🚧 |
| Temporary Access Pass | 🚧 |
| Privileged Identity Management | 🚧 |
| Authentication Methods | 🚧 |
| Identity Protection | 🚧 |

---

### Intune

| Runbook | Status |
|---------|:------:|
| Intune Overview | 🚧 |
| Win32 Applications | 🚧 |
| Microsoft 365 Apps | 🚧 |
| Autopilot | 🚧 |
| Remediation Scripts | 🚧 |

---

### Microsoft Defender

| Runbook | Status |
|---------|:------:|
| Defender Overview | 🚧 |
| Defender for Endpoint | 🚧 |
| Defender XDR | 🚧 |
| Advanced Hunting | 🚧 |
| Threat & Vulnerability Management | 🚧 |

> **Note:** Azure security topics such as Defender for Cloud, Microsoft Sentinel and CSPM are maintained in the companion **azure-security** repository.

---

### Purview

| Runbook | Status |
|---------|:------:|
| Purview Overview | 🚧 |
| eDiscovery | 🚧 |
| Review Sets | 🚧 |
| Communication Compliance | 🚧 |
| Data Lifecycle Management | 🚧 |

---

### Teams

| Runbook | Status |
|---------|:------:|
| Teams Overview | 🚧 |
| Teams Administration | 🚧 |
| Meeting Policies | 🚧 |
| Teams Voice | 🚧 |

---

### SharePoint

| Runbook | Status |
|---------|:------:|
| SharePoint Overview | 🚧 |
| Site Administration | 🚧 |
| Permissions | 🚧 |
| Sharing | 🚧 |
| OneDrive | 🚧 |

## Design Goals

This repository aims to become a practical operational reference for Microsoft 365 engineers by combining:

- Documentation
- PowerShell
- Repeatable procedures
- Operational experience
- Microsoft Learn references

---

## Author

**James Thompson**

Cloud Engineer | Microsoft Cloud | Azure | Microsoft 365

This repository documents operational engineering practices developed through real-world administration of Microsoft cloud technologies. All customer-specific information has been anonymised or replaced with representative examples.

---

## Licence

MIT License
