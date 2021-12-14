# Author: Kaleb Moreno
# Version: 12/10/21

# .DESCRIPTION
# The purpose of this script is to.. 

<#

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
    $fileResponse = Read-Host "Would you like to use a custom response file?"
    Write-Output "`n"

    # Grabbing the main menu
    $mainMenu = $jsonFileObject.mainMenu

    # Show the main menu
    showMenu $mainMenu

    while ($userResponse -ne $terminate) { 
        $userResponse = Read-Host "Enter a sub option"
        
        # Cast the string to an int 
        $userResponse = [int]$userResponse

        # Get the sub menu options
        getSubMenu $mainMenu $userResponse

        # Get an option from the sub menu
        formatResponses $jsonFileObject $mainMenu $userResponse

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
    $dashes = "-" * 20
    
    # Writing the menu header
    Write-Output $dashes
    Write-Output $header
    Write-Output $dashes
    # Write-Output "`n"
     
    # The options for the main menu
    for ($i = 0; $i -lt $options.name.Length; $i++) {

        # Changing the number designation from last indicie to -1
        if ($options.name[$i] -like "*xit*") {
            Write-Output "(-1) $($options.name[$i])"
        }
        else {
            Write-Output "($($i)) $($options.name[$i])"
        }
    }
}


function getSubMenu($theMainMenu, $theRes) { 

    # If the input sub menu option is found
    if ($null -ne $theRes) {
        showMenu $theMainMenu.options[$theRes]
    }
}



function formatResponses($theJSONFile, $theMainMenu, $theSubRes) {

    if ($theSubRes -ne -1) {
        
        # The values that must be replaced in the JSON file
        $phone = $theJSONFile.config.phone
        $hours = $theJSONFile.config.hours
        $APLink = $theJSONFile.config.APlink
        $days = $theJSONFile.config.days
        
    
        # Grabbing an additional response for indexing
        $outputSelection = Read-Host "Select an option"
        
        # Grabbing the links 
        $links = $theMainMenu.options[$theSubRes].options[$outputSelection].links

        # If user just wants resources skip all this
        if ($theSubRes -ne 0) { 
            $fname = Read-Host "Enter the first name of the caller"
            $moreInfo = Read-Host "Do you need more data in the response?"
    
            # Checking to see if the responses need more information
            if ($moreInfo -like "*y*") {
                $room = Read-Host "Enter the room number"
                $service = Read-Host "Enter the disrupted service"
            }
    
            # Grabbing more data
            $txt = $theMainMenu.options[$theSubRes].options[$outputSelection].text
            $questions = $theMainMenu.options[$theSubRes].options[$outputSelection].questions

            # Replacing the values
            $txt = $txt -replace "{time}", "$(formatTime)" -replace "{fname}", $fname -replace "{phone}", "$($phone)" -replace "{hours}", "$($hours)" -replace "{days}", "$($days)" -replace "{APlink}", "$($APlink)" -replace "{service}", "$($service)" -replace "{room}", "$($room)"
    
            # Copy the formated response to the clipboard
            Set-Clipboard -value $txt
    
            # If there are questions
            Clear-Host
            $questions
    
            # User feedback
            feedBack
        }

        # Allow for more extensive documentation options
        foreach ($link in $links) {
            openLink($link)
        }
        
    }
}

# TODO
function feedBack() {
    write-output "**Ticket response was copied to your clipboard - Paste if applicable**`n"
}


function formatTime() {
    $currentTime = Get-Date -Format HH
    $returnVal = $null

    if ($currentTime -lt 12) {
        $returnVal = "morning"
    }
    else {
        $returnVal = "afternoon"
    }
    return $returnVal
}


function openLink($theLink) {
    # Handling the documentation links
    $openLinks = Read-Host "Do you need this resources? ($($theLink.label))"
    # Set-Location "C:\"
    # $chrome = (Get-ItemProperty 'HKLM:\SOFTWARE\Classes\ChromeHTML\shell\open\command').'(default)'
    if ($openLinks -like "*y*") {
        Write-Host "**Opening: $($theLink.label) - Check your Taskbar**`n"
        Start-Process "C:\Program Files (x86)\Microsoft\Edge\Application\msedge.exe" -ArgumentList $theLink.uri
    }
    Clear-Host
}


#TODO
function initCustomResponses() {

}


# Starting the App
Main



