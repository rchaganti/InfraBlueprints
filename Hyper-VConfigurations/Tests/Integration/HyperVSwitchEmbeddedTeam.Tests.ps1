param (
    [String] $ConfigurationDataFile
)

$supportFolder = Join-Path -Path (Split-Path -Path (Split-Path -Path (Split-Path -Path (Split-Path -Path $PSScriptRoot -Parent)))) -ChildPath 'Support'
if (Test-Path -Path $supportFolder)
{
    ."$supportFolder\Support.ps1"
}

$configurationData = Get-ConfigurationDataAsObject -ConfigurationData $ConfigurationDataFile
$ConfigurationData

#Describe 'Integration tests to verify desired state' {
#    It 'Hyper-V Role is installed' {
#        (Get-WindowsFeature -Name Hyper-V).InstallState | Should Be 'Installed'
#    }
#    
#    It 'VM switch exists' {
#        Get-VMSwitch -Name $ConfigurationData.AllNodes.SETName | Should not BeNullOrEmpty
#    }
#
#    It 'VM switch is a SET team' {
#        (Get-VMSwitch -Name $ConfigurationData.AllNodes.SETName).EmbeddedTeamingEnabled | Should be $true
#    }
#
#    It 'Management Network adapter exists in the management OS' {
#        Get-VMNetworkAdapter -ManagementOS -Name $ConfigurationData.AllNodes.SetName | Should not BeNullOrEmpty
#    }
#
#    It 'Management Network adapter VLAN matches configuration data' {
#        (Get-VMNetworkAdapterVlan -ManagementOS -VMNetworkAdapterName $ConfigurationData.AllNodes.SetName).AccessVlanId | Should be $ConfigurationData.AllNodes.ManagementVlanID
#    }
#
#    It 'Cluster Network adapter exists in the management OS' {
#        Get-VMNetworkAdapter -ManagementOS -Name $ConfigurationData.AllNodes.ClusterAdapterName | Should not BeNullOrEmpty
#    }
#
#    It 'Cluster Network adapter VLAN matches configuration data' {
#        (Get-VMNetworkAdapterVlan -ManagementOS -VMNetworkAdapterName $ConfigurationData.AllNodes.ClusterAdapterName).AccessVlanId | Should be $ConfigurationData.AllNodes.ClusterAdapterVlanID
#    }
#
#    It 'Live Migration Network adapter exists in the management OS' {
#        Get-VMNetworkAdapter -ManagementOS -Name $ConfigurationData.AllNodes.LiveMigrationAdapterName | Should not BeNullOrEmpty
#    }
#
#    It 'Live Migraiton Network adapter VLAN matches configuration data' {
#        (Get-VMNetworkAdapterVlan -ManagementOS -VMNetworkAdapterName $ConfigurationData.AllNodes.LiveMigrationAdapterName).AccessVlanId | Should be $ConfigurationData.AllNodes.LiveMigrationAdapterVlanID
#    }
#}