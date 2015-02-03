function Remove-ISESnippet{
<#
.Synopsis
   Remove ISE Snippets (deletes the related xml files)
.DESCRIPTION
   Function to remove ISE snippets files. Accepts input from Get-ISESnippet. Or opens GridView with all snippets for selection.
.EXAMPLE
   Remove-ISESnippet -selectFromGridView -WhatIf
#>
    [CmdletBinding(
        SupportsShouldProcess=$true,
        ConfirmImpact="High"
    )]
    param(
         [Parameter(Mandatory=$true,ValueFromPipelineByPropertyName=$true,Position=0,ParameterSetName='Set1')]
         [Parameter(ParameterSetName='Set2')]
         $Path,
         [Parameter(ParameterSetName='Set2')]
         [switch]$selectFromGridView,
         [Parameter(ParameterSetName='Set2')]
         [Parameter(Mandatory=$true,ValueFromPipelineByPropertyName=$true,ParameterSetName='Set1')]
         $Title
    )
    BEGIN{
        if ($selectFromGridView){
            Get-IseSnippet | Out-GridView -PassThru | Remove-ISESnippet
        }
    }
    PROCESS{
        if($Path){
            if($PSCmdlet.ShouldProcess("$Title","Deleting Snippet")) {
               Remove-Item $path
            }
        }
    }  
}