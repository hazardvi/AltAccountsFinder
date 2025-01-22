$featherFilePath = "$env:USERPROFILE\AppData\Roaming\.feather\accounts.json"
$lunarFilePath = "C:\Users\$env:USERNAME\.lunarclient\settings\game\accounts.json"

Write-Output "Processing Feather client accounts..."
if (Test-Path $featherFilePath) {
    $featherData = Get-Content $featherFilePath -Raw | ConvertFrom-Json

    if ($featherData.ms -ne $null) {
        Write-Output "Feather client UUIDs:"
        foreach ($account in $featherData.ms) {
            $minecraftUuid = $account.minecraftUuid
            Write-Output "- Minecraft UUID: $minecraftUuid"
        }
    } else {
        Write-Output "No UUIDs found in the 'ms' section of the Feather accounts.json file."
    }
} else {
    Write-Output "The Feather client accounts.json file could not be found at: $featherFilePath"
}

Write-Output "\nProcessing Lunar client accounts..."
if (Test-Path $lunarFilePath) {
    try {
        $lunarData = Get-Content $lunarFilePath -Raw | ConvertFrom-Json

        if ($lunarData.accounts -ne $null) {
            Write-Output "Lunar client usernames:"
            $accountKeys = $lunarData.accounts.PSObject.Properties.Name

            foreach ($accountKey in $accountKeys) {
                $account = $lunarData.accounts.$accountKey

                if ($account.username -ne $null) {
                    Write-Output "- Username: $($account.username)"
                } else {
                    Write-Output "- Warning: Encountered an account without a 'username'."
                }
            }
        } else {
            Write-Output "Error: 'accounts' property is missing or null in the Lunar accounts.json file."
        }
    } catch {
        Write-Output "An error occurred while reading or parsing the Lunar JSON file: $_"
    }
} else {
    Write-Output "The Lunar client accounts.json file could not be found at: $lunarFilePath"
}

Write-Host "\nProcessing completed. Press Enter to exit."
Read-Host
