function Find-DefinitionInEditor {
    [CmdletBinding()]
    param(
        $File = $psISE.CurrentFile, 
        $Tab = $psISE.CurrentPowerShellTab
    )
    $found = $false
    $editor = $file.Editor
    $Column = $psISE.CurrentFile.Editor.CaretColumn
    $Line = $psISE.CurrentFile.Editor.CaretLine
    $name = ''
    $AST = [Management.Automation.Language.Parser]::ParseInput($psISE.CurrentFile.Editor.Text,[ref]$null,[ref]$null)
    $AST.Find(
            {
                param($ast)
                ($ast -is [System.Management.Automation.Language.CommandAst]) -and
                (($ast.Extent.StartLineNumber -lt $Line -and $ast.Extent.EndLineNumber -gt $line) -or
                ($ast.Extent.StartLineNumber -eq $Line -and $ast.Extent.StartColumnNumber -le $Column) -or
                ($ast.Extent.EndLineNumber -eq $Line -and $ast.Extent.EndColumnNumber -ge $Column))

            }, $true
    ) | Select-Object -ExpandProperty CommandElements | ForEach-Object {  
        $name = $_.Value  
        $AST = [Management.Automation.Language.Parser]::ParseInput($editor.Text,[ref]$null,[ref]$null)
        $definition = $AST.Find(
            {
                param($ast)
                ($ast -is [System.Management.Automation.Language.FunctionDefinitionAst]) -and
                ($ast.Name -eq $name)
            }, $true
        ) | Select-Object -Last 1 
        if ($definition){ 
            $psISE.PowerShellTabs.SelectedPowerShellTab = $tab
            $psISE.PowerShellTabs.SelectedPowerShellTab.Files.SelectedFile = $file
            $editor.SetCaretPosition($definition.Extent.StartLineNumber,$definition.Extent.StartColumnNumber)
            $found = $true
        }
    }
    return @($found, $name)
}

function Find-Definition{
 <#    
    .SYNOPSIS
        Jump to to the definition of the function that the cursor is currently placed at or inside. Searches through all open tabs within ISE.
    .DESCRIPTION
        Utilizes AST to find and go to the definition of the function that the cursor is currently placed within ISE.
    .EXAMPLE
        #Go to to the definition of the function that the cursor is currently placed at/inside
        Find-Definition
#>
    $result = Find-DefinitionInEditor
    if (-not $result[0]){
        #check in all other open tabs and files
        foreach ($tab in $psISE.PowerShellTabs){
            #skip the current file
            $files = $tab.Files | Where-Object { $_.FullPath -ne $psISE.CurrentFile.FullPath }
            foreach ($file in $files){
                $result = Find-DefinitionInEditor $file $tab
                if ($result[0]) {
                    return
                }
            }
        }
        #check if the function is loaded
        try{
            $fullPath = (Get-Command $result[1] -ErrorAction Stop).ScriptBlock.File
        }
        catch{
        } 
        if($fullPath){
            #open the file and set the caret position to the function header
            $file = $psISE.CurrentPowerShellTab.Files.Add("$fullPath")
            $null = Find-DefinitionInEditor $file
        }
        else{
            Write-Warning 'No Definition found'
        }
    }
}



