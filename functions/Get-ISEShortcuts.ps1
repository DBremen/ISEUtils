function Get-ISEShortcuts{
<#
.Synopsis
   Get all Built-in + Add-on shortcuts
.DESCRIPTION
.EXAMPLE
   Get-ISEShortcuts
#>
    $gps = $psISE.GetType().Assembly
    $rm = New-Object Resources.ResourceManager GuiStrings,$gps
    $rs = $rm.GetResourceSet((Get-Culture),$true,$true)
    $selector = @{n='Type';e={'Built-in'}}, "Name" ,`
        @{n='SubMenu';e={'SubMenu'}},@{n='ShortCut';e={$_.Value}}
    $rs | where Name -Match 'Shortcut\d?$|^F\d+Keyboard' | 
        select $selector
    $psISE.CurrentPowerShellTab.AddOnsMenu.Submenus | foreach{
        $menu = $_.DisplayName
        if($_.Action){
           $shortCut = ($_.ShortCut.Modifiers,$_.ShortCut.Key -join ' + ')
           $shortCut = $shortCut.Replace(',',' +') -replace '^\s\+\s',''
           [PSCustomObject][ordered]@{Type='Add-on'; Name=$menu; SubMenu=""; ShortCut=$shortCut}
        }
        $_.SubMenus | foreach{
            $shortCut = ($_.ShortCut.Modifiers,$_.ShortCut.Key -join ' + ')
            $shortCut = $shortCut.Replace(',',' +') -replace '^\s\+\s',''
            [PSCustomObject][ordered]@{Type='Add-on'; Name=$menu; SubMenu=$_.DisplayName; ShortCut=$shortCut}
        }
    }
}

