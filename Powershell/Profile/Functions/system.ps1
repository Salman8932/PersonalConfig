function Set-Course {
    param([string]$CourseName)
    New-Item -ItemType SymbolicLink -Path "$HOME\current_course" -Target "$HOME\courses\$CourseName" -Force | Out-Null
    Write-Host "Switched course to: $CourseName"
}

function Set-CourseHere {
    $CurrentDir = (Get-Location).Path
    New-Item -ItemType SymbolicLink -Path "$HOME\current_course" -Target $CurrentDir -Force | Out-Null
    Write-Host "Switched course to: $CurrentDir"
}
