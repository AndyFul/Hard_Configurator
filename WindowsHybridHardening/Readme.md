## WARNING

WindowsHybridHardening Light is an application in the early stage of development. It can have some bugs, so it is recommended to make a System Restore Point, before using it.

## PROGRAM DESCRIPTION.

Windows Hybrid Hardening Light (WHH) works on Windows 10/11 (Home and Pro editions). It allows configuring Windows built-in features to support antivirus and prevent malware. WHH is a hybrid of two Windows built-in security layers: Software Restriction Policies (SRP) and Windows Defender Application Control (WDAC). After the initial configuration, it can be closed, and all protection comes from the Windows built-in features.
Both SRP and WDAC work well with any antivirus.

WHH is adjusted to the home environment. SRP is still the best Windows built-in solution at home to prevent attack vectors via scripts, shortcuts, and other files with active content. WDAC is the best prevention against malicious EXE, DLL, and MSI files.

The hybrid of SRP and WDAC simplifies proper whitelisting. The folder whitelisted in WDAC allows only EXE, DLL, and MSI files but not scripts and other file types.

WHH uses the RunBySmartscreen tool available via the right-click option on the Explorer context menu. It allows execution with SmartScreen check of standalone EXE/MSI installers from non-NTFS storage devices (like flash drives).

Some important post-exploitation mitigations of vulnerable applications (MS Office, Adobe Acrobat Reader, etc.) can be configured via DocumentsAntiExploit, FirewallHardening, and ConfigureDefender (tools included in the WHH installation package). The ConfigureDefender tool can be used only when Microsoft Defender real-time protection is enabled.

## SWH SWITCH.

When the SWH switch is ON, the below SRP and hardening setup is applied:
1. PowerShell file scripts (like *.ps1) are blocked and PowerShell CMDLines works restricted by Constrained Language Mode.
2. By default, SRP in the SWH setup allows EXE, DLL, and MSI files. Other files with active content (unsafe files) are allowed only in %WinDir%, %ProgramFiles%, and %ProgramFiles(x86)%. The locations outside these folders belong to the SRP UserSpace, where unsafe files are blocked by default. The SRP UserSpace is larger than the WDAC UserSpace. The unsafe files are recognized mostly by the file extensions. These extensions can be added/removed via the application menu: Menu >> SRP file types
3. The %WinDir%  folder (usually c:\Windows) is hardened by adding the writable subfolders to UserSpace.
4. SRP is configured to block also local Administrators.
5. The shortcuts are blocked in UserSpace by default, except for some standard locations like Desktop or Menu Start. If necessary, shortcuts in non-standard locations can be
   whitelisted: Whitelist (blue button) >>  Whitelist By Path >> Add Path*Wildcards
7. SRP in SWH is configured to allow EXE and MSI files, but they are still blocked when the user tries to run them directly from archiver or email client applications.
8. Remote Access is blocked.
9. Protocol SMBv1 is blocked.
10. Cached Logons are disabled.
11. Execution of 16-bit processes is disabled.

After switching OFF, all the above restrictions are removed - Windows default values are applied for them. The user can restore the restrictions by switching ON again.

## WDAC SWITCH

When the WDAC switch is ON, the WDAC policies for EXE, DLL, and MSI files are applied. Those policies use Microsoft's Intelligent Security Graph (ISG) to restrict by default the EXE, DLL, and MSI files, except for:
1. SystemSpace, defined in WindowsHybridHardening as all locations on the SYSTEM-drive that are Non-Writable. All writable locations on the SYSTEM-drive + all locations on Non-SYSTEM-drives belong to UserSpace (can be blocked by WDAC).
2. Locations initially blocked in UserSpace on the SYSTEM-drive, but unblocked by modifying the file/folder ACL permissions. The unblocked locations become Non-Writable. Unblocking extends the SystemSpace to include these locations.
3. Windows OS components, Microsoft signed applications, and MS Store apps (whitelisted by EKU). They are allowed in all locations (also in UserSpace).
4. Folders whitelisted by the user.
  
Writable location means the folder or file, which content can be modified or deleted by a process running with standard (or lower) rights - otherwise, the location is Non-Writable. 


## Software incompatibilities

1. WindowsHybridHardening Light application is a simplified version of WindowsHybridHardening (not yet published). Both WindowsHybridHardening (WHH) versions share some resources and settings, so they should not run together.
2. The WHH SRP settings can conflict with SRP introduced via Group Policies Object (GPO) available in Windows Pro, Education, and Enterprise editions. Before using WHH, the SRP has to be removed from GPO.
3. WHH will also conflict with any software that uses SRP, but such applications are rare (CryptoPrevent, SBGuard, AskAdmin, Ultra Virus Killer). Before using WHH, the conflicting application should be uninstalled.
4. WHH is not intended to run with activated AppLocker policies.

   
