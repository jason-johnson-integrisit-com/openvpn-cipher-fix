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
# Function to add line after match

function Add-LineAfterMatch {
  $path = $args[0]  # Get the first argument passed to the function as the path
  $match = 'cipher'
  $insertText = 'data-ciphers AES-256-CBC'

  $fileContent = Get-Content -Path $path
  $alreadyExists = $fileContent -like "*$insertText*"

  # Check if the insertText already exists
  if ($alreadyExists) {
      return
  }

  $matchFound = $false
  $output = @()

  foreach ($line in $fileContent) {
      $output += $line
      if ($line -like "$match*") {
          $matchFound = $true
          $output += $insertText
      }
  }

  # Save only if a match was found and we made modifications
  if ($matchFound) {
      $output | Set-Content -Path $path
  }
}

# Paths to search
$defaultUserPath = "C:\Users\*\OpenVPN\config"
$programPath = "C:\Program Files\OpenVPN\config"

# Get all .ovpn files in the paths and their subdirectories
$files = Get-ChildItem -Path $defaultUserPath, $programPath -Recurse -Filter "*.ovpn"

foreach ($file in $files) {
  Add-LineAfterMatch $file.FullName  # Here we're just passing the file path as an argument
}

Write-Output "Operation completed successfully!"


