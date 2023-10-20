## PROGRAM DESCRIPTION.

Windows Hybrid Hardening Light (WHH) works on Windows 10/11 (Home and Pro editions). It allows configuring Windows built-in features to support antivirus and prevent malware. WHH is a hybrid of two different Windows built-in security layers: Software Restriction Policies (SRP) and Windows Defender Application Control (WDAC). After the initial configuration, it can be closed, and all protection comes from the Windows built-in features.

WHH is adjusted to the home environment. SRP is still the best Windows built-in solution at home to prevent attack vectors via scripts, shortcuts, and other files with active content. WDAC is the best prevention against malicious EXE, DLL, and MSI files.

The hybrid of SRP and WDAC simplifies proper whitelisting. The folder whitelisted in WDAC allows only EXE, DLL, and MSI files but not scripts and other file types.

WHH uses the RunBySmartscreen tool available via the right-click option on the Explorer context menu. It allows execution with SmartScreen check of standalone EXE/MSI installers from non-NTFS storage devices (like flash drives).

Some important post-exploitation mitigations of vulnerable applications (MS Office, Adobe Acrobat Reader, etc.) can be configured via DocumentsAntiExploit, FirewallHardening, and ConfigureDefender (tools included in the WHH installation package). The ConfigureDefender tool can be used only when Microsoft Defender real-time protection is enabled.

## Software incompatibilities

1. WindowsHybridHardening Light application is a simplified version of WindowsHybridHardening. Both WindowsHybridHardening (WHH) versions share some resources and settings, so they should not run together.
2. The WHH SRP settings can conflict with SRP introduced via Group Policies Object (GPO) available in Windows Pro, Education, and Enterprise editions. Before using WHH, the SRP has to be removed from GPO.
3. WHH will also conflict with any software that uses SRP, but such applications are rare (CryptoPrevent, SBGuard, AskAdmin, Ultra Virus Killer). Before using WHH, the conflicting application should be uninstalled.
4. WHH is not intended to run with activated AppLocker policies.

   
