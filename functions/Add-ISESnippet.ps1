function Add-ISESnippet{
<#
.Synopsis
   Helper function to add a new ISE snippet
.DESCRIPTION
   Wrapper around New-ISESnippet that automaticcaly adds the author based on $env:USERNAME and the CaretOffset based on the positon of the char '^' within the text
.PARAMETER Title
    Title of the snippet.
.PARAMETER Description
    Description of the snippet.
.PARAMETER Text
    Body of the snippet.
.EXAMPLE
    $txt=@"
    [PSCustomObject][ordered]@{
    ^
    }
    "@
    Add-ISESnippet -Title PSCustomObject -Description "PSCustomObject" -Text $txt -Force
#>
    [CmdletBinding()]
    param(
        [Parameter(Mandatory=$true)]
        $Title,
        [Parameter(Mandatory=$true)]
        $Description,
        [Parameter(Mandatory=$true)]
        $Text,[switch]$force 
    )
    $caretOffset = $text.IndexOf('^')
    if ($caretOffset -ne -1){
        $text = $text.Remove($caretOffSet,1)
        $PSBoundParameters.Add('CaretOffset',$caretOffset)
    }
    $PSBoundParameters.Add('Author',$env:USERNAME)
    New-IseSnippet @$PSBoundParameters
}
