# Add-ISESnippet

## SYNOPSIS
Helper function to add a new ISE snippet

## SYNTAX

```
Add-ISESnippet [-Title] <Object> [-Description] <Object> [-Text] <Object> [-force]
```

## DESCRIPTION
Wrapper around New-ISESnippet that automaticcaly adds the author based on $env:USERNAME and the CaretOffset based on the positon of the char '^' within the text

## EXAMPLES

### -------------------------- EXAMPLE 1 --------------------------
```
$txt=@"
```

\[PSCustomObject\]\[ordered\]@{
^
}
"@
Add-ISESnippet -Title PSCustomObject -Description "PSCustomObject" -Text $txt -Force

## PARAMETERS

### -Title
Title of the snippet.

```yaml
Type: Object
Parameter Sets: (All)
Aliases: 

Required: True
Position: 1
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Description
Description of the snippet.

```yaml
Type: Object
Parameter Sets: (All)
Aliases: 

Required: True
Position: 2
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Text
Body of the snippet.

```yaml
Type: Object
Parameter Sets: (All)
Aliases: 

Required: True
Position: 3
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -force
{{Fill force Description}}

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases: 

Required: False
Position: Named
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

## INPUTS

## OUTPUTS

## NOTES

## RELATED LINKS

