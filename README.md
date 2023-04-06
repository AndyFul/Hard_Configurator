# Hard_Configurator ver. 6.1.1.1 beta (April 2023)
https://github.com/AndyFul/Hard_Configurator/raw/master/Hard_Configurator_Beta_6.1.1.1.exe

# Hard_Configurator ver. 6.0.1.1 (July 2022) - no support for Windows 11 22H2
https://github.com/AndyFul/Hard_Configurator/raw/master/Hard_Configurator_setup_6.0.1.1.exe


Support for Windows 11 22H2 added in the new beta version (Hard_Configurator_Beta_6.1.1.1.exe)

Support for Windows 11 up to ver. 21H1 added from version 6.0.0.0.


## Windows 11 ver. 22H2 (fresh installation) turns off by default Software Restriction Policies. So, Hard_Configurator ver 6.0.1.1 cannot use SRP (restrictions fron the left panel in H_C ). This issue is corrected in the new beta version (6.1.1.1 beta). The new beta version can also work with enabled Smart App Control.

Please note: From the ver. 5.1.1.1, the Recommended Settings on Windows 8+ works differently as compared to ver. 5.0.0.0 (and prior).
From the ver. 5.1.1.1, the Recommended Settings and some other predefined setting profiles use "More SRP... " - "Update Mode" = ON, which 
whitelists the EXE and MSI files in ProgramData and user AppData folders (other files are blocked like in ver. 5.0.0.0). If one is happy with 
blocking the EXE and MSI files in ProgramData and user AppData folders, then it is necessary to set "More SRP... " - "Update Mode" = OFF.

From version 4.1.1.1 (July 2019) Hard_Configurator installer and all its executables are signed with "Certum Code Signing CA SHA2" certificate
(Open Source Developer Andrzej Pluta).

## WARNING!!!
Windows built-in Software Restriction Policies are incompatible with Child Account activated on Windows 10 and 11 via Microsoft Family Safety.
Such an account disables most SRP restrictions. This issue is persistent even after removing Child Account. To recover SRP functionality, 
Windows has to be refreshed or reset.
Hard_Configurator uses Windows built-in features. Some of them can be removed or added by Microsoft in the future major Windows upgrades. 
Please use the updated version of Hard_Configurator. The old versions can rarely produce some issues.

The version 4.0.0.0 was corrected in the October 2018 to match Microsoft requirements, because on the beginning of Otcober
it was flagged as a hack-tool by Microsoft. The detection was related to ConfigureDefender ver. 1.0.1.1 which was installed with
Hard_Configurator. ConfigureDefender ver. 1.0.1.1 was considered as a hack-tool by Microsoft, because it had an option to disable
Windows Defender real-time protection. The corrected version of Hard_Configurator has been analyzed and accepted by Microsoft.


## PROGRAM DESCRIPTION.

GUI to manage Software Restriction Policies (SRP) and harden Windows Home editions (Windows Vista at least).
The old Hard_Configurator website: https://hard-configurator.com/ is now discontinued and not supported by the author. 
The informative Malwaretips thread about Hard_Configurator can be found here:
https://malwaretips.com/threads/hard_configurator-windows-hardening-configurator.66416/


This program can configure Windows built-in security to harden the system. When you close Hard_Configurator it closes all its processes. The 
real-time protection comes from the reconfigured Windows settings.
Hard_Configurator can be seen as a Medium Integrity Level smart default-deny setup, which is based on SRP + Application Reputation Service 
(forced SmartScreen) + Windows hardening settings (restricting vulnerable features).  
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
10. Hardening Windows Firewall by blocking the Internet access to LOLBins.
11. Disabling PowerShell script execution (Windows 7+).
12. Securing PowerShell by Constrained Language mode (SRP, PowerShell 5.0+)
13. Disabling execution of scripts managed by Windows Script Host.
14. Removing "Run As Administrator" option from the Explorer right-click context menu.
15. Forcing SmartScreen check for files without 'Mark Of The Web' (Windows 8+) and preventing DLL hijacking of SmartScreen.
16. Disabling Remote Desktop, Remote Assistance, Remote Shell, and Remote Registry.
17. Disabling execution of 16-bit applications.
18. Securing Shell Extensions.
19. Disabling SMB protocols.
20. Disabling program elevation on Standard User Account.
21. Enabling Validate Admin Code Signatures (UAC setting).
22. Disabling Cached Logons.
23. Forcing Secure Attention Sequence before User Account Control prompt.
24. Filtering Windows Event Log for blocked file execution events (Nirsoft FullEventLogView).
25. Filtering autoruns from the User Space, and script autoruns from anywhere (Sysinternals Autorunsc).
26. Enabling&Filtering Advanced SRP logging.
27. Turning ON/OFF all above restrictions.
28. Restoring Windows Defaults.
29. Making System Restore Point.
30. Using predefined setting profiles for Windows 7, Windows 8, and Windows 10.
31. Saving the chosen restrictions as a profile, and restoring when needed.
32. Backup management for Profile Base (whitelist profiles and setting profiles).
33. Changing GUI skin.
34. Updating application.
35. Uninstalling application (Windows defaults restored).


Most of the above tasks can be made by hand using Windows regedit. Anyway, with Hard_Configurator, it can be done more quickly and safely. 
Also, the user can quickly apply custom settings saved in profiles.

Forcing SmartScreen check can protect the user, when normally the SmartScreen for Explorer (in Windows 8+) is bypassed.
That can happen if you have got the executable file (EXE, MSI, etc.) when using:

* the downloader or torrent application (EagleGet, utorrent etc.);
* container format file (zip, 7z, arj, rar, etc.), with the exception of some unpackers like ZIP built-in Windows unpacker.
* CD/DVD/Blue-ray disc;
* CD/DVD/Blue-ray disc image (iso, bin, etc.);
* non-NTFS USB storage device (FAT32 pendrive, FAT32 USB disk);
* Memory Card;

so the file does not have the proper Alternate Data Stream attached (Mark Of The Web).

Forcing the SmartScreen check, can protect in a smart way file execution with Administrative Rights in the User Space. It is a complementary 
to SRP, that covers file execution as standard user. If "Run as administrator" option is removed from the Explorer right-click context menu, 
while SRP and "Forced SmartScreen" are both activated, then the user can only execute files that are whitelisted or checked by SmartScreen 
Application on the run.

If SRP is deactivated, then Hard_Configurator options can be changed to force SmartScreen check without invoking Administrative Rights. This 
change adds "Install By Smartscreen" option to Explorer context menu.

Hard_Configurator is based on Windows built-in security, so there is no need to turn off the program restrictions to install Windows Updates, 
Universal Applications from Windows Store, and perform system Scheduled Tasks.

## Contact: 
Andrzej Pluta (@Andy Ful)
hardconfigurator@gmail.com
