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

Describe 'PreDeploy tests for system configuration' {
    Context 'Computer host name validation' {
        It 'host name should not match configuration data' {
            (Get-CimInstance -ClassName Win32_ComputerSystem).DNSHostName | Should Not Be $configurationData.AllNodes.ComputerName
        }

        It '$env:USERDNSDOMAIN' {
            $env:USERDNSDOMAIN | Should Be BeNullOrEmpty
        }
    }
}
