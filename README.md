# QuickFill 
Version: 2022.01.23

## What is QuickFill?
<strong>QuickFill is a Powershell console program that seeks to demystify the ticket creation / response process by copying pre-formatted responses to the system clipboard, while providing useful remarks for a selected topic. This program assumes the following about its users:</strong>

1. You are tired of typing the same things over and over while responding to common issues - like printers failing to print.
2. You realize that you can't remember everything, and would like to be able to search for less common issues quickly
3. You are either on the phone with a caller, or interacting with a user via TOPdesk.
4. You like to have all of your resources in one central place.
5. You don't know where to find the information you need for a particular concern.

<strong>There are a few things that this program does for you that makes your life as a Helpdesk Tech easier:</strong>

1. Writes responses, based on your selection in one of the menus and adds in dynamic content, like the time of day. For example, the program checks to see what time of day it is before it proceeds to write "Good morning so-and-so" or "Good afternoon so-and-so." This is so you don't have to go back and edit a response before you send it off.
2. The program will copy that response to your clipboard so you can simply hit CTRL + V to paste it into the response box in TOPdesk. This is a huge time saver during the busy seasons.
3. The program will show you links to relevant resources, if there are any, in SharePoint, OneNote or other documentation hubs, for selected concerns. It will then attempt to automatically open that resource in a tab / page in Chrome. If Chrome is not present, the program will default to Microsoft Edge. This is all optional however.
4. Most of the options that exist in the sub menus contain "Remarks." Remarks help familiarize a new Tech and even remind seasoned Techs, what they ought to do for a particular concern. For example, say someone calls in about a Juno:
    * First, the Tech will find the Juno menu option and go through the prompts (I will cover this in a moment)
    * Next, the Tech will review the remarks and realize that they MUST include the room number of the Juno in the ticket before they escalate it to a On Site Tech. This little detail is one example of things that are very often missed during ticket escalation, which can be avoided by using this program.
5. This program contains a search algorithm that makes locating specific issues much easier within the program itself. All you have to do is select "Search", input a search term, and the program will show you where it found that term, then copy the search results / path to your clipboard. This is super helpful when you don't know where to look for something. So, if you didn't have enough time to look at the results, you can just paste them anywhere for further review.
6. In the "Helpdesk Resources" there are links to just about anything you could need as a Tech. There are status pages, guides, official resources like the Approved Applications List, text based guides, etc. 

<strong>Best of all, this program is totally customizable and very flexible. If you pick up just a little knowledge on how to read JSON, you can write and use your own custom response file! This means you can make the program say whatever you want it to. However, if you want to keep it simple and aren't interested in writing your own responses, you can just use my API which I'll do my best to keep up to date and relevant. Note that this a labor of love and is something that only I can do at this time.</strong>

## What QuickFill is not
A magic bullet. A panacea. A one-size-fits-all tool. There are still many cases in which you'd have to collaborate with other techs / departments in order to find an appropriate response to a caller or ticket. I'd caution you from considering my responses as an authority on a particular issue, but rather a good direction to begin looking for an answer. Always double check something you're unfamiliar with. 

## How to use QuickFill
I aimed to make this program as user friendly as possible, however I recognize that not everyone is conformable with console-based programs. I'll break the entire process down with examples and simple steps.

<strong>First, Run the program</strong>

    1. Open Powershell or the CMD on your Windows Machine and type in "Powershell"
    2. Navigate to the QuickFill directory and run the QuickFill.ps1 script
    3. Respond to the prompt: Would you like to use a custom response file?
      * Note that you can input anything with a "y" here to use a custom response file
        otherwise, it'll query my API. Just hit "Enter" to move forward.

<strong>Next, the Main Menu will pop up and we'll have to select an option. The option you select will depend on what you're trying to do! Check out the examples for some ideas on how to use the program.</strong>

    ---------
    Main Menu
    ---------
    (0) Helpdesk Resources
    (1) Quick Responses
    (2) Wrong Department
    (3) General Hardware Concerns
    (4) General Software Concerns
    (5) EdApps
    (6) Modern Management Eng.
    (7) Sys. Eng.
    (8) Network Eng.
    (9) About this app
    (10) Search
    (-1) Exit
    Enter an option:
    
## Examples
#### Example 1 - Ticket comes in with a user not able to print

    ---------
    Main Menu
    ---------
    (0) Helpdesk Resources
    (1) Quick Responses
    (2) Wrong Department
    (3) General Hardware Concerns
    (4) General Software Concerns
    (5) EdApps
    (6) Modern Management Eng.
    (7) Sys. Eng.
    (8) Network Eng.
    (9) About this app
    (10) Search
    (-1) Exit
    Enter an option: 4

