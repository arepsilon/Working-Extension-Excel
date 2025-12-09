$path = "c:\Users\user\Desktop\Excel Extension to me\Hosted Extension\config.html"
$content = Get-Content -Path $path -Raw

# 2. Add Date option and container to UI - Retry
$searchUI = '                    <option value="percentage">Percentage</option>'
$replaceUI = '                    <option value="percentage">Percentage</option>`r`n                    <option value="date">Date</option>'

# Try to match with just LF as well
if (-not $content.Contains($searchUI)) {
    $searchUI = $searchUI.Replace("`r`n", "`n")
    $replaceUI = $replaceUI.Replace("`r`n", "`n")
}

if ($content.Contains($searchUI)) {
    $content = $content.Replace($searchUI, $replaceUI)
    Write-Host "Updated UI (Option)"
} else {
    Write-Host "Could not find target for UI (Option)"
}

# Add container after the select container
$searchContainer = '            <div class="color-picker" id="number-format-container">'
# We need to find the closing div of this container to append after it.
# Since simple replace is hard with closing divs, I'll replace the closing tag of the select with select + closing div + new container
# Wait, that's risky.
# Let's try to find the next container "currency-symbol-container" and insert BEFORE it.

$searchNext = '            <div class="color-picker" id="currency-symbol-container" style="display: none;">'
$replaceNext = '            <div class="color-picker" id="date-format-container" style="display: none;">`r`n                <label>Date Format:</label>`r`n                <input type="text" id="date-format" placeholder="e.g. MM/DD/YYYY" value="MM/DD/YYYY">`r`n                <small style="display:block; color:#666; margin-top:5px;">Use MM, DD, YYYY, MMM, etc.</small>`r`n            </div>`r`n`r`n            <div class="color-picker" id="currency-symbol-container" style="display: none;">'

if (-not $content.Contains($searchNext)) {
    $searchNext = $searchNext.Replace("`r`n", "`n")
    $replaceNext = $replaceNext.Replace("`r`n", "`n")
}

if ($content.Contains($searchNext)) {
    $content = $content.Replace($searchNext, $replaceNext)
    Write-Host "Updated UI (Container)"
} else {
    Write-Host "Could not find target for UI (Container)"
}

Set-Content -Path $path -Value $content -NoNewline
