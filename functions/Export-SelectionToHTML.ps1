function Export-SelectionToHTML{
    <#
    .Synopsis
       Export the current selected text within ISE as .html file
    .DESCRIPTION
       The current selected text within ISE is exported as .html file. The path is determined by a SaveFileDialog.
       The function returns the path the html file.
    .EXAMPLE
       Export-SelectionToHTML
    #>
    [void][Reflection.Assembly]::LoadWithPartialName("System.Windows.Forms")
    $SaveFileDialog = New-Object Windows.Forms.SaveFileDialog
    $SaveFileDialog.Filter = "HTML files (*.html)|*.html"
    $SaveFileDialog.InitialDirectory = $env:USERPROFILE
    if ($SaveFileDialog.ShowDialog() -eq [Windows.Forms.DialogResult]::OK){ 
        $htmlPath = $SaveFileDialog.FileName 
    }
    else{
        exit
    }
    $text = $psise.CurrentFile.Editor.SelectedText
    if (-not $text) {
        Write-Warning 'No text selected'
        return
    }

    $errors = $null
    $tokens = [Management.Automation.PsParser]::Tokenize($text,[ref]$errors)
    if ($errors) {
        $errors
        #return
    }
    $sb = New-Object Text.StringBuilder
    $null = $sb.Append("<pre>")
    $lastToken = $null
    foreach ($token in $tokens){
        $spaces = " " * ($token.Start - ($lastToken.Start + $lastToken.Length))
        $null = $sb.Append($spaces)
        if ($token.Type -eq 'NewLine') {
           $null = $sb.Append("`n")
        } 
        else {
            $block = [Web.HttpUtility]::HtmlEncode($text.SubString($token.start, $token.length))
            $color = $psise.Options.TokenColors[$token.Type]
            $red = "{0:x2}" -f $color.R
            $green = "{0:x2}" -f $color.G
            $blue= "{0:x2}" -f $color.B
            $color = "#$red$green$blue"
            $null = $sb.Append("<span style='color:$color'>$block</span>")
        }
        $lastToken = $token
    }
    $null = $sb.Append("</pre>")
    $html=@"
<!DOCTYPE html []>
<html>
	<head>
		<title></title>
		<meta http-equiv="content-type" content="text/html;charset=UTF-8" />
	</head>
	<body>
		$($sb.ToString())
	</body>
</html>
"@
    $html | Out-File $htmlPath -Encoding ascii
    $htmlPath
}

