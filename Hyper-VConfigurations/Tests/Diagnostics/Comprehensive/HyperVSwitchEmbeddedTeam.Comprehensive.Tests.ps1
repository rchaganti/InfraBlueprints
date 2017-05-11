Function Set-VMNetworkConfiguration {
    [CmdletBinding()]
    Param (
        [Parameter(Mandatory=$true,
                   Position=1,
                   ParameterSetName='DHCP',
                   ValueFromPipeline=$true)]
        [Parameter(Mandatory=$true,
                   Position=0,
                   ParameterSetName='Static',
                   ValueFromPipeline=$true)]
        $NetworkAdapter,

        [Parameter(Mandatory=$true,
                   Position=1,
                   ParameterSetName='Static')]
        [String[]]$IPAddress=@(),

        [Parameter(Mandatory=$false,
                   Position=2,
                   ParameterSetName='Static')]
        [String[]]$Subnet=@(),

        [Parameter(Mandatory=$false,
                   Position=3,
                   ParameterSetName='Static')]
        [String[]]$DefaultGateway = @(),

        [Parameter(Mandatory=$false,
                   Position=4,
                   ParameterSetName='Static')]
        [String[]]$DNSServer = @(),

        [Parameter(Mandatory=$false,
                   Position=0,
                   ParameterSetName='DHCP')]
        [Switch]$Dhcp
    )

    $VM = Get-WmiObject -Namespace 'root\virtualization\v2' -Class 'Msvm_ComputerSystem' | Where-Object { $_.ElementName -eq $NetworkAdapter.VMName } 
    $VMSettings = $vm.GetRelated('Msvm_VirtualSystemSettingData') | Where-Object { $_.VirtualSystemType -eq 'Microsoft:Hyper-V:System:Realized' }    
    $VMNetAdapters = $VMSettings.GetRelated('Msvm_SyntheticEthernetPortSettingData') 

    $NetworkSettings = @()
    foreach ($NetAdapter in $VMNetAdapters) {
        if ($NetAdapter.Address -eq $NetworkAdapter.MacAddress) {
            $NetworkSettings = $NetworkSettings + $NetAdapter.GetRelated("Msvm_GuestNetworkAdapterConfiguration")
        }
    }

    $NetworkSettings[0].IPAddresses = $IPAddress
    $NetworkSettings[0].Subnets = $Subnet
    $NetworkSettings[0].DefaultGateways = $DefaultGateway
    $NetworkSettings[0].DNSServers = $DNSServer
    $NetworkSettings[0].ProtocolIFType = 4096

    if ($dhcp) {
        $NetworkSettings[0].DHCPEnabled = $true
    } else {
        $NetworkSettings[0].DHCPEnabled = $false
    }

    $Service = Get-WmiObject -Class "Msvm_VirtualSystemManagementService" -Namespace "root\virtualization\v2"
    $setIP = $Service.SetGuestNetworkAdapterConfiguration($VM, $NetworkSettings[0].GetText(1))

    if ($setip.ReturnValue -eq 4096) {
        $job=[WMI]$setip.job 

        while ($job.JobState -eq 3 -or $job.JobState -eq 4) {
            start-sleep 1
            $job=[WMI]$setip.job
        }

        if ($job.JobState -eq 7) {
            Write-Output "Success"
        }
        else {
            throw $job.GetError()
        }
    } elseif($setip.ReturnValue -eq 0) {
        Write-Output "Success"
    }
}

function Get-ConfigurationDataAsObject
{
    [CmdletBinding()]
    Param (
        [Parameter(Mandatory)]
        [Microsoft.PowerShell.DesiredStateConfiguration.ArgumentToConfigurationDataTransformation()]
        [hashtable] $ConfigurationData    
    )
    return $ConfigurationData
}

$ConfigurationData = Get-ConfigurationDataAsObject -ConfigurationDat C:\ConvergedSwitch\NodeData.psd1

Describe "Simple Operations tests for Hyper-V Deployment and network Configuration" {
    BeforeAll {
        $ConfigurationData.Add('TemplateVHDPath','C:\VHD\Template.vhdx')
        $ConfigurationData.Add('VMName','TestVM')
        $ConfigurationData.Add('VMIPAddress','10.5.0.24')
        $ConfigurationData.Add('VMSubnetMask','255.255.255.0')
    }
    
    Context 'Hyper-V module related tests' {
        It 'Hyper-V Module is available' {
            Get-Module -Name Hyper-V -ListAvailable | should not BeNullOrEmpty
        }

        It 'Hyper-V Module can be loaded' {
            Import-Module -Name Hyper-V -Global -PassThru -Force | should not BeNullOrEmpty
        }
    }

    Context "Host connectctivity checks" {
        It "Verify if management gateway can be reached" {
            Test-Connection -ComputerName $ConfigurationData.AllNodes.ManagementGateway -Count 2 -Quiet | Should be $true
        }

        It "Resolve the hostname using the name server" {
            (Resolve-DnsName -Name $ConfigurationData.AllNodes.Hostname -Type A -Server $ConfigurationData.AllNodes.ManagementDnsServer).IPAddress | Should not BeNullOrEmpty
        }
    }

    Context 'VM creation test' {
        It 'VM can be created' {
            New-VM -Name $ConfigurationData.VMName -SwitchName $ConfigurationData.AllNodes.SetName -VHDPath $ConfigurationData.TemplateVHDPath -Generation 2 | should not BeNullOrEmpty
        }

        It 'New VM can be started' {
            $VM = Start-VM -VMName $ConfigurationData.VMName -Passthru | should not BeNullOrEmpty
            While ($VM.VMIntegrationService.Where({$_.Name -eq 'Heartbeat'}).PrimaryStatusDescription -ne 'OK') {
                $VM = Get-VM -VMName $ConfigurationData.VMName
                Start-Sleep -Seconds 5
            }
        }

        It 'VLAN ID can be configured for the VM' {
            $VMNetAdapter = Get-VMNetworkAdapter -VMName $ConfigurationData.VMName
            Set-VMNetworkAdapterVlan -VMNetworkAdapter $VMNetAdapter -Access -VlanId $ConfigurationData.AllNodes.ManagementVlanID -Passthru | Should not BeNullOrEmpty 
        }

        It 'IP Address can be injected' {
            $VMNetAdapter = Get-VMNetworkAdapter -VMName $ConfigurationData.VMName
            Set-VMNetworkConfiguration -NetworkAdapter $VMNetAdapter -IPAddress $ConfigurationData.VMIPAddress -Subnet $ConfigurationData.VMSubnetMask -DefaultGateway $ConfigurationData.AllNodes.ManagementGateway -DNSServer $ConfigurationData.AllNodes.ManagementDnsServer | Should be 'success'
        }
        
        It 'VM IP Address can be reached' {
            Test-Connection -ComputerName $ConfigurationData.VMIPAddress -Count 2 -Quiet | Should be $true
        }
    }

    AfterAll {
        remove-Module Hyper-V -Force
        #Stop-VM -VMName $ConfigurationData.VMName -Force -Passthru | Remove-VM -Force
    }
}