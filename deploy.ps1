# Load configuration
$configPath = Join-Path $PSScriptRoot "config.json"
$config = Get-Content -Path $configPath | ConvertFrom-Json

# Function to display a styled message
function Write-ColoredMessage {
    param(
        [string]$Message,
        [string]$Status = "INFO",
        [string]$Color = "White"
    )
    $timestamp = Get-Date -Format "HH:mm:ss"
    $statusColor = switch ($Status) {
        "SUCCESS" { "Green" }
        "ERROR" { "Red" }
        "WARNING" { "Yellow" }
        "INFO" { "Cyan" }
        default { "White" }
    }
    
    Write-Host "[$timestamp] " -NoNewline -ForegroundColor DarkGray
    Write-Host "[$Status] " -NoNewline -ForegroundColor $statusColor
    Write-Host $Message -ForegroundColor $Color
}

# Function to get modified files
function Get-ModifiedFiles {
    $modifiedFiles = git status --porcelain | ForEach-Object {
        $change = $_.Substring(0, 2).Trim()
        $file = $_.Substring(3)
        [PSCustomObject]@{
            Change = $change
            File = $file
        }
    }
    return $modifiedFiles
}

# Parse arguments
$commitMessage = ""
$specificFiles = @()
$i = 0
while ($i -lt $args.Count) {
    if ($args[$i] -eq "-m") {
        $i++
        if ($i -lt $args.Count) {
            $commitMessage = $args[$i]
        }
    } elseif ($args[$i] -eq "-f") {
        $i++
        while ($i -lt $args.Count -and -not ($args[$i].StartsWith("-"))) {
            $specificFiles += $args[$i]
            $i++
        }
        $i--
    }
    $i++
}

# Display logo
Write-Host "`n`n" -NoNewline
Write-Host ">> " -NoNewline
Write-Host "$($config.projectSettings.projectName) Deployment Tool" -ForegroundColor Magenta
Write-Host "================================================`n" -ForegroundColor DarkGray

# Move to correct directory
$projectPath = $config.projectSettings.projectPath
if ((Get-Location).Path -ne $projectPath) {
    Write-ColoredMessage "Moving to project directory..." "INFO"
    Set-Location -Path $projectPath
}

# Check for changes
Write-ColoredMessage "Checking for changes..." "INFO"
$allModifiedFiles = Get-ModifiedFiles

if (-not $allModifiedFiles) {
    Write-ColoredMessage "No changes detected." "WARNING"
    Write-Host "`nPress any key to exit..." -ForegroundColor DarkGray
    $null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
    exit
}

# Display all modified files
Write-ColoredMessage "Modified files:" "INFO"
$fileOptions = @()
$index = 1
$allModifiedFiles | ForEach-Object {
    $changeColor = switch ($_.Change) {
        "M" { $config.display.colors.modified }    # Modified
        "A" { $config.display.colors.added }       # Added
        "D" { $config.display.colors.deleted }     # Deleted
        "R" { $config.display.colors.renamed }     # Renamed
        "??" { $config.display.colors.untracked }  # Untracked
        default { "White" }
    }
    Write-Host "  [$index] " -NoNewline -ForegroundColor Cyan
    Write-Host "$($_.Change) " -NoNewline -ForegroundColor $changeColor
    Write-Host $_.File -ForegroundColor White
    $fileOptions += $_.File
    $index++
}

# If no specific files were provided in arguments, ask for them
if ($specificFiles.Count -eq 0) {
    Write-Host "`nSelect files to commit (Enter numbers separated by commas, or 'all' for all files):" -ForegroundColor Yellow
    $selection = Read-Host
    
    if ($selection -ne "all") {
        $selectedIndices = $selection -split ',' | ForEach-Object { $_.Trim() }
        $specificFiles = @()
        foreach ($idx in $selectedIndices) {
            if ([int]::TryParse($idx, [ref]$null)) {
                $fileIndex = [int]$idx - 1
                if ($fileIndex -ge 0 -and $fileIndex -lt $fileOptions.Count) {
                    $specificFiles += $fileOptions[$fileIndex]
                }
            }
        }
    }
}

# If no commit message was provided in arguments, ask for it
if (-not $commitMessage) {
    Write-Host "`nEnter commit message:" -ForegroundColor Yellow
    $commitMessage = Read-Host
    if (-not $commitMessage) {
        $commitMessage = "Auto-commit: $(Get-Date -Format 'yyyy-MM-dd HH:mm')"
    }
}

# Add files
if ($specificFiles.Count -gt 0) {
    Write-ColoredMessage "Adding specified files..." "INFO"
    foreach ($file in $specificFiles) {
        Write-ColoredMessage "Adding: $file" "INFO"
        git add "$file"
    }
} else {
    Write-ColoredMessage "Adding all modified files..." "INFO"
    git add .
}

# Create commit
Write-ColoredMessage "Creating commit with message: $commitMessage" "INFO"
git commit -m $commitMessage

if ($LASTEXITCODE -eq 0) {
    Write-ColoredMessage "Commit created successfully!" "SUCCESS"
} else {
    Write-ColoredMessage "Error creating commit." "ERROR"
    exit 1
}

# Push to GitHub
Write-ColoredMessage "Pushing to GitHub..." "INFO"
$pushOutput = git push 2>&1
if ($LASTEXITCODE -eq 0) {
    Write-ColoredMessage "Push completed successfully!" "SUCCESS"
} else {
    Write-ColoredMessage "Error pushing to GitHub:" "ERROR"
    Write-Host $pushOutput -ForegroundColor Red
    exit 1
}

# Display summary
Write-Host "`n================================================" -ForegroundColor DarkGray
Write-ColoredMessage "Deployment completed successfully!" "SUCCESS"
Write-Host "GitHub Actions will now deploy the changes..." -ForegroundColor DarkGray
Write-Host "================================================`n" -ForegroundColor DarkGray

Write-Host "Press any key to exit..." -ForegroundColor DarkGray
$null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
