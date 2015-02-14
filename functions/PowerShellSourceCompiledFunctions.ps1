. "$(Split-Path $PSScriptRoot -Parent)\resources\ConvertTo-ISEAddOn.ps1"
$addScriptHelp ={
    New-StackPanel {
        New-TextBlock -FontSize 17 -Margin "24 2 0 3" -FontWeight Bold -Text "Synopsis"
        New-TextBox -Margin "7, 5, 7, 5" -Name "txtSynopsis"
        New-TextBlock -FontSize 17  -Margin "24 2 0 3" -FontWeight Bold -Text "Description"
        New-TextBox -Margin "7, 5, 7, 5" -Name "txtDescription"
        New-TextBlock -FontSize 17 -Margin "24 2 0 3" -FontWeight Bold -Text "1. Param"
        New-TextBox -Margin "7, 5, 7, 5" -Name "txtFirstParamName"
        New-TextBlock -FontSize 17 -Margin "24 2 0 3" -FontWeight Bold -Text "1. Param Description" 
        New-TextBox -Margin "7, 5, 7, 5" -Name "txtFirstParamDesc"
        New-TextBlock -FontSize 17 -Margin "24 2 0 3" -FontWeight Bold -Text "2. Param"
        New-TextBox -Margin "7, 5, 7, 5" -Name "txtSecondParamName"
        New-TextBlock -FontSize 17 -Margin "24 2 0 3" -FontWeight Bold -Text "2. Param Description"
        New-TextBox -Margin "7, 5, 7, 5" -Name "txtSecondParamDesc"
        New-TextBlock -FontSize 17 -Margin "24 2 0 3" -FontWeight Bold -Text "Link"
        New-TextBox -Margin "7, 5, 7, 5" -Name "txtLink"
        New-TextBlock -FontSize 17 -Margin "24 2 0 3" -FontWeight Bold -Text "1. Example"
        New-TextBox -Margin "7, 5, 7, 5" -Name "txtFirstExample"
        New-TextBlock -FontSize 17 -Margin "24 2 0 3" -FontWeight Bold -Text "2. Example"
        New-TextBox -Margin "7, 5, 7, 5" -Name "txtSecondExample"
        New-CheckBox -Margin "5, 5, 2, 0"  -Name "chkOutput" {
            New-StackPanel -Margin "3,-5,0,0" {
                New-TextBlock -Name "OutputText" -FontSize 16 -FontWeight Bold -Text "Copy to clipboard"
                New-TextBlock -FontSize 14 TextWrapping Wrap
            }
        }
        New-Button -HorizontalAlignment Stretch -Margin 7 {
            New-TextBlock -FontSize 17 -FontWeight Bold -Text "Add to ISE"
        } -On_Click{
            $txtSynopsis = ($this.Parent.Children | where {$_.Name -eq "txtSynopsis"}).Text 
            $txtDescription = ($this.Parent.Children | where {$_.Name -eq "txtDescription"}).Text
            $txtFirstParamName = ($this.Parent.Children | where {$_.Name -eq "txtFirstParamName"}).Text
            $txtFirstParamDesc = ($this.Parent.Children | where {$_.Name -eq "txtFirstParamDesc"}).Text
            $txtSecondParamName = ($this.Parent.Children | where {$_.Name -eq "txtSecondParamName"}).Text
            $txtSecondParamDesc = ($this.Parent.Children | where {$_.Name -eq "txtSecondParamDesc"}).Text
            $txtLink = ($this.Parent.Children | where {$_.Name -eq "txtLink"}).Text 
            $txtFirstExample = ($this.Parent.Children | where {$_.Name -eq "txtFirstExample"}).Text 
            $txtSecondExample = ($this.Parent.Children | where {$_.Name -eq "txtSecondExample"}).Text 
            $chkOutput = ($this.Parent.Children | where {$_.Name -eq "chkOutput"}).isChecked
            $helptext=@"
    <#    
    .SYNOPSIS
        $txtSynopsis
    .DESCRIPTION
        $txtDescription
"@
            if ($txtFirstParamName) {
                $helpText+="`n`t.PARAM $txtFirstParamName`n`t`t$txtFirstParamDesc"
            }
            if ($txtSecondParamName) {
                $helpText+="`n`t.PARAM $txtSecondParamName`n`t`t$txtSecondParamDesc"
            }
            if ($txtFirstExample) {
                $helpText+="`n`t.EXAMPLE`n`t`t$txtFirstExample"
            }
            if ($txtSecondExample) {
                $helpText+="`n`t.EXAMPLE`n`t`t$txtSecondExample"
            }
            if ($txtLink) {
                $helpText+="`n`t.LINK`n`t`t$txtLink"
            }
        $helpText+="`n" + @"
    .NOTES 
        CREATED:  $((Get-Date).ToShortDateString())
        AUTHOR      :  $env:USERNAME
	    Changelog:    
	        ----------------------------------------------------------------------------------                                           
	        Name          Date         Description        
	        ----------------------------------------------------------------------------------
	        ----------------------------------------------------------------------------------
  
"@.TrimEnd() + "`n`t#>"
            if ($chkOutput) {
                $helptext | clip
		    } 
            $psise.CurrentPowerShellTab.Files.SelectedFile.Editor.InsertText($helpText)  

        }
    }  
}


