$h = $Host.UI

cls
write-host " --- PsRemoting -------------------------"
write-host ""

. ./PsRemoting.vars.ps1

$PsConfigsDir 	= $ENV:PsConfigsDir
$PsSessionsDir 	= $ENV:PsSessionsDir
$PsConfig       = $ENV:PsDefaultConfig

$ENV:PsDefaultConfig = @{}

$message  = 'PsRemoting'

$req = "Do you wish to enable PsRemoting?" 
$opt = 'skip', '&yes', '&no' 
$action = $h.PromptForChoice($message, $req, $opt, 0)

if ($action -eq 1){

	write-host " --- PsRemoting -------------------------"

	if(!(Test-Path -Path $PsConfigsDir )){ mkdir $PsConfigsDir; }
	if(!(Test-Path -Path $PsSessionsDir )){ mkdir $PsSessionsDir; } 
 


	$req  = "Allow sessions external access?"
	$res  = $h.PromptForChoice($message, $req, $opt, 0)

	
	if  ($res -eq 0) {
		Enable-WSManCredSSP Server
		Enable-PSSessionConfiguration -name Microsoft.Power*
		Enable-PSRemoting -force
	} elseif  ($res -eq 1) { 
		Enable-WSManCredSSP Server
		Enable-PSSessionConfiguration -name Microsoft.Power*
		Set-NetFirewallRule -Name "WINRM-HTTP-In-TCP-PUBLIC" -RemoteAddress Any
		Enable-PSRemoting -force
	} 


	$req = "Write new session configs?"
	$res = $h.PromptForChoice($message, $req, $opt, 0)

	if ($res -eq 1){
		$f = "${PsConfigsDir}/exemple.pssc"; 	if(Test-Path -Path $f ){ rm $f; }
		New-PSSessionConfigurationFile  -Path $f		
			
		$f = "${PsConfigsDir}/no-language.pssc"; if(Test-Path -Path $f ){ rm $f; }		
		New-PSSessionConfigurationFile  -Path $f -LanguageMode NoLanguage
	}

	$req = "Overwrite current sessions?"
        $res = $h.PromptForChoice($message, $req, $opt, 0)
	
	if($res -eq 1){ 
		Get-PSSessionConfiguration | where { $_.Name -eq "PsSessionExemple" -Or $_.Name -eq "NoLanguage" } | foreach-object -process { 
			Unegister-PSSessionConfiguration 
		}
	}	
	Register-PSSessionConfiguration -Path "${PsConfigsDir}/no-language.pssc" -Name NoLanguage -Force
	Register-PSSessionConfiguration -Path "${PsConfigsDir}/exemple.pssc" -Name PsSessionExemple -Force
}

elseif ($action -eq 2){
	
}






Write-host "PsSessions Configs"
Get-PSSessionConfiguration | Format-Wide -property Name
