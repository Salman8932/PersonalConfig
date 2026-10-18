$env:EDITOR = "nvim"
$env:VISUAL = "nvim"

function refreshpath {
    $env:Path = [System.Environment]::ExpandEnvironmentVariables(
        [System.Environment]::GetEnvironmentVariable("Path","Machine") + ";" + 
        [System.Environment]::GetEnvironmentVariable("Path","User")
    )
    Write-Host "Environment PATH successfully reloaded!" -ForegroundColor Green
}
