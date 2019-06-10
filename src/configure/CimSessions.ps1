cls
write-host " --- 'CimSessions -------------------------"
write-host ""

$message  = 'Configuration'



$req = "Do you wish to setup 'CimSessions?" 
$opt = 'skip', '&yes', '&no' 
$act = $h.PromptForChoice($message, $req, $opt, 0)

if ($act -eq 1){
    $req = "Do you wish to override past CimSessions?" 
    $opt = 'skip', '&yes', '&no' 
    $act = $h.PromptForChoice($message, $req, $opt, 0)

}



$SessionOption = New-CimSessionOption -Protocol DCOM

New-CimSession -ComputerName Server1 -SessionOption $SessionOption