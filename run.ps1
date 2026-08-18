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

function Install-PythonPackage {
    param (
        [Parameter(Mandatory)]
        [string]$Name
    )

    python -c "import $Name" 2>$null

    if ($LASTEXITCODE -eq 0) {
        Write-Host "$Name already installed." -ForegroundColor Green
    }
    else {
        Write-Host "$Name not found. Installing..." -ForegroundColor Yellow
        python -m pip install --upgrade $Name
    }
}

# ============================================================
# Dependencies
# ============================================================

Write-Host "`n=== Dependencies ===" -ForegroundColor Cyan

# Git



# Python
# Windows may expose a
#
# fake Python executable through
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

#Latex and Perl
Install-ScoopPackage "latex" "pdflatex"
Install-ScoopPackage "perl" "perl"

# SumatraPDF
Install-ScoopPackage "sumatrapdf" "sumatrapdf"

#Format and LSP
Install-ScoopPackage "stylua" "stylua"



if (Get-Command prettier -ErrorAction SilentlyContinue) {
    Write-Host "Prettier already installed." -ForegroundColor Green
}
else {
    Write-Host "Prettier not found. Installing..." -ForegroundColor Yellow
    npm install -g prettier
}

if (-not (Get-Module -ListAvailable -Name PSScriptAnalyzer)) {

    Write-Host "Installing PSScriptAnalyzer..." -ForegroundColor Cyan

    if ((Get-PSRepository -Name PSGallery).InstallationPolicy -ne "Trusted") {
        Set-PSRepository -Name PSGallery -InstallationPolicy Trusted
    }

    Install-Module PSScriptAnalyzer -Scope CurrentUser -Force
}
else {
    Write-Host "PSScriptAnalyzer already installed." -ForegroundColor Green
}

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

Install-PythonPackage "pynvim"
Install-PythonPackage "black"
Install-PythonPackage "isort"

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

function Deploy-ConfigFile {
    param (
        [Parameter(Mandatory)]
        [string]$CONFIG_FILE,
	
        [Parameter(Mandatory)]
        [string]$NAME
    )
Write-Host "`n=== Installing " + $NAME + " configuration ===" -ForegroundColor Cyan

$REPO_CONFIG= "$PSScriptRoot\" + $CONFIG_FILE
$LOCAL_CONFIG= "$env:LOCALAPPDATA" + $CONFIG_FIlE

if (-not (Test-Path $REPO_CONFIG)) {
    Write-Warning "$NAME" + " configuration folder not found:"
    Write-Warning "$REPO_CONFIG"
}

else {

if (Test-Path $LOCAL_CONFIG){

	Write-Host "Existing " + $NAME + " configuration found." -ForegroundColor Yellow

	$PATH_ITEM = Get-Item $LOCAL_CONFIG -Force

	if ($PATH_ITEM.Linktype) {
		#Already a symlink
		Write-Host "Existing symlink found. Removing it..." -ForegroundColor Yellow

		Remove-Item $LOCAL_CONFIG -Force
	}

	else {
		#Normal directory
		$BACKUP_CONFIG = "$LOCAL_CONFIG.backup"
		Write-Host "Existing directory found." -ForegroundColor Yellow
		Write-Host "Backing it up to $BACKUP_CONFIG"

	# If an old backup exists, don't overwrite it
        if (Test-Path $BACKUP_CONFIG) {
            Write-Warning "Backup already exists: $BACKUP_CONFIG"
            Write-Warning "Merging"
        }

        Rename-Item $LOCAL_CONFIG $BACKUP_CONFIG -Force
	}
     }

     New-Item `
     	-ItemType SymbolicLink `
	-Path $LOCAL_CONFIG `
	-TARGET $REPO_CONFIG `
	| Out-Null

     Write-Host $NAME + " configuration linked." -ForegroundColor Green
}


  Write-Host "`n=== Installing " + "$NAME" + " configuration ===" -ForegroundColor Cyan

}

Deploy-ConfigFile "nvim" "Neovim"
<#
$NVIM_REPO_CONFIG= "$PSScriptRoot\nvim"
$NVIM_LOCAL_CONFIG= "$env:LOCALAPPDATA\nvim"

if (-not (Test-Path $NVIM_REPO_CONFIG)) {
    Write-Warning "Neovim configuration folder not found:"
    Write-Warning "$NVIM_REPO_CONFIG"
}

else {

if (Test-Path $NVIM_LOCAL_CONFIG){

	Write-Host "Existing Neovim configuration found." -ForegroundColor Yellow

	$NVIM_PATH_ITEM = Get-Item $NVIM_LOCAL_CONFIG -Force

	if ($NVIM_PATH_ITEM.Linktype) {
		#Already a symlink
		Write-Host "Existing symlink found. Removing it..." -ForegroundColor Yellow

		Remove-Item $NVIM_LOCAL_CONFIG -Force
	}

	else {
		#Normal directory
		$BACKUP_NVIM_CONFIG = "$NVIM_LOCAL_CONFIG.backup"
		Write-Host "Existing directory found." -ForegroundColor Yellow
		Write-Host "Backing it up to $BACKUP_NVIM_CONFIG"

	# If an old backup exists, don't overwrite it
        if (Test-Path $BACKUP_NVIM_CONFIG) {
            Write-Warning "Backup already exists: $BACKUP_NVIM_CONFIG"
            Write-Warning "Merging"
        }

        Rename-Item $NVIM_LOCAL_CONFIG $BACKUP_NVIM_CONFIG -Force
	}
     }

     New-Item `
     	-ItemType SymbolicLink `
	-Path $NVIM_LOCAL_CONFIG `
	-TARGET $NVIM_REPO_CONFIG `
	| Out-Null

     Write-Host "Neovim configuration linked." -ForegroundColor Green
}
#>

# ============================================================
# Copy PowerShell configuration
# ============================================================

Write-Host "`n=== Installing PowerShell configuration ===" -ForegroundColor Cyan

$psSource = Join-Path $PSScriptRoot "powershell"
$psTarget = Split-Path $PROFILE

if (Test-Path $psSource) {

    New-Item -ItemType Directory -Path $psTarget -Force | Out-Null

    Copy-Item ` -Path "$psSource\*" `
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
    "sumatrapdf",
    "stylua"
    "black",
    "isort"
    "prettier"`
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
