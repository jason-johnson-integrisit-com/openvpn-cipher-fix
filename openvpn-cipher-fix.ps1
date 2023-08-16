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
  $path = $args[0]
  $match = "cipher"
  $insertText = "data-ciphers AES-256-CBC"

  if (-not (Test-Path $path)) {
      Write-Host "File $path does not exist." -ForegroundColor Red
      return
  }

  $fileContent = Get-Content -Path $path
  $alreadyExists = $fileContent -contains $insertText

  if ($alreadyExists) {
      Write-Host "File $path already contains the line '$insertText'. Skipping..." -ForegroundColor Yellow
      return
  }

  $matchFound = $false
  $output = @()

  foreach ($line in $fileContent) {
      $output += $line
      if ($line -like "$match*") {
          $matchFound = $true
          Write-Host "Match found in file $path." -ForegroundColor Cyan
      }

      if ($matchFound -and ($line -notlike "$insertText")) {
          $output += $insertText
          $matchFound = $false
          Write-Host "Inserted line '$insertText' in file $path." -ForegroundColor Green
      }
  }

  $output | Set-Content -Path $path
}

# Define paths
$defaultUserPath = "C:\Users\*\OpenVPN\config"
$programPath = "C:\Program Files\OpenVPN\config"

# Get a list of all .ovpn files in the defined paths and subfolders
$files = Get-ChildItem -Path $defaultUserPath, $programPath -Recurse -Filter "*.ovpn"

Write-Host "Searching for .ovpn files to process..." -ForegroundColor Cyan

foreach ($file in $files) {
  Write-Host "Processing file: $file.FullName" -ForegroundColor Magenta
  Add-LineAfterMatch $file.FullName
}

Write-Host "Processing complete. Press any key to exit..." -ForegroundColor Magenta
$host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown") | Out-Null
