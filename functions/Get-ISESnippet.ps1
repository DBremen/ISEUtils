function Get-ISESnippet{
<#
.Synopsis
   Get all ISE Snippets with all their properties
.DESCRIPTION
   Improvement of the built-in Get-ISESnippet cmdlet. This function retrieves the information out of the xml files
   that are stored within the default snippets folder
.EXAMPLE
   Get-ISESnippet
#>
    [CmdletBinding()]
    $snippetFiles = Get-ChildItem (Join-Path (Split-Path $profile.CurrentUserCurrentHost) "Snippets") -File -Recurse
    foreach ($snippetFile in $snippetFiles){
        $snippetXML = [xml](Get-Content $snippetFile.FullName -Raw)
        $snippetXML | 
            select @{n='Version'; e={$_.Snippets.Snippet.Version}}, @{n='Description';e={$_.Snippets.Snippet.Header.Description}},`
                @{n='Title';e={$_.Snippets.Snippet.Header.Title}}, @{n='Author';e={$_.Header.Snippets.Snippet.Author}},`
                @{n='Language';e={$_.Snippets.Snippet.Code.Script.Language}}, @{n='CaretOffset';e={$_.Snippets.Snippet.Code.Script.CaretOffset}},`
                @{n='Code';e={$_.Snippets.Snippet.Code.Script.'#cdata-section'}}, @{n='Path'; e={$snippetFile.FullName}}       
    }
}
