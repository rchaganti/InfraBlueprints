Configuration SETTeam
{
    Import-DscResource -ModuleName InfraBlueprints
    HyperVSwitchEmbeddedTeam CloudSwitch
    {
        SwitchName = 'CloudSwitch'
        NetAdapterName = 'SLOT 3','SLOT 3 2'
        ManagementVlanId = 101
        ManagementIPAddress = '172.16.101.201'
        ManagementSubnet = 24
        ManagementGateway = '172.16.101.1'
        ManagementDns = '172.16.101.2'
        LiveMigrationVlanId = 102
        LiveMigrationIPAddress = '172.16.102.201'
        LiveMigrationSubnet = 24
        ClusterVlanId = 103
        ClusterIPAddress = '172.16.103.201'
        ClusterSubnet = 24
    }
}