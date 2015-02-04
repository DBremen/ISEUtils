. $PSScriptRoot\functions\Get-ZenCode.ps1
. $PSScriptRoot\functions\Get-ISEShortcuts.ps1
. $PSScriptRoot\functions\Add-ISESnippet.ps1
. $PSScriptRoot\functions\Get-ISESnippet.ps1
. $PSScriptRoot\functions\Remove-ISESnippet.ps1

#menu items

#compiled functions
Add-Type -Path $PSScriptRoot\resources\ISEUtils.dll

$newISEMenu = [scriptblock]::Create('$psISE.CurrentPowerShellTab.VerticalAddOnTools.Add("New-ISEMenu",[ISEUtils.NewISEMenu],$true);($psISE.CurrentPowerShellTab.VerticalAddOnTools | where {$_.Name -eq "New-ISEMenu"}).IsVisible=$true')
$newISESnippet = [scriptblock]::Create('$psISE.CurrentPowerShellTab.VerticalAddOnTools.Add("New-ISESnippet",[ISEUtils.NewISESnippet],$true);($psISE.CurrentPowerShellTab.VerticalAddOnTools | where {$_.Name -eq "New-ISESnippet"}).IsVisible=$true')


#inline functions 
$expandZenCode = {
    $currEditor = $psISE.CurrentFile.Editor
    $col = $currEditor.CaretLineText.Length - $currEditor.CaretLineText.TrimStart().Length
    $currEditor.SelectCaretLine()
    $line = $currEditor.CaretLineText.Trim()
    if ($line -like '*|*'){
        $sb = [scriptblock]::Create($line.Insert($line.IndexOf('|') + 2, "zenCode '") + "'")
        $txt = $sb.Invoke()
    }
    else{
        $txt = (zenCode $line)
    }

    $offset = " " * $col 
    $txt = $offset + (($txt-split "`r`n") -join "`r`n" + $offset)
    $currEditor.InsertText($txt)
}   
         
$runLine={
    ([scriptblock]::Create($psISE.CurrentFile.Editor.CaretLineText.Trim())).Invoke()
}

$splitSelectionByLastChar={
    $currEditor = $psISE.CurrentFile.Editor
    $currEditor.InsertText($selText.Remove($selText.LastIndexOf($splitChar),1).Split($splitChar) -join "`n")
    $selText = $currEditor.SelectedText
    $splitChar = $selText[-1]
    $currEditor.InsertText($selText.Remove($selText.LastIndexOf($splitChar),1).Split($splitChar) -join "`n")
}

$removeMenu = {
    $menu = $psISE.CurrentPowerShellTab.AddOnsMenu.Submenus | where DisplayName -eq 'ISEUtils'
    [void]$psISE.CurrentPowerShellTab.AddOnsMenu.Submenus.Remove($menu)
    [Microsoft.VisualBasic.Interaction]::Msgbox('To completly remove ISEUtils you will also need to delete the entry from your profile',"Exclamation","")
}



#add Menu items
Add-Type -AssemblyName Microsoft.VisualBasic
function Add-SubMenu($menu,$displayName,$code,$shortCut=$null){
    try{
        [void]$menu.Submenus.Add($displayName, $code,  $shortCut)
    }
    catch{
        $shortCut = [Microsoft.VisualBasic.Interaction]::InputBox("The shortcut ($shortCut) is already assigned. Please enter another combination.", "ShortCut", $shortCut)
        [void]$menu.Submenus.Add($displayName, $code,  $shortCut)
    }
}
        
$menu = $psISE.CurrentPowerShellTab.AddOnsMenu.Submenus.Add('ISEUtils', $null, $null)
Add-SubMenu $menu 'Expand ZenCode' $expandZenCode 'CTRL+SHIFT+J'
Add-SubMenu $menu 'Run Line' $runLine 'F2'
Add-SubMenu $menu 'Split Selection by last char' $splitSelectionByLastChar $null
Add-SubMenu $menu 'New-ISESnippet' $newISESnippet $null
Add-SubMenu $menu 'New-ISEMenu' $newISEMenu $null
Add-SubMenu $menu 'Remove ISEUtils' $removeMenu $null


Export-ModuleMember -Function ("Get-ZenCode","Get-ISEShortCuts","Get-ISESnippet","Remove-ISESnippet","Add-ISESnippet") -Alias zenCode
