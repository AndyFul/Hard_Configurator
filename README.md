# Hard_Configurator
GUI to Manage Software Restriction Policies (SRP) and harden Windows Home OS (Vista and later versions).

Important info for Windows 10 Creators Update (compilation 15063.13). 

Due to integration with Windows Defender, Microsoft made some important changes in the SmartScreen Application Reputation. So, the Hard_Configurator setting <Run As SmartScreen>='Administrator', fails to force SmartScreen for all files - it works just as the standard 'Run as administrator'. 
I have to make some tests to figure out if the previous functionality of this setting could be recovered in the Windows 10 Creators version.
Until this will be done, here are the recommended Hard_Configurator settings:
<Run As SmartScreen> = 'Standard User'
<Hide 'Run As Administrator'> = 'OFF'

With the above settings, when SRP are activated, one can still use the SmartScreen when installing programs from User Space. But, both options: 'Run By SmartScreen' and 'Run as administrator', from Explorer context menu must be used:
After using 'Run By SmartScreen' the program is blocked by SRP, but 'Mark of the Web' is added and the program is checked by SmartScreen.
'Run as administrator' allows to bypass SRP and install the file.

So SRP + 'Run By SmartScreen'', with the above settings, can be used as any other, second opinion anti-malware scanner. 


Hard_Configurator makes changes in Windows Registry to accomplish tasks enumerated below:

1. Enabling/Disabling Software Restriction Policies (as anti-exe) in Windows Home.
2. Changing SRP Security Levels, Enforcement options, and protected extensions.
3. Whitelisting files in SRP by path (also with wildcards) and by hash.
4. Enabling/Disabling Windows Defender PUA protection (Windows 8+).
5. Disabling/Enabling Untrusted Fonts (Windows 10).
6. Disabling/Enabling file execution from removable disks (Windows 7+).
7. Disabling/Enabling PowerShell script execution (Windows 7+).
8. Restricting shortcut execution to some folders only.
9. Disabling/Enabling Windows Script Host.
10. Hiding/Unhiding "Run As Administrator" option in Explorer context menu.
11. Forcing SmartScreen check for files without 'Mark Of The Web' (Windows 8+).
12. Disabling/Enabling Remote Assistance, Remote Shell, and Remote Registry.
13. Protect (deny execution) Writable subfolders in C:\Windows folder.
14. Turning ON/OFF  all above restrictions.
15. Saving chosen restrictions as defaults.
16. Loading defaults.
17. Choosing/changing GUI skin.
18. Troubleshooting when restrictions could block something important. Integration and output filtering for Sysinternals Autoruns, and
    NirSoft FullEventLogView utilities.

All the above tasks (except forcing Smartscreen check) can be made by hand using Windows regedit. Anyway, with Hard_Configurator, it can be done more quickly and safely. 

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

Forcing SmartScreen check, can protect in a smart way file execution with Administrative Rights in the User Space (see point A), and is a complementary to SRP that covers file execution without Administrative Rights. If "Run As Administrator" option is hidden from Explorer context menu, while SRP and "Run As Smartscreen" are both activated, then the user can only execute files that are whitelisted or checked by SmartScreen App on the Run.

If SRP is deactivated, then Hard_Configurator options can be changed to force SmartScreen check without invoking Administrative Rights. This change adds "Run By Smartscreen" option to Explorer context menu.

Hard_Configurator is based on Windows built-in security, so there is no need to turn off the program restrictions to install Windows Updates and perform system Scheduled Tasks.

