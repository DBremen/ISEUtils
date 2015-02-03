#based on function from James Brundage
function ConvertTo-ISEAddOn
{
    [CmdletBinding(DefaultParameterSetName="CreateOnly")]
    param(
    [Parameter(Mandatory=$true,
        ParameterSetName="DisplayNow")]
    [string]$DisplayName,

    [Parameter(Mandatory=$true,
        ParameterSetName="CreateOnly")]
    [Parameter(Mandatory=$true,
        ParameterSetName="DisplayNow")]
    [ScriptBlock[]]
    $ScriptBlock,

    [Parameter(Mandatory=$true,
        ParameterSetName="CreateOnly")]
    $DLLPath,

    [Parameter(Mandatory=$true,
        ParameterSetName="CreateOnly")]
    $Namespace,

    [Parameter(Mandatory=$true,
        ParameterSetName="CreateOnly")]
    [string[]]$Class,

    [Parameter(ParameterSetName="DisplayNow")]
    [switch]
    $AddVertically,

    [Parameter(ParameterSetName="DisplayNow")]
    [switch]
    $AddHorizontally,

    [Parameter(Mandatory=$true,
        ParameterSetName="DisplayNow")]
    [switch]
    $Visible,

    [Parameter(Mandatory=$true,
        ParameterSetName="DisplayNow")]
    [switch]
    $addMenu


    )

    begin {
        if ($psVersionTable.PSVersion -lt "3.0") {
            Write-Warning "Ise Window Add ons were not added until version 3.0."
            return
        }
    }

    process {
        $Class = @($Class)
        $addOnNumber = Get-Random
        $addOnTypeStart =@"
$(if ($PSCmdlet.ParameterSetName -eq 'CreateOnly'){
    "namespace $Namespace"
}else{
    "namespace ISEAddOn"
})
{
    using System;
    using System.Collections.ObjectModel;
    using System.ComponentModel;
    using System.Management.Automation;
    using System.Management.Automation.Runspaces;
    using System.Windows;
    using System.Windows.Controls;
    using System.Windows.Data;
    using Microsoft.PowerShell.Host.ISE;
    using System.Collections.Generic;
    using System.Windows.Input;
    using System.Text;

"@
    $index=0
    $(foreach ($currSB in $ScriptBlock){
        $addOnTypeMiddle+=@"
    $(if ($PSCmdlet.ParameterSetName -eq 'CreateOnly'){
        "public class $($Class[$index]) : UserControl, IAddOnToolHostObject"
    }else{
        "public class IseAddOn${addOnNumber} : UserControl, IAddOnToolHostObject"
    })
    {

        ObjectModelRoot hostObject;
            
        #region IAddOnToolHostObject Members

        public ObjectModelRoot HostObject
        {
            get
            {
                return this.hostObject;
            }
            set
            {
                this.hostObject = value;
                this.hostObject.CurrentPowerShellTab.PropertyChanged += new PropertyChangedEventHandler(CurrentPowerShellTab_PropertyChanged);


                Run();
            }
        }

        private void CurrentPowerShellTab_PropertyChanged(object sender, PropertyChangedEventArgs e)
        {
            if (e.PropertyName == "CanInvoke" && this.hostObject.CurrentPowerShellTab.CanInvoke)
            {
                if (this.Content != null && this.Content is UIElement ) {                     
                    (this.Content as UIElement).IsEnabled = true; 
                }
            } else {
                if (this.Content != null && this.Content is UIElement) { 
                    (this.Content as UIElement).IsEnabled = true; 
                }
            }
        }
        $(if ($PSCmdlet.ParameterSetName -eq 'CreateOnly'){
            "public $($Class[$index])() { }"
        }else{
            "public IseAddOn${addOnNumber}() { }"
        })

        public void Run() {
            if (Runspace.DefaultRunspace == null ||
                Runspace.DefaultRunspace.ApartmentState != System.Threading.ApartmentState.STA ||
                Runspace.DefaultRunspace.ThreadOptions != PSThreadOptions.UseCurrentThread) {
                InitialSessionState iss = InitialSessionState.CreateDefault();
                iss.ImportPSModule(new string[] { "ShowUI" });
                Runspace rs  = RunspaceFactory.CreateRunspace(iss);
                rs.ApartmentState = System.Threading.ApartmentState.STA;
                rs.ThreadOptions = PSThreadOptions.UseCurrentThread;
                rs.Open();
                rs.SessionStateProxy.SetVariable("psise", HostObject);
                Runspace.DefaultRunspace = rs;
            }
            
            PowerShell psCmd = PowerShell.Create().AddScript(@"
$($currSB.ToString().Replace('"','""'))
");
            psCmd.Runspace = Runspace.DefaultRunspace;
            try { 
                this.Content = psCmd.Invoke<UIElement>()[0];                 
            } catch { 
            } 
            
        }        
        
        #endregion
    }
"@
$index++
})
        $addOnType=$addOnTypeStart + $addOnTypeMiddle + "}"
        $presentationFramework = [System.Windows.Window].Assembly.FullName
        $presentationCore = [System.Windows.UIElement].Assembly.FullName
        $windowsBase=[System.Windows.DependencyObject].Assembly.FullName
        $gPowerShell=[Microsoft.PowerShell.Host.ISE.PowerShellTab].Assembly.FullName
        $systemXaml=[system.xaml.xamlreader].Assembly.FullName
        $systemManagementAutomation=[psobject].Assembly.FullName
        if ($PSCmdlet.ParameterSetName -eq 'CreateOnly'){
            Add-Type -TypeDefinition $addOnType -ReferencedAssemblies $systemManagementAutomation,$presentationFramework,$presentationCore,$windowsBase,$gPowerShell,$systemXaml -ignorewarnings -OutputAssembly $DLLPath -OutputType Library
            return 
        }
        else{
            $t = add-type -TypeDefinition $addOnType -ReferencedAssemblies $systemManagementAutomation,$presentationFramework,$presentationCore,$windowsBase,$gPowerShell,$systemXaml -ignorewarnings -PassThru 
            if ($AddHorizontally) {
                $psISE.CurrentPowerShellTab.HorizontalAddOnTools.Add("$displayName",$t,$true)
            } 
            elseif ($addVertically) {
                $psISE.CurrentPowerShellTab.VerticalAddOnTools.Add("$displayName",$t,$true)
            } 
            if($addMenu){
                $name="ISEAddon$addonNumber"
                $sb = [scriptblock]::Create('$psISE.CurrentPowerShellTab.VerticalAddOnTools.Add("' + $name + '",[ISEAddon.ISEAddon' + $addonNumber + '],$true);($psISE.CurrentPowerShellTab.VerticalAddOnTools | where {$_.Name -eq "' + $name + '"}).IsVisible=$true')
                $psISE.CurrentPowerShellTab.AddOnsMenu.Submenus.Add($name, $sb, $null)
            }
        }     
    }
}