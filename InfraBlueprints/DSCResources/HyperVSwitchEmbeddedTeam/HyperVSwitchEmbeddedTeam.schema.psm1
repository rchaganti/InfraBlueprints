Configuration HyperVSwitchEmbeddedTeam
{
    [CmdletBinding()]
    param (
        [Parameter(Mandatory)]
        [String] $SwitchName,

        [Parameter(Mandatory)]
        [String[]] $NetAdapterName,

        [Parameter()]
        [ValidateSet('Dynamic','HyperVPort')]
        [String] $LoadbalancingAlgorithm = 'Dynamic',

        [Parameter()]
        [String] $TeamingMode = 'SwitchIndependent',

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
        [int] $ManagementMinimumBandwidthWeight=30,

        [Parameter()]
        [ValidateRange(0,100)]
        [int] $ClusterMinimumBandwidthWeight=30,

        [Parameter()]
        [ValidateRange(0,100)]        
        [int] $LiveMigrationMinimumBandwidthWeight=40,

        [Parameter(Mandatory)]
        [String] $ManagementIPAddress,

        [Parameter(Mandatory)]
        [Int] $ManagementSubnet,

        [Parameter(Mandatory)]
        [String] $ManagementGateway,

        [Parameter(Mandatory)]
        [String] $ManagementDns,

        [Parameter(Mandatory)]
        [String] $ClusterIPAddress,

        [Parameter(Mandatory)]
        [Int] $ClusterSubnet,

        [Parameter(Mandatory)]
        [String] $LiveMigrationIPAddress,

        [Parameter(Mandatory)]
        [Int] $LiveMigrationSubnet
    )

    Import-DscResource -Name cVMSwitch, cVMNetworkAdapter, cVMNetworkAdapterVlan, cVMNetworkAdapterSettings -ModuleName cHyper-V -ModuleVersion 3.0.0.0
    Import-DscResource -Name xIPAddress, xDNSServerAddress, xDefaultGatewayAddress -ModuleName xNetworking -ModuleVersion 2.12.0.0

    cVMSwitch $SwitchName
    {
        Name = $SwitchName
        Type = 'External'
        NetAdapterName = $NetAdapterName
        TeamingMode = $TeamingMode
        LoadBalancingAlgorithm = $LoadbalancingAlgorithm
        MinimumBandwidthMode = 'Weight'
        Ensure = 'Present'
    }

    cVMNetworkAdapterVlan ManagementAdapterVlan
    {
        Id = "${SwitchName}-Management"
        Name = $SwitchName
        AdapterMode = 'Access'
        VlanId = $ManagementVlanId
        VMName = 'ManagementOS'
        DependsOn = "[cVMSwitch]$SwitchName"
    }

    cVMNetworkAdapterSettings ManagementAdapterSettings
    {
        Id = "${SwitchName}-Management"
        Name = $SwitchName
        SwitchName = $SwitchName
        VMName = 'ManagementOS'
        MinimumBandwidthWeight = $ManagementMinimumBandwidthWeight
        DependsOn = "[cVMSwitch]$SwitchName"
    }

    xIPAddress ManagementAdapterIPAddress
    {
        InterfaceAlias = "vEthernet ($SwitchName)"
        IPAddress = $ManagementIPAddress
        SubnetMask = $ManagementSubnet
        AddressFamily = 'IPv4'
        DependsOn = '[cVMNetworkAdapterVlan]ManagementAdapterVlan'
    }

    xDefaultGatewayAddress ManagementAdapterGateway
    {
        InterfaceAlias = "vEthernet ($SwitchName)"
        AddressFamily = 'IPv4'
        Address = $ManagementGateway
        DependsOn = '[xIPAddress]ManagementAdapterIPAddress'
    }

    xDNSServerAddress ManagementDns
    {
        InterfaceAlias = "vEthernet ($SwitchName)"
        AddressFamily = 'IPv4'
        Address = $ManagementDns
        DependsOn = '[xDefaultGatewayAddress]ManagementAdapterGateway'
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
        SubnetMask = $ClusterSubnet
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
        SubnetMask = $LiveMigrationSubnet
        AddressFamily = 'IPv4'
        DependsOn = '[cVMNetworkAdapterVlan]LiveMigrationAdapterVlan'
    }
}