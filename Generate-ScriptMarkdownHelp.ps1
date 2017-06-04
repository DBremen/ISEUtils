function Generate-ScriptMarkdownHelp{
    <#    
    .SYNOPSIS
        The function that generated the Markdown help in this repository.
        Generates markdown help for each function containing comment based help in the module (Description not empty) within a folder recursively and a summary table for the main README.md
    .DESCRIPTION
        platyPS is used to generate the function level help + the README.md is generated "manually".
	.PARAMETER Path
		Path to the module to create the documentation for
    .PARAMETER RepoUrl
        Url for the Git repository homepage
	.EXAMPLE
       Generate-ScriptMarkdownHelp -Path C:\Scripts\ps1\SyncToy\SyncToy.psm1 -RepoUrl https://github.com/DBremen/SyncToy
#>
    [CmdletBinding()]
    Param($Path,$RepoUrl)
    $summaryTable = @'
# ISEUtils
Collection of some useful additions for the built-in PowerShell ISE
Some functions (New-ISESnippet, New-ISEMenu...) are PowerShell only (no C# coding in Visual Studio required) integrated (making use of the VerticalAddOnToolbar Add-Ons)
(read [here](https://powershellone.wordpress.com/2015/09/28/create-an-integrated-wpf-based-ise-add-on-with-powershell/) for more info ). 

The module adds automatic saving of opened files and prompt for re-opening previously saved session upon start of ISE (based on the ISESessionTools module from Oisin Grehan)

List of functions of the exported functions and menu items (Add_ons/ISEUtils):

| Function/Menu | Synopsis | Documentation |
| --- | --- | --- |
'@
    Import-Module platyps
    $htCheck = @{}
    #if run from ISE while the module is loaded, comment out line below.
    #Import-Module $Path
    $Module = [IO.Path]::GetFileNameWithoutExtension($Path)
    $functions = Get-Command -Module $Module
    foreach ($function in $functions){
        try{
            $help =Get-Help $function.Name | Where-Object {$_.Name -eq $function.Name} -ErrorAction Stop
        }catch{
            continue
        }
        if ($help.description -ne $null){
            $htCheck[$function.Name] += 1
            $link = $help.relatedLinks 
            if ($link){
                $link = $link.navigationLink.uri | Where-Object {$_ -like '*powershellone*'}
            }
            $mdFile = $function.Name + '.md'
            $summaryTable += "`n| $($function.Name) | $($help.Synopsis.replace("`n",'')) | $("[Link]($($repoUrl)/blob/master/docs/$mdFile)") |"
        }
    }
    $docFolder = "$(Split-Path (Get-Module $Module)[0].Path)\docs"
    $summaryTable += @'
| Get-File | F# based PowerShell cmdlet wrapper around Directory.GetFiles ignoring PathTooLong and AccessDenied exceptions ||
| Menu "Expand ZenCode" | Enables zen Coding within PowerShell ISE, zen Code expressions are expanded by using the AddOn menu or assigned keyboard shortcut ||
| Menu "Run Line" | Execute line that contains current cursor position ||
| Menu "Split selection by last char"  | Splits the selection by the last character within the selection ||
| Menu "New-ISEMenu" | Integrated GUI to create new entries for the AddOn Menu ||
| Menu "New-ISESnippet" | Integrated GUI to create new Snippets ||
| Menu "FileTree" | Integrated GUI that shows a tree with folders (on first drive) that contain .ps1 and .psm1 files, clicking on a file node will open the file within ISE) ||
| Menu "Add-ScriptHelp" | Integrated GUI to generate help documentation for scripts/cmdlets. The generated output is added to the ISE and can be also copied to the clipboard) | [Link]( https://powershellone.wordpress.com/2015/09/28/create-an-integrated-wpf-based-ise-add-on-with-powershell/) |
| Menu Menu "Open-ScriptFolder" | Opens the folder that contains the current script within windows explorer ||
| Menu "Export-ISESession" | Save list of currently opened scripts (excluding 'untitled') as file ||
| Menu "Import-ISESession" | Import previously saved session file to load session back into ISE ||
| Menu "Export-SelectionAsRTF" | Export the current selection as an RTF document ||
| Menu "Export-SelectionAsHTML" | Export the current selection as an HTML document ||
| Menu "Expand-Alias" | Expand all aliases within the active editor window ||
| Menu "GoTo-Definition" | Jump to the definition of the function where the cursor is currently at. ||
| Menu "Spell check selection" | Integrated GUI to spell check the selected text. With option to auto correct. ||
'@
    $summaryTable | Set-Content "$(Split-Path $docFolder -Parent)/README.md" -Force
    $documenation = New-MarkdownHelp -Module $Module -OutputFolder $docFolder -Force
    foreach ($file in (dir $docFolder)){
        $text = (Get-Content -Path $file.FullName | Select-Object -Skip 6) | Set-Content $file.FullName -Force
    }
    #sanity check if help file were generated for each script
    [PSCustomObject]$htCheck
}
 Generate-ScriptMarkdownHelp -Path "C:\Scripts\ps1\Utils\ISEUtils\ISEUtils.psm1" -RepoUrl https://github.com/DBremen/ISEUtils