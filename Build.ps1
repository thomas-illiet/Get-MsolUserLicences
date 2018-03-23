
Param(
    # Name of Module
    [Parameter(Mandatory=$true)]
    [string]$ModuleName,

    # By default Update-Manifest increments ModuleVersion; this controls which part of the version number is incremented
    [Parameter(ParameterSetName="Increment")]
    [ValidateSet("Major","Minor","Build")]
    [string]$Increment = "Build",

    # When set, and incrementing the ModuleVersion, output the new version number.
    [Parameter(ParameterSetName="Increment")]
    [switch]$Passthru,
   
    [Parameter(Mandatory=$true)]
    [string]$PSGalleryApiKey
)


# ++++++++++++++++++++++++
# Install Powershell Gallery Module
Write-Output "- Install Powershell Gallery"
Try {
    if ((Get-Module -ListAvailable -Name 'PowerShellGet') -eq $null) {
        Install-Module -Name PowerShellGet -Force
    }
} Catch {
    Throw [System.NotImplementedException]::New("Unable to install Powershell Gallery Module : $_")
}

# ++++++++++++++++++++++++
# Get Current Version
Write-Output "- Get Current Version"
Try {
    [Version]$Version = (Find-Module -Name $ModuleName -ErrorAction SilentlyContinue).Version
    if($Version -ne $null) {
        $Version = switch($Increment) {
            "Major" {
                [Version]::new($Version.Major + 1, 0)
            }
            "Minor" {
                $Minor = if($Version.Minor -le 0) { 1 } else { $Version.Minor + 1 }
                [Version]::new($Version.Major, $Minor)
            }
            "Build" {
                $Build = if($Version.Build -le 0) { 1 } else { $Version.Build + 1 }
                [Version]::new($Version.Major, $Version.Minor, $Build)
            }
        }
    } else {
        $Version = [version]'0.0.1'
    }
} Catch {
    Throw [System.NotImplementedException]::New("Unable to get version : $_")
}

# ++++++++++++++++++++++++
# Create Definision File
Write-Output "- Create Definision File"
Try {
    $Params = @{
        Path              = (Join-Path -Path $PSScriptRoot -ChildPath "$ModuleName/$ModuleName.psd1")
        ModuleVersion     = $Version
    }
    Update-ModuleManifest @Params
} Catch {
    Throw [System.NotImplementedException]::New("Unable to Create Definision File : $_")
}

# ++++++++++++++++++++++++
# Publish Module
Write-Output "- Publish Module"
Try {
    publish-module -path (Join-Path -Path $PSScriptRoot -ChildPath $ModuleName) -NuGetApiKey $PSGalleryApiKey
} Catch {
    Throw [System.NotImplementedException]::New("Unable to upload on Powershell Gallery : $_")
}