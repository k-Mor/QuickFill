/**
 * Copyright 2021 Kaleb Moreno

    Licensed under the Apache License, Version 2.0 (the "License");
    you may not use this file except in compliance with the License.
    You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

    Unless required by applicable law or agreed to in writing, software
    distributed under the License is distributed on an "AS IS" BASIS,
    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
    See the License for the specific language governing permissions and
    limitations under the License.

 * 
 * @author Kaleb Moreno
 * @version 08/27/2021
 * @description - This file holds all of the backend code for a simple API that sends JSON data 
 * to any site that sends in a GET request.
 */


// The Express framework and other constants
const express = require('express'), 
    
    // Instance of the Express Framework
    app = express(), 

    // Grab the data
    data = require('./Data/responses.json'),

   // Heroku port or defaults to 3000
    appPort = process.env.PORT || 3000, 

    // Cors library
    cors = require('cors');

// telling the application to use CORS
app.use(cors());

// Telling express to expect JSON data
app.use(express.json());

// Root route 
app.get('/', (req, res) => {
        // Jackpot data
        res.json(data);
});

// Telling the app to listen on either a local port in Heroku, or 3000 by default
app.listen(appPort, () => {
    console.log("Application started & listening on port: ", appPort);
});