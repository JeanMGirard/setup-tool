$h = $Host.UI


# ---------------------------------------------------------------------------- #
#                                  PsRemoting                                  #
# ---------------------------------------------------------------------------- #
Clear-Host
write-host " --- PsRemoting -------------------------"
write-host ""

. "$($PSScriptRoot)/vars.ps1"

$PsConfigsDir = $ENV:PsConfigsDir
$PsSessionsDir = $ENV:PsSessionsDir
$PsConfig = $ENV:PsDefaultConfig

$ENV:PsDefaultConfig = @{}

$message = 'PsRemoting'

$req = "Do you wish to enable PsRemoting?" 
$opt = 'skip', '&yes', '&no' 
$action = $h.PromptForChoice($message, $req, $opt, 0)

if ($action -eq 1) {

    write-host " --- PsRemoting -------------------------"

    if (!(Test-Path -Path $PsConfigsDir )) { mkdir $PsConfigsDir; }
    if (!(Test-Path -Path $PsSessionsDir )) { mkdir $PsSessionsDir; } 
 


    $req = "Allow sessions external access?"
    $res = $h.PromptForChoice($message, $req, $opt, 0)

	
    if ($res -eq 0) {
        Enable-WSManCredSSP Server
        Enable-PSSessionConfiguration -name Microsoft.Power*
        Enable-PSRemoting -force
    }
    elseif ($res -eq 1) { 
        Enable-WSManCredSSP Server
        Enable-PSSessionConfiguration -name Microsoft.Power*
        Set-NetFirewallRule -Name "WINRM-HTTP-In-TCP-PUBLIC" -RemoteAddress Any
        Enable-PSRemoting -force
    } 


    $req = "Write new session configs?"
    $res = $h.PromptForChoice($message, $req, $opt, 0)

    if ($res -eq 1) {
        $f = "${PsConfigsDir}/exemple.pssc"; if (Test-Path -Path $f ) { rm $f; }
        New-PSSessionConfigurationFile  -Path $f		
			
        $f = "${PsConfigsDir}/no-language.pssc"; if (Test-Path -Path $f ) { rm $f; }		
        New-PSSessionConfigurationFile  -Path $f -LanguageMode NoLanguage
    }

    $req = "Overwrite current sessions?"
    $res = $h.PromptForChoice($message, $req, $opt, 0)
	
    if ($res -eq 1) { 
        Get-PSSessionConfiguration | where { $_.Name -eq "PsSessionExemple" -Or $_.Name -eq "NoLanguage" } | foreach-object -process { 
            Unegister-PSSessionConfiguration 
        }
    }	
    Register-PSSessionConfiguration -Path "${PsConfigsDir}/no-language.pssc" -Name NoLanguage -Force
    Register-PSSessionConfiguration -Path "${PsConfigsDir}/exemple.pssc" -Name PsSessionExemple -Force
}

elseif ($action -eq 2) {
	
}






Write-host "PsSessions Configs"
Get-PSSessionConfiguration | Format-Wide -property Name

# ---------------------------------------------------------------------------- #
#                                  CimSessions                                 #
# ---------------------------------------------------------------------------- #

Clear-Host
write-host " --- 'CimSessions -------------------------"
write-host ""

$message = 'Configuration'

$req = "Do you wish to setup 'CimSessions?" 
$opt = 'skip', '&yes', '&no' 
$act = $h.PromptForChoice($message, $req, $opt, 0)

if ($act -eq 1) {
    $req = "Do you wish to override past CimSessions?" 
    $opt = 'skip', '&yes', '&no' 
    $act = $h.PromptForChoice($message, $req, $opt, 0)

}



$SessionOption = New-CimSessionOption -Protocol DCOM

New-CimSession -ComputerName Server1 -SessionOption $SessionOption

# ---------------------------------------------------------------------------- #
#                            Net Connection Profiles                           #
# ---------------------------------------------------------------------------- #

Clear-Host
write-host " --- Net Connection Profiles ---------------- "
write-host ""

Get-NetConnectionProfile | Format-Table -Property InterfaceIndex, InterfaceAlias, NetworkCategory

$message = 'Network connections Configurations'
$question = "Mark all network connections as private?"
$choices = '&No', '&Yes'

$decision = $Host.UI.PromptForChoice($message, $question, $choices, 0)

Clear-Host

if ($decision -eq 1) {
    get-NetConnectionProfile | where { $_.NetworkCategory -eq "Public" } | 
    ForEach-Object -Process { set-NetConnectionProfile -NetworkCategory "Private" }
}

Get-NetConnectionProfile | Format-Table -Property InterfaceIndex, InterfaceAlias, NetworkCategory


# ---------------------------------------------------------------------------- #
#                                   PsDrives                                   #
# ---------------------------------------------------------------------------- #

Clear-Host
write-host " --- 'PsDrives -------------------------"
write-host ""

$message = 'PsDrives'

$req = "Do you wish to enable 'PsDrives?" 
$opt = 'skip', '&yes', '&no' 
$action = $h.PromptForChoice($message, $req, $opt, 0)
$PsDriveRoot = "dimgo"
$PsDrvName = "winSetup"

$Items = Get-PsDrive;


if ($action -eq 1) {
    $req = "Do you wish to enable 'PsDrives?" 
    $opt = 'skip', '&yes', '&no' 
    $action = $h.PromptForChoice($message, $req, $opt, 0)

    if (!($Items.Title -contains $PsDriveRoot)) {
        $PsDrv = New-PSDrive -Name $PsDrvName `
            -PSProvider "Registry" -Root "HKLM:\Software\${$PsDriveRoot}"
    }
    if (!($Items.Title -contains $PsDriveRoot)) {
        $PsDrv = New-PSDrive -Name $PsDrvName `
            -PSProvider "Registry" -Root "HKLM:\Software\${$PsDriveRoot}"
    }
}
elseif ($action -eq 2) {
    $PsDrv = New-PSDrive -Name $PsDrvName -PSProvider "Registry" -Root "HKLM:\Software\${PsDrvName}"
}

# ---------------------------------------------------------------------------- #

