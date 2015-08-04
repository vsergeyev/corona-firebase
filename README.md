# Corona-firebase

Library to work with Firebase databases in Corona SDK based apps

It utilize Firebase REST API to retrieve, add, change and delete data.
Streaming API supported too.

# Fast start

    firebase = require('corona_firebase')
    local db = firebase('https://corona.firebaseio.com/')
    db:get("users", function(event)
      if ( event.isError ) then
        print( "Network error!" )
      else
        print ( event.response )
      end
    end)

# Usage

``main.lua`` file contains useful tests. Run it on Corona Emulator and look
into console output to see what happening. It using https://corona.firebaseio.com/ DB for tests.


# Methods

Importing library returns a db object. It mimics behaviour of Firebase REST API https://www.firebase.com/docs/rest/api/

    firebase = require('corona_firebase')
    local db = firebase('https://[YOUR_DB_ID_HERE].firebaseio.com/')

On a background ``network.request`` used from Corona SDK https://docs.coronalabs.com/api/library/network/request.html

## get - reading data

    db:get("[ENDPOINT]", function(event)
    	if ( event.isError ) then
            -- Network error
        elseif ( event.phase == "began" ) then
            -- Request started, something useful may be in event.response
        elseif ( event.phase == "progress" ) then
            -- Request in progress
        elseif ( event.phase == "ended" ) then
            -- Finished, data should be in event.response
        end
    end)

## post - pushing data

    db:post("[ENDPOINT]", '[JSON_DATA]', function(event)
        -- ..
    end)

## patch - updating data

    db:patch("[ENDPOINT]", '[JSON_DATA]', function(event)
        -- ..
    end)

## put - writing data

    db:put("[ENDPOINT]", '{"key": "value"}', function(event)
    	-- ..
    end)

## delete - removing data

    db:delete("[ENDPOINT]", function(event)
    	-- ..
    end)

# Streaming

## on - subscribing on live data updates

    db:on("[ENDPOINT]", function( data )
        print("Got data!")
        print(data)
    end)

``EventSource / Server-Sent Events`` protocol used here. Client's ``Accept`` header is set to ``text/event-stream``. Every time ''data'' changed on server your application will receive a
notification. Timeout errors handled as well.
