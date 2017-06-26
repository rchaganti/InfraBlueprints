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

Describe 'Simple Operations tests for system configuration' {
    Context 'Computer host name validation' {
        It 'host name matches configuration data' {
            (Get-CimInstance -ClassName Win32_ComputerSystem).DNSHostName | Should Be $configurationData.AllNodes.ComputerName
        }
    }

    Context 'Domain-joined validation' {
        It 'system is domain-joined' {
            (Get-CimInstance -ClassName Win32_ComputerSystem).PartofDomain | Should Be $true
        }

        It 'Domain name matches the configuration data' {
            (Get-CimInstance -ClassName Win32_ComputerSystem).Domain | Should Be $configurationData.AllNodes.DomainName
        }
    }
}
