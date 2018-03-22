@{

    # Script module or binary module file associated with this manifest.
    RootModule = 'Get-MsolUserLicences.psm1'
    
    # Version number of this module.
    ModuleVersion = '1.0.0'
    
    # ID used to uniquely identify this module
    GUID = '7800b74f-7409-4219-ac53-bc11f34674fb'
    
    # Author of this module
    Author = 'thomas.illiet'
    
    # Company or vendor of this module
    CompanyName = 'thomas-illiet.fr'
    
    # Copyright statement for this module
    Copyright = '(c) 2018 Thomas ILLIET. All rights reserved.'
    
    # Description of the functionality provided by this module
    Description = 'This script provides a report that shows license allocation in Office 365.'
    
    # Functions to export from this module, for best performance, do not use wildcards and do not delete the entry, use an empty array if there are no functions to export.
    FunctionsToExport = @('Get-MsolUserLicences')
    
    # Cmdlets to export from this module, for best performance, do not use wildcards and do not delete the entry, use an empty array if there are no cmdlets to export.
    CmdletsToExport = ''
    
    # Variables to export from this module
    VariablesToExport = ''
    
    # Aliases to export from this module, for best performance, do not use wildcards and do not delete the entry, use an empty array if there are no aliases to export.
    AliasesToExport = ''
    
    # Private data to pass to the module specified in RootModule/ModuleToProcess. This may also contain a PSData hashtable with additional module metadata used by PowerShell.
    PrivateData = @{
    
        PSData = @{
    
            # Tags applied to this module. These help with module discovery in online galleries.
            Tags = @('Office365')
    
            # A URL to the license for this module.
            LicenseUri = 'https://raw.githubusercontent.com/thomas-illiet/Get-MsolUserLicences/master/LICENSE'
    
            # A URL to the main website for this project.
            ProjectUri = 'https://github.com/thomas-illiet/Get-MsolUserLicences'
    
            # A URL to an icon representing this module.
            IconUri = 'https://raw.githubusercontent.com/thomas-illiet/Get-MsolUserLicences/master/Resource/Icon.png'
    
        } # End of PSData hashtable
    
    } # End of PrivateData hashtable
    
}
    