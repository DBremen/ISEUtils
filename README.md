# ISEUtils
Collection of some useful additions for the built-in PowerShell ISE
Some functions (New-ISESnippet, New-ISEMenu) are PowerShell only integrated (making use of the VerticalAddOnToolbar Add-Ons). List of functions with short description:

references for zen coding

https://github.com/madskristensen/zencoding
https://zen-coding.googlecode.com/files/ZenCodingCheatSheet.pdfc

- Get-ZenCode (PowerShell version of zen Coding based on WebEssentials VisualStudio extension version, with added functionality for pipeline input. See examples in Get-ZenCode.ps1. The function returns the expanded zen Code expression)
- Get-ISEShortcuts (returns all built-in and AddOn shortcut key bindings)
- Get-ISESnippet 
- Remove-ISESnippet
- Add-ISESnippet
- AddOn Menu "Expand ZenCode" (Enables zen Coding within PowerShell ISE, zen Code expressions are expanded by using the AddOn menu or assigned keyboard shortcut)
- AddOn Menu "Run Line" (execute line that contains current cursor position)
- AddOn Menu "Split selection by last char" 
- AddOn Menu "New-ISEMenu" (integrated AddOn to create new entries for the AddOn Menu)
- AddOn Menu "New-ISESnippet" (integrated AddOn to create new Snippets)



