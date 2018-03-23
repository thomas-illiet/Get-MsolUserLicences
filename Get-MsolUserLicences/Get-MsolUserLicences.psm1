function Get-MsolUserLicences
{
    <#  
        .DESCRIPTION  
            This script provides a report that shows license allocation in Office 365.
            
        .NOTES  
            File Name   : Get-MsolUserLicences.ps1
            Author      : Thomas ILLIET, contact@thomas-illiet.fr

        .PARAMETER UserprincipalName
            Speicifies the user ID of the user to retrieve.

        .Parameter LicenceFile
            Json licence database file ( you can find example file in my repository )

        .EXAMPLE
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

        .EXAMPLE
            $UserLicences = Get-MsolUser | Get-MsolUserLicences -ConvertName $false
            $UserLicences | Export-Csv -Delimiter ";" -Encoding UTF8 -NoTypeInformation -Path "export.csv"
    #>


    [cmdletbinding()]
    Param (
        # UserPrincipalName
        [Parameter(Mandatory=$False,ValueFromPipeline=$True,ValueFromPipelinebyPropertyName=$True,Position=0)]
        [String]$UserPrincipalName,

        # File for custom SKU conversion
        [Parameter(Mandatory=$False,Position=1)]
        [String]$LicenceFile=(Join-Path -Path $PSScriptRoot -ChildPath 'Licences.json'),

        # Convert Sku
        [Parameter(Mandatory=$False,Position=2)]
        [Bool]$ConvertName=$true
    )

    Begin {
        function Get-LicenseName
        {
            Param(
                [Parameter(Mandatory=$True)]
                [String]$Sku,
                [Parameter(Mandatory=$False)]
                [String]$LicenceFile
            )

            # Load Licence File
            Try
            {
                $LicenseName = @{}
                $CsvFile = Get-Content -Raw -Path $LicenceFile
                (ConvertFrom-Json $CsvFile).psobject.properties | ForEach-Object { $LicenseName[$_.Name] = $_.Value }
            }
            Catch
            {
                throw "Unable to load LicenceFile ! "
            }
            
            # Search Licence by sku name
            if($LicenseName.($sku))
            {
                return $LicenseName.($sku)
            }
            else
            {
                Write-Debug "Sku name ($sku) is not defined"
                return $sku
            }

        }

        #----------------------------------------------
        # Create Template Object
        #----------------------------------------------
        $licensetype = Get-MsolAccountSku | Where-Object {$_.ConsumedUnits -ge 1}

        $TemplateObject = [PsCustomObject]@{
            DisplayName       = $null
            UserPrincipalName = $null
        }

        # Loop through all licence types found in the tenant
        foreach ($license in $licensetype.AccountSkuId) 
        {
            if($ConvertName -eq $true)
            {
                $Name = Get-LicenseName -Sku $license.split(':')[1] -LicenceFile $LicenceFile
                $TemplateObject | Add-Member -Name $Name -Type NoteProperty -Value $false
            }
            else
            {
                $TemplateObject | Add-Member -Name $license.split(':')[1] -Type NoteProperty -Value $false
            }
        }
    }


    Process  {
        #----------------------------------------------
        # Get All users
        #----------------------------------------------
        if(-not([string]::IsNullOrEmpty($UserPrincipalName)))
        {
            $Users = Get-MsolUser -UserPrincipalName $UserPrincipalName
        }
        else
        {
            $Users = Get-MsolUser -All | where {$_.isLicensed -eq "True"} | select DisplayName, UserPrincipalName, isLicensed, Licenses
        }

        #----------------------------------------------
        # Create Report Object
        #----------------------------------------------
        $ReturnObject=@()
        foreach($User in $Users)
        {
            $UserObject = $TemplateObject.PsObject.Copy()

            # Set User information
            $UserObject.DisplayName = $User.DisplayName
            $UserObject.UserPrincipalName = $User.UserPrincipalName

            # Define Licence Attribution
            foreach($License in $User.Licenses.AccountSkuId)
            {
                if($ConvertName -eq $true)
                {
                    $Name = Get-LicenseName -Sku $license.split(':')[1] -LicenceFile $LicenceFile
                    $UserObject.($Name) = $true
                }
                else
                {
                    $UserObject.($license.split(':')[1]) = $true
                }
            }

            # Add Object to return store
            $ReturnObject += $UserObject
        }
        return $ReturnObject
    }
}