## PROGRAM DESCRIPTION.

Windows Hybrid Hardening Light (WHH) works on Windows 10/11 (Home and Pro editions). It allows configuring Windows built-in features to support antivirus and prevent malware. WHH is a hybrid of two different Windows built-in security layers: Software Restriction Policies (SRP) and Windows Defender Application Control (WDAC). After the initial configuration, it can be closed, and all protection comes from the Windows built-in features.

WHH is adjusted to the home environment. SRP is still the best Windows built-in solution at home to prevent attack vectors via scripts, shortcuts, and other files with active content. WDAC is the best prevention against malicious EXE, DLL, and MSI files.

The hybrid of SRP and WDAC simplifies proper whitelisting. The folder whitelisted in WDAC allows only EXE, DLL, and MSI files but not scripts and other file types.

WHH uses the RunBySmartscreen tool available via the right-click option on the Explorer context menu. It allows execution with SmartScreen check of standalone EXE/MSI installers from non-NTFS storage devices (like flash drives).

Some important post-exploitation mitigations of vulnerable applications (MS Office, Adobe Acrobat Reader, etc.) can be configured via DocumentsAntiExploit, FirewallHardening, and ConfigureDefender (tools included in the WHH installation package). The ConfigureDefender tool can be used only when Microsoft Defender real-time protection is enabled.

## SWH SWITCH.

When the SWH switch is ON, the below SRP and hardening setup is applied:
1. PowerShell file scripts (like *.ps1) are blocked and PowerShell CMDLines works restricted by Constrained Language Mode.
2. By default, SRP in the SWH setup allows EXE, DLL, and MSI files. Other files with active content (unsafe files) are allowed only in %WinDir%, %ProgramFiles%, and %ProgramFiles(x86)%. The locations outside these folders belong to the SRP UserSpace, where unsafe files are blocked by default. The SRP UserSpace is larger than the WDAC UserSpace. The unsafe files are recognized mostly by the file extensions. These extensions can be added/removed via the Menu:  
Menu >> SRP file types
3. The %WinDir%  folder (usually c:\Windows) is hardened by adding the writable subfolders to UserSpace.
4. SRP is configured to block also local Administrators.
5. The shortcuts are blocked in UserSpace by default, except for some standard locations like Desktop or Menu Start. If necessary, shortcuts in non-standard locations can be whitelisted:

Whitelist (blue button) >>  Whitelist By Path >> Add Path*Wildcards
6. SRP in SWH is configured to allow EXE and MSI files, but they are still blocked when the user tries to run them directly from archiver or email client applications.
7. Remote Access is blocked.
8. Protocol SMBv1 is blocked.
9. Cached Logons are disabled.
10. Execution of 16-bit processes is disabled.

After switching OFF, all the above restrictions are removed - Windows default values are applied for them. The user can restore the restrictions by switching ON again.


## Software incompatibilities

1. WindowsHybridHardening Light application is a simplified version of WindowsHybridHardening (not yet published). Both WindowsHybridHardening (WHH) versions share some resources and settings, so they should not run together.
2. The WHH SRP settings can conflict with SRP introduced via Group Policies Object (GPO) available in Windows Pro, Education, and Enterprise editions. Before using WHH, the SRP has to be removed from GPO.
3. WHH will also conflict with any software that uses SRP, but such applications are rare (CryptoPrevent, SBGuard, AskAdmin, Ultra Virus Killer). Before using WHH, the conflicting application should be uninstalled.
4. WHH is not intended to run with activated AppLocker policies.

   
