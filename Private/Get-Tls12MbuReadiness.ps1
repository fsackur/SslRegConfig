﻿function Get-Tls12MbuReadiness
{
    <#
        .SYNOPSIS
        Audits readiness for disabling TLS 1.0 and below.

        .DESCRIPTION
        Audits readiness for disabling TLS 1.0 and below.

        If updates are required, they will be reported in the output.

        .OUTPUTS
        [psobject]

        .EXAMPLE
        Get-Tls12MbuReadiness

    #>
    [CmdletBinding()]
    [OutputType([psobject])]
    param ()

    begin
    {
        Write-Verbose "[$(Get-Date)] Begin :: $($MyInvocation.MyCommand)"
    }

    process
    {
        $CommvaultVersion = Get-CommvaultVersion

        $Output = New-Object PSObject -Property @{
            SupportsTls12    = $false
            RequiredUpdates  = @()
            CommvaultVersion = $CommvaultVersion
        }

        $Output.SupportsTls12 = (
            ($null -eq $CommVaultVersion) -or
            ($CommVaultVersion -ge [version]"10.0.116.19243")
        )

        if (-not $Output.SupportsTls12) {
            $Report.RequiredUpdates += "Request MBU team to push Commvault 10 SP14 or above"
        }

        return $Output
    }

    end
    {
        Write-Verbose "[$(Get-Date)] End   :: $($MyInvocation.MyCommand)"
    }
}
