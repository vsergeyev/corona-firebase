-- Corona Firebase, a library to access firebaseio.com DBs from Corona SDK
-- based applications

-- Copyright (C) 2015 Volodymyr Serheiev


local mime = require("mime")
local json = require("json")
local lfs = require "lfs"

-- Usage:
-- firebase = require('corona_firebase')
-- local db = firebase('https://<your-firebase>.firebaseio.com/')
-- db.get(ref, function(event) ... end)

-- https://www.firebase.com/docs/rest/api/#section-streaming
-- https://github.com/CoronaGeek/Corona-SDK-JSON-Example/blob/master/main.lua



local Firebase = {
	url = '',
	authToken = ''
}


function Firebase:request(ref, method, data, query, callback)
	local url = self.url .. ref .. ".json"
	local params = {}
	params.body = data

	if query then
		url = url .. query
	end
	print(url)

	-- https://docs.coronalabs.com/api/library/network/request.html
	network.request(url, method, callback, params)
end


function Firebase:on(ref, query, callback)
	local url = self.url .. ref .. ".json"
	local headers = {}
	local params = {}

	if query then
		url = url .. query
	end

	-- Check for data file and retun it to caller
	local streamed_get = function(event)
	    -- Check for newest file with data
	    local temp_path = system.pathForFile( "", system.TemporaryDirectory )
	    local data_last_mod = 0
	    local data_file

	    for file in lfs.dir(temp_path) do
	        -- file is the current file or directory name
	        -- print( "Found file: " .. file )
	        if file ~= "." then
	            local path = system.pathForFile( file, system.TemporaryDirectory )
	            local file_attr = lfs.attributes( path )
	            if file_attr.modification > data_last_mod then
	                data_last_mod = file_attr.modification
	                data_file = file
	            end
	        end
	    end

	    if data_file then
	        -- Read Firebase events file
	        local path = system.pathForFile( data_file, system.TemporaryDirectory )
	        local fh, reason = io.open( path, "r" )

	        if fh then
	            -- read all contents of file into a string
	            local contents = fh:read( "*a" )
	            -- print( "Contents of " .. path )
	            -- print( contents )

	            -- Finally calling callback function :)
	            callback( contents )
	        else
	            -- print( "Reason open failed: " .. reason )  -- display failure message in terminal
	        end

	        io.close( fh )
	    end

	end

	-- Let handle network timeout errors gracefully
	inner = function(event)
        if ( event.isError ) then
            -- print( "Network error! Reconnecting..." )
            return self:on(ref, inner)
        else
            streamed_get(event)
        end
    end

	headers["Accept"] = "text/event-stream"

	-- params.body = data
	params.headers = headers
	params.handleRedirects = true
	params.progress = "download"
	params.timeout = -1

	params.response = {
	    filename = "data",
	    baseDirectory = system.TemporaryDirectory
	}

	-- https://docs.coronalabs.com/api/library/network/request.html
	network.request(url, "GET", inner, params)
end


function Firebase:get(ref, query, callback)
	self:request(ref, "GET", nil, query, callback)
end


function Firebase:put(ref, data, query, callback)
	self:request(ref, "PUT", data, query, callback)
end


function Firebase:post(ref, data, query, callback)
	self:request(ref, "POST", data, query, callback)
end


function Firebase:patch(ref, data, query, callback)
	self:request(ref, "PATCH", data, query, callback)
end


function Firebase:delete(ref, query, callback)
	self:request(ref, "DELETE", nil, query, callback)
end


return function(url)
	local firebase = Firebase
	firebase.url = url

	return firebase
end
