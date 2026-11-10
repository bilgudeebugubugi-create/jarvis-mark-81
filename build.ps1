param(
    [switch]$SkipPyInstaller,
    [switch]$SkipInstaller
)

$ErrorActionPreference = "Stop"

$Root = Split-Path -Parent $MyInvocation.MyCommand.Path
Set-Location $Root

if (-not $SkipPyInstaller) {
    $Python = Join-Path $Root ".venv\Scripts\python.exe"
    if (-not (Test-Path $Python)) {
        $PythonCommand = Get-Command python -ErrorAction Stop
        $Python = $PythonCommand.Source
    }

    & $Python -m pip install -r (Join-Path $Root "requirements-build.txt")
    if ($LASTEXITCODE -ne 0) {
        throw "Could not install the PyInstaller build dependency."
    }

    & $Python -m PyInstaller --clean --noconfirm `
        --distpath (Join-Path $Root "dist") `
        --workpath (Join-Path $Root "build\pyinstaller") `
        (Join-Path $Root "Jarvis.spec")
    if ($LASTEXITCODE -ne 0) {
        throw "PyInstaller failed to build Jarvis."
    }

    Write-Host "Build complete: $(Join-Path $Root 'dist\Jarvis\Jarvis.exe')"
} elseif (-not (Test-Path (Join-Path $Root "dist\Jarvis\Jarvis.exe"))) {
    throw "The PyInstaller output is missing; build it before skipping PyInstaller."
}

if (-not $SkipInstaller) {
    $ISCC = $null
    $CompilerCommand = Get-Command ISCC.exe -ErrorAction SilentlyContinue
    if ($CompilerCommand) {
        $ISCC = $CompilerCommand.Source
    } else {
        foreach ($Candidate in @(
            "C:\Program Files (x86)\Inno Setup 6\ISCC.exe",
            "C:\Program Files\Inno Setup 6\ISCC.exe"
        )) {
            if (Test-Path $Candidate) {
                $ISCC = $Candidate
                break
            }
        }
    }
    if (-not $ISCC) {
        foreach ($RegistryPath in @(
            "HKCU:\Software\Microsoft\Windows\CurrentVersion\Uninstall",
            "HKLM:\Software\Microsoft\Windows\CurrentVersion\Uninstall",
            "HKLM:\Software\WOW6432Node\Microsoft\Windows\CurrentVersion\Uninstall"
        )) {
            $Install = Get-ItemProperty -Path (Join-Path $RegistryPath "*") -ErrorAction SilentlyContinue |
                Where-Object { $_.DisplayName -like "Inno Setup*" -and $_.InstallLocation } |
                Select-Object -First 1
            if ($Install) {
                $Candidate = Join-Path $Install.InstallLocation "ISCC.exe"
                if (Test-Path $Candidate) {
                    $ISCC = $Candidate
                    break
                }
            }
        }
    }

    if (-not $ISCC) {
        throw "Inno Setup 6 is required to create the installer. Install it from https://jrsoftware.org/isdl.php or build only the app payload with -SkipInstaller."
    }

    & $ISCC (Join-Path $Root "Jarvis.iss")
    if ($LASTEXITCODE -ne 0) {
        throw "Inno Setup failed to create the installer."
    }

    Write-Host "Installer complete: $(Join-Path $Root 'dist\JARVIS-Setup-x64.exe')"
}