$fileTree ={
    $logoBase64='iVBORw0KGgoAAAANSUhEUgAAABAAAAAQCAYAAAAf8/9hAAAABGdBTUEAALGOfPtRkwAAACBjSFJNAACHDwAAjA8AAP1SAACBQAAAfXkAAOmLAAA85QAAGcxzPIV3AAAKJ2lDQ1BpY2MAAEjHnZZ3VFTXFofPvXd6oc0wAlKG3rvAANJ7k15FYZgZYCgDDjM0sSGiAhFFRJoiSFDEgNFQJFZEsRAUVLAHJAgoMRhFVCxvRtaLrqy89/Ly++Osb+2z97n77L3PWhcAkqcvl5cGSwGQyhPwgzyc6RGRUXTsAIABHmCAKQBMVka6X7B7CBDJy82FniFyAl8EAfB6WLwCcNPQM4BOB/+fpFnpfIHomAARm7M5GSwRF4g4JUuQLrbPipgalyxmGCVmvihBEcuJOWGRDT77LLKjmNmpPLaIxTmns1PZYu4V8bZMIUfEiK+ICzO5nCwR3xKxRoowlSviN+LYVA4zAwAUSWwXcFiJIjYRMYkfEuQi4uUA4EgJX3HcVyzgZAvEl3JJS8/hcxMSBXQdli7d1NqaQffkZKVwBALDACYrmcln013SUtOZvBwAFu/8WTLi2tJFRbY0tba0NDQzMv2qUP91829K3NtFehn4uWcQrf+L7a/80hoAYMyJarPziy2uCoDOLQDI3fti0zgAgKSobx3Xv7oPTTwviQJBuo2xcVZWlhGXwzISF/QP/U+Hv6GvvmckPu6P8tBdOfFMYYqALq4bKy0lTcinZ6QzWRy64Z+H+B8H/nUeBkGceA6fwxNFhImmjMtLELWbx+YKuGk8Opf3n5r4D8P+pMW5FonS+BFQY4yA1HUqQH7tBygKESDR+8Vd/6NvvvgwIH554SqTi3P/7zf9Z8Gl4iWDm/A5ziUohM4S8jMX98TPEqABAUgCKpAHykAd6ABDYAasgC1wBG7AG/iDEBAJVgMWSASpgA+yQB7YBApBMdgJ9oBqUAcaQTNoBcdBJzgFzoNL4Bq4AW6D+2AUTIBnYBa8BgsQBGEhMkSB5CEVSBPSh8wgBmQPuUG+UBAUCcVCCRAPEkJ50GaoGCqDqqF6qBn6HjoJnYeuQIPQXWgMmoZ+h97BCEyCqbASrAUbwwzYCfaBQ+BVcAK8Bs6FC+AdcCXcAB+FO+Dz8DX4NjwKP4PnEIAQERqiihgiDMQF8UeikHiEj6xHipAKpAFpRbqRPuQmMorMIG9RGBQFRUcZomxRnqhQFAu1BrUeVYKqRh1GdaB6UTdRY6hZ1Ec0Ga2I1kfboL3QEegEdBa6EF2BbkK3oy+ib6Mn0K8xGAwNo42xwnhiIjFJmLWYEsw+TBvmHGYQM46Zw2Kx8lh9rB3WH8vECrCF2CrsUexZ7BB2AvsGR8Sp4Mxw7rgoHA+Xj6vAHcGdwQ3hJnELeCm8Jt4G749n43PwpfhGfDf+On4Cv0CQJmgT7AghhCTCJkIloZVwkfCA8JJIJKoRrYmBRC5xI7GSeIx4mThGfEuSIemRXEjRJCFpB+kQ6RzpLuklmUzWIjuSo8gC8g5yM/kC+RH5jQRFwkjCS4ItsUGiRqJDYkjiuSReUlPSSXK1ZK5kheQJyeuSM1J4KS0pFymm1HqpGqmTUiNSc9IUaVNpf+lU6RLpI9JXpKdksDJaMm4ybJkCmYMyF2TGKQhFneJCYVE2UxopFykTVAxVm+pFTaIWU7+jDlBnZWVkl8mGyWbL1sielh2lITQtmhcthVZKO04bpr1borTEaQlnyfYlrUuGlszLLZVzlOPIFcm1yd2WeydPl3eTT5bfJd8p/1ABpaCnEKiQpbBf4aLCzFLqUtulrKVFS48vvacIK+opBimuVTyo2K84p6Ss5KGUrlSldEFpRpmm7KicpFyufEZ5WoWiYq/CVSlXOavylC5Ld6Kn0CvpvfRZVUVVT1Whar3qgOqCmrZaqFq+WpvaQ3WCOkM9Xr1cvUd9VkNFw08jT6NF454mXpOhmai5V7NPc15LWytca6tWp9aUtpy2l3audov2Ax2yjoPOGp0GnVu6GF2GbrLuPt0berCehV6iXo3edX1Y31Kfq79Pf9AAbWBtwDNoMBgxJBk6GWYathiOGdGMfI3yjTqNnhtrGEcZ7zLuM/5oYmGSYtJoct9UxtTbNN+02/R3Mz0zllmN2S1zsrm7+QbzLvMXy/SXcZbtX3bHgmLhZ7HVosfig6WVJd+y1XLaSsMq1qrWaoRBZQQwShiXrdHWztYbrE9Zv7WxtBHYHLf5zdbQNtn2iO3Ucu3lnOWNy8ft1OyYdvV2o/Z0+1j7A/ajDqoOTIcGh8eO6o5sxybHSSddpySno07PnU2c+c7tzvMuNi7rXM65Iq4erkWuA24ybqFu1W6P3NXcE9xb3Gc9LDzWepzzRHv6eO7yHPFS8mJ5NXvNelt5r/Pu9SH5BPtU+zz21fPl+3b7wX7efrv9HqzQXMFb0ekP/L38d/s/DNAOWBPwYyAmMCCwJvBJkGlQXlBfMCU4JvhI8OsQ55DSkPuhOqHC0J4wybDosOaw+XDX8LLw0QjjiHUR1yIVIrmRXVHYqLCopqi5lW4r96yciLaILoweXqW9KnvVldUKq1NWn46RjGHGnIhFx4bHHol9z/RnNjDn4rziauNmWS6svaxnbEd2OXuaY8cp40zG28WXxU8l2CXsTphOdEisSJzhunCruS+SPJPqkuaT/ZMPJX9KCU9pS8Wlxqae5Mnwknm9acpp2WmD6frphemja2zW7Fkzy/fhN2VAGasyugRU0c9Uv1BHuEU4lmmfWZP5Jiss60S2dDYvuz9HL2d7zmSue+63a1FrWWt78lTzNuWNrXNaV78eWh+3vmeD+oaCDRMbPTYe3kTYlLzpp3yT/LL8V5vDN3cXKBVsLBjf4rGlpVCikF84stV2a9021DbutoHt5turtn8sYhddLTYprih+X8IqufqN6TeV33zaEb9joNSydP9OzE7ezuFdDrsOl0mX5ZaN7/bb3VFOLy8qf7UnZs+VimUVdXsJe4V7Ryt9K7uqNKp2Vr2vTqy+XeNc01arWLu9dn4fe9/Qfsf9rXVKdcV17w5wD9yp96jvaNBqqDiIOZh58EljWGPft4xvm5sUmoqbPhziHRo9HHS4t9mqufmI4pHSFrhF2DJ9NProje9cv+tqNWytb6O1FR8Dx4THnn4f+/3wcZ/jPScYJ1p/0Pyhtp3SXtQBdeR0zHYmdo52RXYNnvQ+2dNt293+o9GPh06pnqo5LXu69AzhTMGZT2dzz86dSz83cz7h/HhPTM/9CxEXbvUG9g5c9Ll4+ZL7pQt9Tn1nL9tdPnXF5srJq4yrndcsr3X0W/S3/2TxU/uA5UDHdavrXTesb3QPLh88M+QwdP6m681Lt7xuXbu94vbgcOjwnZHokdE77DtTd1PuvriXeW/h/sYH6AdFD6UeVjxSfNTws+7PbaOWo6fHXMf6Hwc/vj/OGn/2S8Yv7ycKnpCfVEyqTDZPmU2dmnafvvF05dOJZ+nPFmYKf5X+tfa5zvMffnP8rX82YnbiBf/Fp99LXsq/PPRq2aueuYC5R69TXy/MF72Rf3P4LeNt37vwd5MLWe+x7ys/6H7o/ujz8cGn1E+f/gUDmPP8atgFYAAAAAlwSFlzAAAOxAAADsQBlSsOGwAAAAl2cEFnAAAB9AAAAfQATLSjPAAAAAZiS0dEAP8A/wD/oL2nkwAAACV0RVh0ZGF0ZTpjcmVhdGUAMjAxMS0xMC0yNFQxMzozOToyNSswMDowMF0UNKAAAAAldEVYdGRhdGU6bW9kaWZ5ADIwMTEtMTAtMjRUMTM6Mzk6MjUrMDA6MDAsSYwcAAAAF3RFWHRwbmc6Yml0LWRlcHRoLXdyaXR0ZW4ACKfELPIAAAIoSURBVDhPhZM5aBRRGMf/c+ysmz0Vr3W9kCVqMESbKLhgaWElFpYiaGO1QuJRBBHUwsYUNiI2NhKVIIiFNiEIQU1jRC10N/FiPdjDXOvszM6M3/fynOy4K/5geI957/t/51M8ApKrjz9hdSwEQ1NhOy5s10PT8WhPK+35Zt1yMHRoCxRFETa+wMD9Im4+LSFqaMiujaA3E8WuTAy9G7rEmurShQGTHylg+GhW7P2/pu0gGdERCamYKZv4WDXx4GVZeLfocymCtxf7sXFlmO5p0gpQ5QpVhtRoeshlk/hluYiFdayKhrA+YQjxs6PT4k4rvgDjkJcEqd852YMTuTSqdVueAJqqwF0ul09AgC+V522cGy3iyuFt2LMphsWGI0+pYDLKVgICTHyFhutjJTx6VcGTfB9CmiI68i/aBNhLJmXgyI03ePe9jsKlvVRgl1rYHj7TJsBw5bkbXEiV0loTNyh/efgXbQLsjVOtDefQRzXYPvQcs/WmqE8nAgI8ddzn4uV9+DZrIXxqHCVaefo6dYBpEfCEZ/5GJn8gPTiB28d3onptP8YGdv+/jRYNEF/6Sh5P3yuge10E+bsF9FyYxHkaIJvOdZmG0yLkCxzoTuFzrYF5k/KlMPjxJKilbPK6tAhDV1CjWjycKiOdDC8ZEYHXWFmwMf7+J54V5zAxPYepLwv0MhUyVoVg/9Y4bh3bIUb7DwGBTnyomHgxsyR25uBm8SaWAX4DbfDnARMBjE8AAAAASUVORK5CYII='
    $logo = [System.Convert]::FromBase64String($logoBase64)
    $TreeViewItem_Expanded={
        PARAM (
            [Object]$sender,
            [Windows.RoutedEventArgs]$e
        )
        if(($sender.Items.Count -eq 1) -and ($sender.Items[0] -is [string])){
            $sender.Items.Clear()
            $expandedDir = $null
            if($sender.Tag -is [System.IO.DriveInfo]){
                $expandedDir = $sender.Tag.RootDirectory
            }
            if($sender.Tag -is [System.IO.DirectoryInfo]){
                $expandedDir = $sender.Tag
            }
            try{
                foreach($subDir in $expandedDir.GetDirectories()){
                    $isNotSystem = ($subDir.Attributes -band [IO.FileAttributes]::System) -ne [IO.FileAttributes]::System
                    #$isNotHidden = ($subDir.Attributes -band [IO.FileAttributes]::Hidden) -ne [IO.FileAttributes]::Hidden
                    #$isNotReparsePoint = ($subDir.Attributes -band [IO.FileAttributes]::ReparsePoint) -ne [IO.FileAttributes]::ReparsePoint
                    if ($isNotSystem){
                        $files = Get-File $subDir.FullName -Include *.ps1,*.psm1 
                        if ($files.Count){
                            $treeViewItem = CreateTreeItem $subDir
                            $stackPanel = New-Object Windows.Controls.StackPanel
                            $stackPanel.Orientation = "Horizontal"
                            $img = New-Object Windows.Controls.Image
                            $img.Source = $logo
                            $null = $stackPanel.Children.Add($img)
                            $tb = New-Object Windows.Controls.TextBlock
                            $tb.Text = " $($subDir.Name)"
                            $null = $stackPanel.Children.Add($tb)
                            $treeViewItem.Header = $stackPanel
                            $sender.Items.Add($treeViewItem)
                        }
                        else{
                            $subSubDirs = [IO.Directory]::GetDirectories($subDir.FullName)
                            foreach ($subSubDir in $subSubDirs){
                                $files = Get-File $subSubDir -Include *.ps1,*.psm1 
                                if ($files.Count){
                                    $treeViewItem = CreateTreeItem $subDir
                                    $stackPanel = New-Object Windows.Controls.StackPanel
                                    $stackPanel.Orientation = "Horizontal"
                                    $img = New-Object Windows.Controls.Image
                                    $img.Source = $logo
                                    $null = $stackPanel.Children.Add($img)
                                    $tb = New-Object Windows.Controls.TextBlock
                                    $tb.Text = " $($subDir.Name)"
                                    $null = $stackPanel.Children.Add($tb)
                                    $treeViewItem.Header = $stackPanel
                                    $sender.Items.Add($treeViewItem)
                                    break
                                }
                            }
                        }
                    }
                }
                $files = $expandedDir.GetFiles() | where {$_.Extension -eq ".ps1" -or $_.Extension -eq ".psm1"}
                foreach($file in $files){
                    $treeViewItem = New-Object Windows.Controls.TreeViewItem
                    $treeViewItem.Tag = $file.Fullname
                    $treeViewItem.Foreground =  (New-Object Windows.Media.SolidColorBrush ([Windows.Media.Colors]::DarkBlue))
                    $stackPanel = New-Object Windows.Controls.StackPanel
                    $stackPanel.Orientation = "Horizontal"
                    $ms = New-Object System.IO.MemoryStream
                    [System.Drawing.Icon]::ExtractAssociatedIcon($file.FullName).Save($ms)
                    $ibd = New-Object System.Windows.Media.Imaging.IconBitmapDecoder($ms,[Windows.Media.Imaging.BitmapCreateOptions]::None, [Windows.Media.Imaging.BitmapCacheOption]::Default)
                    $img = New-Object Windows.Controls.Image
                    $img.Source = $ibd.Frames[0]
                    $img.Height = 16
                    $null = $stackPanel.Children.Add($img)
                    $tb = New-Object Windows.Controls.TextBlock
                    $tb.Text = " $($file.Name)"
                    $null = $stackPanel.Children.Add($tb)
                    $treeViewItem.Header = $stackPanel
                    $sender.Items.Add($treeViewItem)
                }
            }
            catch { }
        }
    }

    function CreateTreeItem($info){
        $tvi = New-Object Windows.Controls.TreeViewItem
        $tvi.Header = $info.Name
        $tvi.Tag = $info
        $null = $tvi.Items.Add('Loading...')
        $null = $tvi.AddHandler([Windows.Controls.TreeViewItem]::ExpandedEvent,[Windows.RoutedEventHandler]$TreeViewItem_Expanded)
        $tvi
    }


    function Get-DriveItems{
        $drives = [System.IO.DriveInfo]::GetDrives()
        #foreach($driveInfo in $drives){
        $item = CreateTreeItem $drives[0]
        $item.IsExpanded = $true
        $item
        #}
    }

    $onSelectedItemChanged = {
        if ($_.NewValue.Tag -and (Test-Path $_.NewValue.Tag -PathType Leaf) ) {
            $psise.CurrentPowerShellTab.Files.Add([string]$_.NewValue.Tag)
        }
    }

    New-TreeView -Items ((Get-DriveItems)) -On_SelectedItemChanged $onSelectedItemChanged -FontSize ($psISE.Options.FontSize * ($psISE.Options.Zoom / 100.0)) 
}


