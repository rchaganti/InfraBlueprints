@{
    AllNodes = @(
        @{
            NodeName = "*"
            SwitchName = "S2DSwitch"
            NetAdapterName = @('SLOT 3','SLOT 3 2')
            ManagementAdapterName = 'Management'
            SMB1AdapterName = 'Storage1'
            SMB2AdapterName = 'Storage2'
            TeamingMode = 'SwitchIndependent'
            LoadbalancingAlgorithm = 'Dynamic'
            ManagementVlanId = 102
            SMB1VlanId = 103
            SMB2VlanId = 104
            ManagementPrefixLength = 24             
            SMB1PrefixLength = 24
            SMB2PrefixLength = 24                      
        },
        @{
            NodeName = 'localhost'
            ManagementIPAddress = '172.16.102.51'
            ManagementGateway = '172.16.102.1'
            ManagementDns = '172.16.102.202'
            SMB1IPAddress = '172.16.103.51'
            SMB2IPAddress = '172.16.104.51'
        }   
    )
}