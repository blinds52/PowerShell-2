﻿$here = Split-Path -Parent $MyInvocation.MyCommand.Path
$sut = (Split-Path -Leaf $MyInvocation.MyCommand.Path).Replace('.Tests.', '.')
#. "$here\$sut"

#Import-Module "$PSScriptRoot\..\Support"
. "$PSScriptRoot\..\Support\$sut"

Describe 'Secure String' {
    Context 'Get-PlaintextFromSecureString' {
        It 'Shows plaintext from piped SecureString' {
            ConvertTo-SecureString -String 'test' -AsPlainText -Force | Get-PlaintextFromSecureString | Should Be 'test'
        }
        It 'Shows plaintext from SecureString parameter' {
            $input = ConvertTo-SecureString -String 'test' -AsPlainText -Force
            Get-PlaintextFromSecureString -SecureString $input | Should Be 'test'
        }
    }
    Context 'EncryptedString' {
        It 'Works for both piped' {
            $input = ConvertTo-SecureString -String 'test' -AsPlainText -Force
            $input | ConvertTo-EncryptedString -Key '0123456789abcedf' | ConvertFrom-EncryptedString -Key '0123456789abcedf' | Get-PlaintextFromSecureString | Should Be (Get-PlaintextFromSecureString -SecureString $input)
        }
        It 'Works for parameter and pipe (in that order)' {
            $input = ConvertTo-SecureString -String 'test' -AsPlainText -Force
            ConvertTo-EncryptedString -SecureString $input -Key '0123456789abcedf' | ConvertFrom-EncryptedString -Key '0123456789abcedf' | Get-PlaintextFromSecureString | Should Be (Get-PlaintextFromSecureString -SecureString $input)
        }
        It 'Works for pipe and parameter (in that order)' {
            $input = ConvertTo-SecureString -String 'test' -AsPlainText -Force
            $encrypted = $input | ConvertTo-EncryptedString -Key '0123456789abcedf'
            ConvertFrom-EncryptedString -EncryptedString $encrypted -Key '0123456789abcedf' | Get-PlaintextFromSecureString | Should Be (Get-PlaintextFromSecureString -SecureString $input)
        }
    }
}