# Expand-Alias

## SYNOPSIS
Function to expand aliases either in the currently active ISE file 
or (in case a a path is provided) within any PowerShell file (that way the function can be also used from the PowerShell Console) to their respective definitions.

## SYNTAX

### Text (Default)
```
Expand-Alias [[-code] <Object>]
```

### Path
```
Expand-Alias -path <Object>
```

## DESCRIPTION
Aliases are very useful when working interactively, since they help saving extra keystrokes when you just want to get things done fast. 
At the same time if we are speaking about production code where readability,
and easy comprehension of the code are much more important the usage of aliases should be avoided.
With the Expand-Alias function you can get the best of both worlds.
Writing clearer code while avoiding extraneous keystrokes.

## EXAMPLES

### -------------------------- EXAMPLE 1 --------------------------
```
#Expand all alieases within the active ISE tab
```

Expand-Alias

### -------------------------- EXAMPLE 2 --------------------------
```
#Expand all aliases within the file specified
```

Expand-Alias -Path c:\scripts\ps1\test.ps1

## PARAMETERS

### -code
First parameter set for the usage within the ISE.
Defaults to $psISE.CurrentFile.Editor.Text

```yaml
Type: Object
Parameter Sets: Text
Aliases: 

Required: False
Position: 1
Default value: $psISE.CurrentFile.Editor.Text
Accept pipeline input: False
Accept wildcard characters: False
```

### -path
Second parameter set for the expansion of aliases within PowerShell files.
Specifies the path to the file within which the aliases are to be expanded.

```yaml
Type: Object
Parameter Sets: Path
Aliases: 

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

## INPUTS

## OUTPUTS

## NOTES

## RELATED LINKS

[https://powershellone.wordpress.com/2015/10/07/expanding-aliases-in-powershell-ise-or-any-powershell-file/](https://powershellone.wordpress.com/2015/10/07/expanding-aliases-in-powershell-ise-or-any-powershell-file/)

