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

    if (($LASTEXITCODE -eq 0) -or (Get-Command $Name -ErrorAction SilentlyContinue)) {
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
Install-ScoopPackage "nvim" "nvim"
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
Install-PythonPackage "ipython"
Install-PythonPackage "micro-editor"

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
# Configuration Helper
# ============================================================

function Deploy-ConfigFile {
    param (
        [Parameter(Mandatory)]
        [string]$CONFIG_FILE,
	
        [Parameter(Mandatory)]
        [string]$NAME
    )

  Write-Host "`n=== Installing"  "$NAME"  "configuration ===" -ForegroundColor Cyan
$REPO_CONFIG= "$PSScriptRoot\"
$LOCAL_CONFIG = $null

switch($CONFIG_FILE) {
"nvim" {
	$LOCAL_CONFIG = "$env:LOCALAPPDATA" + $CONFIG_FIlE
	$REPO_CONFIG = $REPO_CONFIG + $CONFIG_FIlE
	break
 }

"yazi" {
	$LOCAL_CONFIG = "$env:AppData\yazi\config\yazi.toml"
	$REPO_CONFIG = $REPO_CONFIG + "yazi.toml"
	break
 }
"pwsh" {
	$LOCAL_CONFIG = Split-Path $PROFILE
	$REPO_CONFIG = $REPO_CONFIG + "powershell"
	break
 }
}

if (-not (Test-Path $REPO_CONFIG)) {
    Write-Warning "$NAME" + " configuration folder not found:"
    Write-Warning "$REPO_CONFIG"
}

else {

if (($LOCAL_CONFIG -ne $null) -and (Test-Path $LOCAL_CONFIG)){

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



}

#Copy Neovim Configuration
Deploy-ConfigFile "nvim" "Neovim"

#Copy Yazi Configuration
Deploy-ConfigFile "yazi" "Yazi"

#Copy Powershell configuration
Deploy-ConfigFile "pwsh" "PowerShell"
# ============================================================
# Copy PowerShell configuration
# ============================================================


<#
write-host "`n=== installing powershell configuration ===" -foregroundcolor cyan

$pssource = join-path $psscriptroot "powershell"
$pstarget = split-path $profile

if (test-path $pssource) {

    new-item -itemtype directory -path $pstarget -force | out-null

    copy-item ` -path "$pssource\*" `
        -destination $pstarget `
        -recurse `
        -force

    write-host "powershell configuration copied." -foregroundcolor green
}
else {
    write-warning "powershell configuration folder not found:"
    write-warning $pssource
}
#>

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
    "isort",
    "prettier",
    "ipython",
    "nvim",
    "micro"`
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
