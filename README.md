# Hard_Configurator
GUI to Manage Software Restriction Policies (SRP) and harden Windows Home OS (Vista and later versions).

Hard_Configurator makes changes in Windows Registry to accomplish tasks enumerated below:

1. Enabling Software Restriction Policies (as anti-exe) in Windows Home.
2. Changing SRP Security Levels, Enforcement options, and Designated File Types.
3. Whitelisting files in SRP by path (also with wildcards) and by hash.
4. Enabling Windows Defender PUA protection (Windows 8+).
5. Disabling Untrusted Fonts (Windows 10).
6. Disabling file execution from removable disks (Windows 7+).
7. Disabling PowerShell script execution (Windows 7+).
8. Restricting shortcut execution to some folders only (via SRP).
9. Disabling Windows Script Host.
10. Hiding "Run As Administrator" option in Explorer context menu.
11. Forcing SmartScreen check for files without 'Mark Of The Web' (Windows 8+, Nirsoft NirCmd).
12. Disabling Remote Assistance, Remote Shell, and Remote Registry.
13. Protecting (deny execution) Writable subfolders in "C:\Windows" folder (via SRP).
14. Disabling execution of 16-bit applications.
15. Securing Shell Extensions.
16. Disabling Command Prompt (via SRP).
17. Disabling access to PowerShell executables (via SRP).
18. Securing PowerShell by Constrained Language mode (SRP, Windows 7+, PowerShell 5.0+)
19. Disabling program elevation on Standard User Account.
20. Filtering Windows Event Log for blocked file execution events (Nirsoft FullEventLogView).
21. Filtering autoruns from the User Space, and script autoruns from anywhere (Sysinternals Autorunsc).
22. Enabling&Filtering Advanced SRP logging.
23. Restoring Windows Defaults.
24. Making System Restore Point.
25. Enabling "Run as administrator" fo MSI files.
25. Turning ON/OFF all above restrictions.
26. Saving chosen restrictions as defaults, and restoring when needed.
27. Choosing/changing GUI skin.

Most of the above tasks can be made by hand using Windows regedit. Anyway, with Hard_Configurator, it can be done more quickly and safely. 

Forcing SmartScreen check can be very useful, because normally the SmartScreen Filter in Windows 8+ allows many vectors of infection listed below:

A) You have got the executable file (BAT, CMD, COM, CPL, DLL, EXE, JSE, MSI, OCX, PIF, SCR and VBE) using:
* the downloader or torrent application (EagleGet, utorrent etc.);
* container format file (zip, 7z, arj, rar, etc.);
* CD/DVD/Blue-ray disc;
* CD/DVD/Blue-ray disc image (iso, bin, etc.);
* non NTFS USB storage device (FAT32 pendrive, FAT32 usb disk);
* Memory Card;

so the file does not have the proper Alternate Data Stream attached (Mark Of The Web).

B) You have run the executable file with runas.exe (Microsoft), AdvancedRun (Nirsoft), RunAsSystem.exe (AprelTech.com), etc.

Forcing SmartScreen check, can protect in a smart way file execution with Administrative Rights in the User Space (see point A), and is a complementary to SRP that covers file execution as standard user. If "Run As Administrator" option is hidden from Explorer context menu, while SRP and "Run As Smartscreen" are both activated, then the user can only execute files that are whitelisted or checked by SmartScreen Application on the run.

If SRP is deactivated, then Hard_Configurator options can be changed to force SmartScreen check without invoking Administrative Rights. This change adds "Run By Smartscreen" option to Explorer context menu.

Hard_Configurator is based on Windows built-in security, so there is no need to turn off the program restrictions to install Windows Updates, Universal Applications from Windows Store, and perform system Scheduled Tasks.

