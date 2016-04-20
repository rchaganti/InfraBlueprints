@{
    AllNodes = @(
        @{
            NodeName='localhost'
            HostName = 'HV-Host-3'
            ManagementIPAddress = '10.5.0.73'
            ClusterIPAddress = '10.7.0.73'
            LiveMigrationIPAddress = '10.8.0.73'
        },
        @{
            NodeName = '*'
            PsDscAllowPlainTextPassword=$true
            PSDscAllowDomainUser=$true
            DomainName = 'CloudInfra.lab'
            ClusterAdapterName = 'Cluster'
            LiveMigrationAdapterName = 'LiveMigration'
            SETName='SetSwitch'
            SETNetAdapters = 'NIC1','NIC2'
            ManagementSubnetMask = 24
            ClusterSubnetMask = 24
            LiveMigrationSubnetMask = 24
            ManagementGateway = '10.5.0.21'
            ManagementDnsServer = '10.5.0.5'
            ManagementVlanID = 51
            ClusterAdapterVlanID = 52
            LiveMigrationAdapterVlanID = 53
        }   
    )
}