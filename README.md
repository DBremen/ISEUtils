# ISEUtils
Collection of some useful additions for the built-in PowerShell ISE
Some functions (New-ISESnippet, New-ISEMenu...) are PowerShell only (no C# coding in Visual Studio required) integrated (making use of the VerticalAddOnToolbar Add-Ons)
(read [here](https://powershellone.wordpress.com/2015/09/28/create-an-integrated-wpf-based-ise-add-on-with-powershell/) for more info ). 

The module adds automatic saving of opened files and prompt for re-opening previously saved session upon start of ISE (based on the ISESessionTools module from Oisin Grehan)

List of functions of the exported functions and menu items (Add_ons/ISEUtils):

| Function/Menu | Synopsis | Documentation |
| --- | --- | --- |
| Add-ISESnippet | Helper function to add a new ISE snippet | [Link](https://github.com/DBremen/ISEUtils/blob/master/docs/Add-ISESnippet.md) |
| Expand-Alias | Function to expand aliases either in the currently active ISE file or (in case a a path is provided) within any PowerShell file (that way the function can be also used from the PowerShell Console) to their respective definitions. | [Link](https://github.com/DBremen/ISEUtils/blob/master/docs/Expand-Alias.md) |
| Export-SelectionToHTML | Export the current selected text within ISE as .html file | [Link](https://github.com/DBremen/ISEUtils/blob/master/docs/Export-SelectionToHTML.md) |
| Export-SelectionToRTF | Export the current selected text within ISE as .rtf file | [Link](https://github.com/DBremen/ISEUtils/blob/master/docs/Export-SelectionToRTF.md) |
| Find-Definition | Jump to to the definition of the function that the cursor is currently placed at or inside. Searches through all open tabs within ISE. | [Link](https://github.com/DBremen/ISEUtils/blob/master/docs/Find-Definition.md) |
| Get-IseSnippet | Get all ISE Snippets with all their properties | [Link](https://github.com/DBremen/ISEUtils/blob/master/docs/Get-IseSnippet.md) |
| Get-ZenCode | Zen Coding for PowerShell | [Link](https://github.com/DBremen/ISEUtils/blob/master/docs/Get-ZenCode.md) |
| Remove-ISESnippet | Remove ISE Snippets (deletes the related xml files) | [Link](https://github.com/DBremen/ISEUtils/blob/master/docs/Remove-ISESnippet.md) || Get-File | F# based PowerShell cmdlet wrapper around Directory.GetFiles ignoring PathTooLong and AccessDenied exceptions ||
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
