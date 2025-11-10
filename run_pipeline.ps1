# --- User-Friendly File Lister (v2 - Bug Fixed) ---

# 1. Ask the user for connection details
Write-Host "--- NAS Connection Details ---"
$NasAddress = Read-Host "Enter NAS Address (e.g., my.nas.com)"
$SshUser = Read-Host "Enter User ID (e.g., admin)"

# --- Port Validation ---
$SshPort = 0
while ($SshPort -lt 1 -or $SshPort -gt 65535) {
    $SshPortInput = Read-Host "Enter SSH Port (default is 22)"
    if ([string]::IsNullOrWhiteSpace($SshPortInput)) {
        $SshPort = 22 # Default port
        break
    }
    try {
        $SshPort = [int]$SshPortInput
        if ($SshPort -lt 1 -or $SshPort -gt 65535) {
            Write-Host "[INVALID] Port must be a number between 1 and 65535."
        }
    }
    catch {
        Write-Host "[INVALID] Port must be a number."
        $SshPort = 0 # Reset to loop again
    }
}
# --- End Port Validation ---

$TargetPath = Read-Host "Enter Target Path to search (e.g., /volume1/photos)"

# 2. Ask the user for file types
Write-Host "`n--- Search Details ---"
$FileTypesInput = Read-Host "Enter file types, separated by commas (e.g., *.mp4, *.jpg, *.png)"

# 3. Define the output file name
$OutputFile = "$PSScriptRoot\NAS_File_List_$(Get-Date -Format 'yyyyMMdd_HHmmss').csv"


# 4. Build the dynamic 'find' command
$typesArray = $FileTypesInput.Split(',')
$findOptions = $typesArray | ForEach-Object { "-iname '$($_.Trim())'" }
$findCommandPart = $findOptions -join " -o "
$fullFindCommand = "find $TargetPath -not -path '*@eaDir*' \( $findCommandPart \)"

Write-Host "`nSearching... please wait."

# 5. Execute the command and save the file
try {
    Write-Host "Attempting to connect to $NasAddress. Please enter password for $SshUser..."
    
    # Run ssh and capture output in a variable
    $fileList = ssh -p $SshPort $SshUser@$NasAddress "$fullFindCommand"
    
    # Check the exit code of the last external command (ssh)
    if ($LASTEXITCODE -ne 0) {
        # If the exit code is not 0 (success), manually throw an error to be caught
        throw "SSH command failed. Check Address, User, Password, or Path."
    }
    
    # If successful (exit code 0), save the output to the file
    $fileList | Set-Content -Path $OutputFile -Encoding Utf8BOM

    Write-Host "[SUCCESS] File list saved to: $OutputFile"
    
    if ((Get-Item $OutputFile).Length -eq 0) {
        Write-Host "[INFO] Search complete. No matching files were found."
    }
}
catch {
    # This block will now catch the 'throw'
    Write-Host "[ERROR] An error occurred: $($_.Exception.Message)"
    # Create an error log file
    Set-Content -Path $OutputFile -Value "Error: $($_.Exception.Message)" -Encoding Utf8BOM
}

Read-Host "Operation complete. Press Enter to exit."