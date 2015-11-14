#https://github.com/madskristensen/zencoding
#https://zen-coding.googlecode.com/files/ZenCodingCheatSheet.pdf
function Get-ZenCode{
       <#    
    .SYNOPSIS
        zen Coding with PowerShell
    .DESCRIPTION
        Extension of zenCoding from WebEssentials for Visual Studio with PowerShell 
pipeline support. Can be used to expand zenCoding expressions within PowerShell ISE
    .PARAMETER zenCodeExpr
        The zenCode expression to be expanded
    .PARAMETER InputObject
        Optional pipeline input to be fed into the zenCodeExpr
    .EXAMPLE
        1..3 | zenCode 'html>head>title{test}+body>ul>li{[string]$_ + " someText " + $_}' -show
    .EXAMPLE
        gps | zenCode 'html>head>title+body>table>tr>th{name}+th{ID}^(tr>td{$_.name}+td{$_.id})' -show
    .LINK
        https://github.com/madskristensen/zencoding
        https://zen-coding.googlecode.com/files/ZenCodingCheatSheet.pdf
    .NOTES 
        CREATED:  (Get-Date).ToShortDateString()
        AUTHOR      :  Dirk
        Tags<>:     :
	    Changelog:    
	      -----------------------------------------------------------------------------
                                           
	      Name          Date         Description        
	      -----------------------------------------------------------------------------

	      -----------------------------------------------------------------------------
    #>
    [Alias("zenCode")]
    [CmdletBinding()]
    Param
    (
        [Parameter(Mandatory=$true,
                   Position=0)]
        $zenCodeExpr,
        [Parameter(ValueFromPipeline=$true,
                   Position=1)]
        $InputObject,

        [Parameter(Position=2)]
        $outPath="",

        [Parameter(Position=3)]
        [switch]$show
    )
    if (-not ([Management.Automation.PSTypeName]'ZenCoding.HtmlParser').Type)
    {
        Add-Type -Path "$(Split-Path $PSScriptRoot -Parent)\resources\ZenCoding.dll" 
    }
    Add-Type -AssemblyName System.Web
    $allData = @($Input)
    if ($allData){
        $closingCurlyPositions = ([regex]::Matches($zenCodeExpr,'\$_.*?(?=\})(})')).Groups | 
            where {$_.Value -eq '}'} | select -ExpandProperty Index | sort -Descending
        $txtWithinCurlies = [regex]::Matches($zenCodeExpr,'(?<=\{).*?(?=\})')
        
        $pipelineVars = @([regex]::Matches($zenCodeExpr,'(\$_(\.\w+)*)')) 
        $firstIndex = ($pipelineVars | sort index | select -first 1).Index
        $pipelineVars = $pipelineVars | select -ExpandProperty Value
        $txtWithinCurlies = $txtWithinCurlies | select -ExpandProperty Value
        $txtWithinCurliesCount = $txtWithinCurlies | group -AsHashTable -AsString
        #if the expression contains a table, no unqualified pipelinVar ($_) and no headers, add the headers based on the property names
        if ($zenCodeExpr -like '*table*' -and $pipelineVars -notcontains '$_' -and $zenCodeExpr -notlike '*>th*'){
            $headerIndex = ([regex]::Matches($zenCodeExpr,'(?<=\>)table.*?(>)').Groups | 
                where {$_.Value -eq '>' -and $_.Index -lt $firstIndex} | 
                sort Index -Descending).Index + 1
            $headerExpr = 'tr>'
            $headerExpr += (($pipelineVars.SubString(3) | foreach { "th{$_}"}) -join '+') + '^'
            $zenCodeExpr = $zenCodeExpr.Insert($headerIndex,$headerExpr)
            $firstIndex += $headerExpr.Length
        }
        $txtWithinCurlies = $txtWithinCurlies.Trim() | where {$_ -like '*$_*'} | Get-Unique
        $pipelineVars=$pipelineVars.Trim() | Get-Unique
        $htReplacements = @{}
        #foreach ($curlyPos in $closingCurlyPositions){
         #   $zenCodeExpr = $zenCodeExpr.Insert($curlyPos+1,"*$($allData.count)")
        #}
        #add the multiplier and wrap the expression into parenthesis
        $zenCodeExpr = $zenCodeExpr.Insert($zenCodeExpr.Substring(0,$firstIndex).LastIndexOf('>')+1,'(')
        $zenCodeExpr += ")*$($allData.count)"
        foreach ($var in $txtWithinCurlies){
            $guid = [guid]::NewGuid().Guid + '_'
            $htReplacements.Add($guid,$var)
            $zenCodeExpr = $zenCodeExpr -Replace ([regex]::Escape($var) + '\b') ,($guid + '$')
        }
    }
    $zenCodeParser = New-Object ZenCoding.HtmlParser
    $txt = $zenCodeParser.Parse($zenCodeExpr)
    $i=1
    foreach ($item in $allData){
        foreach ($replacement in $htReplacements.GetEnumerator()) { 
            #cannot rely on zencoding numbering therefore use remove/insert instead of replacing all unique instances
            $sb = [scriptblock]::Create($replacement.Value.Replace('$_','$item'))
            $value=$sb.Invoke()
            #do once for each instance of the placeholder within the template
            $count = $txtWithinCurliesCount[$replacement.Value].Count
            for($j=0;$j -lt $count;$j++){
                $firstIndex = $txt.IndexOf($replacement.Key)
                #if the value is an array add a nested table with all its values
                if ($value.Count -gt 1){
                    $searchTxt = $txt.Substring(0,$firstIndex)
                    $startIndex = $searchTxt.LastIndexOf('<')+1
                    $enclosingTag = $searchTxt.Substring($startIndex,$searchTxt.LastIndexOf('>')-$startIndex)
                    #object, insert nested table with headers based on properties
                    if($value | Get-Member CreateObjRef -MemberType Method){
                        $tableExpr = 'table>tr>'
                        $props = ($value | Get-Member | where {$_.MemberType -like '*Property'}).Name
                        $tableExpr += (($props | foreach { "th{$_}"}) -join '+') + '^'
                        $tableExpr += '(tr>' + (($props | foreach { 'td{$_.' + "$_}" }) -join '+') + ')'
                        $replacementStr = $value | zenCode $tableExpr
                    }
                    #values handle according to enclosingtag
                    elseif($enclosingTag -eq 'td'){
                        $replacementStr = $value | zenCode 'table>(tr>td{$_})'
                    }
                    #li assume ul
                    elseif ($enclosingTag -eq 'li'){
                        $expr = 'ul{' + $replacement.Value.Replace('$_.','') + '}>(li{$_})'
                        $replacementStr = $value | zenCode $expr
                    }
                    #just repeat the element and indent the texst
                    else{
                        $expr = '(' + $enclosingTag + '[style=margin-left:2em]{$_})' 
                        $replacementStr = $value | zenCode $expr
                    }

                    $txt=$txt.Remove($firstIndex,$replacement.Key.Length+1).Insert($firstIndex,$replacementStr)
                }
                else{
                    $txt=$txt.Remove($firstIndex,$replacement.Key.Length+1).Insert($firstIndex,$value)
                }
            }
        }
        $i++
    }
    #apply indentation
    $tempRoot = $false
    #hex values do not work in xml
    $escapedTxt= $txt.Replace('0x','hex').Replace('&','&amp;')
    try{
        [xml]$xml=$escapedTxt
    }
    catch{
        #missing unique root element, insert 
        [xml]$xml = "<tempRoot>$escapedTxt</tempRoot>"
        $tempRoot = $true
    }
    $StringWriter = New-Object IO.StringWriter 
    $settings = New-Object XML.XmlWriterSettings
    $settings.Indent = $true
    $settings.IndentChars = "`t"
    $settings.OmitXmlDeclaration = $true
    $XmlWriter = [XMl.XmlTextWriter]::Create($stringWriter,$settings) 
    $xml.WriteContentTo($XmlWriter) 
    $XmlWriter.Flush() 
    $StringWriter.Flush() 
    #remove the root element 
    if ($tempRoot){
        $output = ($StringWriter.ToString() -replace '(?m)\s*</*tempRoot>\s*?','').Trim() -replace '(?m)^\t{1}',''
    }
    else{
        $output = $StringWriter.ToString()
    }
    #create a temp file if show flag is set and no outPath was provided
    if ($show -and $outPath -eq ""){
       $outPath=[IO.Path]::GetTempFileName().Replace('.tmp','.html')
    }
    if ($outPath -ne ""){
        $output | Set-Content $outPath 
    }
    else{
        $output
    }
    if ($show){
        Invoke-Item $outPath
    }
} 

