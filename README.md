# windows-setup-tool

## requirements

Requires at least chocolatey. It is a popular package manager for Windows.

**install with powershell** 
```powershell
Set-ExecutionPolicy Bypass -Scope Process -Force; iex ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))
```


## load

Open a Powershell prompt with **administrative permissions**. 

```powershell
git clone https://github.com/JeanMGirard/windows-setup-tool.git
import-module ./windows-setup-tool/winSetup.psm1
```

## configure the script

Open the ``packages.ini`` file inside the repo. 
A lot of packages are already suggested, but you can add any missing ones under the correct section (see below).

**Syntax:**

```ini
[choco_pkgs]        # === Chocolatey packages ===
conemu=             # Skipped
git=True            # Install git (if not already installed)
python3=False       # Uninstall python
```
 

## Start setup

```powershell
$file = "./windows-setup-tool/packages.ini" 

set-allPackages $file   # All sections
```

Or, if you only need to update a specific type of package.

```powershell
# one of
set-ChocoPackages $file
set-PsPackages    $file
set-PsModules     $file
set-AtomPackages  $file
set-WinOptionalFeatures $file
```


## configuration file

| Sections               | command             | Description |
| ---------------------- | ------------------- | --- |
| powershell_pkgs        | PsPackages          | |
| powershell_mods        | PsModules           | |
| choco_pkgs             | ChocoPackages       | Windows applications |
| npm_pkgs               | NodePackages        | NodeJs Packages |
| pip_pkgs               | (not supported yet) | Python Packages |
| apm_exts               | AtomPackages        | Atom extensions |
| apm_thms               | AtomPackages        | Atom themes     |
| WinOptionalFeatures    | WinOptionalFeatures | |

## Resources 

### Find packages  

- on [Chocolatey](https://chocolatey.org/packages) 

