# 🧰 RAPA File Pipeline

An interactive PowerShell script to extract file lists (.mp4, .jpg, etc.) from any Synology NAS via SSH and save them as an Excel-compatible (UTF-8-BOM) CSV.

This script is user-friendly and prompts for all necessary details, so no code editing is required to use it.

---

## ✨ Features

* **Interactive:** Asks for NAS address, user, port, and search paths.
* **Excel-Friendly:** Saves the CSV file with `UTF-8-BOM` encoding to prevent broken characters (like Korean) in Microsoft Excel.
* **Flexible:** Allows you to specify any file types to search for (e.g., `*.mp4, *.jpg, *.zip`).
* **Safe:** Ignores Synology's system thumbnail folders (`@eaDir`) by default.
* **Direct Download:** Streams the file list directly from the NAS to your PC without saving temporary files on the NAS.

---

##  Prerequisites

1.  **PowerShell:** Must be run from a PowerShell terminal on your Windows PC.
2.  **NAS Settings:**
    * **SSH Service:** Must be **enabled** on your Synology NAS.
        * (Go to `Control Panel` > `Terminal & SNMP` > `Enable SSH service`).
    * **User Permissions:** The NAS user you log in with must have permission to access the folders you want to search.

---

## 🚀 How to Use

1.  **Download the Script:**
    * Click the green **`< > Code`** button on this GitHub page.
    * Select **`Download ZIP`**.
    * Unzip the file to a folder on your PC (e.g., your Desktop).

2.  **Run the Script:**
    * Right-click the `run_pipeline.ps1` file and choose **`Run with PowerShell`**.
    * *(If this fails due to security policy, open PowerShell manually, `cd` to the folder, and type `.\run_pipeline.ps1` and press Enter.)*

3.  **Answer the Prompts:**
    The script will ask you for the following information. Just type the answers and press Enter.

    * `Enter NAS Address:` (e.g., `my.nas.com` or `192.168.1.100`)
    * `Enter User ID:` (e.g., `admin` or `your_username`)
    * `Enter SSH Port:` (Press Enter to use the default: `22`)
    * `Enter Target Path to search:` (e.g., `/volume1/photos` or `/volume1/video`)
    * `Enter file types, separated by commas:` (e.g., `*.mp4, *.jpg`)

4.  **Enter Password:**
    * It will then ask for your NAS user's password. Type it and press Enter (password will not be visible).

5.  **Done!**
    * The script will search the NAS. When finished, a new CSV file (e.g., `NAS_File_List_20251110_143000.csv`) will appear in the same folder as the script.