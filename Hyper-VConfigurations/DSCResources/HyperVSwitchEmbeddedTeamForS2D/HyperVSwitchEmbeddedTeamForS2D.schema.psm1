Configuration HyperVSwitchEmbeddedTeamForS2D
{
    [CmdletBinding()]
    param (
        [Parameter()]
        [String] $SwitchName = 'S2DSwitch',

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
        [String] $SMB1AdapterName = 'SMB1',

        [Parameter()]
        [String] $SMB2AdapterName = 'SMB2',

        [Parameter(Mandatory)]
        [ValidateRange(1,4096)]
        [Int] $ManagementVlanId,

        [Parameter(Mandatory)]
        [ValidateRange(1,4096)]
        [Int] $SMB1VlanId,

        [Parameter(Mandatory)]
        [ValidateRange(1,4096)]
        [Int] $SMB2VlanId,

        [Parameter(Mandatory)]
        [String] $ManagementIPAddress,

        [Parameter(Mandatory)]
        [Int] $ManagementPrefixLength,

        [Parameter(Mandatory)]
        [String] $ManagementGateway,

        [Parameter(Mandatory)]
        [String] $ManagementDns,
        
        [Parameter(Mandatory)]
        [String] $SMB1IPAddress,

        [Parameter(Mandatory)]
        [Int] $SMB1PrefixLength,

        [Parameter(Mandatory)]
        [String] $SMB2IPAddress,

        [Parameter(Mandatory)]
        [Int] $SMB2PrefixLength
    )

    Import-DscResource -Name cVMSwitch, cVMNetworkAdapter, cVMNetworkAdapterVlan -ModuleName cHyper-V -ModuleVersion 3.0.0.0
    Import-DscResource -Name xIPAddress, xDNSServerAddress, xDefaultGatewayAddress, xNetAdapterRDMA -ModuleName xNetworking -ModuleVersion 3.2.0.0
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
    
    cVMNetworkAdapterVlan ManagementAdapterVlan {
        Id = "${SwitchName}-Management"
        Name = $ManagementAdapterName
        VMName = 'ManagementOS'
        AdapterMode = 'Access'
        VlanId = $ManagementVlanID
        DependsOn = "[cVMSwitch]$SwitchName"
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

    cVMNetworkAdapter $SMB1AdapterName
    {
        Id = "${SwitchName}-SMB1"
        Name = $SMB1AdapterName
        SwitchName = $SwitchName
        VMName = 'ManagementOS'
        Ensure = 'Present'
        DependsOn = "[cVMSwitch]$SwitchName"
    }

    cVMNetworkAdapterVlan SMB1AdapterVlan
    {
        Id = "${SwitchName}-SMB1"
        Name = $SMB1AdapterName
        AdapterMode = 'Access'
        VMName = 'ManagementOS'
        VlanId = $SMB1VlanId
        DependsOn = "[cVMNetworkAdapter]$SMB1AdapterName"
    }

    xIPAddress SMB1IPAddress
    {
        InterfaceAlias = "vEthernet ($SMB1AdapterName)"
        IPAddress = $SMB1IPAddress
        PrefixLength = $SMB1PrefixLength
        AddressFamily = 'IPv4'
        DependsOn = '[cVMNetworkAdapterVlan]SMB1AdapterVlan'
    }

    xNetAdapterRDMA SMB1RDMA
    {
        Name = "vEthernet ($SMB1AdapterName)"
        Enabled = $true
    }

    cVMNetworkAdapter $SMB2AdapterName
    {
        Id = "${SwitchName}-SMB2"
        Name = $SMB2AdapterName
        SwitchName = $SwitchName
        VMName = 'ManagementOS'
        Ensure = 'Present'
        DependsOn = "[cVMSwitch]$SwitchName"
    }

    cVMNetworkAdapterVlan SMB2AdapterVlan
    {
        Id = "${SwitchName}-SMB2"
        Name = $SMB2AdapterName
        AdapterMode = 'Access'
        VMName = 'ManagementOS'
        VlanId = $SMB2VlanId
        DependsOn = "[cVMNetworkAdapter]$SMB2AdapterName"
    }

    xIPAddress SMB2IPAddress
    {
        InterfaceAlias = "vEthernet ($SMB2AdapterName)"
        IPAddress = $SMB2IPAddress
        PrefixLength = $SMB2PrefixLength
        AddressFamily = 'IPv4'
        DependsOn = '[cVMNetworkAdapterVlan]SMB2AdapterVlan'
    }

    xNetAdapterRDMA SMB2RDMA
    {
        Name = "vEthernet ($SMB2AdapterName)"
        Enabled = $true
    }
}