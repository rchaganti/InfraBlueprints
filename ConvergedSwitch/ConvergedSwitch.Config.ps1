Configuration ConvergedSwitch {
    param (
        [pscredential] $DomainCredential
    )
    Import-DscResource –ModuleName 'PSDesiredStateConfiguration'
    Import-DscResource -ModuleName cHyper-V -Name cSwitchEmbeddedTeam, cVMNetworkAdapterVlan, cVMNetworkAdapter, cVMNetworkAdapterSettings
    Import-DscResource -ModuleName xNetworking
    Import-DscResource -ModuleName xComputerManagement

    Node $AllNodes.NodeName {  
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
    
        cSwitchEmbeddedTeam SET {
            Name = $Node.SETName
            NetAdapterName = $Node.SETNetAdapters
            AllowManagementOS = $true
            BandwidthReservationMode = 'Weight'
            Ensure = 'Present'
            DependsOn = '[WindowsFeature]HyperV'
        }

        cVMNetworkAdapterVlan SETVLAN {
            Id = ([guid]::NewGuid()).guid
            Name = $Node.SETName
            VMName = 'Management OS'
            AdapterMode = 'Access'
            VlanId = $Node.ManagementVlanID
            DependsOn = "[cSwitchEmbeddedTeam]SET"
        }

        cVMNetworkAdapterSettings SETSettings {
            Id = ([guid]::NewGuid()).guid
            Name = $Node.SETName
            SwitchName = $Node.SETName
            VMName = 'Management OS'
            MinimumBandwidthWeight = 30
        }

        xIPAddress SETIPAddress {
            InterfaceAlias = "vEthernet ($($Node.SETName))"
            IPAddress = $Node.ManagementIPAddress
            SubnetMask = $Node.ManagementSubnetMask
            AddressFamily = 'IPV4'
            DependsOn = '[cVMNetworkAdapterVlan]SETVLAN'
        }

        xDefaultGatewayAddress SETGateway {
            InterfaceAlias = "vEthernet ($($Node.SETName))"
            AddressFamily = 'IPV4'
            Address = $Node.ManagementGateway
            DependsOn = '[xIPAddress]SETIPAddress'
        }

        xDNSServerAddress SETDns {
            InterfaceAlias = "vEthernet ($($Node.SETName))"
            AddressFamily = 'IPv4'
            Address =  $Node.ManagementDnsServer
            DependsOn = '[xIPAddress]SETIPAddress'
        }

        cVMNetworkAdapter SETCluster {
            Id = ([GUID]::NewGuid()).Guid
            Name = $Node.ClusterAdapterName
            SwitchName = $Node.SETName
            VMName = 'Management OS'
            Ensure = 'Present'
            DependsOn = '[cSwitchEmbeddedTeam]SET'
        }

        cVMNetworkAdapterVlan SETClusterVlan {
            Id = ([guid]::NewGuid()).guid
            Name = $Node.ClusterAdapterName
            AdapterMode = 'Access'
            VMName = 'Management OS'
            VlanId = $Node.ClusterAdapterVlanID
            DependsOn = '[cVMNetworkAdapter]SETCluster'
        }

        xIPAddress SETClusterIPAddress {
            InterfaceAlias = "vEthernet ($($Node.ClusterAdapterName))"
            IPAddress = $Node.ClusterIPAddress
            SubnetMask = $Node.ClusterSubnetMask
            AddressFamily = 'IPV4'
            DependsOn = '[cVMNetworkAdapterVlan]SETClusterVlan'
        }

        cVMNetworkAdapter SETLM {
            Id = ([GUID]::NewGuid()).Guid
            Name = $Node.LiveMigrationAdapterName
            SwitchName = $Node.SETName
            VMName = 'Management OS'
            Ensure = 'Present'
            DependsOn = '[cSwitchEmbeddedTeam]SET'
        }

        cVMNetworkAdapterVlan SETLMVlan {
            Id = ([guid]::NewGuid()).guid
            Name = $Node.LiveMigrationAdapterName
            AdapterMode = 'Access'
            VMName = 'Management OS'
            VlanId = $Node.LiveMigrationAdapterVlanID
            DependsOn = '[cVMNetworkAdapter]SETLM'
        }

        xIPAddress SETLMIPAddress {
            InterfaceAlias = "vEthernet ($($Node.LiveMigrationAdapterName))"
            IPAddress = $Node.LiveMigrationIPAddress
            SubnetMask = $Node.LiveMigrationSubnetMask
            AddressFamily = 'IPV4'
            DependsOn = '[cVMNetworkAdapterVlan]SETLMVlan'
        }

        xComputer DomainJoin {
            Name = $Node.HostName
            DomainName = $Node.DomainName
            Credential = $DomainCredential
            DependsOn = '[xIPAddress]SETIPAddress'
        }
    }
}

$Pasword = ConvertTo-SecureString 'Dell1234' -AsPlainText -Force
$DomainCredential = New-Object System.Management.Automation.PSCredential ('CloudInfra\Administrator',$Pasword)
ConvergedSwitch -ConfigurationData .\en-US\nodedata.psd1 -DomainCredential $DomainCredential