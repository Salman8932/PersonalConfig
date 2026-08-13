$ErrorActionPreference = "Stop"

Write-Host "`n=== Windows Development Bootstrap ===" -ForegroundColor Cyan

# ============================================================
# Scoop
# ============================================================

if (-not (Get-Command scoop -ErrorAction SilentlyContinue)) {
    Write-Host "Scoop not found. Installing..." -ForegroundColor Yellow

    Set-ExecutionPolicy RemoteSigned -Scope CurrentUser -Force
    Invoke-RestMethod https://get.scoop.sh | Invoke-Expression

    # Refresh PATH after installing Scoop
    $env:Path = [Environment]::GetEnvironmentVariable("Path", "Machine") + ";" +
                [Environment]::GetEnvironmentVariable("Path", "User")
}

if (-not (scoop bucket list | Select-String "^extras")) {
    Write-Host "Adding Scoop Extras bucket..." -ForegroundColor Yellow
    scoop bucket add extras
}

# ============================================================
# Helper
# ============================================================

function Install-ScoopPackage {
    param (
        [Parameter(Mandatory)]
        [string]$Name,

        [Parameter(Mandatory)]
        [string]$Command
    )

    if (-not (Get-Command $Command -ErrorAction SilentlyContinue)) {
        Write-Host "$Command not found. Installing $Name..." -ForegroundColor Yellow
        scoop install $Name
    }
    else {
        Write-Host "$Command already installed." -ForegroundColor Green
    }
}

# ============================================================
# Dependencies
# ============================================================

Write-Host "`n=== Dependencies ===" -ForegroundColor Cyan

# Git



# Python
# Windows may expose a fake Python executable through
# the Microsoft Store App Execution Alias.
$python = Get-Command python -ErrorAction SilentlyContinue

if (-not $python -or $python.Source -like "*WindowsApps*") {
    Write-Host "Real Python not found. Installing Python..." -ForegroundColor Yellow
    scoop install python
}
else {
    Write-Host "Python already installed." -ForegroundColor Green
}

# Build tools
Install-ScoopPackage "make" "make"
Install-ScoopPackage "gcc" "gcc"

# Node.js / npm
Install-ScoopPackage "nodejs" "node"

# Neovim utilities
Install-ScoopPackage "ripgrep" "rg"
Install-ScoopPackage "fd" "fd"

# SumatraPDF
Install-ScoopPackage "sumatrapdf" "sumatrapdf"

# ============================================================
# Refresh PATH
# ============================================================

Write-Host "`n=== Refreshing PATH ===" -ForegroundColor Cyan

$env:Path = [Environment]::GetEnvironmentVariable("Path", "Machine") + ";" +
            [Environment]::GetEnvironmentVariable("Path", "User")

# ============================================================
# Python / pynvim
# ============================================================

Write-Host "`n=== Python Provider ===" -ForegroundColor Cyan

$python = Get-Command python -ErrorAction SilentlyContinue

if (-not $python) {
    Write-Error "Python could not be found after installation."
    exit 1
}

Write-Host "Python: $($python.Source)" -ForegroundColor Green

try {
    python -c "import pynvim" 2>$null

    if ($LASTEXITCODE -eq 0) {
        Write-Host "pynvim already installed." -ForegroundColor Green
    }
    else {
        throw
    }
}
catch {
    Write-Host "pynvim not found. Installing..." -ForegroundColor Yellow
    python -m pip install --upgrade pynvim
}

# ============================================================
# Yazi file(1) support
# ============================================================

Write-Host "`n=== Yazi ===" -ForegroundColor Cyan

$yaziFileOne = "$env:USERPROFILE\scoop\apps\git\current\usr\bin\file.exe"

if (-not (Test-Path $yaziFileOne)) {
 $YaziFileOne = "C:\Program Files\Git\usr\bin\file.exe"
 Write-Host "Git not installed from scoop, redirecting..." -ForegroundColor Yellow
}

if (Test-path $yaziFileOne) {
    Write-Host "Found file.exe." .. "At path $yaziFileOne" -ForegroundColor Green

    # Current session
    $env:YAZI_FILE_ONE = $yaziFileOne

    # Permanent user environment variable
    [Environment]::SetEnvironmentVariable(
        "YAZI_FILE_ONE",
        $yaziFileOne,
        "User"
    )

    Write-Host "YAZI_FILE_ONE configured." -ForegroundColor Green
}
else {
    Write-Warning "Git's file.exe was not found:"
    Write-Warning $yaziFileOne
}

# ============================================================
# Copy Neovim configuration
# ============================================================

Write-Host "`n=== Installing Neovim configuration ===" -ForegroundColor Cyan

$nvimSource = Join-Path $PSScriptRoot "nvim"
$nvimTarget = Join-Path $env:LOCALAPPDATA "nvim"

if (Test-Path $nvimSource) {

    New-Item -ItemType Directory -Path $nvimTarget -Force | Out-Null

    Copy-Item `
        -Path "$nvimSource\*" `
        -Destination $nvimTarget `
        -Recurse `
        -Force

    Write-Host "Neovim configuration copied." -ForegroundColor Green
}
else {
    Write-Warning "Neovim configuration folder not found:"
    Write-Warning $nvimSource
}

# ============================================================
# Copy PowerShell configuration
# ============================================================

Write-Host "`n=== Installing PowerShell configuration ===" -ForegroundColor Cyan

$psSource = Join-Path $PSScriptRoot "powershell"
$psTarget = Split-Path $PROFILE

if (Test-Path $psSource) {

    New-Item -ItemType Directory -Path $psTarget -Force | Out-Null

    Copy-Item `
        -Path "$psSource\*" `
        -Destination $psTarget `
        -Recurse `
        -Force

    Write-Host "PowerShell configuration copied." -ForegroundColor Green
}
else {
    Write-Warning "PowerShell configuration folder not found:"
    Write-Warning $psSource
}

# ============================================================
# Verification
# ============================================================

Write-Host "`n=== Verification ===" -ForegroundColor Cyan

$commands = @(
    "git",
    "python",
    "pip",
    "make",
    "gcc",
    "node",
    "npm",
    "rg",
    "fd",
    "sumatrapdf"
)

foreach ($command in $commands) {

    if (Get-Command $command -ErrorAction SilentlyContinue) {
        Write-Host "[OK] $command" -ForegroundColor Green
    }
    else {
        Write-Host "[MISSING] $command" -ForegroundColor Red
    }
}

# ============================================================
# Done
# ============================================================

Write-Host "`n============================================" -ForegroundColor Cyan
Write-Host " Bootstrap complete!" -ForegroundColor Green
Write-Host "============================================" -ForegroundColor Cyan

Write-Host "`nRestart your terminal before launching Neovim/Yazi."
