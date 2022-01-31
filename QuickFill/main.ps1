<#
    Author: Kaleb Moreno
    Version: 22.01.31

    .DESCRIPTION
        The purpose of his script is to allow Helpdesk techs to do their jobs more efficiently 
        by giving them the responses and resources that they use on a frequent basis. In the 
        attached response file, there are a variety of remarks on specific selected issues that give
        newer and more established techs alike things to consider.



    Copyright © 2022 Kaleb Moreno

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


# Pulling in the functions
Import-Module -Name ".\Modules\HelperFunctions.psm1"
        
# Program driver 
function main() {

    # App version number
    $appVersion = "22.01.31"
    
    $terminate = -1
    $mainMenu = $jsonFileObject.mainMenu
    $api = "https://quickfill.herokuapp.com/"
  
    # Prompt for response file type
    $fileResponse = formatPrompt "Would you like to use a custom response file?"
    
    # If the user wants to use the API that I wrote for this program
    if ($fileResponse -Like "*y*") {
        $jsonFileObject = Get-Content '.\Resources\Responses.json' | Out-String | ConvertFrom-Json
    } else {

        # Default to the API for the response file
        try {
            Write-Host "Connecting to API..."
            $jsonFileObject = Invoke-restmethod -Uri $api
        }
        catch {
            Write-Host "There was an error connecting to the API..`nCheck your internet connection."
        }
    }

    # Clearing for the main menu
    Clear-Host
  
    # Grabbing the main menu
    $mainMenu = $jsonFileObject.mainMenu
  
    # Show the main menu
    Write-Host "QuickFill App $([char]0x00A9) Kaleb Moreno`nFile Version: $($jsonFileObject.config.version)`nApp Version: $($appVersion)`n" -ForegroundColor DarkGray
    showMenu $mainMenu
  
    while ($userResponse -ne $terminate) { 
        $userResponse = formatPrompt "Enter an option"
        
        # Breaking the loop if the input is -1
        if ($userResponse -like "*$($terminate)*") { break }

        # Checking to see if the user wants to search
        if ($mainMenu.options[$userResponse].name -eq "Search") { 
            $key = formatPrompt "Enter the search term"
            Write-Host ""
            doSearch $mainMenu $key.Trim()
         } else {

            # Get the sub menu options
            getSubMenu $mainMenu $userResponse
    
            # Get an option from the sub menu
            formatResponses $jsonFileObject $mainMenu $userResponse
         }

        # Clear the remarks
        Clear-Host

        # Redirect back to the main menu
        showMenu $mainMenu
    }
  }
  
  # Starting the App
  Main
