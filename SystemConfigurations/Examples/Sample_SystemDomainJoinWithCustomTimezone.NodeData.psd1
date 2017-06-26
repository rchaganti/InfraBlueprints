@{
    AllNodes = @(
        @{
            NodeName = 'Localhost'
            ComputerName = 'S2DNode01'
            DomainName = 'S2DLab.local'
            Timezone = 'India Standard Time'
        },
        @{
            NodeName = '*'
            PSDscAllowPlainTextPassword = $true
        }   
    )
}
