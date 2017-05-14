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

$ConfigurationData = Get-ConfigurationDataAsObject -ConfigurationData $configurationDataPSD1

Describe "Simple Operations tests for Hyper-V Deployment with Switch Embedded Teaming and related network Configuration" {
    Context 'Hyper-V module related tests' {
        It "Hyper-V Module is available" {
            Get-Module -Name Hyper-V -ListAvailable | should not BeNullOrEmpty
        }

        It "Hyper-V Module can be loaded" {
            Import-Module -Name Hyper-V -Global -PassThru -Force | should not BeNullOrEmpty
        }
    }

    Context 'Hyper-V Host networking tests' {
        $vmSwitch = Get-VMSwitch -Name $ConfigurationData.AllNodes.SwitchName -ErrorAction SilentlyContinue
        It "A VM Switch should exist" {            
            $vmSwitch | Should not BeNullOrEmpty
        }

        It "Only one VM switch should exist" {
            $vmSwitch.Count | Should be 1
        }

        It "VM switch should be a SET" {
            $vmSwitch.EmbeddedTeamingEnabled | Should be $true
        }        

        It "Bandwidth Reservation Mode should be Weight" {
            $vmSwitch.BandwidthReservationMode | Should be 'Weight'
        }

        It "Management Network Adapter exists" {
            { Get-VMNetworkAdapter -ManagementOS -Name $ConfigurationData.AllNodes.ManagementAdapterName } | Should Not Throw
        }

        It "Cluster Network Adapter exists" {
            { Get-VMNetworkAdapter -ManagementOS -Name $ConfigurationData.AllNodes.ClusterAdapterName } | Should Not Throw
        }

        It "Live Migration Network Adapter exists" {
            { Get-VMNetworkAdapter -ManagementOS -Name $ConfigurationData.AllNodes.LiveMigrationAdapterName } | Should Not Throw
        }        
    }

    Context "General networking tests" {
        It "DNS name of user DNS domain should resolve" {
            Resolve-DnsName -Name $env:USERDNSDOMAIN -DnsOnly | Should Not BeNullOrEmpty
        }

        It "Default Gateway on the management network should be reachable" {
            Test-Connection -ComputerName $ConfigurationData.AllNodes.ManagementGateway -Count 2 -Quiet | Should Be $true
        }
    }    

    AfterAll {
        remove-Module Hyper-V
    }
}