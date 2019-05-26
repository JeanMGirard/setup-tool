function install-choco{
  Set-ExecutionPolicy Bypass -Scope Process -Force
  iex ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))
  choco feature enable -n allowGlobalConfirmation
  Set-PackageSource -Name chocolatey -Trusted
}
function install-scoop{
  iex (new-object net.webclient).downloadstring('https://get.scoop.sh')
}

Export-ModuleMember -Function 'install-*'
