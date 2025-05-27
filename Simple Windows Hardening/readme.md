## WARNING!
Simple Windows Hardening (SWH) is intended for the home environment. It is assumed that users avoid configuring security features commonly used in Enterprises, such as GPO or AppLocker. The settings applied by those security features can tamper with SWH (more info available in the section "Software  incompatibilities").
If necessary, the home Administrators can block GPedit functionality on the concrete user account via Windows Registry:

Windows Registry Editor Version 5.00

[HKEY_CURRENT_USER\Software\Policies\Microsoft\MMC\\{8FC0B734-A0E1-11D1-A7D3-0000F87571E3}]

"Restrict_Run"=dword:00000001


# Simple Windows Hardening ver. 2.1.1.1 - July 2023 - added support for Windows 11 22H2 and later versions
https://github.com/AndyFul/Hard_Configurator/raw/master/Simple%20Windows%20Hardening/SimpleWindowsHardening_2111.zip

# Simple Windows Hardening ver. 2.0.0.1 - August 2022 - no support for Windows 11 22H2
https://github.com/AndyFul/Hard_Configurator/raw/master/Simple%20Windows%20Hardening/SimpleWindowsHardening_2001.zip

Windows 11 ver. 22H2 (fresh installation), turns off Software Restriction Policies. So, SimpleWindowsHardening ver. 
2.0.0.1 (and prior) cannot use the SWH options related to SRP. This issue was corrected in version 2.1.1.1.
It can also work with Smart App Control.


## Overview
SWH works best on Windows Home and Pro editions. It is a portable application that allows configuring Windows 
built-in features to support antivirus and prevent fileless malware. SWH is adjusted to the home environment. After the initial 
configuration, it can be closed, and all protection comes from the Windows built-in features.

SWH is based on Software Restriction Policies (SRP) and some useful Windows Policies. 
Users on Windows 11 should bear in mind that Microsoft stopped the development of SRP a few years ago. One cannot exclude the 
possibility that some problems related to SRP may arise in the future on Windows 11. It is also possible that Microsoft will remove 
SRP on Windows 12. 
SWH is tested via the Windows Insider program, so any possible problem is recognized in advance and reported on the Dev. Website.

The security setup is adjusted to keep usability and prevent fileless malware in the home environment. So, the EXE and MSI files are 
not restricted in SWH, except when executed from archives and email clients. However, non-executable files like scripts, shortcuts, and 
other files with unsafe extensions are restricted. Such a setup can be very efficient because nowadays, many initial vectors of attack 
are performed via non-executable files.

SWH application is a simplified version of Hard_Configurator. Generally, it will apply the Hard_Configurator 
Windows_10_Basic_Recommended_Settings (without Forced SmartScreen). These settings can be modified (in a limited way) in SWH, because 
sometimes on some computers, they should be allowed for usability.

The restrictions made by SWH can be switched OFF/ON by using two switches on the right of the green buttons:   Software Restriction 
Policies   and   Windows Hardening. In the OFF position, the restrictions are remembered and next removed - Windows default settings 
are applied for previously restricted features. When switching ON, the remembered settings are restored. Furthermore, in the ON 
position, the configurable settings can be changed by the user from the Settings menu.


## The EXE / MSI 0-day malware

The SWH application does not apply restrictions to EXE and MSI files, because these files are often used to install/update 
applications. Nowadays, many antivirus solutions have very good detection of such files, as compared to the detection of scripts. But 
still, the antivirus proactive features can have a problem with 0-day malware. In the home environment, the main delivery vectors of 
0-day malware is spam emails and flash drives (USB drives). 

The user has to be very careful when running EXE/MSI files originating from:
1. Internet web links embedded in the emails.
2. Attachments embedded in the emails.
3. Flash drives (USB drives) shared with other people.

When using SWH restrictions, the user can consider using the RunBySmartScreen tool or enabling the Antivirus file reputation
lookup (available in Avast, Norton, Microsoft Defender, Comodo, etc.). 

RunBySmartscreen is available as a part of Hard_Confugurator Hardening Tools (together with ConfigureDefender and FirewallHardening):
https://github.com/AndyFul/ConfigureDefender/tree/master/H_C_HardeningTools

RunBySmartScreen allows (on demand) checking of the EXE/MSI file against the Microsoft SmartScreen Application Reputation service in 
the cloud. Many such files are accepted by SmartScreen, and this is the best way to avoid the 0-day malware. If the EXE/MSI file is 
not recognized by SmartScreen as safe or malicious, then the simplest method is to wait a minimum of one day before running the unsafe 
file. After one day, most of the malicious links are dead and most of the 0-day malware is properly detected by a good antivirus.


## Quick configuration

1. Run SWH - the restrictions are automatically configured.
2. Log OFF the account or reboot is required, depending on what restrictions were applied before running SWH.
3. If MS Office (or Adobe Acrobat Reader) is installed, then it is recommended to make some additional hardening by using
   DocumentsAntiExploit tool. More info is included in the "DocumentsAntiExploit tool - Manual". 
    
Please keep updating your system/software. Use SWH on the default settings for some time, until you are accustomed to it. Most 
users will probably not see any difference, but rarely a legal script or file with an unsafe extension will be blocked by SWH 
settings. You can use the blue buttons  View Blocked Events   and  Manage the Whitelist  to recognize and whitelist the blocked files. 
Please be careful, if you are not certain that the blocked file is safe, then wait one or two days before whitelisting it.


## Software  incompatibilities

1. Software Restriction Policies (SRP) used in SWH may conflict with SRP introduced via Group Policy Object (GPO), available in Windows Pro, Education, and Enterprise editions. Before using SWH, the SRP has to be removed from GPO.
2. Caution is required when applying policies via GPO on Windows 11 - this can turn OFF the SRP. So, after each GPO session, it is necessary to run and close SWH, which will automatically turn ON the SRP again (Windows restart is required).
3. SWH can also conflict with any software that uses SRP, but such applications are rare (CryptoPrevent, SBGuard, AskAdmin). Before using SWH, the conflicting application should be uninstalled.
4. It is not recommended to use SWH alongside WindowsHybridHardening and Hard_Configurator. These applications share several settings, which can lead to misconfigurations.
5. Windows built-in Software Restriction Policies (SRP) are incompatible with AppLocker. Any active AppLocker rule introduced via GPO or MDM WMI Bridge, turns off SRP. When running SWH, it checks for active AppLocker rules and alerts about the issue.
6. The Child Account activated via Microsoft Family Safety also uses AppLocker (via MDM), so SRP cannot work with it. This issue is persistent even after removing the Child Account because (due to a bug), the AppLocker rules are not removed. To recover SRP functionality, one must remove the AppLocker rules manually from the directory %Windir%\System32\AppLocker.
