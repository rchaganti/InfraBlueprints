Configuration HyperVSwitchNativeTeam {
    [CmdletBinding()]
    param (
        [Parameter()]
        [String] $TeamName = 'ConvergedTeam',

        [Parameter(Mandatory)]
        [String[]] $TeamMembers,

        [Parameter()]
        [ValidateSet("Dynamic", "HyperVPort", "IPAddresses", "MacAddresses", "TransportPorts")]
        [String] $LoadbalancingAlgorithm = 'Dynamic',

        [Parameter()]
        [ValidateSet("SwitchIndependent", "LACP", "Static")]
        [String] $TeamingMode = 'SwitchIndependent',

        [Parameter()]
        [String] $SwitchName = 'ConvergedSwitch',

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

    Import-DscResource -ModuleName cHyper-V -Name cVMSwitch, cVMNetworkAdapterVlan, cVMNetworkAdapter, cVMNetworkAdapterSettings -ModuleVersion 3.0.0.0
    Import-DscResource -ModuleName xNetworking -Name xNetworkTeam, xIPAddress, xDefaultGatewayAddress, xDNSServerAddress -ModuleVersion 3.2.0.0
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
    }
    
    xNetworkTeam $TeamName {
        Name = $TeamName
        TeamMembers = $TeamMembers
        LoadBalancingAlgorithm = $LoadbalancingAlgorithm
        TeamingMode = $TeamingMode
        Ensure = 'Present'
    }

    cVMSwitch $SwitchName
    {
        Name = $SwitchName
        NetAdapterName = $TeamName
        Type = 'External'
        AllowManagementOS = $false
        Ensure = 'Present'
        MinimumBandwidthMode = 'Weight'
        DependsOn = '[WindowsFeature]HyperV',"[xNetworkTeam]$TeamName"
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