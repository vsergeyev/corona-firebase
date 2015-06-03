-- Corona Firebase, a library to access firebaseio.com DBs from Corona SDK
-- based applications

-- Copyright (C) 2015 Volodymyr Serheiev


local mime = require("mime")
local json = require("json")

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


function Firebase:request(ref, method, data, callback)
	local url = self.url .. ref .. ".json"
	local params = {}
	params.body = data

	-- https://docs.coronalabs.com/api/library/network/request.html
	network.request(url, method, callback, params)
end


function Firebase:get(ref, callback)
	self:request(ref, "GET", nil, callback)
end


function Firebase:put(ref, data, callback)
	self:request(ref, "PUT", data, callback)
end


function Firebase:post(ref, data, callback)
	self:request(ref, "POST", data, callback)
end


function Firebase:patch(ref, data, callback)
	self:request(ref, "PATCH", data, callback)
end


function Firebase:delete(ref, callback)
	self:request(ref, "DELETE", nil, callback)
end


return function(url)
	local firebase = Firebase
	firebase.url = url

	return firebase
end
