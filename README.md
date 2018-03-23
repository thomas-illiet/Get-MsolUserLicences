# Get-MsolUserLicences

[![Build Status](https://travis-ci.org/thomas-illiet/Get-MsolUserLicences.svg?branch=master)](https://travis-ci.org/thomas-illiet/Get-MsolUserLicences)

## SYNOPSIS

This script provides a report that shows license allocation in Office 365.

## NOTES

  - **File Name**   : Get-MsolUserLicences.ps1
  - **Author**      : Thomas ILLIET, contact@thomas-illiet.fr

## Install

```
Install-Script -Name Get-MsolUserLicences
```

## EXEMPLE

``` 
Get-MsolUserLicences -UserPrincipalName "unicorn@microsoft.com"

DisplayName                             : CANONNE Ronan
UserPrincipalName                       : unicorn@microsoft.com
Office 365 Enterprise E3                : False
Microsoft Flow Free                     : False
POWERAPPS_VIRAL                         : False
Power BI for Office 365 Standard        : False
Enterprise Mobility + Security E3       : False
Skype for Business PSTN Conferencing    : False
Azure Rights Management Services Ad-hoc : False
Office 365 Enterprise E1                : False
```

## EXEMPLE

```
$UserLicences = Get-MsolUser | Get-MsolUserLicences -ConvertName $false
$UserLicences | Export-Csv -Delimiter ";" -Encoding UTF8 -NoTypeInformation -Path "export.csv"
```