$newISEMenu = {
    function Get-ShortcutKeys{
    $existingShortcuts = $psISE.CurrentPowerShellTab.AddOnsMenu.Submenus | foreach{
            $menu = $_.DisplayName
            if($_.Action){
                $currShortCut = ($_.ShortCut.Modifiers,$_.ShortCut.Key -join '+')
                $currShortCut.Replace(',','+') -replace '^\+',''
            }
            $_.SubMenus | foreach{
                $currShortCut = ($_.ShortCut.Modifiers,$_.ShortCut.Key -join '+')
                $currShortCut.Replace(',','+') -replace '^\+',''
            }
        } | where {$_ -ne ""}
        $existingShortcuts.replace('+ ','+')
    }
    New-Grid -AllowDrop:$true -Name "ISE Menu Creator" -columns Auto, * -rows Auto,Auto,Auto,Auto,*,Auto,Auto -Margin 5 {
        New-TextBox -Name Warning -Foreground Red -FontWeight Bold -Margin 5 -Column 1  -TextWrapping Wrap -IsReadOnly -Visibility Hidden
        ($comboMenus = New-ComboBox -Name comboMenus -Column 1 -Row ($Row=1) -Margin 5 -FontSize 14 `
            -Items (@("No parent menu")+($psISE.CurrentPowerShellTab.AddOnsMenu.Submenus | where {!$_.Action}).DisplayName) `
            -On_Loaded { $this.SelectedIndex = 0})
        New-Label "Addon _Parent Menu" -Target $comboMenus -Row $Row -FontWeight ([System.Windows.FontWeights]::Bold)
        ($txtName = New-TextBox -Name txtName -Column 1 -Row ($Row+=1) -Margin 5 -FontSize 16)
        New-Label "Addon Menu _Name" -Target $txtName -Row $Row -FontWeight ([System.Windows.FontWeights]::Bold)
        ($txtShortcut = New-TextBox -Name txtShortcut -Column 1 -Row ($Row+=1) -Margin 5 -FontSize 16 `
            -On_KeyDown { 
            function Get-CharFromKey($key){
                $MAPVK_VK_TO_VSC = 0x00
                $MAPVK_VSC_TO_VK = 0x01
                $MAPVK_VK_TO_CHAR = 0x02
                $MAPVK_VSC_TO_VK_EX = 0x03

    $kbstate_sig = @'
[DllImport("user32.dll", CharSet=CharSet.Auto)]
public static extern int GetKeyboardState(byte[] keystate);
'@

    $mapchar_sig = @'
[DllImport("user32.dll", CharSet=CharSet.Auto)]
public static extern int MapVirtualKey(uint uCode, int uMapType);
'@

    $tounicode_sig = @'
[DllImport("user32.dll", CharSet=CharSet.Auto)]
public static extern int ToUnicode(uint wVirtKey, uint wScanCode, byte[] lpkeystate, System.Text.StringBuilder pwszBuff, int cchBuff, uint wFlags);
'@

                $getKBState = Add-Type -MemberDefinition $kbstate_sig -name "Win32MyGetKeyboardState" -namespace Win32Functions -passThru
                $getKey = Add-Type -MemberDefinition $mapchar_sig -name "Win32MyMapVirtualKey" -namespace Win32Functions -passThru
                $getUnicode = Add-Type -MemberDefinition $tounicode_sig -name "Win32MyToUnicode" -namespace Win32Functions -passThru
                $char = ' '
                $virtualKey = [System.Windows.Input.KeyInterop]::VirtualKeyFromKey($key)
                $keyboardState = New-Object Byte[] 256
                [void]$getKBState::GetKeyboardState($keyboardState)
                $scanCode = $getKey::MapVirtualKey($virtualKey, $MAPVK_VK_TO_VSC)
                $stringBuilder = New-Object System.Text.StringBuilder(2)
                $result = $getUnicode::ToUnicode($virtualKey, $scanCode, $keyboardState, $stringBuilder, $stringBuilder.Capacity, 0)
                switch ($result){
                        {$_ -eq 0 -or $_ -eq -1} { break }
                        1                        { $ch = $stringBuilder[0];break }
                        default                  { $ch = $stringBuilder[0];break }
                     }
                     return $ch
            }
            $char = (Get-CharFromKey ([System.Windows.Input.Key]$_.Key)) 
            if ($char -eq $null){ 
                $char = ([string]$_.Key).Replace('Left','').Replace('Right','').Replace('System','Alt')
            }
            if($this.Text -eq "") { $this.Text = ([string]$char).ToUpper() }
            else{ $this.Text = ($this.Text + "+" + ([string]$char).ToUpper()) -replace '\+\s?\+','+' }
            $_.Handled = $true
            })
        New-Label "Shortcut _Key" -Row $Row -Target $txtShortcut -FontWeight ([System.Windows.FontWeights]::Bold) 
        ($txtScriptBlock = New-TextBox -Name txtScriptBlock -Margin 5 -Column 1 -FontSize 16 -Row ($Row+=1) -MinHeight 141 -AcceptsReturn:$true -HorizontalScrollBarVisibility Auto -VerticalScrollBarVisibility Auto)
        New-Label "Script _Block" -Row $Row -Target $txtScriptBlock -FontWeight ([System.Windows.FontWeights]::Bold)
        New-CheckBox "_Add to ISE Profile" -Name chkProfile -Row ($Row+=1)
        New-StackPanel -Orientation Horizontal  -Column 1 -Row ($Row+=1) -HorizontalAlignment Right -Margin 5 {
            New-Button "_Save" -Name btnSave -Width 75 -Margin "0,0,5,0" -IsDefault -On_Click {
                $txtName = $this.Parent.Parent.Children | where {$_.Name -eq "txtName"} 
                $txtShortcut = $this.Parent.Parent.Children | where {$_.Name -eq "txtShortcut"} 
                $txtScriptBlock = $this.Parent.Parent.Children | where {$_.Name -eq "txtScriptBlock"} 
                $Warning = $this.Parent.Parent.Children | where {$_.Name -eq "Warning"} 
                $chkProfile = $this.Parent.Parent.Children | where {$_.Name -eq "chkProfile"} 
                $comboMenus = $this.Parent.Parent.Children | where {$_.Name -eq "comboMenus"} 
                if ($comboMenus.SelectedValue -ne 'No parent menu'){
                    $menuItems = ($psise.CurrentPowerShellTab.AddOnsMenu.Submenus | where {$_.DisplayName -eq $comboMenus.SelectedValue}).SubMenus.DisplayName
                }else{
                    $menuItems = $psise.CurrentPowerShellTab.AddOnsMenu.Submenus | Select -ExpandProperty DisplayName
                }
                if ($menuItems -Contains $txtName.Text) {
                    $Warning.Text = "The name for the menu is already present"
                    $Warning.Visibility = "Visible"
                    return
                }         
                if ($comboMenus.SelectedValue -ne 'No parent menu'){
                    $menu = $psISE.CurrentPowerShellTab.AddOnsMenu.SubMenus | where {$_.DisplayName -eq $comboMenus.SelectedValue}
                }
                else{
                    $menu = $psISE.CurrentPowerShellTab.AddOnsMenu
                }   
                if($txtShortcut.Text.Trim() -eq ""){ $shortCut = $null } 
                else { $shortCut = $txtShortcut.Text }
                try {
                    if($txtScriptBlock.Text.Trim() -eq ""){ $scriptBlock = $null } else { $scriptBlock = [ScriptBlock]::Create($txtScriptBlock.Text) }
                    $menu.SubMenus.Add($txtName.Text,$scriptBlock,$shortCut) | Out-Null
                    $Warning.Text = "Menu item has been created"
                    $Warning.Visibility = "Visible"
                }
                catch {
                    $Warning.Text = "Error Creating MenuItem:`n$_"
                    $Warning.Visibility = "Visible"
                    return
                }
                if ($chkProfile.IsChecked) {
                    $profileText = "`n`#Added by ISE Menu Creator Addon if (`$psISE) { `$psISE.CurrentPowerShellTab.AddOnsMenu.SubMenus.Add(`"$($txtName.Text)`",`{$ScriptBlock`},`"$($txtShortcut.Text)`") | Out-Null } "
                    Add-Content -Path $profile -Value $profileText
                }
            }  
            New-Button "Close" -Name btnCancel -Width 75 -On_Click{ ($psISE.CurrentPowerShellTab.VerticalAddOnTools | where{$_.Name -eq 'New-IseMenu'}).IsVisible=$false }                                                                                                      
        }
    } 
}