I know that the printing info lives in "General Software Concerns" so I'll type in "4." We'll be re-directed to that menu after we hit "Enter."

    -------------------------
    General Software Concerns
    -------------------------
    (0) DRC Insights - WIDA Assessments
    (1) Suspicious Emails
    (2) Bit locker recovery error
    (3) Help I have a virus! (Chrome notifications)
    (4) Connecting to PSDSTAFF on Android
    (5) Connecting to PSDSTAFF on IOS
    (6) REI Video Software - .HD5 files
    (7) Time is off - W32Time service
    (8) Resetting Passwords
    (9) OneNote Notebook troubleshooting
    (10) Student Login Concerns
    (11) Trusted Platform Module Error
    (12) Outlook Emails Not Sending
    (13) Adding A Shared Mailbox
    (14) Outlook Calendar
    (15) Eval Tool
    (16) Multi Factor Authentication (MFA) issues
    (17) Adobe Creative Cloud
    (18) PSDVPN
    (19) Display Settings
    (20) Adding folder from SharePoint to File Explorer
    (21) Printing issues
    (22) Employee Online Login
    (23) Parent Securly Concerns
    (24) How To Install An Application
    (25) How To Install Office 365
    (26) How to Sync the Company Portal
    (27) Back
    Select an option:

Now that we are in the correct menu, we'll hit "21" for "Printing Issues." We will then be prompted to enter the name of the person calling / who submitted the ticket. We'll use Bob as an example.

    -------------------------
    General Software Concerns
    -------------------------
    (0) DRC Insights - WIDA Assessments
    (1) Suspicious Emails
    (2) Bit locker recovery error
    (3) Help I have a virus! (Chrome notifications)
    (4) Connecting to PSDSTAFF on Android
    (5) Connecting to PSDSTAFF on IOS
    (6) REI Video Software - .HD5 files
    (7) Time is off - W32Time service
    (8) Resetting Passwords
    (9) OneNote Notebook troubleshooting
    (10) Student Login Concerns
    (11) Trusted Platform Module Error
    (12) Outlook Emails Not Sending
    (13) Adding A Shared Mailbox
    (14) Outlook Calendar
    (15) Eval Tool
    (16) Multi Factor Authentication (MFA) issues
    (17) Adobe Creative Cloud
    (18) PSDVPN
    (19) Display Settings
    (20) Adding folder from SharePoint to File Explorer
    (21) Printing issues
    (22) Employee Online Login
    (23) Parent Securly Concerns
    (24) How To Install An Application
    (25) How To Install Office 365
    (26) How to Sync the Company Portal
    (27) Back
    Select an option: 21
    Enter the first name of the user: Bob

    ** Item was copied to your clipboard **

Notice that the program will tell you anytime that it interacts with your clipboard by the message:  ** Item was copied to your clipboard **

What did it copy to your clipboard? Lets see!

<blockquote>

  Good afternoon Bob,

  Thank you for reaching out to the Helpdesk. Connecting to our printers can be challenging at times and there are a few things you need to check prior to a successful print. First, ensure that your PSDVPN is disconnected, and the box to connect automatically is unchecked. Second, ensure that you are on the PSDWIRELESS network or your connection shows psd.local. Lastly, ensure that you have added this printer through Printix. If these things are in order and you still can't print, follow the next steps:

  • Open your Company Portal

  • Search for 'Printix Service Fix' and install it

  • Attempt to print to the printer

  • If that is not successful, try removing the printer in your 'Printers & Scanners' menu, then re-add the printer through Printix.

  If adding a printer through Printix is something you are not sure about, complete the following steps

  • Move your mouse cursor down to the lower right-hand side of your taskbar (The long rectangle on the bottom of your screen)

  • Look for an upwards facing arrow ∧ and click that to open a small menu

  • Search for a little black and white 'P' and click that to open another menu

  • Search for the top menu option that says 'Printers' and click that to open another menu

  • In this menu, search for the printer you want to add, select the checkbox next to it, then click 'add' on the lower right-hand side of that menu

  Please feel free to give us a call if you have additional remarks at 253-841-8600, Monday - Friday, 6:30AM to 4:00PM. Have a wonderful rest of your day!

</blockquote>

All you have to do is hit CTRL + V to paste this response into the response box in TOPdesk if you are responding to a ticket. Next, lets look at the Remarks.

    [Printing issues]

    Remarks
    ----------
    • First check to make sure they are on PSDWIRELESS or PSDDEVICES
    • Check to make sure the PSDVPN is disconnected and the box to 'Connect Automatically' is unchecked
    • Ensure they have signed into Printix and have added the printers they want to use
    • Make sure the printer doesn't require a user code provided by the Office Manager
    • Check the Printix service and make sure it's running (Usually obvious by no printers showing up in the Printix list) - restart with admin creds if necessary
    • Escalate to Sys. Eng. Team if all these things are in place, but they still can't print

    Do you need this resources? (OneNote Notebook):

