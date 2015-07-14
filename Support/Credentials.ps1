﻿function Get-CredentialFromStore {
    <#
    .SYNOPSIS
    XXX

    .DESCRIPTION
    XXX

    .PARAMETER CredentialName
    XXX

    .PARAMETER CredentialStore
    XXX

    .EXAMPLE
    XXX
    #>
    [CmdletBinding()]
    [OutputType([pscredential])]
    param(
        [Parameter(Mandatory)]
        [ValidateNotNullOrEmpty()]
        [string]
        $CredentialName
        ,
        [Parameter(Mandatory)]
        [ValidateNotNullOrEmpty()]
        [string]
        $CredentialStore
    )

    $Path = Join-Path -Path $CredentialStore -ChildPath ($CredentialName + '.clixml')
    Import-Clixml -Path $Path
}

function New-CredentialInStore {
    <#
    .SYNOPSIS
    XXX

    .DESCRIPTION
    XXX

    .PARAMETER CredentialName
    XXX

    .PARAMETER Credential
    XXX

    .PARAMETER CredentialStore
    XXX

    .EXAMPLE
    XXX
    #>
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)]
        [ValidateNotNullOrEmpty()]
        [string]
        $CredentialName
        ,
        [Parameter(Mandatory)]
        [ValidateNotNullOrEmpty()]
        [pscredential]
        $Credential
        ,
        [Parameter(Mandatory)]
        [ValidateNotNullOrEmpty()]
        [string]
        $CredentialStore
    )

    $Path = Join-Path -Path $CredentialStore -ChildPath ($CredentialName + '.clixml')
    $Credential | Export-Clixml -Path $Path
}