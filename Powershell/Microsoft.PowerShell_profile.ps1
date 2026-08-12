#Load functions
Get-ChildItem "$PSScriptRoot\Profile\Functions\*.ps1" | ForEach-Object {. $_.FullName}

#Load aliases
. "$PSScriptRoot\Profile\aliases.ps1"

#Load Prompt
. "$PSScriptRoot\Profile\prompt.ps1"

#Load environment variables
. "$PSScriptRoot\Profile\env.ps1"
