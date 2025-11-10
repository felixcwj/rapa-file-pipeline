# Get the directory where the script is located.
$ScriptDir = $PSScriptRoot

# 1. Define the output CSV file path (will be saved in the same folder as the script).
$OutputFile = "$ScriptDir\rapa_file_list_FOR_EXCEL.csv"

Write-Host "Searching for file list on NAS and saving to an Excel-compatible CSV..."
Write-Host "Output file location: $OutputFile"


# 2. Execute the 'find' command on the NAS via SSH (Port 2022).
#    The output is piped '|' directly to Set-Content.
#    Set-Content saves the result to $OutputFile with UTF-8-BOM encoding (for Excel).

try {
    Write-Host "Attempting to connect to NAS (Port 2022). Please enter password (Rapa2025!)..."
    
    ssh -p 2022 DOB@rapa2025-2.synology.me "find /volume1/초기데이터_검증용 -not -path '*@eaDir*' \( -iname '*.mp4' -o -iname '*.jpg' \)" | Set-Content -Path $OutputFile -Encoding Utf8BOM

    Write-Host "[SUCCESS] Excel-compatible CSV file has been created."
}
catch {
    Write-Host "[ERROR] An error occurred during the operation: $_"
}

Read-Host "Operation complete. Press Enter to exit."