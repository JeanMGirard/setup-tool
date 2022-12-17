$h = $Host.UI

cls
write-host " --- Desired state configuration -------------------------"
write-host ""

$DscDirectory = "C:\DSC\Configurations\"


$message  = ' --- DSC --- '

$req = "Do you wish to enable DSC?" 
$opt = 'skip', '&yes', '&no' 
$action = $h.PromptForChoice($message, $req, $opt, 0)

if($action -eq 1){
    if(!(Test-Path -Path $DscDirectory )){ mkdir $DscDirectory; }

}

if(Test-Path -Path $DscDirectory ){ 
    New-DscCheckSum -Path $DscDirectory -Force
}

cls
Get-DscResource | Format-table -property Name, Module
