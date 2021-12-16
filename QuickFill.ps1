<#
    Author: Kaleb Moreno
    Version: 12/10/21

    .DESCRIPTION
        The purpose of this script is to.. 



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
    
    # First set the location
    # TODO : Configure the relative path 
    # Set-Location 'C:\Users\MorenKS\myStuff\psScripts'
    Set-Location "C:\myStuff" #laptop
    # Set-Location "C:\Users\Kaleb\OneDrive\Documents"


    # Get the JSON file
    $jsonFileObject = Get-Content '.\newResponses.json' | Out-String | ConvertFrom-Json

    # Prompt for response file type
    $fileResponse = formatPrompt "Would you like to use a custom response file?"
    Clear-Host

    # Grabbing the main menu
    $mainMenu = $jsonFileObject.mainMenu

    # Show the main menu
    showMenu $mainMenu

    while ($userResponse -ne $terminate) { 
        $userResponse = formatPrompt "Enter a sub option"
        
        # Get the sub menu options
        getSubMenu $mainMenu $userResponse

        # Get an option from the sub menu
        formatResponses $jsonFileObject $mainMenu $userResponse

        # Clear the questions
        Clear-Host

        # Redirect back to the main menu
        showMenu $mainMenu
    }
}


function showMenu($theJson) {
    
    # The menu header
    $header = $theJson.name

    # The primary options
    $options = $theJson.options 

    # Dashes for the menu header
    $dashes = "-" * $header.Length
    
    # Writing the menu header
    Write-Host $dashes
    Write-Host $header
    Write-Host $dashes
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

    Clear-Host
    # If the input sub menu option is found
    if ($null -ne $theRes) {
        showMenu $theMainMenu.options[$theRes]
    }
}



function formatResponses($theJSONFile, $theMainMenu, $theSubRes) {
    $terminate = -1
    if ($theSubRes -ne $terminate) {
        
        # The values that must be replaced in the JSON file
        $phone = $theJSONFile.config.phone
        $hours = $theJSONFile.config.hours
        $APLink = $theJSONFile.config.APlink
        $days = $theJSONFile.config.days
        
    
        # Grabbing an additional response for indexing
        $outputSelection = formatPrompt "Select an option"
        $outputSelection = [int]$outputSelection
        
        # Grabbing the links 
        $links = $theMainMenu.options[$theSubRes].options[$outputSelection].links
        
        # Grabbing more data
        $txt = $theMainMenu.options[$theSubRes].options[$outputSelection].text
        $questions = $theMainMenu.options[$theSubRes].options[$outputSelection].questions

        # If user just wants resources skip all this
        if ($theSubRes -ne 0 -And $txt.Length -ge 1) { 
            $fname = formatPrompt "Enter the first name of the caller"
            $moreInfo = formatPrompt "Do you need more data in the response? ex.[Room #], [Service Name]"
    
            # Checking to see if the responses need more information
            if ($moreInfo -like "*y*") {
                $room = formatPrompt "Enter the room number"
                $service = formatPrompt "Enter the disrupted service"
            }
    


            # Replacing the values
            $txt = $txt `
                -replace "{time}", "$(formatTime)" `
                -replace "{fname}", $fname `
                -replace "{phone}", "$($phone)" `
                -replace "{hours}", "$($hours)" `
                -replace "{days}", "$($days)" `
                -replace "{APlink}", "$($APlink)" `
                -replace "{service}", "$($service)" `
                -replace "{room}", "$($room)"
    
            
            # User feedback
            if ($txt.Length -ge 1 -And $null -ne $txt) {
                Set-Clipboard -value $txt
                feedback
            }
        }

        # If there are questions
        # Clear-Host
        $questions

        # Allow for more extensive documentation options
        foreach ($link in $links) {
            openLink($link)
        }
        
    }
}

function feedBack() {
    $delayTime = 1.4
    Write-Host "`n** Ticket response was copied to your clipboard **`n" -ForegroundColor DarkGreen
    Start-Sleep -Seconds $delayTime
    Clear-Host
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
    $openLinks = formatPrompt "`nDo you need this resources? ($($theLink.label))"
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


