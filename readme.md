# MARK LV

## Build the Windows installer

Install the runtime dependencies, then run the build script from the project
directory:

```powershell
python -m pip install -r requirements.txt
.\build.ps1
```

The script uses `.venv\Scripts\python.exe` when that environment exists;
otherwise it uses the active `python` command. PyInstaller is installed from
`requirements-build.txt` as part of the build. Install Inno Setup 6 on the
build PC to generate the installer.

The installer is written to `dist\JARVIS-Setup-x64.exe`. It installs the app
under the current user's Local AppData, so it does not require administrator
access or a separately installed Python. The intermediate PyInstaller payload
is written to `dist\Jarvis\`.

The package includes the app assets and built-in action and plugin modules, but
does not include API keys, certificates, or personal memory files. Configure
your API key on first launch. Browser automation uses a compatible browser
installed on the target PC (typically Chrome or Edge); Playwright browser
binaries are not bundled.