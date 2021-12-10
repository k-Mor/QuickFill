<#
    Author: Kaleb Morneo
    Version: 12/10/21
    
    .DESCRIPTION
        The purpose of this script is to.. 
#>


function main() {
    
    # General vars
    $terminate = -1
    $mainMenu = $jsonFileObject.mainMenu
    
    # First set the location
    # TODO : Configure the relative path 
    Set-Location 'C:\Users\MorenKS\myStuff\psScripts'

    # Get the JSON file
    $jsonFileObject = Get-Content '.\responses.json' | Out-String | ConvertFrom-Json

    # Prompt for response file type
    $fileResponse = Read-Host "Would you like to use a custom response file?"
    Write-Output "`n"

    $mainMenu = $jsonFileObject.mainMenu

    # Show the main menu
    showMenu($mainMenu, $null)

    while($userResponse -ne $terminate) { 
        $userResponse = Read-Host "Enter a sub option"
         Write-Output "This is what you said: $($userResponse)"
        
        # Cast the var to an int 
        # $userResponse = [int]$userResponse

        showMenu($mainMenu, $userResponse)
    }
}


function showMenu($theJson, $theRes) {

    #Write-Output "This is the Response: $($theRes)"
    
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
    Write-Output "`n"
     
    # The options for the main menu
    for($i = 0; $i -lt $options.name.Length; $i++) {

        # Changing the number designation from last indicie to -1
        if ($options.name[$i] -like "*xit*") {
            Write-Output "-1 $($options.name[$i])"
        } else {

            if ($theRes -eq $i) { Write-Output $options.name }
            Write-Output "$($i) $($options.name[$i])"
        }
    }
}

# TODO
function feedBack() {

}


# TODO
function getTime() {

}


# TODO
function formatResponseSub() {

}

# TODO
function formatResponses() {

}

#TODO
function initCustomResponses() {

}


# Starting the App
Main



