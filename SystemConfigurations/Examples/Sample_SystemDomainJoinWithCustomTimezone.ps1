Configuration SystemDomainJoin
{
    param (
        [pscredential] $DomainJoinCredential
    )

    Import-DscResource -Name SystemDomainJoinWithCustomTimezone -ModuleName SystemConfigurations
    Import-DscResource -ModuleName PSDesiredStateConfiguration

    Node $AllNodes.NodeName
    {
        SystemDomainJoinWithCustomTimezone SystemDomainJoin
        {
            ComputerName = $Node.ComputerName
            DomainName = $Node.DomainName
            DomainJoinCredential = $DomainJoinCredential
            Timezone = $Node.Timezone
        }
    }
}

$secpasswd = ConvertTo-SecureString 'Dell1234' -AsPlainText -Force
$domainJoinCredential = New-Object System.Management.Automation.PSCredential ('s2dlab\administrator', $secpasswd)

SystemDomainJoin -DomainJoinCredential $domainJoinCredential -ConfigurationData .\Sample_SystemDomainJoinWithCustomTimezone.NodeData.psd1
