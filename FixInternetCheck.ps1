#Requires -RunAsAdministrator

Write-Warning "BACKUP YOUR REGISTRY BEFORE RUNNING!"
$ContinueRun = Read-Host "Continue running? (y/n)"

if (($ContinueRun -ne 'y') -or ($ContinueRun -ne 'Y')) {
  Write-Output "Exiting..."
  break
}

# changes made based off of answer here: https://answers.microsoft.com/en-us/windows/forum/windows_10-networking/windows-shows-no-internet-access-but-my-internet/2e9b593f-c31c-4448-b5d9-6e6b2bd8560c
$Hive = "HKLM:\SYSTEM\CurrentControlSet\Services\NlaSvc\Parameters\Internet"
$RegChanges = [PSCustomObject]@{
  ActiveDnsProbeContent   = "8.8.4.4"
  ActiveDnsProbeContentV6 = "2001:4860:4860::8844"
  ActiveDnsProbeHost      = "dns.google"
  ActiveDnsProbeHostV6    = "dns.google"
  ActiveWebProbeHostV6    = "www.msftconnecttest.com"
  EnableActiveProbing     = "1"
}

$RegChanges.PsObject.Properties | ForEach-Object {
  $CurrentValue = (Get-ItemProperty -Path $Hive -Name $_.Name).$($_.Name)
  
  if ($CurrentValue -ne $_.Value) {
    Write-Output "Changing $($_.Name) value from $CurrentValue to $($_.Value)"
    Set-ItemProperty -Path $Hive -Name $_.Name -Value $_.Value -Verbose
  }
}
