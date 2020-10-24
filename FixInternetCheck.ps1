#Requires -RunAsAdministrator

$Hive = "HKLM:\SYSTEM\CurrentControlSet\Services\NlaSvc\Parameters\Internet"
$RegChanges = [PSCustomObject]@{
  ActiveDnsProbeContent = "8.8.4.4"
  ActiveDnsProbeContentV6 = "2001:4860:4860::8844"
  ActiveDnsProbeHost = "dns.google"
  ActiveDnsProbeHostV6 = "dns.google"
  ActiveWebProbeHostV6 = "www.msftconnecttest.com"
  EnableActiveProbing = "1"
}

$RegChanges.PsObject.Properties | ForEach-Object {
  $CurrentValue = (Get-ItemProperty -Path $Hive -Name $_.Name).$($_.Name)
  
  if ($CurrentValue -ne $_.Value) {
    Write-Output "Changing $($_.Name) value from $CurrentValue to $($_.Value)"
    Set-ItemProperty -Path $Hive -Name $_.Name -Value $_.Value -Verbose
  }
}

