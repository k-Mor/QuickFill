# QuickFill

## What is QuickFill?
##### QuickFill is a Powershell console program that seeks to demystify the ticket creation / response process by copying pre-formatted responses to the system clipboard, while providing useful remarks for a selected topic. This program assumes the following about its users:

1. You are tired of typing the same things over and over while responding to common issues - like printers failing to print.
2. You realize that you can't remember everything, and would like to be able to search for less common issues quickly
3. You are either on the phone with a caller, or interacting with a user via TOPdesk.
4. You like to have all of your resources in one central place.
5. You don't know where to find the information you need for a particular concern.

##### There are a few things that this program does for you that makes your life as a Helpdesk Tech easier:

1. Writes responses, based on your selection in one of the menus and adds in dynamic content, like the time of day. For example, the program checks to see what time of day it is before it proceeds to write "Good morning so-and-so" or "Good afternoon so-and-so." This is so you don't have to go back and edit a response before you send it off.
2. The program will copy that response to your clipboard so you can simply hit CTRL + V to paste it into the response box in TOPdesk. This is a huge time saver during the busy seasons.
3. The program will show you links to relevant resources, if there are any, in SharePoint, OneNote or other documentation hubs, for selected concerns. It will then attempt to automatically open that resource in a tab / page in Chrome. If Chrome is not present, the program will default to Microsoft Edge. This is all optional however.
4. Most of the options that exist in the sub menus contain "Remarks." Remarks help familiarize a new Tech and even remind seasoned Techs, what they ought to do for a particular concern. For example, say someone calls in about a Juno:
    * First, the Tech will find the Juno menu option and go through the prompts (I will cover this in a moment)
    * Next, the Tech will review the remarks and realize that they MUST include the room number of the Juno in the ticket before they escalate it to a On Site Tech. This little detail is one example of things that are very often missed during ticket escalation, which can be avoided by using this program.
5. This program contains a search algorithm that makes locating specific issues much easier within the program itself. All you have to do is select "Search", input a search term, and the program will show you where it found that term, then copy the search results / path to your clipboard. This is super helpful when you don't where to look for something. So, if you didn't have enough time to look at the results, you can just paste them anywhere for further review.
6. In the "Helpdesk Resources" there are links to just about anything you could need as a Tech. There are status pages, guides, official resources like the Approved Applications List, text based guides, etc. 

##### Best of all, this program is totally customizable and very flexible. If you pick up just a little knowledge on how to read JSON, you can write and use your own custom response file! This means you can make the program say whatever you want it to. However, if you want to keep it simple and aren't interested in writing your own responses, you can just use my API which I'll do my best to keep up to date and relevant. Note that this a labor of love and is something that only I can do at this time.

## What QuickFill is not
#### A magic bullet. There are still many cases in which you'd have to collaborate with other techs / departments in order to find an appropriate response to a caller or ticket. I'd caution you at considering my responses as an authority on a particular issue, but rather a good direction to begin looking for an answer. Always double check something you're unfamiliar with. 

## What problem this program aims to solve
---

## How to use this program efficiently
---

## How to get additional help and submit change requests
---

