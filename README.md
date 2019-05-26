# windows-setup-tool

## requirements
Requires at least chocolatey. It is a popular package manager for Windows.
> install with powershell : ``Set-ExecutionPolicy Bypass -Scope Process -Force; iex ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))``


## load
Open a Powershell prompt with **administrative permissions**. The setup tool does not work yet for 

``git clone https://github.com/JeanMGirard/windows-setup-tool.git``  
``import-module ./windows-setup-tool/winSetup.psm1``

## configure the setup
Open the ``packages.ini`` file inside the repo. 
A lot of packages are already suggested, but you can add any missing ones under the correct section (see below).

In the file:
```
[choco_pkgs]  # Chocolatey packages
conemu=             # Does not change anything
git=True            # Install git if not already installed
python3=False       # Uninstall python3 if already installed
```

It means... you can keep the desired state of your pc in it or you can split it in how many files you'd like ! 
Only have to run the function after a change 

## Start
```powershell
$file = "./packages.ini" 

# All section
set-allPackages $file

# Or any of :
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

