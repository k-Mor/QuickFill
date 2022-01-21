# O(n)^2 searching algorithm that works effeciently on small n - may need revision if n continues to
# grow
function doSearch($theMainMenu, $theKey) {
    $results = "You searched for: $($theKey)`n`n"
    $initialLen = $results.Length
    $minVal = 2
    $delay = 2.4

    foreach ($item in $theMainMenu.options) {
        for ($i = 0; $i -lt $item.options.Count; $i++) {
            if ($item.options[$i].name -Like "*$($theKey)*" -Or $item.options[$i].remarks -Like "*$($theKey)*") {
                Write-host "$($item.name)" -ForegroundColor Blue -NoNewline
                Write-Host " -> [$($item.options[$i].name)]" -ForegroundColor Cyan
                $results += "$($item.name) -> [$($item.options[$i].name)]`n"
            }
        }
    }

    if ($results.Length -ne $initialLen) { # ensuring a non null search
        Set-Clipboard $results 
        feedBack($delay)
    } else {
        Write-Host "Nothing was found.. Try different variations of the search" -ForegroundColor Red
        Start-Sleep -Seconds $minVal
    }
  }

  # The purpose of this function is to display the provided menus 
  # In a consistent and clear format
  function showMenu($theJson) {
    
    # The menu header
    $header = $theJson.name
  
    # The primary options
    $options = $theJson.options 
  
    # Dashes for the menu header
    $dashes = "-" * $header.Length
    
    # Writing the menu header with bolded text
    Write-Host $dashes -ForegroundColor White
    Write-Host $header -ForegroundColor White
    Write-Host $dashes -ForegroundColor White
     
    # The options for the menu
    for ($i = 0; $i -lt $options.name.Length; $i++) {
  
        # Changing the number designation from last indicie to -1
        if ($options.name[$i] -like "*xit*") {
            Write-Host "(-1) $($options.name[$i])"
        }
        else {
            Write-Host "($($i)) $($options.name[$i])"
        }
    }
  }
  
  # The purpose of this function is to get the sub menus that live
  # inside of the parent menu
  function getSubMenu($theMainMenu, $theRes) { 

    # Clearing previous menus when moving between them
    Clear-Host
  
    # If the input sub menu option is found
    if ($null -ne $theRes) {
        showMenu $theMainMenu.options[$theRes]
    }
  }
  
  # The purpose of this function is to format the responses, replace the dynamic data 
  # interact with the clipboard, and open links when the user selects that option
  function formatResponses($theJSONFile, $theMainMenu, $theSubRes) {
    $terminate = -1
    $empty = 0
    $minLen = 1
    $options = $theMainMenu.options[$theSubRes].options
    $delay = 1.4
  
    # Grabbing an additional response for indexing
    $outputSelection = formatPrompt "Select an option"
    
    # This condition is checking for two things - the termination characters
    # And if the last menu item is selected. This is the reserved spot for sub menu termination
    if ($theSubRes -ne $terminate -And $options[$outputSelection] -ne $options[$terminate]) {
  
        # The values that must be replaced in the JSON file
        $phone = $theJSONFile.config.phone
        $hours = $theJSONFile.config.hours
        $APLink = $theJSONFile.config.APlink
        $days = $theJSONFile.config.days
            
        # Grabbing the links 
        $links = $options[$outputSelection].links
        
        # Grabbing more data
        $txt = $options[$outputSelection].text
        $remarks = $options[$outputSelection].remarks
  
        # If user just wants resources skip all this
        if ($theSubRes -ne $empty -And $txt.Length -ge $minLen) { 
            $fname = formatPrompt "Enter the first name of the user"
  
            # Asking for additional data if that is indicated by the special char ~
            if ($options[$outputSelection].name -Like "*~*") { 
              $moreInfo = formatPrompt "Enter the additional data"
            }
  
            # Replacing the values
            $txt = $txt `
                -replace "{time}", "$(formatTime)" `
                -replace "{fname}", "$($fname.Trim())" `
                -replace "{phone}", "$($phone)" `
                -replace "{hours}", "$($hours)" `
                -replace "{days}", "$($days)" `
                -replace "{APlink}", "$($APlink)" `
                -replace "{data}", "$($moreInfo)"
    
            # User feedback
            if ($txt.Length -ge $minLen -And $null -ne $txt) {
                Set-Clipboard -value $txt
                feedback($delay)
            }
        }
  
        # Handling the remarks
        Clear-Host
        Write-Host "[$($options[$outputSelection].name)]"
        Write-Host $remarks
  
        # Handling the items with no links 
        if ($null -eq $links) {
          formatPrompt("Continue?")
        }
  
        # Allow for more extensive documentation options
        foreach ($link in $links) {
            openLink($link)
        }
    }
  }
  
  # The purpose of this function is to provide an element of user feedback
  # When the program interacts with the system's clipboard
  function feedBack($theTime) {
    Write-Host "`n** Item was copied to your clipboard **`n" -ForegroundColor DarkGreen
    Start-Sleep -Seconds $theTime
  }
  
  # The purpose of this function is to create a uniform and eye-catching prompt 
  # So that the user knows when their input is expected
  function formatPrompt($thePrompt) {
    return "$(Write-Host "$($thePrompt): " -ForegroundColor Red -NoNewline) $(Read-Host)"
  }
  
  # The purpose of this function is to to ensure that the responses are 
  # using the correct time of day in them
  function formatTime() {
    $currentTime = Get-Date -Format HH
    $returnVal = $null
    $noon = 12
  
    if ($currentTime -lt $noon) {
        $returnVal = "morning"
    }
    else {
        $returnVal = "afternoon"
    }
    return $returnVal
  }
  
  # The purpose of this function is to open links with Chrome as the initial browser
  # Then Edge as the secondary browser should CHrome not be found
  function openLink($theLink) {
    $delay = 1.4
  
    # Handling the documentation links
    $openLinks = formatPrompt "Do you need this resources? ($($theLink.label))"
   
    if ($openLinks -like "*y*") {
        Write-Host "** Opening: $($theLink.label) **`n" -ForegroundColor DarkGreen
        $browser = "C:\Program Files (x86)\Google\Chrome\Application\chrome.exe" # Defaults to Chrome
        if (Test-Path $browser) {
            Start-Process $browser -ArgumentList $theLink.uri
        } else {
            $browser = "C:\Program Files (x86)\Microsoft\Edge\Application\msedge.exe"
            Start-Process $browser -ArgumentList $theLink.uri
        }
        Start-Sleep $delay
    }
  }