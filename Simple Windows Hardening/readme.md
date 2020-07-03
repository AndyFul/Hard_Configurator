Simple Windows Hardening (SWH) is a portable application that works on Windows 10 (Home and Pro editions). It is a simple configurator (front end) of advanced security that is already present in Windows 10, but which is not activated by default. This security is based on Software Restriction Policies (SRP) and some useful Windows Policies. It is not intended to work as a standalone security solution, but to support antivirus by reducing the attack surface in the home environment. After the initial configuration made via SWH, it can be closed and all protection comes from the Windows built-in features.

The security setup is adjusted to prevent fileless malware and keep usability. So, the EXE and MSI files are not restricted in SWH, except when executed from archives and email clients. But, scripts, shortcuts, and other files with unsafe extensions are restricted. Such a setup can be very efficient because nowadays, most initial vectors of attack are not related to EXE or MSI files, but other files are used instead.

SWH application is a simplified version of Hard_Configurator. Generally, it will apply the Hard_Configurator Windows_10_Basic_Recommended_Settings (without Forced SmartScreen). These settings can be modified (in a limited way) in SWH, because sometimes on some computers they should be allowed for usability.

The restrictions made by SWH can be switched OFF/ON by using two switches on the right of the green buttons:   Software Restriction Policies   and   Windows Hardening . In the OFF position, the restrictions are remembered and next removed - Windows default settings are applied for previously restricted features. When switching ON, the remembered settings are restored. Furthermore, in the ON position the configurable settings can be changed by the user from the Settings menu.


# THE EXE / MSI 0-DAY MALWARE.

The SWH application does not apply restrictions to EXE and MSI files, because these files are often used to install/update applications. Nowadays, many antivirus solutions have very good detection of such files, as compared to the detection of scripts. But still, the antivirus proactive features can have a problem with 0-day malware. In the home environment, the main delivery vectors of 0-day malware are spam emails and flash drives (USB drives). 

The user has to be very careful when running EXE/MSI files originated from:
Internet web links embedded in the emails.
Attachments embedded in the emails.
Flash drives (USB drives) shared with other people.

When using SWH restrictions, the user can consider the RunBySmartScreen tool. It allows checking any EXE/MSI file against the Microsoft SmartScreen Application Reputation service in the cloud. Many such files are accepted by SmartScreen, and this is the best way to avoid the 0-day malware. If the EXE/MSI file is not recognized by SmartScreen as safe or malicious, then the simplest method is waiting a minimum one day before running the unsafe file. After one day most of the malicious links are dead and most of the 0-day malware are properly detected by a good antivirus.


# QUICK CONFIGURATION

Run SWH - the restrictions are automatically configured.
Log OFF the account or reboot is required, depending on what restrictions were applied before running SWH.

Please keep updated your system/software. Use SWH on the default settings for some time, until you will be accustomed to it. Most users will probably do not see any difference, but rarely a legal script or file with unsafe extension will be blocked by SWH settings. You can use blue buttons  View Blocked Events   and  Manage the Whitelist  to recognize and whitelist the blocked files. Please be careful, if you are not certain that the blocked file is safe, then wait one day or two before whitelisting it.


# SOFTWARE  INCOMPATIBILITIES

Windows built-in SRP is incompatible with Child Account activated on Windows 10 via Microsoft Family Safety. Such an account disables most SRP restrictions. This issue is persistent even after removing the Child Account. To recover SRP functionality, Windows has to be refreshed or reset.

SWH is incompatible with SRP introduced via Group Policies Object (GPO) available in Windows Pro, Education, and Enterprise editions. GPO refresh feature will overwrite the SWH settings related to SRP. So, before installing SWH, the SRP has to be removed from GPO.

SWH will also conflict with any software which uses SRP, but such applications are rare (CryptoPrevent, SBGuard, AskAdmin, Ultra Virus Killer). Before installing SWH it will be necessary to uninstall the conflicting application or it will be detected and SWH will replace the SRP settings with predefined settings.

