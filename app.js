/**
 * @author Kaleb Moreno
 * @version 07/15/2021
 * 
 * @description The purpose of this file is to house the driver and 
 * methods which together form a user input, JSON file manipulation program.
 * 
 * Unicodes in use 
 * -------------------------
 * \u263C - Sun bullet point
 * \u21D2 - Right arrow
 * \u2691 - Black flag
 * \u26A0 - Warning sign
 * \u26CF - Pickaxe
 * \u2301 - Lighting bolt
 * 
 */

const prompt = require('prompt-sync')(), // The library that allows for easier user input
	fs = require('fs'), // The file system library
	jsonData = require('./Data/responses.json'), // The JSON I created for the responses
	clipboardy = require('clipboardy'); // This library gives me the ability to copy to the clipboard

/**
 * @description This function simply prints a string for user feedback
 */
const feedback = () => {
	console.clear();
	console.log('\n\u26CF  Response was copied to the clipboard  \u26CF\n');
};

/**
 * @description The purpose of this method is to write the formatted strings to an output
 * file for copying and pasting.
 * 
 * @param {string} theContent 
 */
// const writeOutput = (theContent) => {

// 	const file = './output.txt';
// 	fs.writeFile(file, theContent, err => {
// 		if (err) {
// 			console.log(err);
// 			return;
// 		};
// 	});
// };


/**
 * @description The purpose of this method is to return the time of day at the time of the call
 * 
 * @returns This method returns a string representation of the time of day
 */
const getTime = () => {
	let date = new Date();
	let time = date.getHours();

	if (time < 12) {
		return 'morning';
	} else {
		return 'afternoon';
	}

};

/**
 * @description The purpose of this method is to show the menu that is passed to it 
 * by printing it to the console.
 * 
 * @param {string} theHeader - The "name" of the JSON object 
 * @param {*} theMenu  - The "options" of the JSON object
 */
const showM = (theHeader, theMenu) => {
	const temp = -1;

	console.log(
		"\u2301".repeat(18) + `\n${theHeader}\n` + "\u2301".repeat(18) + "\n");

	for (item in theMenu) {

		if (theMenu[item].name == "Exit") {
			console.log(`(${temp}) ${theMenu[item].text}`);	
		} else {
			console.log(`(${item}) ${theMenu[item].name}`);	
		};
		
	};
};

/**
 * @description the purpose of this function is to find and replace data pulled from
 * a separate JSON file. It then calls the WriteOutput function for writing to the file.
 * 
 * @param {*} theMainMenu - The main menu
 * @param {*} theSelection - The main menu option that the user selected
 * @param {*} theOptions - The options found in the JSON file for that selection
 * @param {*} theName - The name of the caller / user
 * @param {*} theDays - The days of the week EdTech is open
 * @param {*} theHours - The business hours EdTech is open	
 * @param {*} theAsset - The asset tag associated with a referenced device
 * @param {*} theRoom - The room or location at which the problem was discovered
 * @param {*} thePhone - The current phone number for EdTech
 * @param {*} theLink  - The current Bookings appointment link
 */
const formatResponseSub = (theMainMenu, theSelection, theOptions, theName, theDays, theHours, theAsset, theRoom, thePhone, theLink) => {

	// Checking for the exit -1 character
	if (theSelection >= 0) {
		let innerInput;
		let escalate = 2;
		let wrongD = 1;
		let theServiceOut;

		theName = prompt('Enter a first name for this issue: ');

		if (prompt("Need more options: Asset/RM/Service (y)? ") == 'y') {
			theAsset = prompt('Enter the asset # if applicable: ');
			theRoom = prompt('Enter the room # / Location if applicable: ');
			theServiceOut = prompt('Enter the disrupted service if applicable: ');

		};

		// Showing the menu
		showM(theMainMenu.options[theSelection].name, theOptions);

		// Getting a sub option selection
		innerInput = parseInt(prompt('Enter a sub option: '));

		// Checking for valid selection options
		if (innerInput >= 0) {

			// Grabbing the JSON we need
			let handle = theMainMenu.options[theSelection].options[innerInput];

			if(theSelection == escalate || theSelection == wrongD) { // Escalation sub menu will always be 1

				// Reducing the depth of the handle
				handle = theMainMenu.options[theSelection];
			}

			// Writing the response to the output file and replacing the placeholders.
			clipboardy.writeSync(handle.text
				.replace("{time}", getTime())
				.replace("{fname}", theName)
				.replace("{days}", theDays)
				.replace("{phone}", thePhone)
				.replace("{hours}", theHours)
				.replace("{asset}", theAsset)
				.replace("{team}", theOptions[innerInput].name)
				.replace("{room}", theRoom)
				.replace("{APlink}", theLink)
				.replace("{service}", theServiceOut));
			
				// Providing user feedback
				feedback();
		};
	};
};

/**
 * @description The purpose of this function is to format the response of a 
 * non-sub-menu containing main menu selection.
 * 
 * @param {JSON object} theMainMenu - The main menu options
 * @param {*} theSelection - The user input selection
 * @param {*} theName - The name of the user / caller
 * @param {*} theDays - The days EdTech is open 
 * @param {*} theHours - The hours the EdTech is open for
 * @param {*} thePhone - The current phone number for the Helpdesk
 */
const formatResponse = (theMainMenu, theSelection, theName, theDays, theHours, thePhone) => {

	theName = prompt('Enter a first name: ');

	showM(theMainMenu.options[theSelection].name);

	clipboardy.writeSync(theMainMenu.options[theSelection].text
		.replace("{time}", getTime())
		.replace("{fname}", theName)
		.replace("{days}", theDays)
		.replace("{phone}", thePhone)
		.replace("{hours}", theHours));

	feedback();
};


/**
 * @description This is the driver for the program
 */
const Main = () => {


	// User input representation
	let userInput = 0,
		fname = '',
		exitNum = -1,
		asset = "",
		wrongDepartment = 1,
		escM = 2,
		compM = 3,
		commonIssues = 4,
		phone = "253-841-8600",
		days = "Monday - Friday",
		hours = "07:30AM to 03:30PM",
		room = "",
		APlink = "https://outlook.office365.com/owa/calendar/EdtecHelpdeskCalendar@puyallupsd.onmicrosoft.com/bookings/";
		mainM = jsonData.mainMenu,
		header = mainM.name


	// Starting the REPL
	while (userInput != exitNum) {

		//Show the main menu
		showM(header, mainM.options);

		//Getting the response
		userInput = parseInt(prompt('Enter a number: '));

		//The options that run after the selection
		if (userInput >= 0) {

			// Sub menu 1
			const compOptions = mainM.options[userInput].options;

			// Sub menu 2
			const escOptions = mainM.options[userInput].options;

			// Sub menu 3
			const issueOptions = mainM.options[userInput].options;

			// Sub menu 4
			const wrongD = mainM.options[userInput].options;

			if (userInput == escM) {

				formatResponseSub(mainM, userInput, escOptions, fname, days, hours, asset, room, phone, APlink);
			} 
			
			else if (userInput == commonIssues) {

				formatResponseSub(mainM, userInput, issueOptions, fname, days, hours, asset, room, phone, APlink);
			} 
			
			else if (userInput == compM) {

				formatResponseSub(mainM, userInput, compOptions, fname, days, hours, asset, room, phone, APlink);

			} 
			
			else if (userInput == wrongDepartment) {

				formatResponseSub(mainM, userInput, wrongD, fname, days, hours, asset, room, phone, APlink);

			// General case
			} 
			
			else {
				formatResponse(mainM, userInput, fname, days, hours, phone);
			};
		};
	};
};

// Starting the program
Main();
