Configuration HyperVSetConverged
{
    Import-DscResource -Name HyperVSwitchEmbeddedTeam -ModuleName Hyper-VConfigurations
    Import-DscResource -ModuleName PSDesiredStateConfiguration

    Node $AllNodes.NodeName
    {
        HyperVSwitchEmbeddedTeam HyperVSetConverged
        {
            SwitchName = $Node.SwitchName
            NetAdapterName = $Node.NetAdapterName
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

HyperVSetConverged -ConfigurationData .\Sample_HyperVSwitchEmbeddedTeam.NodeData.psd1
