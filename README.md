# ISEUtils
Collection of some useful additions for the built-in PowerShell ISE
Some functions (New-ISESnippet, New-ISEMenu...) are PowerShell only (no C# coding in Visual Studio required) integrated (making use of the VerticalAddOnToolbar Add-Ons) (read here for more info https://powershellone.wordpress.com/2015/09/28/create-an-integrated-wpf-based-ise-add-on-with-powershell/). List of functions with short description:


references for zen coding

https://github.com/madskristensen/zencoding  
https://zen-coding.googlecode.com/files/ZenCodingCheatSheet.pdfc

Automatic saving of opened files and prompt for re-opening previously saved session upon start of ISE (this is based on the ISESessionTools module from Oisin Grehan)

- Get-ZenCode (PowerShell version of zen Coding based on WebEssentials VisualStudio extension version, with added functionality for pipeline input. See examples in Get-ZenCode.ps1. The function returns the expanded zen Code expression)
  https://powershellone.wordpress.com/2015/11/09/zen-coding-for-the-powershell-console-and-ise/
- Get-ISEShortcuts (returns all built-in and AddOn shortcut key bindings)
- Get-ISESnippet 
- Remove-ISESnippet
- Add-ISESnippet
- Export-SelectionToRTF (export to .rtf file)
- Export-SelectionToHTML (export to .html file)
- Expand-Alias (function that Expand aliases within files (path parameter) text or the current ISE Window)

  https://powershellone.wordpress.com/2015/10/07/expanding-aliases-in-powershell-ise-or-any-powershell-file/
- Find-Definition (Finds function definition within any open ISE tab or file (provided that the function is loaded))
- Get-File (f# based PowerShell cmdlet wrapper around Directory.GetFiles ignoring PathTooLong and AccessDenied exceptions)
- AddOn Menu "Expand ZenCode" (Enables zen Coding within PowerShell ISE, zen Code expressions are expanded by using the AddOn menu or assigned keyboard shortcut)
- AddOn Menu "Run Line" (execute line that contains current cursor position)
- AddOn Menu "Split selection by last char" 
- AddOn Menu "New-ISEMenu" (integrated AddOn to create new entries for the AddOn Menu)
- AddOn Menu "New-ISESnippet" (integrated AddOn to create new Snippets)
- AddOn Menu "FileTree" (integrated AddOn that shows a tree with folders (on first drive) that contain .ps1 and .psm1 files, clicking on a file node will open the file within ISE)
- AddOn Menu "Add-ScriptHelp" (integrated AddOn to generate help documentation for scripts/cmdlets. The generated output is added to the ISE and can be also copied to the clipboard)
  https://powershellone.wordpress.com/2015/09/28/create-an-integrated-wpf-based-ise-add-on-with-powershell/
- AddOn Menu "Open-ScriptFolder" (opens the folder that contains the current script within windows explorer)
- AddOn Menu "Export-ISESession" (save list of currently opened scripts (excluding 'untitled') as file
- AddOn Menu "Import-ISESession" (import previously saved session file to load session back into ISE"
- AddOn Menu "Export-SelectionAsRTF"
- AddOn Menu "Export-SelectionAsHTML"
- AddOn Menu "Expand-Alias"
- AddOn Menu "GoTo-Definition"




