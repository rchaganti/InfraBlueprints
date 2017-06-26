@{
    AllNodes = @(
        @{
            NodeName = 'Localhost'
            ComputerName = 'S2DNode01'
            DomainName = 'S2DLab.local'
            TimeZone = 'India Standard Time'
        },
        @{
            NodeName = '*'
            PSDscAllowPlainTextPassword = $true
        }   
    )
}
