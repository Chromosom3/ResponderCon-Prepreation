# Script: user_creation.ps1
# Author: Dylan 'Chromosom3' Navarro
# Description: Used to make user accounts in bulk

# Configuration
$OU_Location = "OU=Accounts,OU=Workshop,DC=Domain,DC=local"
$defaultPass = "Password123!@#"
$number_of_users = 33

# Don't edit below this line
$number_of_users += 1
for (0 -lt $number_of_users; $number_of_users = $number_of_users - 1){
    $username = "user" + $number_of_users
    Write-Host("Making user $username...")
    New-ADUser -SamAccountName $username -Name $username -Path $OU_Location -AccountPassword (ConvertTo-SecureString -AsPlainText $defaultPass -Force)
}