$newISESnippet={
 function New-ISESnippet{
        [CmdletBinding()]
        param(

            [Parameter(Mandatory=$true, Position=0)]
            [String]
            $Title,
        
            [Parameter(Mandatory=$true, Position=1)]
            [String]
            $Description,
        
            [Parameter(Mandatory=$true, Position=2)]
            [String]
            $Text,

            [String]
            $Author,

            [Int32]
            [ValidateRange(0, [Int32]::MaxValue)]
            $CaretOffset = 0,

            [Switch]
            $Force
        )

        Begin
        {
            $snippetPath = "$env:USERPROFILE\Documents\WindowsPowerShell\Snippets"
            if($Text.IndexOf("]]>") -ne -1)
            {
                throw [Microsoft.PowerShell.Host.ISE.SnippetStrings]::SnippetsNoCloseCData -f "Text","]]>"
            }

            if (-not (Test-Path $snippetPath))
            {
                $null = mkdir $snippetPath
            }
        }

        End
        {
            $snippet = @"
<?xml version='1.0' encoding='utf-8' ?>
    <Snippets  xmlns='http://schemas.microsoft.com/PowerShell/Snippets'>
        <Snippet Version='1.0.0'>
            <Header>
                <Title>$([System.Security.SecurityElement]::Escape($Title))</Title>
                <Description>$([System.Security.SecurityElement]::Escape($Description))</Description>
                <Author>$([System.Security.SecurityElement]::Escape($Author))</Author>
                <SnippetTypes>
                    <SnippetType>Expansion</SnippetType>
                </SnippetTypes>
            </Header>

            <Code>
                <Script Language='PowerShell' CaretOffset='$CaretOffset'>
                    <![CDATA[$Text]]>
                </Script>
            </Code>

    </Snippet>
</Snippets>

"@

            $pathCharacters = '/\`*?[]:><"|.';
            $fileName=new-object text.stringBuilder
            for($ix=0; $ix -lt $Title.Length; $ix++)
            {
                $titleChar=$Title[$ix]
                if($pathCharacters.IndexOf($titleChar) -ne -1)
                {
                    $titleChar = "_"
                }

                $null = $fileName.Append($titleChar)
            }

            $params = @{
                FilePath = "$snippetPath\$fileName.snippets.ps1xml";
                Encoding = "UTF8"
            }

            if ($Force)
            {
                $params["Force"] = $true
            }
            else
            {
                $params["NoClobber"] = $true
            }

            $snippet | Out-File @params

            $psise.CurrentPowerShellTab.Snippets.Load($params["FilePath"])
        }
    }

    New-Grid -AllowDrop:$true -Name "addon" -columns Auto, * -rows Auto,Auto,Auto,*,Auto,Auto,Auto -Margin 5 {
        New-TextBox -Name Warning -Foreground Red -FontWeight Bold -Margin 5 -Column 1  -TextWrapping Wrap -IsReadOnly -Visibility Hidden
        ($txtTitle = New-TextBox -Name txtTitle -Column 1 -Row ($Row=1) -Margin 5 -FontSize 16)
        New-Label "_Title*" -Target $txtTitle -Row $Row -FontWeight ([System.Windows.FontWeights]::Bold)
        ($txtDescription = New-TextBox -Name txtDescription -Column 1 -Row ($Row+=1) -Margin 5 -FontSize 16)
        New-Label "_Description*" -Row $Row -Target $txtDescription -FontWeight ([System.Windows.FontWeights]::Bold) 
        ($txtCode = New-TextBox -Name txtCode -Margin 5 -Column 1 -FontSize 16 -Row ($Row+=1) -MinHeight 141 `
           -AcceptsReturn:$true -HorizontalScrollBarVisibility Auto -VerticalScrollBarVisibility Auto `
           -On_TextChanged{
                $caretOffset = $this.Text.IndexOf('^')
                if ($caretOffset -ne -1){
                    ($this.Parent.Children | where {$_.Name -eq 'txtCaretOffset'}).Text = $caretOffset
                }
                else{
                    ($this.Parent.Children | where {$_.Name -eq 'txtCaretOffset'}).Text = ""
                }
           }-On_Loaded{
                $this.Text = $psise.CurrentPowerShellTab.Files.SelectedFile.Editor.SelectedText
           }
        )
        New-Label "_Code*" -Row $Row -Target $txtCode -FontWeight ([System.Windows.FontWeights]::Bold)
        ($txtCaretOffset = New-TextBox -Name txtCaretOffset -Text $caretOffset -Margin 5 -Column 1 -FontSize 16 `
            -Row ($Row+=1) -On_TextChanged{
                if ($this.Text.Trim() -ne ""){
                    $txtCode = $this.Parent.Children | where {$_.Name -eq 'txtCode'}
                    $warning = $this.Parent.Children | where {$_.Name -eq 'Warning'}
                    $currCode = $txtCode.Text
                    if ($currCode.Length -gt $this.Text){
                        $currCaretPos = $currCode.IndexOf('^')
                        if ($currCaretPos -ne -1){
                            $currCode = $txtCode.Text.Remove($currCaretPos,1)
                        }
                        $txtCode.Text = $currCode.Insert([int]($this.Text),'^')
                        $warning.Visibility = "Hidden"
                    }
                    else{
                        $warning = $this.Parent.Children | where {$_.Name -eq 'Warning'}
                        $warning.Visibility = "Visible"
                        $warning.Text = "CaretOffset needs to be within boundaries of code"
                    }
                }
           }-On_Loaded{
                $code = $psise.CurrentPowerShellTab.Files.SelectedFile.Editor.SelectedText
                if ($code){
                    $caretOffset = $code.IndexOf('^')
                    if ($caretOffset -eq -1){
                        $caretOffset = ""
                    }
                    $this.Text = $caretOffset
                } 
           })
        New-Label "CaretOffse_t (marked`nby'^' within code)" -Row $Row -Target $txtCaretOffset -FontWeight ([System.Windows.FontWeights]::Bold)
        ($txtAuthor = New-TextBox -Name txtAuthor -Text $env:USERNAME -Margin 5 -Column 1 -FontSize 16 -Row ($Row+=1))
        New-Label "_Author" -Row $Row -Target $txtAuthor -FontWeight ([System.Windows.FontWeights]::Bold)
        New-CheckBox "_Force overwrite" -Name chkForce -Row ($Row+=1) -Visibility Hidden
        New-StackPanel -Orientation Horizontal  -Column 1 -Row ($Row+=1) -HorizontalAlignment Right -Margin 5 {
            New-Button "_Save" -Name btnSave -Width 75 -Margin "0,0,5,0" -IsDefault -On_Click {
                foreach($name in ('txtTitle','txtDescription','txtCode','txtCaretOffset','txtAuthor','Warning','chkForce')){
                    New-Variable $name -Value ($this.Parent.Parent.Children | where {$_.Name -eq $name})
                }
                if ($txtTitle.Text.Trim() -eq "" -or $txtDescription.Text.Trim() -eq "" -or $txtCode.Text.Trim() -eq ""){
                    $Warning.Text = "Title, Description and Code are mandatory. Please provide values."
                    $Warning.Visibility = "Visible"
                    return
                }
                $code = $txtCode.Text
                $caretOffset = $txtCaretOffset.Text
                $htParams=@{}
                if ($txtCaretOffset.Text.Trim() -ne ""){
                    $code = $code.Remove($caretOffSet,1)
                    $htParams.Add('CaretOffset',$caretOffset)
                }
                if ($txtAuthor.Text.Trim() -ne ""){
                    $htParams.Add('Author',$txtAuthor.Text)
                }
               
                try {
                    New-IseSnippet @htParams -Title $txtTitle.Text -Text $code -description $txtDescription.Text 
                    $warning.Visibility = "Visible"
                    $warning.Text = "Added new Snippet"
                }
                catch {
                    if(!$chkForce.IsChecked){
                        $message = "`n$($_.exception.message)`n`nPlease indicate by using the checkbox if you want to force an overwrite."
                        $Warning.Text = $message
                        $Warning.Visibility = 'Visible'
                        $chkForce.Visibility = 'Visible'
                    }
                    elseif($chkForce.IsChecked -and $chkForce.Visibility -eq 'Visible'){
                        New-IseSnippet @htParams -Title $txtTitle.Text -Text $code -description $txtDescription.Text -Force
                        $warning.Visibility = "Visible"
                        $warning.Text = "Added new Snippet"
                        $chkForce.Visibility = 'Hidden'
                    }
                }
            }    
            New-Button "Close" -Name btnCancel -Width 75 -On_Click{ ($psISE.CurrentPowerShellTab.VerticalAddOnTools | where{$_.Name -eq 'New-IseSnippet'}).IsVisible=$false }                                               
        }
    } 
}

#to create the dll for the Add-on

$dllPath = "$(Split-Path $PSScriptRoot -Parent)\resources\ISEUtils.dll"
$classes = "NewISEMenu","NewISESnippet","FileTree","AddScriptHelp"
$namespace = "ISEUtils"
ConvertTo-ISEAddOn -ScriptBlock ($newISEMenu,$newISESnippet,$fileTree,$addScriptHelp) -NameSpace $namespace -DLLPath $dllPath -class $classes


#paramters for ConvertTo-ISEAddOn to generate add-on dynamically (for testing purpose)
#ConvertTo-ISEAddOn -ScriptBlock $newISEMenu -AddVertically -Visible -DisplayName "MyISE-Add-On$num" -addMenu
