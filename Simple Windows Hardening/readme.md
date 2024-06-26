# Simple Windows Hardening ver. 2.1.1.1 - July 2023 - added support for Windows 11 22H2 and later versions
https://github.com/AndyFul/Hard_Configurator/raw/master/Simple%20Windows%20Hardening/SimpleWindowsHardening_2111.zip

# Simple Windows Hardening ver. 2.0.0.1 - August 2022 - no support for Windows 11 22H2
https://github.com/AndyFul/Hard_Configurator/raw/master/Simple%20Windows%20Hardening/SimpleWindowsHardening_2001.zip

Windows 11 ver. 22H2 (fresh installation) turns off by default Software Restriction Policies. So, SimpleWindowsHardening ver. 
2.0.0.1 (and prior) cannot use the SWH options related to SRP. This issue was corrected in version 2.1.1.1.
It can also work with enabled Smart App Control.


## Overview
Simple Windows Hardening (SWH) works on Windows Home and Pro editions. It is a portable application that allows configuring Windows 
built-in features to support antivirus and prevent fileless malware. SWH is adjusted to the home environment. After the initial 
configuration, it can be closed and all protection comes from the Windows built-in features.

SWH is based on Software Restriction Policies (SRP) and some useful Windows Policies. 
Users on Windows 11 should bear in mind that Microsoft stopped the development of SRP a few years ago. One cannot exclude the 
possibility that some problems related to SRP may arise in the future on Windows 11. It is also possible that Microsoft will remove 
SRP on Windows 12. 
SWH is tested via the Windows Insider program, so any possible problem is recognized in advance and reported on the Dev. Website.

The security setup is adjusted to keep usability and prevent fileless malware in the home environment. So, the EXE and MSI files are 
not restricted in SWH, except when executed from archives and email clients. However non-executable files like scripts, shortcuts, and 
other files with unsafe extensions are restricted. Such a setup can be very efficient because nowadays, many initial vectors of attack 
are performed via non-executable files.

SWH application is a simplified version of Hard_Configurator. Generally, it will apply the Hard_Configurator 
Windows_10_Basic_Recommended_Settings (without Forced SmartScreen). These settings can be modified (in a limited way) in SWH, because 
sometimes on some computers they should be allowed for usability.

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
file. After one day most of the malicious links are dead and most of the 0-day malware is properly detected by a good antivirus.


## Quick configuration

1. Run SWH - the restrictions are automatically configured.
2. Log OFF the account or reboot is required, depending on what restrictions were applied before running SWH.
3. If MS Office (or Adobe Acrobat Reader) is installed, then it is recommended to make some additional hardening by using
   DocumentsAntiExploit tool. More info is included in the "DocumentsAntiExploit tool - Manual". 
    
Please keep updating your system/software. Use SWH on the default settings for some time, until you are accustomed to it. Most 
users will probably not see any difference, but rarely a legal script or file with an unsafe extension will be blocked by SWH 
settings. You can use the blue buttons  View Blocked Events   and  Manage the Whitelist  to recognize and whitelist the blocked files. 
Please be careful, if you are not certain that the blocked file is safe, then wait one day or two before whitelisting it.


## Software  incompatibilities

Windows built-in SRP cannot work with AppLocker (introduced via GPO or MDM WMI Bridge). In such a case, SimpleWindowsHardening shows
an alert. Furthermore, the options related to SRP are Switched OFF and removed from the Settings menu.

From the year 2022, AppLocker (GPO) policies can work on Windows 10/11 Home and Pro. AppLocker is activated by default on Windows 11
ver. 22H2 or later (also on Windows Home), so SRP is disabled in the default configuration.

SimpleWindowsHardening ver. 2.1.1.1 can enable SRP on Windows 11, and SRP can also work with enabled Smart App Control (SAC). 

Windows built-in SRP is incompatible with the Child Account activated on Windows 10+ via Microsoft Family Safety. Child Account adds some
AppLocker rules (via MDM), so SRP cannot work. Unfortunately, after removing the Child Account, the AppLocker Policy files are not removed
(unpleasant bug)! These policy files have to be removed manually to recover the SRP functionality.

SimpleWindowsHardening settings are not compatible with SRP introduced via Group Policies Object (GPO) available in Windows Pro,
Education, and Enterprise editions. The GPO refresh feature will overwrite the SimpleWindowsHardening settings. So, before installing 
SimpleWindowsHardening, SRP has to be removed from GPO.

SimpleWindowsHardening will also conflict with any software that uses SRP, but such applications are rare (CryptoPrevent, SBGuard, 
AskAdmin, Ultra Virus Killer). Before installing SimpleWindowsHardening it will be necessary to uninstall the conflicting application. 

SWH uses Windows built-in features. Some of them can be removed or added by Microsoft in future major Windows upgrades. Please use 
the updated SWH version. The old versions can rarely produce some issues.

