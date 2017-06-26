Configuration HyperVSetS2D
{
    Import-DscResource -Name HyperVSwitchEmbeddedTeamForS2D -ModuleName Hyper-VConfigurations
    Import-DscResource -ModuleName PSDesiredStateConfiguration

    Node $AllNodes.NodeName
    {
        HyperVSwitchEmbeddedTeamForS2D HyperVSetS2D
        {
            SwitchName = $Node.SwitchName
            NetAdapterName = $Node.NetAdapterName
            ManagementAdapterName = $Node.ManagementAdapterName
            SMB1AdapterName = $Node.SMB1AdapterName
            SMB2AdapterName = $Node.SMB2AdapterName
            ManagementVlanId = $Node.ManagementVlanId
            SMB1VlanId = $Node.SMB1VlanId
            SMB2VlanId = $Node.SMB2VlanId
            ManagementIPAddress = $Node.ManagementIPAddress
            ManagementPrefixLength = $Node.ManagementPrefixLength
            ManagementGateway = $Node.ManagementGateway
            ManagementDns = $Node.ManagementDns
            SMB1IPAddress = $Node.SMB1IPAddress
            SMB1PrefixLength = $Node.SMB1PrefixLength
            SMB2IPAddress = $Node.SMB2IPAddress
            SMB2PrefixLength = $Node.SMB2PrefixLength            
        }
    }
}

HyperVSetS2D -ConfigurationData .\Sample_HyperVSwitchEmbeddedTeamForS2D.NodeData.psd1
