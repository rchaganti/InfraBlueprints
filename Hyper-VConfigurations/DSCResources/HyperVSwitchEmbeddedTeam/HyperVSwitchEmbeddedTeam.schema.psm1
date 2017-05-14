Configuration HyperVSwitchEmbeddedTeam
{
    [CmdletBinding()]
    param (
        [Parameter()]
        [String] $SwitchName = 'SETSwitch',

        [Parameter(Mandatory)]
        [String[]] $NetAdapterName,

        [Parameter()]
        [ValidateSet('Dynamic','HyperVPort')]
        [String] $LoadbalancingAlgorithm = 'Dynamic',

        [Parameter()]
        [String] $TeamingMode = 'SwitchIndependent',

        [Parameter()]
        [String] $ManagementAdapterName = 'Management',        

        [Parameter()]
        [String] $ClusterAdapterName = 'Cluster',

        [Parameter()]
        [String] $LiveMigrationAdapterName = 'LiveMigration',

        [Parameter(Mandatory)]
        [ValidateRange(1,4096)]
        [Int] $ManagementVlanId,

        [Parameter(Mandatory)]
        [ValidateRange(1,4096)]
        [Int] $ClusterVlanId,

        [Parameter(Mandatory)]
        [ValidateRange(1,4096)]
        [Int] $LiveMigrationVlanId,

        [Parameter()]
        [ValidateRange(0,100)]
        [int] $ManagementMinimumBandwidthWeight = 30,

        [Parameter()]
        [ValidateRange(0,100)]
        [int] $ClusterMinimumBandwidthWeight = 30,

        [Parameter()]
        [ValidateRange(0,100)]        
        [int] $LiveMigrationMinimumBandwidthWeight = 40,

        [Parameter(Mandatory)]
        [String] $ManagementIPAddress,

        [Parameter(Mandatory)]
        [Int] $ManagementPrefixLength,

        [Parameter(Mandatory)]
        [String] $ManagementGateway,

        [Parameter(Mandatory)]
        [String] $ManagementDns,

        [Parameter(Mandatory)]
        [String] $ClusterIPAddress,

        [Parameter(Mandatory)]
        [Int] $ClusterPrefixLength,

        [Parameter(Mandatory)]
        [String] $LiveMigrationIPAddress,

        [Parameter(Mandatory)]
        [Int] $LiveMigrationPrefixLength
    )

    Import-DscResource -Name cVMSwitch, cVMNetworkAdapter, cVMNetworkAdapterVlan, cVMNetworkAdapterSettings -ModuleName cHyper-V -ModuleVersion 3.0.0.0
    Import-DscResource -Name xIPAddress, xDNSServerAddress, xDefaultGatewayAddress -ModuleName xNetworking -ModuleVersion 3.2.0.0
    Import-DscResource -ModuleName PSDesiredStateConfiguration

    WindowsFeature HyperV {
        Name = 'Hyper-V'
        Ensure = 'Present'
        IncludeAllSubFeature = $true
    }

    WindowsFeature HyperVMgmt {
        Name = 'RSAT-Hyper-V-Tools'
        Ensure = 'Present'
        IncludeAllSubFeature = $true
        DependsOn = '[WindowsFeature]HyperV'
    }

    cVMSwitch $SwitchName
    {
        Name = $SwitchName
        Type = 'External'
        NetAdapterName = $NetAdapterName
        TeamingMode = $TeamingMode
        LoadBalancingAlgorithm = $LoadbalancingAlgorithm
        MinimumBandwidthMode = 'Weight'
        AllowManagementOS = $false
        Ensure = 'Present'
        DependsOn = '[WindowsFeature]HyperV'
    }

    cVMNetworkAdapter $ManagementAdapterName
    {
        Id = "${SwitchName}-Management"
        Name = $ManagementAdapterName
        SwitchName = $SwitchName
        VMName = 'ManagementOS'
        Ensure = 'Present'
        DependsOn = "[cVMSwitch]$SwitchName"
    }    

    cVMNetworkAdapterVlan ManagementAdapterVlan
    {
        Id = "${SwitchName}-Management"
        Name = $ManagementAdapterName
        AdapterMode = 'Access'
        VlanId = $ManagementVlanId
        VMName = 'ManagementOS'
        DependsOn = "[cVMNetworkAdapter]$ManagementAdapterName"
    }

    cVMNetworkAdapterSettings ManagementAdapterSettings
    {
        Id = "${SwitchName}-Management"
        Name = $ManagementAdapterName
        SwitchName = $SwitchName
        VMName = 'ManagementOS'
        MinimumBandwidthWeight = $ManagementMinimumBandwidthWeight
        DependsOn = "[cVMNetworkAdapter]$ManagementAdapterName"
    }

    xIPAddress ManagementAdapterIPAddress
    {
        InterfaceAlias = "vEthernet ($ManagementAdapterName)"
        IPAddress = $ManagementIPAddress
        PrefixLength = $ManagementPrefixLength
        AddressFamily = 'IPv4'
        DependsOn = '[cVMNetworkAdapterVlan]ManagementAdapterVlan'
    }

    xDefaultGatewayAddress ManagementAdapterGateway
    {
        InterfaceAlias = "vEthernet ($ManagementAdapterName)"
        AddressFamily = 'IPv4'
        Address = $ManagementGateway
        DependsOn = '[xIPAddress]ManagementAdapterIPAddress'
    }

    xDNSServerAddress ManagementDns
    {
        InterfaceAlias = "vEthernet ($ManagementAdapterName)"
        AddressFamily = 'IPv4'
        Address = $ManagementDns
        DependsOn = '[xIPAddress]ManagementAdapterIPAddress'
    }

    cVMNetworkAdapter $ClusterAdapterName
    {
        Id = "${SwitchName}-Cluster"
        Name = $ClusterAdapterName
        SwitchName = $SwitchName
        VMName = 'ManagementOS'
        Ensure = 'Present'
        DependsOn = "[cVMSwitch]$SwitchName"
    }

    cVMNetworkAdapterVlan ClusterAdapterVlan
    {
        Id = "${SwitchName}-Cluster"
        Name = $ClusterAdapterName
        AdapterMode = 'Access'
        VMName = 'ManagementOS'
        VlanId = $ClusterVlanId
        DependsOn = "[cVMNetworkAdapter]$ClusterAdapterName"
    }

    cVMNetworkAdapterSettings ClusterAdapterSettings
    {
        Id = "${SwitchName}-Cluster"
        Name = $ClusterAdapterName
        SwitchName = $SwitchName
        VMName = 'ManagementOS'
        MinimumBandwidthWeight = $ClusterMinimumBandwidthWeight
        DependsOn = "[cVMNetworkAdapter]$ClusterAdapterName"
    }

    xIPAddress ClusterIPAddress
    {
        InterfaceAlias = "vEthernet ($ClusterAdapterName)"
        IPAddress = $ClusterIPAddress
        PrefixLength = $ClusterPrefixLength
        AddressFamily = 'IPv4'
        DependsOn = '[cVMNetworkAdapterVlan]ClusterAdapterVlan'
    }

    cVMNetworkAdapter $LiveMigrationAdapterName
    {
        Id = "${SwitchName}-LiveMigration"
        Name = $LiveMigrationAdapterName
        SwitchName = $SwitchName
        VMName = 'ManagementOS'
        Ensure = 'Present'
        DependsOn = "[cVMSwitch]$SwitchName"
    }

    cVMNetworkAdapterVlan LiveMigrationAdapterVlan
    {
        Id = "${SwitchName}-LiveMigration"
        Name = $LiveMigrationAdapterName
        AdapterMode = 'Access'
        VMName = 'ManagementOS'
        VlanId = $LiveMigrationVlanId
        DependsOn = "[cVMNetworkAdapter]$LiveMigrationAdapterName"
    }

    cVMNetworkAdapterSettings LiveMigrationAdapterSettings
    {
        Id = "${SwitchName}-LiveMigration"
        Name = $LiveMigrationAdapterName
        SwitchName = $SwitchName
        VMName = 'ManagementOS'
        MinimumBandwidthWeight = $LiveMigrationMinimumBandwidthWeight
        DependsOn = "[cVMNetworkAdapter]$LiveMigrationAdapterName"
    }

    xIPAddress LiveMigrationIPAddress
    {
        InterfaceAlias = "vEthernet ($LiveMigrationAdapterName)"
        IPAddress = $LiveMigrationIPAddress
        PrefixLength = $LiveMigrationPrefixLength
        AddressFamily = 'IPv4'
        DependsOn = '[cVMNetworkAdapterVlan]LiveMigrationAdapterVlan'
    }
}