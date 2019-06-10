cls
write-host " --- Net Connection Profiles ---------------- "
write-host ""

Get-NetConnectionProfile | Format-Table -Property InterfaceIndex, InterfaceAlias, NetworkCategory

$message  = 'Network connections Configurations'
$question = "Mark all network connections as private?"
$choices  = '&No', '&Yes'

$decision = $Host.UI.PromptForChoice($message, $question, $choices, 0)

cls

if ($decision -eq 1){
	get-NetConnectionProfile | where { $_.NetworkCategory -eq "Public" } | 
		ForEach-Object -Process { set-NetConnectionProfile -NetworkCategory "Private" }
}

Get-NetConnectionProfile | Format-Table -Property InterfaceIndex, InterfaceAlias, NetworkCategory