#example uses:


#show piped input
#1..3 | zenCode 'html>head>title{test}+body>ul>li{[string]$_ + " someText " + $_}' -show
#5..1 | zenCode 'ul>li.item{$_}'

#display properties as table
#gps | zenCode 'html>head>title+body>table>tr>th{name}+th{ID}^(tr>td{$_.name}+td{$_.id})' -show

#display properties as list
#gps | zenCode 'html>head>title{test}+body>ul{$_.Name}>li{$_.Company}+li{$_.Path}' -show

#display properties as indented within parent element
#gps | zenCode 'html>head>title{test}+body>div{$_.Name}+div{$_.ID}+div{$_.Modules.ModuleName}' -show


#display nested properties (as nested table)
#gps | zenCode 'html>head>title+body>table[border=1]>tr>th{name}+th{ID}+th{Module.ModuleName}^(tr>td{$_.name}+td{$_.id})+td{$_.Modules.ModuleName}' -show

#display nested properties (as nested table) + column headings based on property names
#gps | zenCode 'html>head>title+body>table[border=1]>(tr>td{$_.Name}+td{$_.ID})+td{$_.Modules.ModuleName}' -show

#also works for lists
#gps | zenCode 'html>head>title{test}+body>ul{$_.Name}>li{$_.Company}+li{$_.Modules.ModuleName}' -show

