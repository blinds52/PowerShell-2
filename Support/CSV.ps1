﻿function Import-Array {
    [CmdletBinding()]
    [OutputType([array])]
    param(
        [Parameter(Mandatory)]
        [ValidateNotNullOrEmpty()]
        [string[]]
        $File
    )

    Write-Verbose -Message ('[{0}] Sourcing from first existing input file' -f $MyInvocation.MyCommand)

    # check for input files in the following order
    foreach ($InputFile in $File) {
        Write-Verbose -Message ('[{0}] Checking for input file <{1}>' -f $MyInvocation.MyCommand, $InputFile)

        # check if file exists
        if (Test-Path -Path $InputFile) {
            # jump out of loop because file exists
            Write-Verbose -Message ('[{0}] Found file <{1}>. Skipping other candidates.' -f $MyInvocation.MyCommand, $InputFile)
            break
        }

        # expand path to input file
        $InputFile = Join-Path -Path $PSScriptRoot -ChildPath $InputFile
        Write-Verbose -Message ('[{0}] Full path to input file is <{1}>' -f $MyInvocation.MyCommand, $InputFile)

        # check if file exists
        if (Test-Path -Path $InputFile) {
            # jump out of loop because file exists
            Write-Verbose -Message ('[{0}] Found file <{1}>. Skipping other candidates.' -f $MyInvocation.MyCommand, $InputFile)
            break
        }
        Write-Verbose -Message ('[{0}] File <{1}> not found.' -f $MyInvocation.MyCommand, $InputFile)
    }

    # make sure an input file was found
    if ($InputFile -eq $null -Or -Not (Test-Path -Path $InputFile)) {
        throw ('[{0}] Unable to determine input file. Aborting.' -f $MyInvocation.MyCommand)
    }

    # read group memberships from file
    $Lines = @(Get-Content -Path $InputFile)
    Write-Verbose -Message ('[{0}] Read {1} lines from input file <{2}>.' -f $MyInvocation.MyCommand, $Lines.Count, $InputFile)

    return $Lines
}

function Import-Hash {
    [CmdletBinding()]
    [OutputType([System.Collections.Hashtable])]
    param(
        [Parameter(Mandatory)]
        [ValidateNotNullOrEmpty()]
        [string[]]
        $File
        ,
        [Parameter()]
        [ValidateNotNullOrEmpty()]
        [string]
        $Delimiter = ';'
        ,
        [Parameter()]
        [ValidateNotNullOrEmpty()]
        [string[]]
        $Header
    )

    Write-Verbose -Message ('[{0}] Sourcing hash from first existing input file' -f $MyInvocation.MyCommand)

    # check for input files in the following order
    foreach ($InputFile in $File) {
        Write-Verbose -Message ('[{0}] Checking for input file <{1}>' -f $MyInvocation.MyCommand, $InputFile)

        # check if file exists
        if (Test-Path -Path $InputFile) {
            # jump out of loop because file exists
            Write-Verbose -Message ('[{0}] Found file <{1}>. Skipping other candidates.' -f $MyInvocation.MyCommand, $InputFile)
            break
        }

        # expand path to input file
        $InputFile = Join-Path -Path $PSScriptRoot -ChildPath $InputFile
        Write-Verbose -Message ('[{0}] Full path to input file is <{1}>' -f $MyInvocation.MyCommand, $InputFile)

        # check if file exists
        if (Test-Path -Path $InputFile) {
            # jump out of loop because file exists
            Write-Verbose -Message ('[{0}] Found file <{1}>. Skipping other candidates.' -f $MyInvocation.MyCommand, $InputFile)
            break
        }
        Write-Verbose -Message ('[{0}] File <{1}> not found.' -f $MyInvocation.MyCommand, $InputFile)
    }

    # make sure an input file was found
    if ($InputFile -eq $null -Or -Not (Test-Path -Path $InputFile)) {
        throw ('[{0}] Unable to determine input file. Aborting.' -f $MyInvocation.MyCommand)
    }

    # read hash from file
    $params = @{
        Delimiter = $Delimiter
    }
    if ($Header) { $params.Add('Header',    $Header) }
    $Hash = Get-Content -Path $InputFile | ConvertFrom-Csv @params
    Write-Verbose -Message ('[{0}] Read {1} key/value pairs from file <{2}>.' -f $MyInvocation.MyCommand, $Hash.Count, $InputFile)

    $Hash
}