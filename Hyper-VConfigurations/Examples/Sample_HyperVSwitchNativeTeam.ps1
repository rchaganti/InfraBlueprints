Configuration HyperVConverged
{
    Import-DscResource -Name HyperVSwitchNativeTeam -ModuleName Hyper-VConfigurations
    Import-DscResource -ModuleName PSDesiredStateConfiguration

    Node $AllNodes.NodeName
    {
        HyperVSwitchNativeTeam HyperVConverged
        {
            TeamName = $Node.TeamName
            TeamMembers = $Node.TeamMembers
            ManagementVlanId = $Node.ManagementVlanId
            LiveMigrationVlanId = $Node.LiveMigrationVlanId
            ClusterVlanId = $Node.ClusterVlanId
            ManagementIPAddress = $Node.ManagementIPAddress
            ManagementPrefixLength = $Node.ManagementPrefixLength
            ManagementGateway = $Node.ManagementGateway
            ManagementDns = $Node.ManagementDns
            ManagementMinimumBandwidthWeight = $Node.ManagementMinimumBandwidthWeight
            ClusterIPAddress = $Node.ClusterIPAddress
            ClusterMinimumBandwidthWeight = $Node.ClusterMinimumBandwidthWeight
            ClusterPrefixLength = $Node.ClusterPrefixLength
            LiveMigrationIPAddress = $Node.LiveMigrationIPAddress
            LiveMigrationPrefixLength = $Node.LiveMigrationPrefixLength
            LiveMigrationMinimumBandwidthWeight = $Node.LiveMigrationMinimumBandwidthWeight            
        }
    }
}