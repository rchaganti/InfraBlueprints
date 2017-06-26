@{
    AllNodes = @(
        @{
            NodeName = '*'
            TeamName = 'ConvergedTeam'
            SwitchName = 'ConvergedSwitch'
            TeamMembers = @('SLOT 3','SLOT 3 2')
            ManagementAdapterName = 'Management'
            ClusterAdapterName = 'Cluster'
            LiveMigrationAdapterName = 'LiveMigration'
            ManagementVlanId = 102
            ClusterVlanId = 103
            LiveMigrationVlanId = 104
            ManagementMinimumBandwidthWeight = 30
            ClusterMinimumBandwidthWeight = 30
            LiveMigrationMinimumBandwidthWeight = 40 
            ManagementPrefixLength = 24             
            ClusterPrefixLength = 24
            LiveMigrationPrefixLength = 24                      
        },
        @{
            NodeName = 'localhost'
            ManagementIPAddress = '172.16.102.51'
            ManagementGateway = '172.16.102.1'
            ManagementDns = '172.16.102.202'
            ClusterIPAddress = '172.16.103.51'
            LiveMigrationIPAddress = '172.16.104.51'
        }   
    )
}
