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

Describe 'Comprehensive Operations tests for system configuration' {
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

        It 'Domain name resolution is working' {
            Resolve-DnsName -Name $env:USERDNSDOMAIN -DnsOnly | Should Not BeNullOrEmpty
        }
    }

    Context 'Time zone tests' {
        It 'Timezone configured on the system matches configuration data' {
            ([System.TimeZone]::CurrentTimeZone).StandardName | Should Be $configurationData.AllNodes.TimeZone
        }
    }

    Context 'Remote Desktop tests' {
        It 'RDP is enabled' {
            (Get-ItemProperty -Path 'HKLM:\System\CurrentControlSet\Control\Terminal Server').fDenyTSConnections | Should be 0
        }

        It 'User Authentication should be secured' {            
            (Get-ItemProperty -Path 'HKLM:\System\CurrentControlSet\Control\Terminal Server\WinStations\RDP-Tcp').UserAuthentication | Should be 1
        }        
    }
}
