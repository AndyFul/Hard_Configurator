# Hard_Configurator
GUI to Manage Software Restriction Policies (SRP) and harden Windows Home OS.

Files: Hard_Configurator(x64).exe , Hard_Configurator(x86).exe, RunAsSmartscreen(x64).exe, and  RunAsSmartscreen(x86).exe have to be copied to the folder c:\Windows\Hard_Configurator\  
Run Hard_Configurator(x86).exe or RunAsSmartscreen(x64).exe depending on Windows architecture (32Bit or 64Bit). Do not execute RunAsSmartscreen - it is executed by Explorer context menu, when in Hard_Configurator the option "Run As Smartscreen" is set ON.
All above files were compiled in AutoIt v. 3.3.14.2

Hard_Configurator makes changes in Windows Registry to accomplish tasks enumerated below:

1. Enabling/Disabling Software Restriction Policies (as anti-exe) in Windows Home.
2. Changing SRP Security Levels, Enforcement options, and protected extensions.
3. Whitelisting files by hash in SRP.
4. Enabling/Disabling Windows Defender PUA protection (only Windows 8+).
5. Disabling/Enabling Untrusted Fonts (only Windows 10).
6. Disabling/Enabling file execution from removable disks.
7. Disabling/Enabling PowerShell script execution (PowerShell console is still enabled for user commands).
8. Disabling/Enabling Command Prompt.
9. Disabling/Enabling Windows Script Host.
10. Hiding/Unhiding "Run As Administrator" option in Explorer context menu.
11. Forcing SmartScreen check for files without Mark Of The Web (from non NTFS sources, zip containers, etc. - only Windows 8+).
12. Disabling/Enabling Remote Assistance.
13. Turning ON/OFF  all above restrictions.
14. Saving chosen restrictions as defaults.
15. Loading defaults.

All above (except forcing Smartscreen check) can be done by hand using Windows regedit. Anyway, with Hard_Configurator, it can be done more quickly and safely. Most of above reg tweaks are well known, and can be found easily by googling.

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

Forcing SmartScreen check, covers in a smart way file execution with Administrative Rights in the User Space (see point A), and is a complementary to SRP that covers file execution without Administrative Rights. If "Run As Administrator" is hidden, while SRP and "Run As Smartscreen" are both activated, then the user can only execute files that are whitelisted or checked by SmartScreen Filter on the run.

