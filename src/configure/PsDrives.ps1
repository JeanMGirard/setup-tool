cls
write-host " --- 'PsDrives -------------------------"
write-host ""

$message  = 'PsDrives'

$req = "Do you wish to enable 'PsDrives?" 
$opt = 'skip', '&yes', '&no' 
$action = $h.PromptForChoice($message, $req, $opt, 0)
$PsDriveRoot="dimgo"
$PsDrvName="winSetup"

$Items = Get-PsDrive;


if ($action -eq 1){
$req = "Do you wish to enable 'PsDrives?" 
$opt = 'skip', '&yes', '&no' 
$action = $h.PromptForChoice($message, $req, $opt, 0)

    if(!($Items.Title -contains $PsDriveRoot)){
        $PsDrv = New-PSDrive -Name $PsDrvName `
        -PSProvider "Registry" -Root "HKLM:\Software\${$PsDriveRoot}"
    }
    if(!($Items.Title -contains $PsDriveRoot)){
        $PsDrv = New-PSDrive -Name $PsDrvName `
        -PSProvider "Registry" -Root "HKLM:\Software\${$PsDriveRoot}"
    }
} elseif ($action -eq 2) {
    $PsDrv = New-PSDrive -Name $PsDrvName -PSProvider "Registry" -Root "HKLM:\Software\${PsDrvName}"
}

