function Export-SelectionToRTF{
    <#
    .Synopsis
       Export the current selected text within ISE as .rtf file
    .DESCRIPTION
       The current selected text within ISE is exported as .rtf file. The path is determined by a SaveFileDialog.
       The function returns the path the rtf file.
    .EXAMPLE
       Export-SelectionToRTF
    #>
    [CmdletBinding()]
    param()
    $text = $psise.CurrentFile.Editor.SelectedText
    if (-not $text) {
        Write-Warning 'No text selected'
        return
    }
    [void][Reflection.Assembly]::LoadWithPartialName("System.Windows.Forms")
    $SaveFileDialog = New-Object Windows.Forms.SaveFileDialog
    $SaveFileDialog.Filter = "Rich text files (*.rtf)|*.rtf"
    $SaveFileDialog.InitialDirectory = $env:USERPROFILE
    if ($SaveFileDialog.ShowDialog() -eq [Windows.Forms.DialogResult]::OK){ 
        $rtfPath = $SaveFileDialog.FileName 
    }
    else{
        exit
    }
    $bindingFlags = [Reflection.BindingFlags]::IgnoreCase -bor [Reflection.BindingFlags]::Instance -bor [Reflection.BindingFlags]::Static -bor [Reflection.BindingFlags]::Public -bor [Reflection.BindingFlags]::NonPublic -bor [Reflection.BindingFlags]::FlattenHierarchy -bor [Reflection.BindingFlags]::InvokeMethod -bor [Reflection.BindingFlags]::CreateInstance -bor [Reflection.BindingFlags]::GetField -bor [Reflection.BindingFlags]::SetField -bor [Reflection.BindingFlags]::GetProperty -bor [Reflection.BindingFlags]::SetProperty
    $editor = $psise.CurrentPowerShellTab.Files.SelectedFile.Editor
    $editorOperations = $editor.GetType().GetProperty('EditorOperations',$bindingFlags).GetValue($editor, $null)
    $textView = $editorOperations.GetType().GetField('_textView', $bindingFlags).GetValue($editorOperations)
    $type = $editorOperations.GetType()
    $generateRTF = $type.GetMethod('GenerateRTF', $bindingFlags,$null,$textView.Selection.SelectedSpans.GetType(),$null)
    $src=
    @"
    using System.Windows.Forms;
    using System.Windows.Threading;
    using System.Reflection;
    using Microsoft.VisualStudio.Text;
    using Microsoft.VisualStudio.Text.Editor;
    using Microsoft.VisualStudio.Text.Operations;
    using Microsoft.VisualStudio.Text.EditorOptions.Implementation;

    namespace DispatchHelper
    {
        public class Dispatch
        {

            public MethodInfo method;
            public object delegateObject;
            public NormalizedSnapshotSpanCollection parameter;
            public Dispatcher dispatcher;
            public string rtf;

            public void InvokeDispatcher(){
       
                DispatcherFrame frame = new DispatcherFrame();
                dispatcher.BeginInvoke(DispatcherPriority.Normal,
                    new DispatcherOperationCallback(DelegateMethod),frame);
                Dispatcher.PushFrame(frame);
            }

            public object DelegateMethod(object f){
                DispatcherFrame df = ((DispatcherFrame)f);
                rtf = method.Invoke( delegateObject, (object[])new NormalizedSnapshotSpanCollection[1]
                        {
                            parameter
                        }
                ) as string;
                df.Continue = false;
                return null;
            }
        }
    }
"@
    if (-not ([Management.Automation.PSTypeName]'DispatchHelper.Dispatch').Type){
        Add-Type $src -ReferencedAssemblies WindowsBase,System.Windows.Forms,Microsoft.PowerShell.Editor
    
    }
    $dispatch = New-Object DispatchHelper.Dispatch
    $dispatch.dispatcher = $textView.Dispatcher
    $dispatch.method = $generateRTF
    $dispatch.delegateObject = $editorOperations
    $dispatch.parameter = $textView.Selection.SelectedSpans
    $dispatch.InvokeDispatcher()
    $dispatch.rtf | Out-File $rtfPath -Encoding ascii
    $rtfPath
}