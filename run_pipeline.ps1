# --- User-Friendly File Lister ---
# This script interactively asks for connection and search details.

# 1. Ask the user for connection details
Write-Host "--- NAS Connection Details ---"
$NasAddress = Read-Host "Enter NAS Address (e.g., my.nas.com)"
$SshUser = Read-Host "Enter User ID (e.g., admin)"
$SshPortInput = Read-Host "Enter SSH Port (default is 22)"
$TargetPath = Read-Host "Enter Target Path to search (e.g., /volume1/photos)"

# Set default port if user just presses Enter
$SshPort = if ([string]::IsNullOrWhiteSpace($SshPortInput)) { 22 } else { $SshPortInput }

# 2. Ask the user for file types
Write-Host "`n--- Search Details ---"
$FileTypesInput = Read-Host "Enter file types, separated by commas (e.g., *.mp4, *.jpg, *.png)"

# 3. Define the output file name
$OutputFile = "$PSScriptRoot\NAS_File_List_$(Get-Date -Format 'yyyyMMdd_HHmmss').csv"


# 4. Build the dynamic 'find' command
# Split the user input string "*,mp4, *.jpg" into an array
$typesArray = $FileTypesInput.Split(',')

# Create the find options (e.g., "-iname '*.mp4' -o -iname '*.jpg'")
$findOptions = $typesArray | ForEach-Object { "-iname '$($_.Trim())'" }
$findCommandPart = $findOptions -join " -o "

# Assemble the final 'find' command string
$fullFindCommand = "find $TargetPath -not -path '*@eaDir*' \( $findCommandPart \)"

Write-Host "`nSearching... please wait."

# 5. Execute the command and save the file
try {
    Write-Host "Attempting to connect to $NasAddress. Please enter password for $SshUser..."
    
    # Execute the dynamic command and pipe output to an Excel-compatible CSV
    ssh -p $SshPort $SshUser@$NasAddress "$fullFindCommand" | Set-Content -Path $OutputFile -Encoding Utf8BOM

    Write-Host "[SUCCESS] File list saved to: $OutputFile"
}
catch {
    Write-Host "[ERROR] An error occurred: $_"
}

Read-Host "Operation complete. Press Enter to exit."