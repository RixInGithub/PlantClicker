[Version]
Class=IEXPRESS
SEDVersion=3

[Options]
PackagePurpose=InstallApp
ShowInstallProgramWindow=1
HideExtractAnimation=1
UseLongFileName=0
InsideCompressed=1
CAB_FixedSize=0
CAB_ResvCodeSigning=0
RebootMode=N
InstallPrompt=%InstallPrompt%
DisplayLicense=%DisplayLicense%
FinishMessage=%FinishMessage%
TargetName=%TargetName%
FriendlyName=%FriendlyName%
AppLaunched=%AppLaunched%
PostInstallCmd=%PostInstallCmd%
AdminQuietInstCmd=%AdminQuietInstCmd%
UserQuietInstCmd=%UserQuietInstCmd%
SourceFiles=SourceFiles

[Strings]
InstallPrompt=
DisplayLicense=
FinishMessage=
TargetName=clicker.exe
FriendlyName=
AppLaunched=cmd /c launch.bat
AdminQuietInstCmd=
UserQuietInstCmd=
PostInstallCmd=cmd /c noop.bat
FILE0="app.ps1"
FILE1="launch.bat"
FILE2="noop.bat"

[SourceFiles]
SourceFiles0=dist

[SourceFiles0]
%FILE0%=
%FILE1%=
%FILE2%=