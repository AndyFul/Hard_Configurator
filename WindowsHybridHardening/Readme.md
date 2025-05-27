## WARNING
Windows Hybrid Hardening Light (WHHLight) is intended for the home environment. It is assumed that users avoid configuring security features commonly used in Enterprises, such as GPO or AppLocker. The settings applied by those security features can tamper with WHHLight (more info available in the section "Software  incompatibilities").
When using WHHLight in SMBs, the Administrators can block GPedit functionality on the concrete user account via Windows Registry:

Windows Registry Editor Version 5.00

[HKEY_CURRENT_USER\Software\Policies\Microsoft\MMC\{8FC0B734-A0E1-11D1-A7D3-0000F87571E3}]

"Restrict_Run"=dword:00000001



## Windows Hybrid Hardening Light ver. 2.0.0.1 (January 2025)
https://github.com/AndyFul/Hard_Configurator/raw/master/WindowsHybridHardening/WHHLight_Package_2001.exe

This version is the same as the latest beta. SWH settings can be now selectively controlled from the menu. Added two new ASR rules to ConfigureDefender.



## Windows Hybrid Hardening ver. 1.1.1.1 (July 2024)
https://github.com/AndyFul/Hard_Configurator/raw/master/WindowsHybridHardening/WHHLight_Package_1111.exe

This version comes with a new WHHLight WDAC setting IAC ( = WDAC ON setting + Install App Control set to "The Microsoft Store only").



## PROGRAM DESCRIPTION.

WHHLight is a simplified configurator of (Windows built-in) application control features.
It works on Windows 10 and 11 to support antivirus and prevent malware. WHHLight is a hybrid of Windows built-in security layers: SmartScreen, Software Restriction Policies (SRP), and Windows Defender Application Control (WDAC).
After the initial configuration, WHHLight can be closed, and all protection comes from the Windows built-in features.
SmartScreen, SRP, and WDAC work well with any antivirus - Microsoft Defender is not required.

WHHLight is adjusted to the home environment. SRP is still the best Windows built-in solution at home to prevent attack vectors via scripts, shortcuts, and other files with active content. WDAC is the best prevention against malicious EXE, DLL, and MSI files.

The hybrid of SRP and WDAC simplifies proper whitelisting. The folder whitelisted in WDAC allows only EXE, DLL, and MSI files but not scripts and other file types.

WHHLight uses the RunBySmartscreen tool available via the right-click option on the Explorer context menu. It allows execution with SmartScreen check of standalone EXE/MSI installers from non-NTFS storage devices (like flash drives).

Some important post-exploitation mitigations of vulnerable applications (MS Office, Adobe Acrobat Reader, etc.) can be configured via DocumentsAntiExploit, FirewallHardening, and ConfigureDefender (tools included in the WHHLight installation package). The ConfigureDefender tool can be used only when Microsoft Defender real-time protection is enabled.

[Videos about WHHLight](https://www.youtube.com/@AndyKula-sk3dt/)

##
## SWH SWITCH.

When the SWH switch is ON, the below SRP and hardening setup is applied:
1. PowerShell file scripts (like *.ps1) are blocked and PowerShell CMDLines works restricted by Constrained Language Mode.
2. By default, SRP in the SWH setup allows EXE, DLL, and MSI files. Other files with active content (unsafe files) are allowed only in %WinDir%, %ProgramFiles%, and %ProgramFiles(x86)%. The locations outside these folders belong to the SRP UserSpace, where unsafe files are blocked by default. The SRP UserSpace is larger than the WDAC UserSpace. The unsafe files are recognized mostly by the file extensions. These extensions can be added/removed via the application menu: Menu >> SRP file types
3. The %WinDir%  folder (usually c:\Windows) is hardened by adding the writable subfolders to UserSpace.
4. SRP is configured to block also local Administrators.
5. Windows SmartScreen is enabled as an Administrator policy.
6. The shortcuts are blocked in UserSpace by default, except for some standard locations like Desktop or Menu Start. If necessary, shortcuts in non-standard locations can be
   whitelisted: Whitelist (blue button) >>  Whitelist By Path >> Add Path*Wildcards
7. SRP in SWH is configured to allow EXE and MSI files, but they are still blocked when the user tries to run them directly from archiver or email client applications.
8. Remote Access is blocked.
9. Protocol SMBv1 is blocked.
10. Cached Logons are disabled.

After switching OFF, all the above restrictions are removed (except for the Administrator policy of SmartScreen) - Windows default values are applied for them. The user can restore the restrictions by switching ON again. 
Additionally, SWH resets some policies used in the Hard_Configurator or WHH full version: Block Desktop and Downloads folders (OFF), Block LOLBins (OFF), Restrict elevation of executables (OFF), Disable Windows Script Host (OFF), Disable execution of 16-bit processes (ON), Hide 'Run as administrator' option (OFF), Enforce shell extension security (OFF), Run As SmartScreen (OFF), Enable MSI elevation (OFF), UAC Secure Credential Prompting (OFF).

## WDAC SWITCH

When the WDAC switch is ON, the WDAC policies for EXE, DLL, and MSI files are applied. Those policies use Microsoft's Intelligent Security Graph (ISG) to restrict by default the EXE, DLL, and MSI files, except for:
1. SystemSpace, defined in WindowsHybridHardening as all locations on the SYSTEM-drive that are Non-Writable. All writable locations on the SYSTEM-drive + all locations on Non-SYSTEM-drives belong to UserSpace (can be blocked by WDAC).
2. Locations initially blocked in UserSpace on the SYSTEM-drive, but unblocked by modifying the file/folder ACL permissions. The unblocked locations become Non-Writable. Unblocking extends the SystemSpace to include these locations.
3. Windows OS components, Microsoft signed applications, and MS Store apps (whitelisted by EKU). They are allowed in all locations (also in UserSpace).
4. Folders whitelisted by the user.
  
Writable location means the folder or file, which content can be modified or deleted by a process running with standard (or lower) rights - otherwise, the location is Non-Writable. 


## Software incompatibilities

1. Software Restriction Policies (SRP) used in WHHLight may conflict with SRP introduced via Group Policy Object (GPO), available in Windows Pro, Education, and Enterprise editions. Before using H_C, the SRP has to be removed from GPO.
2. Caution is required when applying policies via GPO on Windows 11 - this can turn OFF the SRP. So, after each GPO session, it is necessary to run and close WHHLight, which will automatically turn ON the SRP again (Windows restart is required).
3. WHHLight can also conflict with any software that uses SRP, but such applications are rare (CryptoPrevent, SBGuard, AskAdmin). Before using WHHLight, the conflicting application should be uninstalled.
4. It is not recommended to use WHHLight alongside WindowsHybridHardening (full version), Hard_Configurator, and Simple Windows Hardening. These applications share several settings, which can lead to misconfigurations.
5. Windows built-in Software Restriction Policies (SRP) are incompatible with AppLocker. Any active AppLocker rule introduced via GPO or MDM WMI Bridge, turns off SRP. When running WHHLight, it checks for active AppLocker rules and alerts about the issue.
6. The Child Account activated via Microsoft Family Safety also uses AppLocker (via MDM), so SRP cannot work with it. This issue is persistent even after removing the Child Account because (due to a bug) the AppLocker rules are not removed. To recover SRP functionality, one must remove the AppLocker rules manually from the directory %Windir%\System32\AppLocker.
