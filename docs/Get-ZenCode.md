# Get-ZenCode

## SYNOPSIS
Zen Coding for PowerShell

## SYNTAX

```
Get-ZenCode [-ZenCodeExpression] <Object> [[-InputObject] <Object>] [[-outPath] <Object>] [-show]
```

## DESCRIPTION
Extension of zenCoding from WebEssentials for Visual Studio with PowerShell 
pipeline support.
Can be used to expand zenCoding expressions within PowerShell ISE
First of all let's clarify what Zen Coding actually is.
According to their website: Emmet (formerly known as Zen Coding) is
a web-developer's toolkit that can greatly improve your HTML & CSS workflow.
But what does this have to do with PowerShell?
At least I find myself quite often trying to convert PowerShell output into HTML 
or even using the text manipulation capabilities of PowerShell to dynamically construct some static web content. 
Yes, I hear you shouting already isn't that why we have ConvertTo-HTML and Here-Strings? 
Granted that those can make the job already pretty easy, 
but there is still an even better way to (dynamically) generate static HTML pages from within PowerShell.

## EXAMPLES

### -------------------------- EXAMPLE 1 --------------------------
```
head>title{test}+body>ul>li{[string]$_ + " someText " + $_}' -show
```

### -------------------------- EXAMPLE 2 --------------------------
```
head>title+body>table>tr>th{name}+th{ID}^(tr>td{$_.name}+td{$_.id})' -show
```

## PARAMETERS

### -ZenCodeExpression
The zenCode expression to be expanded

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

### -InputObject
Optional pipeline input to be fed into the ZenCodeExpression

```yaml
Type: Object
Parameter Sets: (All)
Aliases: 

Required: False
Position: 2
Default value: None
Accept pipeline input: True (ByValue)
Accept wildcard characters: False
```

### -outPath
{{Fill outPath Description}}

```yaml
Type: Object
Parameter Sets: (All)
Aliases: 

Required: False
Position: 3
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -show
{{Fill show Description}}

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases: 

Required: False
Position: 4
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

## INPUTS

## OUTPUTS

## NOTES

## RELATED LINKS

[https://powershellone.wordpress.com/2015/11/09/zen-coding-for-the-powershell-console-and-ise/](https://powershellone.wordpress.com/2015/11/09/zen-coding-for-the-powershell-console-and-ise/)

[https://github.com/madskristensen/zencoding](https://github.com/madskristensen/zencoding)

[https://zen-coding.googlecode.com/files/ZenCodingCheatSheet.pdf](https://zen-coding.googlecode.com/files/ZenCodingCheatSheet.pdf)

