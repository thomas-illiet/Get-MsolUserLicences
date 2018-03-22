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

                DisplayName               : Unicorn Girl
                UserPrincipalName         : unicorn@microsoft.com
                STREAM                    : False
                Office 365 (Plan E3)      : False
                FLOW_FREE                 : False
                POWERAPPS_VIRAL           : False
                Power-BI Standard         : False
                Enterprise Mobility Suite : True
                (PSTN) conferencing       : False
                Office 365 (Plan E1)      : True

        .EXAMPLE
            Get-MsolUser | Get-MsolUserLicences

            DisplayName          UserPrincipalName                                          Power-BI_Standard O365_BUSINESS_ESSENTIALS
            -----------          -----------------                                          ----------------- ------------------------
            Unicorn Girl         unicorn.girl_microsoft.fr#EXT#@netboot.onmicrosoft.com                  True                    False
            Thomas ILLIET        contact@thomas-illiet.fr                                                True                     True
    #>


    [cmdletbinding()]
    Param (
        # UserPrincipalName
        [Parameter(Mandatory=$False,ValueFromPipeline=$True,ValueFromPipelinebyPropertyName=$True)]
        $UserPrincipalName,

        # File for custom SKU conversion
        [Parameter(Mandatory=$False)]
        [String]$LicenceFile
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
            # Check Licence File is defined
            if(-not([string]::IsNullOrEmpty($LicenceFile)))
            {
                # Load Licence File
                Try
                {
                    $LicenseName = @{}
                    $CsvFile = Get-Content -Raw -Path $LicenceFile
                    (ConvertFrom-Json $CsvFile).psobject.properties | Foreach { $LicenseName[$_.Name] = $_.Value }
                }
                Catch
                {
                    throw "Unable to load LicenceFile ! "
                }
            }
            else
            {
                # Licence Name
                $LicenseName = @{
                    "TEAMS1"                               = "Microsoft Teams"
                    "AAD_PREMIUM"                          = "Azure Active Directory Premium P1"
                    "AAD_PREMIUM_P2"                       = "Azure Active Directory Premium P2"
                    "RMS_S_ENTERPRISE"                     = "Azure Active Directory Rights Management"
                    "RIGHTSMANAGEMENT_ADHOC"               = "Azure Rights Management Services Ad-hoc"
                    "CRMPLAN2"                             = "Dynamics CRM Online Plan 2"
                    "EMS"                                  = "Enterprise Mobility + Security E3"
                    "EMSPREMIUM"                           = "Enterprise Mobility + Security E5"
                    "ENTERPRISEPACK_B_PILOT"               = "Office 365 (Enterprise Preview)"
                    "EXCHANGEENTERPRISE_FACULTY"           = "Exch Online Plan 2 for Faculty"
                    "EXCHANGE_L_STANDARD"                  = "Exchange Online (Plan 1)"
                    "EXCHANGE_S_STANDARD"                  = "Exchange Online (Plan 2)"
                    "ATP_ENTERPRISE_FACULTY"               = "Exchange Online Advanced Threat Protection"
                    "ATP_ENTERPRISE"                       = "Exchange Online ATP"
                    "EXCHANGESTANDARD"                     = "Exchange Online Plan 1"
                    "EXCHANGE_S_ENTERPRISE"                = "Exchange Online Plan 2 S"
                    "EXCHANGEENTERPRISE"                   = "Exchange Online Plan 2"
                    "RIGHTSMANAGEMENT_STANDARD_FACULTY"    = "Information Rights Management for Faculty"
                    "RIGHTSMANAGEMENT_STANDARD_STUDENT"    = "Information Rights Management for Students"
                    "INTUNE_A_VL"                          = "Intune (Volume License)"
                    "MCOLITE"                              = "Lync Online (Plan 1)"
                    "CRMSTORAGE"                           = "Microsoft Dynamics CRM Online Additional Storage"
                    "FLOW_FREE"                            = "Microsoft Flow Free"
                    "IT_ACADEMY_AD"                        = "Microsoft Imagine Academy"
                    "POWERAPPS_INDIVIDUAL_USER"            = "Microsoft PowerApps and Logic flows"
                    "STREAM"                               = "Microsoft Stream"
                    "MICROSOFT_BUSINESS_CENTER"            = "Microsoft Business Center"
                    "MEE_FACULTY"                          = "Minecraft Education Edition Faculty"
                    "MEE_STUDENT"                          = "Minecraft Education Edition Student"
                    "STANDARDWOFFPACK_STUDENT"             = "O365 Education E1 for Students"
                    "STANDARDWOFFPACK_IW_FACULTY"          = "O365 Education for Faculty"
                    "STANDARDWOFFPACK_IW_STUDENT"          = "O365 Education for Students"
                    "STANDARDPACK_STUDENT"                 = "Office 365 (Plan A1) for Students"
                    "ENTERPRISEPACKLRG"                    = "Office 365 (Plan E3)"
                    "EQUIVIO_ANALYTICS_FACULTY"            = "Office 365 Advanced Compliance for faculty"
                    "STANDARDWOFFPACK_FACULTY"             = "Office 365 Education E1 for Faculty"
                    "ENTERPRISEWITHSCAL_FACULTY"           = "Office 365 Education E4 for Faculty"
                    "ENTERPRISEWITHSCAL_STUDENT"           = "Office 365 Education E4 for Students"
                    "STANDARDPACK"                         = "Office 365 Enterprise E1"
                    "STANDARDWOFFPACK"                     = "Office 365 Enterprise E2"
                    "ENTERPRISEPACKWITHOUTPROPLUS"         = "Office 365 Enterprise E3 without ProPlus Add-on"
                    "ENTERPRISEPACK"                       = "Office 365 Enterprise E3"
                    "ENTERPRISEWITHSCAL"                   = "Office 365 Enterprise E4"
                    "ENTERPRISEPREMIUM"                    = "Office 365 Enterprise E5"
                    "DESKLESSPACK_YAMMER"                  = "Office 365 Enterprise K1 with Yammer"
                    "DESKLESSPACK"                         = "Office 365 Enterprise K1 without Yammer"
                    "DESKLESSWOFFPACK"                     = "Office 365 Enterprise K2"
                    "MIDSIZEPACK"                          = "Office 365 Midsize Business"
                    "STANDARDWOFFPACKPACK_FACULTY"         = "Office 365 Plan A2 for Faculty"
                    "STANDARDWOFFPACKPACK_STUDENT"         = "Office 365 Plan A2 for Students"
                    "ENTERPRISEPACK_FACULTY"               = "Office 365 Plan A3 for Faculty"
                    "ENTERPRISEPACK_STUDENT"               = "Office 365 Plan A3 for Students"
                    "OFFICESUBSCRIPTION_FACULTY"           = "Office 365 ProPlus for Faculty"
                    "LITEPACK_P2"                          = "Office 365 Small Business Premium"
                    "WACSHAREPOINTSTD"                     = "Office Online STD"
                    "SHAREPOINTWAC"                        = "Office Online"
                    "OFFICESUBSCRIPTION_STUDENT"           = "Office ProPlus Student Benefit"
                    "OFFICE_PRO_PLUS_SUBSCRIPTION_SMBIZ"   = "Office ProPlus"
                    "POWER_BI_INDIVIDUAL_USER"             = "Power BI for Office 365 Individual"
                    "POWER_BI_STANDALONE"                  = "Power BI for Office 365 Standalone"
                    "POWER_BI_STANDARD"                    = "Power BI for Office 365 Standard"
                    "POWER_BI_PRO"                         = "Power BI Pro"
                    "PROJECTESSENTIALS"                    = "Project Lite"
                    "PROJECTONLINE_PLAN_1_FACULTY"         = "Project Online for Faculty Plan 1"
                    "PROJECTONLINE_PLAN_2_FACULTY"         = "Project Online for Faculty Plan 2"
                    "PROJECTONLINE_PLAN_1_STUDENT"         = "Project Online for Students Plan 1"
                    "PROJECTONLINE_PLAN_2_STUDENT"         = "Project Online for Students Plan 2"
                    "PROJECTPREMIUM"                       = "Project Online Premium"
                    "PROJECTPROFESSIONAL"                  = "Project Online Professional"
                    "PROJECTONLINE_PLAN_1"                 = "Project Online with Project for Office 365"
                    "PROJECTCLIENT"                        = "Project Pro for Office 365"
                    "SHAREPOINTLITE"                       = "SharePoint Online (Plan 1) Lite"
                    "SHAREPOINTENTERPRISE_MIDMARKET"       = "SharePoint Online (Plan 1) MidMarket"
                    "SHAREPOINTENTERPRISE"                 = "SharePoint Online (Plan 2)"
                    "SHAREPOINTSTANDARD"                   = "SharePoint Online Plan 1"
                    "VISIOCLIENT"                          = "Visio Pro for Office 365"
                    "YAMMER_ENTERPRISE"                    = "Yammer Enterprise"
                    "YAMMER_MIDSIZE"                       = "Yammer Midsize"
                }
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
        $licensetype = Get-MsolAccountSku | Where {$_.ConsumedUnits -ge 1}

        $TemplateObject = [PsCustomObject]@{
            DisplayName       = $null
            UserPrincipalName = $null
        }

        # Loop through all licence types found in the tenant
        foreach ($license in $licensetype.AccountSkuId) 
        {
            $Name = Get-LicenseName -Sku $license.split(':')[1] -LicenceFile $LicenceFile
            $TemplateObject | Add-Member -Name $Name -Type NoteProperty -Value $false
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
                $Name = Get-LicenseName -Sku $license.split(':')[1] -LicenceFile $LicenceFile
                $UserObject.($Name) = $true
            }

            # Add Object to return store
            $ReturnObject += $UserObject
        }
        return $ReturnObject
    }
}