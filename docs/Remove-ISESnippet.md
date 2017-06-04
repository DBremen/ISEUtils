# Remove-ISESnippet

## SYNOPSIS
Remove ISE Snippets (deletes the related xml files)

## SYNTAX

### Set2
```
Remove-ISESnippet [-Path <Object>] [-selectFromGridView] [-Title <Object>] [-WhatIf] [-Confirm]
```

### Set1
```
Remove-ISESnippet -Path <Object> -Title <Object> [-WhatIf] [-Confirm]
```

## DESCRIPTION
Function to remove ISE snippets files.
Accepts input from Get-ISESnippet.
Or opens GridView with all snippets for selection.

## EXAMPLES

### -------------------------- EXAMPLE 1 --------------------------
```
Remove-ISESnippet -selectFromGridView -WhatIf
```

## PARAMETERS

### -Path
{{Fill Path Description}}

```yaml
Type: Object
Parameter Sets: Set2
Aliases: 

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

```yaml
Type: Object
Parameter Sets: Set1
Aliases: 

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -selectFromGridView
{{Fill selectFromGridView Description}}

```yaml
Type: SwitchParameter
Parameter Sets: Set2
Aliases: 

Required: False
Position: Named
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

### -Title
{{Fill Title Description}}

```yaml
Type: Object
Parameter Sets: Set2
Aliases: 

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

```yaml
Type: Object
Parameter Sets: Set1
Aliases: 

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -WhatIf
Shows what would happen if the cmdlet runs.
The cmdlet is not run.

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases: wi

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Confirm
Prompts you for confirmation before running the cmdlet.

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases: cf

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

## INPUTS

## OUTPUTS

## NOTES

## RELATED LINKS

