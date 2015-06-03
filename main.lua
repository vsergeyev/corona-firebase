firebase = require('corona_firebase')


local db = firebase('https://corona.firebaseio.com/')


print("---- Begin tests ----")


print("GET")
db:get("users", function(event)
	if ( event.isError ) then
        print( "Network error!" )
    else
        print ( "GET RESPONSE: " .. event.response )
    end
end)


print("PUT")
db:put("users", '{"name": "Vova"}', function(event)
	if ( event.isError ) then
        print( "Network error!" )

    elseif ( event.phase == "began" ) then
        print( "PUT started" )
        print ( "PUT RESPONSE: " .. event.response )

    elseif ( event.phase == "progress" ) then
        print( "PUT in progress" )
        print ( "PUT RESPONSE: " .. event.response )

    elseif ( event.phase == "ended" ) then
        print( "PUT ended" )
        print ( "PUT RESPONSE: " .. event.response )
    end
end)


print("PATCH")
db:put("users/id", '"1"', function(event)
	if ( event.isError ) then
        print( "Network error!" )

    elseif ( event.phase == "began" ) then
        print( "PATCH started" )
        print ( "PATCH RESPONSE: " .. event.response )

    elseif ( event.phase == "progress" ) then
        print( "PATCH in progress" )
        print ( "PATCH RESPONSE: " .. event.response )

    elseif ( event.phase == "ended" ) then
        print( "PATCH ended" )
        print ( "PATCH RESPONSE: " .. event.response )
    end
end)


print("POST")
db:put("users/test", '[2, 3]', function(event)
	if ( event.isError ) then
        print( "Network error!" )

    elseif ( event.phase == "began" ) then
        print( "POST started" )
        print ( "POST RESPONSE: " .. event.response )

    elseif ( event.phase == "progress" ) then
        print( "POST in progress" )
        print ( "POST RESPONSE: " .. event.response )

    elseif ( event.phase == "ended" ) then
        print( "POST ended" )
        print ( "POST RESPONSE: " .. event.response )

		print("DELETE /users/test/0/")
		db:delete("users/test/0/", function(event)
			if ( event.isError ) then
		        print( "Network error!" )
		    else
		        print ( "DELETE RESPONSE: " .. event.response )

		        if ( event.phase == "ended" ) then
			       	print("GET /users/test/")
					db:get("/users/test/", function(event)
						if ( event.isError ) then
					        print( "Network error!" )
					    else
					        print ( "GET RESPONSE: " .. event.response )
					    end
					end)
				end
		    end
		end)
    end
end)


print("DELETE")
db:delete("users/test", function(event)
	if ( event.isError ) then
        print( "Network error!" )
    else
        print ( "DELETE RESPONSE: " .. event.response )
    end
end)


print("---- AUTH tests ----")
print("GET")
db:get("", function(event)
	if ( event.isError ) then
        print( "Network error!" )
    else
        print ( "GET RESPONSE: " .. event.response )
    end
end)