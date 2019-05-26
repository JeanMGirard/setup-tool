
# $ini = import-ini links.ini
# $ini["search-engines"]["link1"]
function Get-Section{
  param(
    [parameter(position=0, Mandatory=$true)][String]$file,
    [parameter(position=1)][String]$ctg
  )
  $ini = @{}
  switch -regex -file $file
  {
      "^\[(.+)\]$" {
          $section = $matches[1]
          $ini[$section] = @{}
      }
      "(.+)=(.+)" {
          $name,$value = $matches[1..2]
          $value = $value.replace(" ","");
          if    ($value.toLower() -eq 'true' ){ $ini[$section][$name] = $true }
          elseif($value.toLower() -eq 'false'){ $ini[$section][$name] = $false }
          else  { $ini[$section][$name] = $value }
      }
  }

  if($ctg){ return $ini[$ctg]
  } else  { return $ini }
 }

 function Get-WinSetupConfig{
  param(
    [parameter(position=0)][String]$file,
    [parameter(position=1)][String]$ctg
  )
  if(!($file)){ $file = (Join-Path -Path (Split-Path $script:MyInvocation.MyCommand.Path) -ChildPath "packages.ini")}
  if(!($ctg)) { $ctg  = "winSetup_conf" }

  return Get-Section $file $ctg;
}



Export-ModuleMember -Function 'Get-*'
