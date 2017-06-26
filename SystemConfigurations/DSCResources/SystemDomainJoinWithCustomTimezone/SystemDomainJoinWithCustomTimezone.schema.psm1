Configuration SystemDomainJoinWithCustomTimezone
{
    [CmdletBinding()]
    param (
        [Parameter(Mandatory)]
        [String] $ComputerName,

        [Parameter(Mandatory)]
        [String] $DomainName,

        [Parameter(Mandatory)]
        [pscredential] $DomainJoinCredential,

        [Parameter(Mandatory)]
        [String] $Timezone
    )

    Import-DscResource -ModuleName xComputerManagement
    Import-DscResource -ModuleName xSystemSecurity
    Import-DscResource -ModuleName xTimeZone
    Import-DscResource -ModuleName xRemoteDesktopAdmin
    Import-DscResource -ModuleName PSDesiredStateConfiguration

    xComputer DomainJoin
    {
        Name = $ComputerName
        DomainName = $DomainName
        Credential = $DomainJoinCredential
    }

    xIEEsc AdminIESecurity
    {
        UserRole = 'Administrators'
        IsEnabled = $false
    }

    xIEEsc UserIESecurity
    {
        UserRole = 'Users'
        IsEnabled = $false
    }

    xRemoteDesktopAdmin EnableRDP
    {
        UserAuthentication = 'Secure'
        Ensure = 'Present'
    }

    xTimeZone CustomTz
    {
        IsSingleInstance = 'Yes'
        TimeZone = $Timezone
    }
}
