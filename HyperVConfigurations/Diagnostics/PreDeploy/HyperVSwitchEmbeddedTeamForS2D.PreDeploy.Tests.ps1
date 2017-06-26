function Get-ConfigurationDataAsObject
{
    [CmdletBinding()]
    Param (
        [Parameter(Mandatory)]
        [Microsoft.PowerShell.DesiredStateConfiguration.ArgumentToConfigurationDataTransformation()]
        [hashtable] $ConfigurationData    
    )
    return $ConfigurationData
}

#Replace this with the right configuration data path
$moduleBase = Split-Path (Split-Path $PSScriptRoot -Parent) -Parent
$examplePath = "${moduleBase}\Examples\"
$baseName = ($MyInvocation.MyCommand.Name.Split('.'))[0]
$configurationDataPSD1 = "${examplePath}\Sample_${baseName}.NodeData.psd1"
#Replace till here

$configurationData = Get-ConfigurationDataAsObject -ConfigurationData $configurationDataPSD1

Describe 'Predeploy tests for Hyper-V Deployment with Switch Embedded Teaming and related network Configuration' {
    Context "Operating System verison tests" {
        $OS = Get-CimInstance -Class Win32_OperatingSystem
        It "Should have the OSType as WinNT" {
            $OS.OSType | Should Be 18
        }
        
        It "Should have server 2016 installed" {
           $OS.Caption | Should BeLike '*Server 2016*'
        }        
    }
        
    Context 'Hyper-V related tests' {
        It 'Hyper-V feature is not installed' {
            (Get-WindowsFeature -Name Hyper-V).Installed | Should Be $false
        }
    }

    Context 'Network adapters should exist' {
        Foreach ($adapter in $configurationData.AllNodes.NetAdapterName)
        {
            It "Network adapter named '$adapter' should exist" {
                Get-NetAdapter -Name $adapter -ErrorAction SilentlyContinue | Should Not BeNullOrEmpty
            }
        }
    }
}
