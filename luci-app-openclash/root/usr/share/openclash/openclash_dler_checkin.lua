#!/usr/bin/lua

require "nixio"
require "luci.util"
require "luci.sys"
local uci = require("luci.model.uci").cursor()
local fs = require "luci.openclash"
local json = require "luci.jsonc"

local function dler_checkin()
	luci.sys.exec(string.format('echo "%s Dler Cloud Checkin Failed! Please Check And Try Again..." >> /tmp/openclash.log', os.date("%Y-%m-%d %H:%M:%S")))
	os.exit(0)
end

dler_checkin()