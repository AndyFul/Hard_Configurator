## Hard_Configurator
GUI to Manage Software Restriction Policies (SRP) and harden Windows Home OS (Vista and later versions).
This program is a configurator that configures Windows built-in security to harden the system. When you close Hard_Configurator it closes all its processes. The protection comes from the reconfigured Windows settings.
Hard_Configurator can be seen as a Medium Integrity Level ‘Anti-exe + Whitelisting’ (via default deny SRP) + Application Reputation Service (forced SmartScreen) + Windows hardening settings (restricting vulnerable features).  
Hard_Configurator makes changes in Windows Registry to accomplish the tasks enumerated below:

1. Enabling Software Restriction Policies (as default-deny) in Windows Home.
2. Changing SRP Security Levels, Enforcement options, and Designated File Types.
3. Whitelisting files in SRP by path (also with wildcards) and by hash.
4. Blocking vulnerable system executables via SRP (Bouncer black list).
5. Protecting (deny execution) Writable subfolders in "C:\Windows" folder (via SRP).
6. Restricting shortcut execution to some folders only (via SRP).
7. Enabling Windows Defender PUA protection (Windows 8+).
8. Protecting MS Office and Adobe Acrobat Reader XI/DC against exploits via malicious documents.
9. Enabling "Run as administrator" for MSI files.
10. Disabling PowerShell script execution (Windows 7+).
11. Securing PowerShell by Constrained Language mode (SRP, Windows 7+ & PowerShell 5.0+)
12. Disabling Windows Script Host.
13. Hiding "Run As Administrator" option in Explorer context menu.
14. Forcing SmartScreen check for files without 'Mark Of The Web' (Windows 8+).
15. Disabling Remote Assistance, Remote Shell, and Remote Registry.
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
26. Built-in ConfigureDefender application.
27. Restoring Windows Defaults.
28. Making System Restore Point.
29. Saving chosen restrictions as a profile, and restoring when needed.
30. Backup management for Profile Base (whitelist profiles and setting profiles).
31. Choosing/changing GUI skin.
32. Updating application.
33. Uninstalling application (Windows defaults restored).


Most of the above tasks can be made by hand using Windows regedit. Anyway, with Hard_Configurator, it can be done more quickly and safely. Also, the user can quickly apply custom settings saved in profiles.

Forcing SmartScreen check can be very useful, because normally the SmartScreen Filter in Windows 8+ allows many vectors of infection listed below:

A) You have got the executable file (BAT, CMD, COM, CPL, DLL, EXE, JSE, MSI, OCX, PIF, SCR and VBE) using:
* the downloader or torrent application (EagleGet, utorrent etc.);
* container format file (zip, 7z, arj, rar, etc.);
* CD/DVD/Blue-ray disc;
* CD/DVD/Blue-ray disc image (iso, bin, etc.);
* non-NTFS USB storage device (FAT32 pendrive, FAT32 USB disk);
* Memory Card;

so the file does not have the proper Alternate Data Stream attached (Mark Of The Web).

B) You have run the executable file with runas.exe (Microsoft), AdvancedRun (Nirsoft), RunAsSystem.exe (AprelTech.com), etc.

Forcing SmartScreen check, can protect in a smart way file execution with Administrative Rights in the User Space (see point A), and is a complementary to SRP that covers file execution as standard user. If "Run as administrator" option is hidden from Explorer context menu, while SRP and "Run As SmartScreen" are both activated, then the user can only execute files that are whitelisted or checked by SmartScreen Application on the run.

If SRP is deactivated, then Hard_Configurator options can be changed to force SmartScreen check without invoking Administrative Rights. This change adds "Run By Smartscreen" option to Explorer context menu.

Hard_Configurator is based on Windows built-in security, so there is no need to turn off the program restrictions to install Windows Updates, Universal Applications from Windows Store, and perform system Scheduled Tasks.

