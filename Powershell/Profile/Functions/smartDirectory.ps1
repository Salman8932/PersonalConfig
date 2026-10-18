

function ccd {
<#
.SYNOPSIS
    Quickly navigate to frequent academic and personal folders.
.DESCRIPTION
    Maps short keywords like 'nus', 'int', and 'ps' to absolute folder paths
    and changes the terminal's location safely using -LiteralPath validation.
.PARAMETER Target
    The short nickname of the folder you want to jump into (e.g., nus, int, ps).
.EXAMPLE
    ccd nus
    Jumps directly to your NUS Year 1 Semester 1 folder.
.NOTES
    Make sure to run `.$profile` if you add new shortcut keys to the dictionary.
#>

    param(
        [Parameter(Mandatory=$true)]
        [string]$Target
    )

    $PathMap = @{
        "nus" = "$HOME\Documents\NUS\Y1S1"
        "int" = "$HOME\Documents\Interests"
	"pconf" = "$Home\Documents\PersonalConfig"
    }

  	# Check if what the user typed matches a key in our dictionary
      if ($PathMap.ContainsKey($Target)) {
        $wd = $PathMap[$Target]
        if (Test-Path -LiteralPath $wd -PathType Container) {
            Set-Location -LiteralPath (Resolve-Path -LiteralPath $wd).Path
        }
    }
      else {
        # Custom clean error message
        Write-Warning "Shortcut '$Target' not found."
        Write-Host "Available shortcuts: $(($PathMap.Keys) -join ', ')" -ForegroundColor Cyan
    }
}
