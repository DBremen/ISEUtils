function Expand-Alias{
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
                    $code = $code.Remove( $_.Start, $_.Content.Length).Insert( $_.Start, $definition)
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
