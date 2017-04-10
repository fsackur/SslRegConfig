function Enable-Ssl {
    <#
        .Synopsis
        Enables Schannel (SSL) protocols, ciphers and algorithms

        .Description
        Enables Schannel (SSL) protocols, ciphers and algorithms.
        
        Performs tests first (e.g. RDP and SQL support for TLS versions) to ensure that this can be done without breaking services. Will not proceed if tests fail. This behaviour can be overriden with the -SkipChecks switch.
        
        Returns a report of "before" and "after" settings.

        .Parameter Protocol
        A list of protocols, ciphers or key-exchange algorithms to enable

        .Parameter ProtocolsIncludingAndAbove
        Specify a protocol, cipher or algorithm to enable along with all items of the same type that are stronger (e.g. specifying 'TLS 1.0' will also enable TLS 1.1 and TLS 1.2)

        .Parameter SkipChecks
        Specifies not to perform safety checks (e.g. RDP and SQL support for TLS versions)

        .Parameter Restart
        Reboot the computer immediately after making the change. If you do not specify this switch, you should restart the computer at the next opportunity to avoid unexpected results.

        .Example
        PS C:\> Enable-Ssl -Protocol 'TLS1.2'

        Enables the TLS 1.2 protocol. A reboot is required to complete the change.

    #>
    [CmdletBinding()]
    [OutputType()]
    param(
        #[switch]$SkipChecks,
        #[switch]$Restart
    )

    dynamicparam {
        $DynamicParameters = New-Object System.Management.Automation.RuntimeDefinedParameterDictionary
        $DynamicParameters.Add('Protocol', (Get-SslDynamicParameter `
            -ParameterName 'Protocol' `
            -Property @{Mandatory=$true; Position=0} `
            -ValidValues ((Get-SslRegLookupTable).Keys | where {$_ -notmatch 'DbD'})
        ))
        return $DynamicParameters
    }

    begin {
        $Protocol = $PSBoundParameters.Protocol

        $OsVersion = [version](Get-WmiObject Win32_OperatingSystem).Version

        #OS < 2012 require the DisabledByDefault value to be set as well on Protocols
        $RegLookup = Get-SslRegLookupTable
        $LookupProtocols = $RegLookup.Keys | where {$RegLookup.$_.Category -eq 'Protocols' -and $_ -notmatch 'DbD'}
        if ($true -or $OsVersion -lt [version]"6.2") {
            foreach ($P in $LookupProtocols) {
                if ($Protocol -contains $P) {
                    $Protocol += "$P DbD"
                }
            }
        }


        if (-not $SkipChecks) {
            Write-Verbose 'Checking SQL components'
            $SqlCheck = Get-SqlTls12Report
            if (-not $SqlCheck.SupportsTls12) {
                $Failing = $SqlCheck | 
                    Get-Member *SupportsTls12 | 
                    select -ExpandProperty Name | 
                    where {$SqlCheck.$_ -ne $true}
                Write-Verbose "Failed SQL compatibility checks: $($Failing -join ', '). Run Get-SqlTls12Report for more detail."
            }
        }
    }

    end {
        return $Protocol
    }
}


function Disable-Ssl {
    <#
        .Synopsis
        Enables Schannel (SSL) protocols, ciphers and algorithms

        .Description
        Enables Schannel (SSL) protocols, ciphers and algorithms.
        
        Performs tests first (e.g. RDP and SQL support for TLS versions) to ensure that this can be done without breaking services. Will not proceed if tests fail. This behaviour can be overriden with the -SkipChecks switch.
        
        Returns a report of "before" and "after" settings.

        .Parameter Protocol
        A list of protocols, ciphers or key-exchange algorithms to disable

        .Parameter ProtocolsUpToAndIncluding
        Specify a protocol, cipher or algorithm to disable along with all items of the same type that are weaker (e.g. specifying 'TLS 1.1' will also disable TLS 1.0, SSL 3.0 etc)

        .Parameter SkipChecks
        Specifies not to perform safety checks (e.g. RDP and SQL support for TLS versions)

        .Parameter Restart
        Reboot the computer immediately after making the change. If you do not specify this switch, you should restart the computer at the next opportunity to avoid unexpected results.

    #>
    [CmdletBinding()]
    [OutputType()]
    param(
        [string[]]$Protocol,
        [string]$ProtocolsUpToAndIncluding,
        [switch]$SkipChecks,
        [switch]$Restart
    )


}


function Get-Ssl {
    <#
        .Synopsis
        Returns status of Schannel (SSL) protocols, ciphers and algorithms

        .Description
        Returns status of Schannel (SSL) protocols, ciphers and algorithms.
        
    #>
    [CmdletBinding()]
    [OutputType()]
    param(

    )


}


function Test {
    return SslRegConfig\Get-SslRegLookupTable


}