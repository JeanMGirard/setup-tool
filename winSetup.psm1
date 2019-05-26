Import-Module ./winConfig.psm1
# Remove-Module -Name "WinSetup"




function set-PsPackages{
  param(
    [parameter(position=0)][String]$file,
    [parameter(position=1)][String]$ctg
  )
  if(!($file)){ $file = (Join-Path -Path (Split-Path $script:MyInvocation.MyCommand.Path) -ChildPath "packages.ini")}
  if(!($ctg)) { $ctg  = "powershell_pkgs" }

  $packages = Get-Section $file $ctg
  $installed = (get-module | Select -Property @{N="Name";E={$_.Name.ToLower()}}) + (get-package | Select -Property @{N="Name";E={$_.Name.ToLower()}})
  

  Foreach ($key in $packages.keys){
    $key = $key.toLower()


    if    (($packages[$key] -eq $true) -and (!($installed.Name.Contains($key)))){
      Write-Host "Installed package ", $key," "
      Install-Package -Name $key -Force
    }
    elseif(($packages[$key] -eq $false) -and ($installed.Name.Contains($key))) {
      Write-Host "Uninstalled package ", $key," "
      Uninstall-Module $key -Force
      Uninstall-Package $key -Force
    }
    elseif(($packages[$key] -eq $true) -or ($packages[$key] -eq $false)){
      Write-Host "Package ", $key," already up-to-date"
    }
    elseif(!($installed.Name.Contains($key))){
      # Install-Package $key -MaximumVersion $modules[$key] -Force
    }
  }
}
function set-PsModules{
  param(
    [parameter(position=0)][String]$file,
    [parameter(position=1)][String]$ctg
  )
  if(!($file)){ $file = (Join-Path -Path (Split-Path $script:MyInvocation.MyCommand.Path) -ChildPath "packages.ini")}
  if(!($ctg)) { $ctg  = "powershell_mods" }

  $modules = Get-Section $file $ctg
  $installed = (get-module | Select -Property @{N="Name";E={$_.Name.ToLower()}}) + (get-package | Select -Property @{N="Name";E={$_.Name.ToLower()}})

  Foreach ($key in $modules.keys){
    $key = $key.toLower()
    if    (($modules[$key] -eq $true) -and (!($installed.Name.Contains($key)))){
      Write-Host "Installed module ", $key," "
      Install-Module -Name $key -Force
    }
    elseif(($modules[$key] -eq $false) -and ($installed.Name.Contains($key))) {
      Write-Host "Uninstalled module ", $key," "
      Uninstall-Module $key -Force
      Uninstall-Package $key -Force
    }
    elseif(($modules[$key] -eq $true) -or ($modules[$key] -eq $false)){
      Write-Host "Module ", $key," already up-to-date"
    }
    elseif(!($installed.Name.Contains($key))){
      # Install-Module $key -MaximumVersion $modules[$key] -Force
    }
  }
}
function set-ChocoPackages{
  param(
    [parameter(position=0)][String]$file,
    [parameter(position=1)][String]$ctg
  )
  if(!($file)){ $file = (Join-Path -Path (Split-Path $script:MyInvocation.MyCommand.Path) -ChildPath "packages.ini")}
  if(!($ctg)) { $ctg  = "choco_pkgs" }

  $packages  = Get-Section $file $ctg
  $installed = (get-module | Select -Property @{N="Name";E={$_.Name.ToLower()}}) + (get-package | Select -Property @{N="Name";E={$_.Name.ToLower()}})
  $config    = Get-WinSetupConfig $file

  $install   = ""
  $uninstall = ""

  Foreach ($key in $packages.keys){
    $key = $key.toLower()

    if    (($packages[$key] -eq $true)){ $install = $install + ' ' + $key }
    elseif(($packages[$key] -eq $false)) {
      $uninstall = $uninstall + ' ' + $key
    }
  }

  if($install.length -gt 0)  {   ( Choco install   -y ($install    | Out-String) ) };
  if($uninstall.length -gt 0){   ( Choco uninstall -y ($uninstall  | Out-String) ) };
}
function set-AtomPackages{
  param([parameter(position=0)][String]$file, [parameter(position=1)][String]$ctg)

  if(!($file)){ $file = (Join-Path -Path (Split-Path $script:MyInvocation.MyCommand.Path) -ChildPath "packages.ini")}
  if(!($ctg)) { $ctg  = "apm_exts" }

  $packages = Get-Section $file $ctg
  $installed = (get-module | Select -Property @{N="Name";E={$_.Name.ToLower()}}) + (get-package | Select -Property @{N="Name";E={$_.Name.ToLower()}})

  Foreach ($key in $packages.keys){
    $key = $key.toLower()

    if    (($packages[$key] -eq $true)){
      Write-Host "Installed apm package ", $key," "
      apm install --quiet $key
    }
    elseif(($packages[$key] -eq $false)) {
      Write-Host "Uninstalled apm package ", $key," "
      apm uninstall $key
    }
  }
}
function set-NodePackages{
  param(
    [parameter(position=0)][String]$file,
    [parameter(position=1)][String]$ctg
  )
  if(!($file)){ $file = (Join-Path -Path (Split-Path $script:MyInvocation.MyCommand.Path) -ChildPath "packages.ini")}
  if(!($ctg)) { $ctg  = "Node_Packages" }

  $packages = Get-Section $file $ctg
  Foreach ($key in $packages.keys){
    $key = $key.toLower()

    if    (($packages[$key] -eq $true)){
      if($config["verbose"]){ Write-Host "Installed node package ", $key," " }
      npm install -g $key
    }
    elseif(($packages[$key] -eq $false)) {
      Write-Host "Uninstalled node package ", $key," "
      npm uninstall -g $key
    }
  }
}


function set-WinOptionalFeatures{
  param(
    [parameter(position=0)][String]$file,
    [parameter(position=1)][String]$ctg
  )
  if(!($file)){ $file = (Join-Path -Path (Split-Path $script:MyInvocation.MyCommand.Path) -ChildPath "packages.ini")}
  if(!($ctg)) { $ctg  = "WinOptionalFeatures" }
  $features = Get-Section $file $ctg

  Foreach ($key in $features.keys){
    $key = $key.toLower()

    if    (($features[$key].toLower() -eq "all")){
      Enable-WindowsOptionalFeature -Online -FeatureName $key  -All
    }
    elseif(($features[$key] -eq $true)){
      Enable-WindowsOptionalFeature -Online -FeatureName $key
    }
    elseif(($features[$key] -eq $false)) {
      Disable-WindowsOptionalFeature -FeatureName $key
    }
  }
}


function set-allPackages{
  param(
    [parameter(position=0)][String]$file
  )
  if(!($file)){ $file = (Join-Path -Path (Split-Path $script:MyInvocation.MyCommand.Path) -ChildPath "packages.ini")}
  set-WinOptionalFeatures $file
  set-PsPackages $file
  set-PsModules $file
  set-ChocoPackages $file
  refreshenv
  set-AtomPackages $file
}



Export-ModuleMember -Function 'set-*'
# Remove-Module -Name "WinSetup"