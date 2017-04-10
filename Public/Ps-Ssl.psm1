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
        [string[]]$Protocol,
        [string]$ProtocolsIncludingAndAbove,
        [switch]$SkipChecks,
        [switch]$Restart
    )


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
    return Get-SslRegLookupTable


}