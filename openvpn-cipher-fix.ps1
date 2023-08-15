<#
.SYNOPSIS
  <Overview of script>
.DESCRIPTION
  Openvpn releases past 2.5 don't work by default with the AES-256-CBC cipher. This will allow you to add this into your openvpn config file programmatically to fix it.
.PARAMETER <Parameter_Name>
    <Brief description of parameter input required. Repeat this attribute if required>
.INPUTS
  <Inputs if any, otherwise state None>
.OUTPUTS
  <Outputs if any, otherwise state None - example: Log file stored in C:\Windows\Temp\<name>.log>
.NOTES
  Version:        1.0
  Author:         Jason Johnson
  Creation Date:  8.15.2023
  Purpose/Change: Initial script development
  
.EXAMPLE
  <Example goes here. Repeat this attribute for more than one example>
#>

# You can hardcode the path here if you want. For example: "C:\path\to\your\file.txt"
$filename = ""

# Function to add line after match
function Add-LineAfterMatch {
    param(
        [string]$path,
        [string]$match = 'cipher',
        [string]$insertText = 'data-ciphers AES-256-CBC'
    )

    $output = @()
    $fileContent = Get-Content -Path $path
    $matchFound = $false

    foreach ($line in $fileContent) {
        $output += $line
        if ($line -like "$match*") {
            $matchFound = $true
            $output += $insertText
        }
    }

    # Check if match was found
    if (-not $matchFound) {
        Write-Error "Error: No line starting with '$match' was found in the file!"
        exit 2
    }

    $output | Set-Content -Path $path
}

# Check if filename is hardcoded
if ($filename) {
    $confirmation = Read-Host "The hardcoded path is '$filename'. Does this look right? (yes/no)"
    if ($confirmation -ne 'yes') {
        $filename = Read-Host "Enter the filepath: Note: You can enter .\filename for current directory you ran script from."
    }
} else {
    $filename = Read-Host "Enter the filepath:"
}

# Confirm the provided file path
$confirmation = Read-Host "You entered '$filename'. Is this correct? (yes/no)"
if ($confirmation -ne 'yes') {
    Write-Error "Exiting due to incorrect file path."
    exit 1
}

# Check if file exists
if (-not (Test-Path $filename)) {
    Write-Error "Error: File '$filename' not found!"
    exit 3
}

# Call the function to modify the file
Add-LineAfterMatch -path $filename

Write-Output "Operation completed successfully!"