Here are the things we often need to consider when looking at printing issues. Notice how the program is asking you if you want to open an additional resource. If you want it to try and open the link for you, just input any word with a "y" in it, and it will open a Chrome or Edge tab / page to that link. There are additional links with this particular issue, and you can open one, or all!

#### Example 2 - Caller calls in and is asking for help with granting / removing badge access

    ---------
    Main Menu
    ---------
    (0) Helpdesk Resources
    (1) Quick Responses
    (2) Wrong Department
    (3) General Hardware Concerns
    (4) General Software Concerns
    (5) EdApps
    (6) Modern Management Eng.
    (7) Sys. Eng.
    (8) Network Eng.
    (9) About this app
    (10) Search
    (-1) Exit
    Enter an option: 2

I know that Edtec doesn't do this so I'll go to "Wrong Department" by typing "2." We'll be re-directed to that menu after we hit "Enter."
    
    ----------------
    Wrong Department
    ----------------
    (0) Facilities
    (1) Human Resources
    (2) Frontline
    (3) IEP Online
    (4) SafeSchools
    (5) Assessments
    (6) Back
    Select an option: 

Now that we are in the correct menu, we'll hit "0" for "Facilities." We will then be prompted to enter the name of the person calling. We'll use Bob again as an example.

    ----------------
    Wrong Department
    ----------------
    (0) Facilities
    (1) Human Resources
    (2) Frontline
    (3) IEP Online
    (4) SafeSchools
    (5) Assessments
    (6) Back
    Select an option: 0
    Enter the first name of the user: Bob

    ** Item was copied to your clipboard **

What did it copy to your clipboard this time? Lets see!

<blockquote>

  Good afternoon Bob,

  We appreciate you reaching out to the Helpdesk and we are always happy to help. However, this concern is not something that is handled by the Helpdesk, or Edtec as a whole. You will need to contact Facilities. Have an excellent rest of your day!

</blockquote>

All you have to do is hit CTRL + V to paste this response into the response box in TOPdesk if you are responding to a ticket. Next, lets look at the Remarks again.

    [Facilities]

    Remarks
    ----------
    • Badge access
    • Doors
    • Heating and cooling (HVAC)
    • Intercoms
    • Clocks

    Continue?:

These are all the common reasons someone will call in / submit a ticket for Facilities. There are no resource links, so the program is asking you to hit "Enter" or a "y" word to continue back to the Main Menu.

#### Example 3 - You get a call / ticket for WCAP and have no idea what / where that is

    ---------
    Main Menu
    ---------
    (0) Helpdesk Resources
    (1) Quick Responses
    (2) Wrong Department
    (3) General Hardware Concerns
    (4) General Software Concerns
    (5) EdApps
    (6) Modern Management Eng.
    (7) Sys. Eng.
    (8) Network Eng.
    (9) About this app
    (10) Search
    (-1) Exit
    Enter an option: 10

In this example, I have no idea where to look for this term, so lets search for it! Type in "10" and hit "Enter."
    
    ---------
    Main Menu
    ---------
    (0) Helpdesk Resources
    (1) Quick Responses
    (2) Wrong Department
    (3) General Hardware Concerns
    (4) General Software Concerns
    (5) EdApps
    (6) Modern Management Eng.
    (7) Sys. Eng.
    (8) Network Eng.
    (9) About this app
    (10) Search
    (-1) Exit
    Enter an option: 10
    Enter the search term: WCAP

You can see that the program is asking for a search term, so lets put in "WCAP." The algorithm will then go and look at every remark and item name for this term.

    ---------
    Main Menu
    ---------
    (0) Helpdesk Resources
    (1) Quick Responses
    (2) Wrong Department
    (3) General Hardware Concerns
    (4) General Software Concerns
    (5) EdApps
    (6) Modern Management Eng.
    (7) Sys. Eng.
    (8) Network Eng.
    (9) About this app
    (10) Search
    (-1) Exit
    Enter an option: 10
    Enter the search term: WCAP

    Wrong Department -> [Assessments]

    ** Item was copied to your clipboard **

Nice! The algorithm found that term in the "Wrong Department" menu under the menu item "Assessments" and copied the search results to your clipboard. Just navigate your way there for more information. Note that when you perform a search, the program only shows the search results for a few seconds. If you missed that period, you can just paste the results from your clipboard anywhere for reference.


What were those results again? Lets paste the results into Notepad with CTRL + V.

<blockquote>

    You searched for: WCAP

    Wrong Department -> [Assessments]


</blockquote>


## How to get additional help and submit change requests

Just shoot me an email, submit a ticket to me, or get me on Teams! If you like this program and find it useful, consider giving it a ⭐️

