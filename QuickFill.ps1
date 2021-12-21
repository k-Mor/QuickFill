<#
    Author: Kaleb Moreno
    Version: 12/10/21

    .DESCRIPTION
        The purpose of this script is to



    Copyright © 2021 Kaleb Moreno

    Permission is hereby granted, free of charge, 
    to any person obtaining a copy of this software and associated documentation files (the “Software”), 
    to deal in the Software without restriction, including without limitation the rights to use, copy, modify, 
    merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom 
    the Software is furnished to do so, subject to the following conditions: The above copyright notice and this 
    permission notice shall be included in all copies or substantial portions of the Software.THE SOFTWARE IS 
    PROVIDED “AS IS”, WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE 
    WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL 
    THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, 
    WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE 
    SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

#>
        



# TODO make the unicode easier to change / replace
function main() {

    # Create the enviornment to run scripts
    # Set-ExecutionPolicy -ExecutionPolicy Bypass
    
    # General vars
    $terminate = -1
    $mainMenu = $jsonFileObject.mainMenu
    $api = "https://quickfill.herokuapp.com/"
    
    # First set the location
    # TODO : Configure the relative path 
    Set-Location 'C:\Users\MorenKS\myStuff\psScripts'
    # Set-Location "C:\myStuff" #laptop
    # Set-Location "C:\Users\Kaleb\OneDrive\Documents"
  
  
    # Get the custom JSON file if one exists
    $jsonFileObject = Get-Content '.\newResponses.json' | Out-String | ConvertFrom-Json
  
    # Prompt for response file type
    $fileResponse = formatPrompt "Would you like to use the corporate response file?"
    
    # If the user wants to use the API that I wrote for this program
    if ($fileResponse -Like "*y*") {
        $jsonFileObject = Invoke-restmethod -Uri $api
    }

    Clear-Host
  
    # Grabbing the main menu
    $mainMenu = $jsonFileObject.mainMenu
  
    # Show the main menu
    Write-Host "QuickFill App $([char]0x00A9) Kaleb Moreno`nVersion: 12/21`n" -ForegroundColor DarkGray
    showMenu $mainMenu
  
    while ($userResponse -ne $terminate) { 
        $userResponse = formatPrompt "Enter a sub option"
        
        # Breaking the loop if the input is -1
        if ($userResponse -like "*$($terminate)*") { break }

        # Checking to see if the user wants to search
        if ($mainMenu.options[$userResponse].name -eq "Search") { 
            $key = formatPrompt "Enter the search term"
            doSearch $mainMenu $key.Trim()
         } else {

            # Get the sub menu options
            getSubMenu $mainMenu $userResponse
    
            # Get an option from the sub menu
            formatResponses $jsonFileObject $mainMenu $userResponse

         }

        # Clear the questions
        Clear-Host

        # Redirect back to the main menu
        showMenu $mainMenu


    }
  }
  
# O(n)^2 searching algorithm that works effeciently on small n - may need revision if n
# grows exponentially  
  function doSearch($theMainMenu, $theKey) {

    $results
    foreach ($item in $theMainMenu.options) {
 
        for ($i = 0; $i -lt $item.options.Count; $i++) {

            if ($item.options[$i].name -Like "*$($theKey)*" -Or $item.options[$i].questions -Like "*$($theKey)*") {
                Write-host "Search key was found in: $($item.name) -> [$($item.options[$i].name)]"
                $results += "Search key was found in: $($item.name) -> [$($item.options[$i].name)]`n"
            }
        }
    }

    if ($results.Count -ge 1) {
        Set-Clipboard $results
        feedBack(5)
    } else {
        Write-Host "Nothing was found.. Try different variations of the key" -ForegroundColor Red
        Start-Sleep -Seconds 1
    }
  }


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
    # Write-Host "`n"
     
    # The options for the main menu
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
  
  function getSubMenu($theMainMenu, $theRes) { 
  
    # Clearing previous menus when moving between them
    Clear-Host
  
    # If the input sub menu option is found
    if ($null -ne $theRes) {
        showMenu $theMainMenu.options[$theRes]
    }
  }
  
  
  
  function formatResponses($theJSONFile, $theMainMenu, $theSubRes) {
    $terminate = -1
    $empty = 0
    $minLen = 1
    $options = $theMainMenu.options[$theSubRes].options
  
    # Grabbing an additional response for indexing
    $outputSelection = formatPrompt "Select an option"
    
    # This condition is checking for two things - the termination character
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
        $questions = $options[$outputSelection].questions
  
  
  
        # If user just wants resources skip all this
        if ($theSubRes -ne $empty -And $txt.Length -ge $minLen) { 
            $fname = formatPrompt "Enter the first name of the user"
  
            # Asking additional questions if that is indicated in the response name
            if ($options[$outputSelection].name -Like "*~*") { 
              $moreInfo = formatPrompt "Enter the additional data"
            }
  
            # Replacing the values
            $txt = $txt `
                -replace "{time}", "$(formatTime)" `
                -replace "{fname}", $fname `
                -replace "{phone}", "$($phone)" `
                -replace "{hours}", "$($hours)" `
                -replace "{days}", "$($days)" `
                -replace "{APlink}", "$($APlink)" `
                -replace "{data}", "$($moreInfo)"
    
            
            # User feedback
            if ($txt.Length -ge $minLen -And $null -ne $txt) {
                Set-Clipboard -value $txt
                feedback(1.4)
            }
        }
  
        # Handling the questions
        Clear-Host
        Write-Host "[$($options[$outputSelection].name)]"
        Write-Host $questions
  
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
  
  function feedBack($theTime) {
    Write-Host "`n** Item was copied to your clipboard **`n" -ForegroundColor DarkGreen
    Start-Sleep -Seconds $theTime
  }
  
  function formatPrompt($thePrompt) {
    return "$(Write-Host "$($thePrompt): " -ForegroundColor Red -NoNewline) $(Read-Host)"
  }
  
  
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
  
  
  function openLink($theLink) {
    $delayTime = 1.4
  
    # Handling the documentation links
    $openLinks = formatPrompt "Do you need this resources? ($($theLink.label))"
    if ($openLinks -like "*y*") {
        Write-Host "** Opening: $($theLink.label) **`n" -ForegroundColor DarkGreen
        Start-Process "C:\Program Files (x86)\Microsoft\Edge\Application\msedge.exe" -ArgumentList $theLink.uri
        Start-Sleep $delayTime
    }
  }
  
  
  #TODO
  function initCustomResponses() {
  
  }
  
  # Starting the App
  Main
