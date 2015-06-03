# Corona-firebase

Library to work with Firebase databases in Corona SDK based apps

It utilize Firebase REST API to retrieve, add, change and delete data.

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
