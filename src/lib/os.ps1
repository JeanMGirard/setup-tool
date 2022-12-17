function Add-Path{
  param(
    [parameter(position=0, Mandatory=$true)][String]$AddPath,
    [parameter(position=1)][Boolean]$permanent
  )
  refreshenv #Prevent unwanted additions
  $env:Path = ($env:Path).replace((";" + $AddPath), "")
  $env:Path += ";" + $AddPath

  if($permanent){
    [Environment]::SetEnvironmentVariable("Path", $env:Path, [EnvironmentVariableTarget]::Machine)
  }
}
function Remove-Path{
  param(
    [parameter(position=0, Mandatory=$true)][String]$RemPath,
    [parameter(position=1)][Boolean]$permanent
  )
  refreshenv #Prevent unwanted additions
  $env:Path = ($env:Path).replace((";" + $RemPath), "")
  if($permanent){
    $env:Path | set-content "PATH.temp.txt"
    [Environment]::SetEnvironmentVariable("Path", $env:Path, [EnvironmentVariableTarget]::Machine)
  }
}


function Add-Host{
  # c:\Windows\System32\Drivers\etc\hosts
}
