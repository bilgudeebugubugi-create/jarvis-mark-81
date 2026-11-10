#define AppName "JARVIS - MARK LV"
#define AppVersion "1.0.0"
#define AppPublisher "Mark LV"

[Setup]
AppId={{B1E59069-494E-4C8F-87F8-1FB015B0997D}
AppName={#AppName}
AppVersion={#AppVersion}
AppVerName={#AppName} {#AppVersion}
AppPublisher={#AppPublisher}
DefaultDirName={localappdata}\Programs\JARVIS
DefaultGroupName=JARVIS
DisableProgramGroupPage=yes
PrivilegesRequired=lowest
ArchitecturesAllowed=x64compatible
ArchitecturesInstallIn64BitMode=x64compatible
OutputDir=dist
OutputBaseFilename=JARVIS-Setup-x64
SetupIconFile=config\jarvis.ico
UninstallDisplayIcon={app}\Jarvis.exe
Compression=lzma2/ultra64
SolidCompression=yes
WizardStyle=modern
CloseApplications=yes

[Tasks]
Name: "desktopicon"; Description: "Create a desktop shortcut"; GroupDescription: "Additional shortcuts:"; Flags: unchecked

[Files]
Source: "dist\Jarvis\*"; DestDir: "{app}"; Flags: ignoreversion recursesubdirs createallsubdirs

[Icons]
Name: "{autoprograms}\JARVIS"; Filename: "{app}\Jarvis.exe"; WorkingDir: "{app}"
Name: "{autodesktop}\JARVIS"; Filename: "{app}\Jarvis.exe"; WorkingDir: "{app}"; Tasks: desktopicon

[Run]
Filename: "{app}\Jarvis.exe"; Description: "Launch JARVIS"; WorkingDir: "{app}"; Flags: postinstall nowait skipifsilent
