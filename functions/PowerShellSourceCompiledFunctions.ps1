. "$(Split-Path $PSScriptRoot -Parent)\resources\ConvertTo-ISEAddOn.ps1"

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
        ($txtScriptBlock = New-TextBox -Name txtScriptBlock -Margin 5 -Column 1 -FontSize 16 -Row ($Row+=1) -MinHeight 141 -MinWidth 336 -AcceptsReturn:$true -HorizontalScrollBarVisibility Auto -VerticalScrollBarVisibility Auto)
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
           -MinWidth 336 -AcceptsReturn:$true -HorizontalScrollBarVisibility Auto -VerticalScrollBarVisibility Auto `
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
                $caretOffset = $code.IndexOf('^')
                if ($caretOffset -eq -1){
                    $caretOffset = ""
                }
                $this.Text = $caretOffset
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
<#
$dllPath = "$(Split-Path $PSScriptRoot -Parent)\resources\ISEUtils.dll"
$classes = "NewISEMenu","NewISESnippet"
$namespace = "ISEUtils"
ConvertTo-ISEAddOn -ScriptBlock ($newISEMenu,$newISESnippet) -NameSpace $namespace -DLLPath $dllPath -class $classes
#>

#paramters for ConvertTo-ISEAddOn to generate add-on dynamically (for testing purpose)
ConvertTo-ISEAddOn -ScriptBlock $newISEMenu -AddVertically -Visible -DisplayName "MyISE-Add-On$num" -addMenu
