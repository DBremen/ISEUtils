[33mcommit 6e79416e3823bc97991b966fafa82a382ab2d926[m
Merge: d61a5f8 3a59f5f
Author: Dirk <bremendirk@gmail.com>
Date:   Wed Feb 4 07:37:11 2015 +0000

    Merge branch 'master' of https://github.com/DirkBremen/ISEAddon

[33mcommit d61a5f880f74b7a6099f80e101683dee12a05d7e[m
Author: Dirk <bremendirk@gmail.com>
Date:   Wed Feb 4 05:34:19 2015 +0000

    Adding license and readme

[1mdiff --git a/ISEUtils.psm1 b/ISEUtils.psm1[m
[1mindex 7340b5d..994be2c 100644[m
[1m--- a/ISEUtils.psm1[m
[1m+++ b/ISEUtils.psm1[m
[36m@@ -74,61 +74,3 @@[m [mAdd-SubMenu $menu 'Remove ISEUtils' $removeMenu $null[m
 [m
 [m
 Export-ModuleMember -Function ("Get-ZenCode","Get-ISEShortCuts","Get-ISESnippet","Remove-ISESnippet","Add-ISESnippet") -Alias zenCode[m
[31m-[m
[31m-[m
[31m-[m
[31m-[m
[31m-[m
[31m-[m
[31m-[m
[31m-[m
[31m-[m
[31m-[m
[31m-[m
[31m-[m
[31m-[m
[31m-[m
[31m-<#$DisplayName = "Expand zen-Code"            [m
[31m-$Action      = {[m
[31m-    $psISE.CurrentFile.Editor.SelectCaretLine()[m
[31m-    $psISE.CurrentFile.Editor.InsertText((zenCode $psISE.CurrentFile.Editor.CaretLineText))[m
[31m-}            [m
[31m-$ShortCut    = "CTRL+SHIFT+W"            [m
[31m-            [m
[31m-$menu=$psISE.CurrentPowerShellTab.AddOnsMenu.Submenus.Add($DisplayName, $Action, $ShortCut)#>[m
[31m-[m
[31m-[m
[31m-[m
[31m-[m
[31m-<#$DisplayName = "Toggle All Regions"            [m
[31m-$Action      = {$psISE.CurrentFile.Editor.ToggleOutliningExpansion()}            [m
[31m-$ShortCut    = "CTRL+ALT+K"            [m
[31m-            [m
[31m-$menu=$psISE.CurrentPowerShellTab.AddOnsMenu.Submenus.Add($DisplayName, $Action, $ShortCut)[m
[31m-#>[m
[31m-[m
[31m-#$psISE.CurrentPowerShellTab.AddOnsMenu.Submenus[-1][m
[31m-<#[void]$psISE.CurrentPowerShellTab.AddOnsMenu.Submenus.Remove($menu)[m
[31m-[m
[31m-[m
[31m-    [m
[31m-    [m
[31m-    [m
[31m-$GetOptions = $psISE.CurrentPowerShellTab.AddOnsMenu.Submenus.Add([m
[31m-    "GetOptions",$null,$null)[m
[31m-$GetOptions.SubMenus.Add("GetFonts", { C:\fso\Get-PsISEfonts.ps1 } , $null)[m
[31m-$GetOptions.SubMenus.Add("GetColors", { C:\fso\Get-PsIseColorValues.ps1 } , $null)#>[m
[31m-[m
[31m-[m
[31m-[m
[31m-[m
[31m-[m
[31m-[m
[31m-[m
[31m-[m
[31m-[m
[31m-[m
[31m-[m
[31m-[m
[31m-[m
[31m-[m
[1mdiff --git a/LICENSE b/LICENSE[m
[1mnew file mode 100644[m
[1mindex 0000000..42d7718[m
[1m--- /dev/null[m
[1m+++ b/LICENSE[m
[36m@@ -0,0 +1,22 @@[m
[32m+[m[32mThe MIT License (MIT)[m
[32m+[m
[32m+[m[32mCopyright (c) 2015 DirkBremen[m
[32m+[m
[32m+[m[32mPermission is hereby granted, free of charge, to any person obtaining a copy[m
[32m+[m[32mof this software and associated documentation files (the "Software"), to deal[m
[32m+[m[32min the Software without restriction, including without limitation the rights[m
[32m+[m[32mto use, copy, modify, merge, publish, distribute, sublicense, and/or sell[m
[32m+[m[32mcopies of the Software, and to permit persons to whom the Software is[m
[32m+[m[32mfurnished to do so, subject to the following conditions:[m
[32m+[m
[32m+[m[32mThe above copyright notice and this permission notice shall be included in all[m
[32m+[m[32mcopies or substantial portions of the Software.[m
[32m+[m
[32m+[m[32mTHE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR[m
[32m+[m[32mIMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,[m
[32m+[m[32mFITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE[m
[32m+[m[32mAUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER[m
[32m+[m[32mLIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,[m
[32m+[m[32mOUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE[m
[32m+[m[32mSOFTWARE.[m
[32m+[m
[1mdiff --git a/README.md b/README.md[m
[1mnew file mode 100644[m
[1mindex 0000000..85b4ad9[m
[1m--- /dev/null[m
[1m+++ b/README.md[m
[36m@@ -0,0 +1,21 @@[m
[32m+[m[32m# ISEAddon[m
[32m+[m[32mCollection of some useful additions for the built-in PowerShell ISE[m
[32m+[m[32mSome functions (New-ISESnippet, New-ISEMenu) are PowerShell only integrated (making use of the VerticalAddOnToolbar Add-Ons). List of functions with short description:[m
[32m+[m
[32m+[m[32mreferences for zen coding[m
[32m+[m[32mhttps://github.com/madskristensen/zencoding[m
[32m+[m[32mhttps://zen-coding.googlecode.com/files/ZenCodingCheatSheet.pdfc[m
[32m+[m
[32m+[m[32m- Get-ZenCode (PowerShell version of zen Coding based on WebEssentials VisualStudio extension version, with added functionality for pipeline input. See examples in Get-ZenCode.ps1. The function returns the expanded zen Code expression)[m
[32m+[m[32m- Get-ISEShortcuts (returns all built-in and AddOn shortcut key bindings)[m
[32m+[m[32m- Get-ISESnippet[m[41m [m
[32m+[m[32m- Remove-ISESnippet[m
[32m+[m[32m- Add-ISESnippet[m
[32m+[m[32m- AddOn Menu "Expand ZenCode" (Enables zen Coding within PowerShell ISE, zen Code expressions are expanded by using the AddOn menu or assigned keyboard shortcut)[m
[32m+[m[32m- AddOn Menu "Run Line" (execute line that contains current cursor position)[m
[32m+[m[32m- AddOn Menu "Split selection by last char"[m[41m [m
[32m+[m[32m- AddOn Menu "New-ISEMenu" (integrated AddOn to create new entries for the AddOn Menu)[m
[32m+[m[32m- AddOn Menu "New-ISESnippet" (integrated AddOn to create new Snippets)[m
[32m+[m
[32m+[m
[32m+[m

[33mcommit b5a75fae0c9bdb6e087bcde57a32567a41b5fded[m
Author: Dirk <bremendirk@gmail.com>
Date:   Tue Feb 3 22:57:26 2015 +0000

    initial commit

[1mdiff --git a/ISEUtils.psm1 b/ISEUtils.psm1[m
[1mnew file mode 100644[m
[1mindex 0000000..7340b5d[m
[1m--- /dev/null[m
[1m+++ b/ISEUtils.psm1[m
[36m@@ -0,0 +1,134 @@[m
[32m+[m[32m﻿. $PSScriptRoot\functions\Get-ZenCode.ps1[m[41m[m
[32m+[m[32m. $PSScriptRoot\functions\Get-ISEShortcuts.ps1[m[41m[m
[32m+[m[32m. $PSScriptRoot\functions\Add-ISESnippet.ps1[m[41m[m
[32m+[m[32m. $PSScriptRoot\functions\Get-ISESnippet.ps1[m[41m[m
[32m+[m[32m. $PSScriptRoot\functions\Remove-ISESnippet.ps1[m[41m[m
[32m+[m[41m[m
[32m+[m[32m#menu items[m[41m[m
[32m+[m[41m[m
[32m+[m[32m#compiled functions[m[41m[m
[32m+[m[32mAdd-Type -Path $PSScriptRoot\resources\ISEUtils.dll[m[41m[m
[32m+[m[41m[m
[32m+[m[32m$newISEMenu = [scriptblock]::Create('$psISE.CurrentPowerShellTab.VerticalAddOnTools.Add("New-ISEMenu",[ISEUtils.NewISEMenu],$true);($psISE.CurrentPowerShellTab.VerticalAddOnTools | where {$_.Name -eq "New-ISEMenu"}).IsVisible=$true')[m[41m[m
[32m+[m[32m$newISESnippet = [scriptblock]::Create('$psISE.CurrentPowerShellTab.VerticalAddOnTools.Add("New-ISESnippet",[ISEUtils.NewISESnippet],$true);($psISE.CurrentPowerShellTab.VerticalAddOnTools | where {$_.Name -eq "New-ISESnippet"}).IsVisible=$true')[m[41m[m
[32m+[m[41m[m
[32m+[m[41m[m
[32m+[m[32m#inline functions[m[41m [m
[32m+[m[32m$expandZenCode = {[m[41m[m
[32m+[m[32m    $currEditor = $psISE.CurrentFile.Editor[m[41m[m
[32m+[m[32m    $col = $currEditor.CaretLineText.Length - $currEditor.CaretLineText.TrimStart().Length[m[41m[m
[32m+[m[32m    $currEditor.SelectCaretLine()[m[41m[m
[32m+[m[32m    $line = $currEditor.CaretLineText.Trim()[m[41m[m
[32m+[m[32m    if ($line -like '*|*'){[m[41m[m
[32m+[m[32m        $sb = [scriptblock]::Create($line.Insert($line.IndexOf('|') + 2, "zenCode '") + "'")[m[41m[m
[32m+[m[32m        $txt = $sb.Invoke()[m[41m[m
[32m+[m[32m    }[m[41m[m
[32m+[m[32m    else{[m[41m[m
[32m+[m[32m        $txt = (zenCode $line)[m[41m[m
[32m+[m[32m    }[m[41m[m
[32m+[m[41m[m
[32m+[m[32m    $offset = " " * $col[m[41m [m
[32m+[m[32m    $txt = $offset + (($txt-split "`r`n") -join "`r`n" + $offset)[m[41m[m
[32m+[m[32m    $currEditor.InsertText($txt)[m[41m[m
[32m+[m[32m}[m[41m   [m
[32m+[m[41m         [m
[32m+[m[32m$runLine={[m[41m[m
[32m+[m[32m    ([scriptblock]::Create($psISE.CurrentFile.Editor.CaretLineText.Trim())).Invoke()[m[41m[m
[32m+[m[32m}[m[41m[m
[32m+[m[41m[m
[32m+[m[32m$splitSelectionByLastChar={[m[41m[m
[32m+[m[32m    $currEditor = $psISE.CurrentFile.Editor[m[41m[m
[32m+[m[32m    $currEditor.InsertText($selText.Remove($selText.LastIndexOf($splitChar),1).Split($splitChar) -join "`n")[m[41m[m
[32m+[m[32m    $selText = $currEditor.SelectedText[m[41m[m
[32m+[m[32m    $splitChar = $selText[-1][m[41m[m
[32m+[m[32m    $currEditor.InsertText($selText.Remove($selText.LastIndexOf($splitChar),1).Split($splitChar) -join "`n")[m[41m[m
[32m+[m[32m}[m[41m[m
[32m+[m[41m[m
[32m+[m[32m$removeMenu = {[m[41m[m
[32m+[m[32m    $menu = $psISE.CurrentPowerShellTab.AddOnsMenu.Submenus | where DisplayName -eq 'ISEUtils'[m[41m[m
[32m+[m[32m    [void]$psISE.CurrentPowerShellTab.AddOnsMenu.Submenus.Remove($menu)[m[41m[m
[32m+[m[32m    [Microsoft.VisualBasic.Interaction]::Msgbox('To completly remove ISEUtils you will also need to delete the entry from your profile',"Exclamation","")[m[41m[m
[32m+[m[32m}[m[41m[m
[32m+[m[41m[m
[32m+[m[41m[m
[32m+[m[41m[m
[32m+[m[32m#add Menu items[m[41m[m
[32m+[m[32mAdd-Type -AssemblyName Microsoft.VisualBasic[m[41m[m
[32m+[m[32mfunction Add-SubMenu($menu,$displayName,$code,$shortCut=$null){[m[41m[m
[32m+[m[32m    try{[m[41m[m
[32m+[m[32m        [void]$menu.Submenus.Add($displayName, $code,  $shortCut)[m[41m[m
[32m+[m[32m    }[m[41m[m
[32m+[m[32m    catch{[m[41m[m
[32m+[m[32m        $shortCut = [Microsoft.VisualBasic.Interaction]::InputBox("The shortcut ($shortCut) is already assigned. Please enter another combination.", "ShortCut", $shortCut)[m[41m[m
[32m+[m[32m        [void]$menu.Submenus.Add($displayName, $code,  $shortCut)[m[41m[m
[32m+[m[32m    }[m[41m[m
[32m+[m[32m}[m[41m[m
[32m+[m[41m        [m
[32m+[m[32m$menu = $psISE.CurrentPowerShellTab.AddOnsMenu.Submenus.Add('ISEUtils', $null, $null)[m[41m[m
[32m+[m[32mAdd-SubMenu $menu 'Expand ZenCode' $expandZenCode 'CTRL+SHIFT+J'[m[41m[m
[32m+[m[32mAdd-SubMenu $menu 'Run Line' $runLine 'F2'[m[41m[m
[32m+[m[32mAdd-SubMenu $menu 'Split Selection by last char' $splitSelectionByLastChar $null[m[41m[m
[32m+[m[32mAdd-SubMenu $menu 'New-ISESnippet' $newISESnippet $null[m[41m[m
[32m+[m[32mAdd-SubMenu $menu 'New-ISEMenu' $newISEMenu $null[m[41m[m
[32m+[m[32mAdd-SubMenu $menu 'Remove ISEUtils' $removeMenu $null[m[41m[m
[32m+[m[41m[m
[32m+[m[41m[m
[32m+[m[32mExport-ModuleMember -Function ("Get-ZenCode","Get-ISEShortCuts","Get-ISESnippet","Remove-ISESnippet","Add-ISESnippet") -Alias zenCode[m[41m[m
[32m+[m[41m[m
[32m+[m[41m[m
[32m+[m[41m[m
[32m+[m[41m[m
[32m+[m[41m[m
[32m+[m[41m[m
[32m+[m[41m[m
[32m+[m[41m[m
[32m+[m[41m[m
[32m+[m[41m[m
[32m+[m[41m[m
[32m+[m[41m[m
[32m+[m[41m[m
[32m+[m[41m[m
[32m+[m[32m<#$DisplayName = "Expand zen-Code"[m[41m            [m
[32m+[m[32m$Action      = {[m[41m[m
[32m+[m[32m    $psISE.CurrentFile.Editor.SelectCaretLine()[m[41m[m
[32m+[m[32m    $psISE.CurrentFile.Editor.InsertText((zenCode $psISE.CurrentFile.Editor.CaretLineText))[m[41m[m
[32m+[m[32m}[m[41m            [m
[32m+[m[32m$ShortCut    = "CTRL+SHIFT+W"[m[41m            [m
[32m+[m[41m            [m
[32m+[m[32m$menu=$psISE.CurrentPowerShellTab.AddOnsMenu.Submenus.Add($DisplayName, $Action, $ShortCut)#>[m[41m[m
[32m+[m[41m[m
[32m+[m[41m[m
[32m+[m[41m[m
[32m+[m[41m[m
[32m+[m[32m<#$DisplayName = "Toggle All Regions"[m[41m            [m
[32m+[m[32m$Action      = {$psISE.CurrentFile.Editor.ToggleOutliningExpansion()}[m[41m            [m
[32m+[m[32m$ShortCut    = "CTRL+ALT+K"[m[41m            [m
[32m+[m[41m            [m
[32m+[m[32m$menu=$psISE.CurrentPowerShellTab.AddOnsMenu.Submenus.Add($DisplayName, $Action, $ShortCut)[m[41m[m
[32m+[m[32m#>[m[41m[m
[32m+[m[41m[m
[32m+[m[32m#$psISE.CurrentPowerShellTab.AddOnsMenu.Submenus[-1][m[41m[m
[32m+[m[32m<#[void]$psISE.CurrentPowerShellTab.AddOnsMenu.Submenus.Remove($menu)[m[41m[m
[32m+[m[41m[m
[32m+[m[41m[m
[32m+[m[41m    [m
[32m+[m[41m    [m
[32m+[m[41m    [m
[32m+[m[32m$GetOptions = $psISE.CurrentPowerShellTab.AddOnsMenu.Submenus.Add([m[41m[m
[32m+[m[32m    "GetOptions",$null,$null)[m[41m[m
[32m+[m[32m$GetOptions.SubMenus.Add("GetFonts", { C:\fso\Get-PsISEfonts.ps1 } , $null)[m[41m[m
[32m+[m[32m$GetOptions.SubMenus.Add("GetColors", { C:\fso\Get-PsIseColorValues.ps1 } , $null)#>[m[41m[m
[32m+[m[41m[m
[32m+[m[41m[m
[32m+[m[41m[m
[32m+[m[41m[m
[32m+[m[41m[m
[32m+[m[41m[m
[32m+[m[41m[m
[32m+[m[41m[m
[32m+[m[41m[m
[32m+[m[41m[m
[32m+[m[41m[m
[32m+[m[41m[m
[32m+[m[41m[m
[32m+[m[41m[m
[1mdiff --git a/functions/Add-ISESnippet.ps1 b/functions/Add-ISESnippet.ps1[m
[1mnew file mode 100644[m
[1mindex 0000000..259c821[m
[1m--- /dev/null[m
[1m+++ b/functions/Add-ISESnippet.ps1[m
[36m@@ -0,0 +1,31 @@[m
[32m+[m[32m﻿function Add-ISESnippet{[m[41m[m
[32m+[m[32m<#[m[41m[m
[32m+[m[32m.Synopsis[m[41m[m
[32m+[m[32m   Helper function to add a new ISE snippet[m[41m[m
[32m+[m[32m.DESCRIPTION[m[41m[m
[32m+[m[32m   Wrapper around New-ISESnippet that automaticcaly adds the author based on $env:USERNAME and the CaretOffset based on the positon of the char '^' within the text[m[41m[m
[32m+[m[32m.EXAMPLE[m[41m[m
[32m+[m[32m    $txt=@"[m[41m[m
[32m+[m[32m    [PSCustomObject][ordered]@{[m[41m[m
[32m+[m[32m    ^[m[41m[m
[32m+[m[32m    }[m[41m[m
[32m+[m[32m    "@[m[41m[m
[32m+[m[32m    Add-ISESnippet -Title PSCustomObject -Description "PSCustomObject" -Text $txt -Force[m[41m[m
[32m+[m[32m#>[m[41m[m
[32m+[m[32m    [CmdletBinding()][m[41m[m
[32m+[m[32m    param([m[41m[m
[32m+[m[32m        [Parameter(Mandatory=$true)][m[41m[m
[32m+[m[32m        $Title,[m[41m[m
[32m+[m[32m        [Parameter(Mandatory=$true)][m[41m[m
[32m+[m[32m        $Description,[m[41m[m
[32m+[m[32m        [Parameter(Mandatory=$true)][m[41m[m
[32m+[m[32m        $Text,[switch]$force[m[41m [m
[32m+[m[32m    )[m[41m[m
[32m+[m[32m    $caretOffset = $text.IndexOf('^')[m[41m[m
[32m+[m[32m    if ($caretOffset -ne -1){[m[41m[m
[32m+[m[32m        $text = $text.Remove($caretOffSet,1)[m[41m[m
[32m+[m[32m        $PSBoundParameters.Add('CaretOffset',$caretOffset)[m[41m[m
[32m+[m[32m    }[m[41m[m
[32m+[m[32m    $PSBoundParameters.Add('Author',$env:USERNAME)[m[41m[m
[32m+[m[32m    New-IseSnippet @$PSBoundParameters[m[41m[m
[32m+[m[32m}[m[41m[m
[1mdiff --git a/functions/Get-ISEShortcuts.ps1 b/functions/Get-ISEShortcuts.ps1[m
[1mnew file mode 100644[m
[1mindex 0000000..7b19a14[m
[1m--- /dev/null[m
[1m+++ b/functions/Get-ISEShortcuts.ps1[m
[36m@@ -0,0 +1,30 @@[m
[32m+[m[32m﻿function Get-ISEShortcuts{[m[41m[m
[32m+[m[32m<#[m[41m[m
[32m+[m[32m.Synopsis[m[41m[m
[32m+[m[32m   Get all Built-in + Add-on shortcuts[m[41m[m
[32m+[m[32m.DESCRIPTION[m[41m[m
[32m+[m[32m.EXAMPLE[m[41m[m
[32m+[m[32m   Get-ISEShortcuts[m[41m[m
[32m+[m[32m#>[m[41m[m
[32m+[m[32m    $gps = $psISE.GetType().Assembly[m[41m[m
[32m+[m[32m    $rm = New-Object Resources.ResourceManager GuiStrings,$gps[m[41m[m
[32m+[m[32m    $rs = $rm.GetResourceSet((Get-Culture),$true,$true)[m[41m[m
[32m+[m[32m    $selector = @{n='Type';e={'Built-in'}}, "Name" ,`[m[41m[m
[32m+[m[32m        @{n='SubMenu';e={'SubMenu'}},@{n='ShortCut';e={$_.Value}}[m[41m[m
[32m+[m[32m    $rs | where Name -Match 'Shortcut\d?$|^F\d+Keyboard' |[m[41m [m
[32m+[m[32m        select $selector[m[41m[m
[32m+[m[32m    $psISE.CurrentPowerShellTab.AddOnsMenu.Submenus | foreach{[m[41m[m
[32m+[m[32m        $menu = $_.DisplayName[m[41m[m
[32m+[m[32m        if($_.Action){[m[41m[m
[32m+[m[32m           $shortCut = ($_.ShortCut.Modifiers,$_.ShortCut.Key -join ' + ')[m[41m[m
[32m+[m[32m           $shortCut = $shortCut.Replace(',',' +') -replace '^\s\+\s',''[m[41m[m
[32m+[m[32m           [PSCustomObject][ordered]@{Type='Add-on'; Name=$menu; SubMenu=""; ShortCut=$shortCut}[m[41m[m
[32m+[m[32m        }[m[41m[m
[32m+[m[32m        $_.SubMenus | foreach{[m[41m[m
[32m+[m[32m            $shortCut = ($_.ShortCut.Modifiers,$_.ShortCut.Key -join ' + ')[m[41m[m
[32m+[m[32m            $shortCut = $shortCut.Replace(',',' +') -replace '^\s\+\s',''[m[41m[m
[32m+[m[32m            [PSCustomObject][ordered]@{Type='Add-on'; Name=$menu; SubMenu=$_.DisplayName; ShortCut=$shortCut}[m[41m[m
[32m+[m[32m        }[m[41m[m
[32m+[m[32m    }[m[41m[m
[32m+[m[32m}[m[41m[m
[32m+[m[41m[m
[1mdiff --git a/functions/Get-ISESnippet.ps1 b/functions/Get-ISESnippet.ps1[m
[1mnew file mode 100644[m
[1mindex 0000000..42685ba[m
[1m--- /dev/null[m
[1m+++ b/functions/Get-ISESnippet.ps1[m
[36m@@ -0,0 +1,21 @@[m
[32m+[m[32m﻿function Get-ISESnippet{[m[41m[m
[32m+[m[32m<#[m[41m[m
[32m+[m[32m.Synopsis[m[41m[m
[32m+[m[32m   Get all ISE Snippets with all their properties[m[41m[m
[32m+[m[32m.DESCRIPTION[m[41m[m
[32m+[m[32m   Improvement of the built-in Get-ISESnippet cmdlet. This function retrieves the information out of the xml files[m[41m[m
[32m+[m[32m   that are stored within the default snippets folder[m[41m[m
[32m+[m[32m.EXAMPLE[m[41m[m
[32m+[m[32m   Get-ISESnippet[m[41m[m
[32m+[m[32m#>[m[41m[m
[32m+[m[32m    [CmdletBinding()][m[41m[m
[32m+[m[32m    $snippetFiles = Get-ChildItem (Join-Path (Split-Path $profile.CurrentUserCurrentHost) "Snippets") -File -Recurse[m[41m[m
[32m+[m[32m    foreach ($snippetFile in $snippetFiles){[m[41m[m
[32m+[m[32m        $snippetXML = [xml](Get-Content $snippetFile.FullName -Raw)[m[41m[m
[32m+[m[32m        $snippetXML |[m[41m [m
[32m+[m[32m            select @{n='Version'; e={$_.Snippets.Snippet.Version}}, @{n='Description';e={$_.Snippets.Snippet.Header.Description}},`[m[41m[m
[32m+[m[32m                @{n='Title';e={$_.Snippets.Snippet.Header.Title}}, @{n='Author';e={$_.Header.Snippets.Snippet.Author}},`[m[41m[m
[32m+[m[32m                @{n='Language';e={$_.Snippets.Snippet.Code.Script.Language}}, @{n='CaretOffset';e={$_.Snippets.Snippet.Code.Script.CaretOffset}},`[m[41m[m
[32m+[m[32m                @{n='Code';e={$_.Snippets.Snippet.Code.Script.'#cdata-section'}}, @{n='Path'; e={$snippetFile.FullName}}[m[41m       [m
[32m+[m[32m    }[m[41m[m
[32m+[m[32m}[m[41m[m
[1mdiff --git a/functions/Get-ZenCode.ps1 b/functions/Get-ZenCode.ps1[m
[1mnew file mode 100644[m
[1mindex 0000000..d6b494b[m
[1m--- /dev/null[m
[1m+++ b/functions/Get-ZenCode.ps1[m
[36m@@ -0,0 +1,259 @@[m
[32m+[m[32m﻿#https://github.com/madskristensen/zencoding[m[41m[m
[32m+[m[32m#https://zen-coding.googlecode.com/files/ZenCodingCheatSheet.pdfc[m[41m[m
[32m+[m[32mfunction Get-ZenCode{[m[41m[m
[32m+[m[32m       <#[m[41m    [m
[32m+[m[32m    .SYNOPSIS[m[41m[m
[32m+[m[32m        zen Coding with PowerShell[m[41m[m
[32m+[m[32m    .DESCRIPTION[m[41m[m
[32m+[m[32m        Extension of zenCoding from WebEssentials for Visual Studio with PowerShell[m[41m [m
[32m+[m[32mpipeline support. Can be used to expand zenCoding expressions within PowerShell ISE[m[41m[m
[32m+[m[32m    .Param zenCodeExpr[m[41m[m
[32m+[m[32m        The zenCode expression to be expanded[m[41m[m
[32m+[m[32m    .Param InputObject[m[41m[m
[32m+[m[32m        Optional pipeline input to be fed into the zenCodeExpr[m[41m[m
[32m+[m[32m    .EXAMPLE[m[41m[m
[32m+[m[32m        1..3 | zenCode 'html>head>title{test}+body>ul>li{[string]$_ + " someText " + $_}' -show[m[41m[m
[32m+[m[32m    .EXAMPLE[m[41m[m
[32m+[m[32m        gps | zenCode 'html>head>title+body>table>tr>th{name}+th{ID}^(tr>td{$_.name}+td{$_.id})' -show[m[41m[m
[32m+[m[32m    .LINK[m[41m[m
[32m+[m[32m        https://github.com/madskristensen/zencoding[m[41m[m
[32m+[m[32m        https://zen-coding.googlecode.com/files/ZenCodingCheatSheet.pdfc[m[41m[m
[32m+[m[32m    .NOTES[m[41m [m
[32m+[m[32m        CREATED:  (Get-Date).ToShortDateString()[m[41m[m
[32m+[m[32m        AUTHOR      :  Dirk[m[41m[m
[32m+[m[32m        Tags<>:     :[m[41m[m
[32m+[m	[32m    Changelog:[m[41m    [m
[32m+[m	[32m      -----------------------------------------------------------------------------[m[41m[m
[32m+[m[41m                                           [m
[32m+[m	[32m      Name          Date         Description[m[41m        [m
[32m+[m	[32m      -----------------------------------------------------------------------------[m[41m[m
[32m+[m[41m[m
[32m+[m	[32m      -----------------------------------------------------------------------------[m[41m[m
[32m+[m[32m    #>[m[41m[m
[32m+[m[32m    [Alias("zenCode")][m[41m[m
[32m+[m[32m    [CmdletBinding()][m[41m[m
[32m+[m[32m    Param[m[41m[m
[32m+[m[32m    ([m[41m[m
[32m+[m[32m        [Parameter(Mandatory=$true,[m[41m[m
[32m+[m[32m              