
; Script de instalación para una aplicación Flutter en Windows usando Inno Setup

[Setup]
AppName=Asistencia CCV
AppVersion=2.0
DefaultDirName={autopf}\Asistencia CCV
OutputBaseFilename=Instalador Asistencia CCV
Compression=lzma
SolidCompression=yes

[Files]
; Copia todos los archivos de la carpeta "instalador", incluidos los .dll
Source: "build\windows\x64\runner\Release\*"; DestDir: "{app}"; Flags: ignoreversion recursesubdirs createallsubdirs

[Icons]
; Crear un acceso directo en el menú de inicio
Name: "{group}\Asistencia CCV"; Filename: "{app}\control_asistencia_daemon.exe"
; Crear un acceso directo en el escritorio
Name: "{commondesktop}\Asistencia CCV"; Filename: "{app}\control_asistencia_daemon.exe"

[Registry]
; Configura la aplicación para que se ejecute al inicio de sesión
Root: HKCU; Subkey: "Software\Microsoft\Windows\CurrentVersion\Run"; ValueType: string; ValueName: "Asistencia CCV"; ValueData: "{app}\control_asistencia_daemon.exe"

[Run]
; Opción para iniciar la aplicación inmediatamente después de la instalación
Filename: "{app}\control_asistencia_daemon.exe"; Description: "Iniciar el sistema de asistencia"; Flags: nowait postinstall skipifsilent

