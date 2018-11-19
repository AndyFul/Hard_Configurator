## Hard_Configurator ver. 4.0.0.2

The previous version 4.0.0.0 was corrected in the October 2018 to match Microsoft requirements, because on the beginning of Otcober
it was flagged as a hack-tool by Microsoft. The detection was related to ConfigureDefender ver. 1.0.1.1 which was installed with
Hard_Configurator. ConfigureDefender ver. 1.0.1.1 was considered as a hack-tool by Microsoft, because it had an option to disable
Windows Defender real-time protection. The corrected version of Hard_Configurator has been analyzed and accepted by Microsoft.

.

PROGRAM DESCRIPTION.

GUI to manage Software Restriction Policies (SRP) and harden Windows Home editions (Windows Vista at least).

.

This program can configure Windows built-in security to harden the system. When you close Hard_Configurator it closes all its processes. The real-time protection comes from the reconfigured Windows settings.
Hard_Configurator can be seen as a Medium Integrity Level smart default-deny setup, which is based on SRP + Application Reputation Service (forced SmartScreen) + Windows hardening settings (restricting vulnerable features).  
Hard_Configurator makes changes in Windows Registry to accomplish the tasks enumerated below:

1. Enabling Software Restriction Policies in Windows Home editions.
2. Changing SRP Security Levels, Enforcement options, and Designated File Types.
3. Whitelisting files in SRP by path (also with wildcards) and by hash.
4. Blocking vulnerable system executables via SRP (Bouncer black list).
5. Protecting (deny execution) writable subfolders in "C:\Windows" folder (via SRP).
6. Restricting shortcut execution to some folders only (via SRP).
7. Enabling Windows Defender advanced settings, like PUA protection, ASR rules, Network Protection etc. 
8. Protecting against weaponized documents, when MS Office and Adobe Acrobat Reader XI/DC are used to open them.
9. Enabling "Run as administrator" for MSI files.
10. Disabling PowerShell script execution (Windows 7+).
11. Securing PowerShell by Constrained Language mode (SRP, PowerShell 5.0+)
12. Disabling execution of scripts managed by Windows Script Host.
13. Removing "Run As Administrator" option from the Explorer right-click context menu.
14. Forcing SmartScreen check for files without 'Mark Of The Web' (Windows 8+).
15. Disabling Remote Desktop, Remote Assistance, Remote Shell, and Remote Registry.
16. Disabling execution of 16-bit applications.
17. Securing Shell Extensions.
18. Disabling SMB protocols.
19. Disabling program elevation on Standard User Account.
20. Disabling Cached Logons.
21. Forcing Secure Attention Sequence before User Account Control prompt.
22. Filtering Windows Event Log for blocked file execution events (Nirsoft FullEventLogView).
23. Filtering autoruns from the User Space, and script autoruns from anywhere (Sysinternals Autorunsc).
24. Enabling&Filtering Advanced SRP logging.
25. Turning ON/OFF all above restrictions.
26. Restoring Windows Defaults.
27. Making System Restore Point.
28. Using predefined setting profiles for Windows 7, Windows 8, and Windows 10.
29. Saving the chosen restrictions as a profile, and restoring when needed.
30. Backup management for Profile Base (whitelist profiles and setting profiles).
31. Changing GUI skin.
32. Updating application.
33. Uninstalling application (Windows defaults restored).


Most of the above tasks can be made by hand using Windows regedit. Anyway, with Hard_Configurator, it can be done more quickly and safely. Also, the user can quickly apply custom settings saved in profiles.

Forcing SmartScreen check can protect the user, when normally the SmartScreen Filter (in Windows 8+) is bypassed.
That can happen if you have got the executable file (BAT, CMD, COM, CPL, DLL, EXE, JSE, MSI, OCX, PIF, SCR or VBE) when using:

* the downloader or torrent application (EagleGet, utorrent etc.);
* container format file (zip, 7z, arj, rar, etc.), with the exception of ZIP built-in Windows management.
* CD/DVD/Blue-ray disc;
* CD/DVD/Blue-ray disc image (iso, bin, etc.);
* non-NTFS USB storage device (FAT32 pendrive, FAT32 USB disk);
* Memory Card;

so the file does not have the proper Alternate Data Stream attached (Mark Of The Web).

Forcing the SmartScreen check, can protect in a smart way file execution with Administrative Rights in the User Space. It is a complementary to SRP, that covers file execution as standard user. If "Run as administrator" option is removed from the Explorer right-click context menu, while SRP and "Run As SmartScreen" are both activated, then the user can only execute files that are whitelisted or checked by SmartScreen Application on the run.

If SRP is deactivated, then Hard_Configurator options can be changed to force SmartScreen check without invoking Administrative Rights. This change adds "Run By Smartscreen" option to Explorer context menu.

Hard_Configurator is based on Windows built-in security, so there is no need to turn off the program restrictions to install Windows Updates, Universal Applications from Windows Store, and perform system Scheduled Tasks.

