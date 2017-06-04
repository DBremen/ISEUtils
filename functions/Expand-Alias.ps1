function Expand-Alias{
<#
    .SYNOPSIS
        Function to expand aliases either in the currently active ISE file 
        or (in case a a path is provided) within any PowerShell file (that way the function can be also used from the PowerShell Console) to their respective definitions.
    .DESCRIPTION
        Aliases are very useful when working interactively, since they help saving extra keystrokes when you just want to get things done fast. 
        At the same time if we are speaking about production code where readability,
        and easy comprehension of the code are much more important the usage of aliases should be avoided.
        With the Expand-Alias function you can get the best of both worlds. Writing clearer code while avoiding extraneous keystrokes.
    .PARAMETER Code
        First parameter set for the usage within the ISE. Defaults to $psISE.CurrentFile.Editor.Text    .PARAMETER Path
        Second parameter set for the expansion of aliases within PowerShell files. Specifies the path to the file within which the aliases are to be expanded.
    .EXAMPLE
        #Expand all alieases within the active ISE tab
        Expand-Alias
    .EXAMPLE
        #Expand all aliases within the file specified
        Expand-Alias -Path c:\scripts\ps1\test.ps1
    .LINK
        https://powershellone.wordpress.com/2015/10/07/expanding-aliases-in-powershell-ise-or-any-powershell-file/
#>
    [CmdletBinding(DefaultParameterSetName = 'Text')]
    param(
        [Parameter(Mandatory=$false, Position=0, ParameterSetName = 'Text')]
        $code = $psISE.CurrentFile.Editor.Text,
        [Parameter(Mandatory=$true, ParameterSetName = 'Path')]
        [ValidateScript({
            if (-not (Test-Path -PathType Leaf -LiteralPath $_ )) {
                throw "Path '$_' does not exist. Please provide the path to an existing File."
            }
            $true
        })]
        $path
    )
    $htAliases = Get-Alias | Group-Object -Property Name -AsHashTable -AsString
    $errors = $null
    if ($PSCmdlet.ParameterSetName -eq 'Path'){
        $code = Get-Content $path -Raw
    }
    [System.Management.Automation.PSParser]::Tokenize($code, [ref]$errors) |
        Where-Object { $_.Type -eq 'Command' } |
        Sort-Object { $_.Start } -Descending |
        ForEach-Object{
            $command = $_.Content
            if ($htAliases.ContainsKey($command)){
                $alias = $htAliases."$command" | Select-Object *
                $definition = $alias.ResolvedCommandName
                if ($PSCmdlet.ParameterSetName -eq 'Path'){
                    #replace the alias within the string
                    $code = $code.Remove($_.Start, $_.Content.Length).Insert( $_.Start, $definition)
                }
                else{
                    #replace the alias inside the ISE
                    $psISE.CurrentFile.Editor.Select($_.StartLine, $_.StartColumn, $_.EndLine, $_.EndColumn)
                    $psISE.CurrentFile.Editor.InsertText($definition)
                }
            }
        }
        if ($PSCmdlet.ParameterSetName -eq 'Path'){
            Set-Content $path -Value $code
        }
}
