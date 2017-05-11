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

$ConfigurationData = Get-ConfigurationDataAsObject -ConfigurationDat C:\ConvergedSwitch\NodeData.psd1

Describe "Simple Operations tests for Hyper-V Deployment and network Configuration" {
    Context 'Hyper-V module related tests' {
        It "Hyper-V Module is available" {
            Get-Module -Name Hyper-V -ListAvailable | should not BeNullOrEmpty
        }

        It "Hyper-V Module can be loaded" {
            Import-Module -Name Hyper-V -Global -PassThru -Force | should not BeNullOrEmpty
        }
    }

    Context "Host connectctivity checks" {
        It "Resolve the hostname using the name server" {
            (Resolve-DnsName -Name $ConfigurationData.AllNodes.Hostname -Type A -Server $ConfigurationData.AllNodes.ManagementDnsServer).IPAddress | Should not be BeNullOrEmpty
        }
    }

    AfterAll {
        remove-Module Hyper-V
    }
}