#expand nested object properties
#gps | select -first 10 | zenCode 'html>head>title+body>table[border=1]>(tr>td{$_.Name}+td{$_.ID})+td{$_.Modules}' -show

#expanded properties area always shown wihtin a table
#gps | select -First 10| zenCode 'html>head>title{test}+body>div{$_.Name}+div{$_.ID}+div{$_.Modules}' -show

#filter expression within 'scriptblocks'
#gps | select -first 10 | zenCode 'html>head>title+body>table[border=1]>(tr>td{$_.Name}+td{$_.ID})+td{$_.Modules | select -first 10}' -show




#zenCode 'p*4>lorem>.test>a' 
#zenCode 'ul[data-bind="foreach:customers"]>li*4>span{Caption $$}+input[type=text data-bind="value:$$"]'

<#
zenCode 'html:5'
zenCode 'a'
zenCode 'script:src'
zenCode 'script[src=blabla]'
zenCode 'img'
zenCode '.class>.class2'
zenCode 'div>ul>li*4'
zenCode 'div+p+bq'
zenCode 'div+div>p>span+em'
zencode 'div+div>p>span+em^bq'
zencode 'div>(header>ul>li*2>a)+footer>p'
zencode 'div#header+div.page+div#footer.class1.class2.class3'
zencode 'td[colspan title]'
zencode 'ul>li.item$*5'
zenCode 'a>{click}+b{here}'
zenCode 'ul>li{item $}*5'
zencode 'ul.generic-list>(li.item>lorem10)*4'
zencode lorem3*10
zencode 'table+'
#>

#empty image placeholder placehold.it
<#
place-150x240-EEEDDD with color 
place-50
place-150x240
#>

#image placeholder lorempixel.com
<#
pix-200-sports
#>



