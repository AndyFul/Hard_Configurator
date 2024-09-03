# WARNING!
The actually fake domain hard-configurator.com has been used by some malicious actors for several months. Please do not use it.
Someone tries to fool people who want to get information about Hard_Configurator.

# Hard_Configurator ver. 7.0.0.0 (July 2024)
https://github.com/AndyFul/Hard_Configurator/raw/master/Hard_Configurator_setup_7.0.0.0.exe

# Hard_Configurator ver. 6.1.1.1 (July 2023) - included support for Windows 11 22H2 and later versions
https://github.com/AndyFul/Hard_Configurator/raw/master/Hard_Configurator_setup_6.1.1.1.exe

## Support for Windows 11 22H2 and later versions
Windows 11 ver. 22H2 (fresh installation) turns off by default Software Restriction Policies. So, Hard_Configurator ver. 
6.0.1.1 cannot use SRP (restrictions from the left panel in H_C ). This issue is corrected in the new version 6.1.1.1. 
The H_C can also work with enabled Smart App Control from this version.

## Software incompatibilities
1. Software Restriction Policies (SRP) used in Hard_Configurator (H_C) may conflict with SRP introduced via Group Policy Object (GPO), available in Windows Pro, Education, and Enterprise editions. Before using H_C, the SRP has to be removed from GPO.
2. Caution is required when applying policies via GPO on Windows 11 - this can turn OFF the SRP.  So, after each GPO session, it is necessary to run and close H_C, which will automatically turn ON the SRP again.
3. H_C can also conflict with any software that uses SRP, but such applications are rare (CryptoPrevent, SBGuard, AskAdmin). Before using H_C, the conflicting application should be uninstalled.
4. It is not recommended to use H_C alongside WindowsHybridHardening and SimpleWindowsHardening. These applications share several settings, which can lead to misconfigurations.
5. Windows built-in Software Restriction Policies (SRP) are incompatible with AppLocker. Any active AppLocker rule introduced via GPO or MDM WMI Bridge, turns off SRP. 
6. The Child Account activated via Microsoft Family Safety also uses AppLocker (via MDM), so SRP cannot work with it. This issue is persistent even after removing the Child Account because (due to a bug) the AppLocker rules are not removed. To recover SRP functionality, one must remove the AppLocker rules manually from the directory %Windir%\System32\AppLocker.


## WARNING!!!

Hard_Configurator is an advanced tool for home Administrators. It is mainly intended to secure the computers of inexperienced users (children, happy clickers, etc.). Please read the help info about available options to avoid overkill setup. 
Hard_Configurator uses Windows built-in features. Some of them can be removed or added by Microsoft in future major Windows upgrades. 
Please use the updated version of Hard_Configurator. The old versions can rarely produce some issues.

Version 4.0.0.0 was corrected in October 2018 to match Microsoft requirements, because, at the beginning of October,
it was flagged as a hack-tool by Microsoft. The detection was related to ConfigureDefender ver. 1.0.1.1 which was installed 
with Hard_Configurator. ConfigureDefender ver. 1.0.1.1 was considered as a hack-tool by Microsoft, because it had an option to 
disable Windows Defender real-time protection. The corrected version of Hard_Configurator has been analyzed and accepted by 
Microsoft.


## PROGRAM DESCRIPTION.

GUI to manage Software Restriction Policies (SRP) and harden Windows Home editions (Windows Vista at least).
The informative Malwaretips thread about Hard_Configurator can be found here:
https://malwaretips.com/threads/hard_configurator-windows-hardening-configurator.66416/


This program can configure Windows built-in security to harden the system. When you close Hard_Configurator it closes all its 
processes. The real-time protection comes from the reconfigured Windows settings.
The Hard_Configurator Recommended_Settings can be seen as a Medium Integrity Level smart default-deny setup, which is based on 
SRP + Application Reputation Service (forced SmartScreen) + Windows hardening settings (restricting vulnerable features). The 
user can apply a more restrictive setup if needed.
Hard_Configurator makes changes in the Windows Registry to accomplish the tasks enumerated below:

1. Enabling Software Restriction Policies in Windows Home editions.
2. Changing SRP Security Levels, Enforcement options, and Designated File Types.
3. Whitelisting files in SRP by path (also with wildcards) and by hash.
4. Blocking LOLBins via SRP.
5. Protecting (deny execution) writable subfolders in %WinDir% folder (via SRP).
6. Restricting the shortcut execution to some folders only (via SRP).
7. Enabling Windows Defender advanced settings, like PUA protection, ASR rules, Network Protection, etc. 
8. Protecting against weaponized documents, when MS Office or Adobe Acrobat Reader XI/DC are used to open them.
9. Enabling "Run as administrator" for MSI files.
10. Hardening Windows Firewall by blocking the Internet access to LOLBins.
11. Disabling PowerShell script execution (Windows 7+).
12. Securing PowerShell by Constrained Language mode (SRP, PowerShell 5.0+)
13. Disabling execution of scripts managed by Windows Script Host.
14. Removing the "Run As Administrator" option from the Explorer right-click context menu.
15. Forcing the SmartScreen reputation check for files without 'Mark Of The Web' (Windows 8+) and preventing DLL hijacking of SmartScreen.
16. Disabling Remote Desktop, Remote Assistance, Remote Shell, and Remote Registry.
17. Disabling execution of 16-bit applications.
18. Enabling & Filtering Advanced SRP logging.
19. Disabling SMB protocols.
20. Disabling program elevation on Standard User Account.
21. Enabling Validate Admin Code Signatures (UAC setting).
22. Disabling Cached Logons.
23. Filtering Windows Event Log for blocked file execution events (Nirsoft FullEventLogView).
24. Filtering autoruns from the User Space, and script autoruns from anywhere (Sysinternals Autorunsc).
25. Turning ON/OFF all the above restrictions.
26. Restoring Windows Defaults.
27. Making System Restore Point.
28. Using predefined setting profiles for Windows 7, Windows 8, and Windows 10+.
29. Saving the chosen restrictions as a profile, and restoring them when needed.
30. Backup management for Profile Base (whitelist profiles and setting profiles).
31. Changing GUI skin.
32. Updating application.
33. Uninstalling application (Windows defaults restored).


Most of the above tasks can be done by hand using Windows Regedit. Anyway, with Hard_Configurator, it can be done more quickly 
and safely. Also, the user can quickly apply custom settings saved in profiles.

Forcing SmartScreen check can protect the user when normally the SmartScreen for Explorer (in Windows 8+) is bypassed.
That can happen if you have the executable file (EXE, MSI, etc.) when using:

* the downloader or torrent application (EagleGet, utorrent etc.);
* container format file (zip, 7z, arj, rar, etc.), except for some unpackers like ZIP built-in Windows unpacker.
* CD/DVD/Blue-ray disc;
* CD/DVD/Blue-ray disc image (iso, bin, etc.);
* non-NTFS USB storage device (FAT32 pendrive, FAT32 USB disk);
* Memory Card;

so the file does not have the proper Alternate Data Stream attached (Mark Of The Web).

Hard_Configurator is based on Windows built-in security, so there is no need to turn off the program restrictions to install 
Windows Updates, Universal Applications from Windows Store, and perform system Scheduled Tasks.

## Contact: 
Andrzej Pluta (@Andy Ful)
hardconfigurator@gmail.com
