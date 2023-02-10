
local m, s, o
local openclash = "openclash"
local uci = luci.model.uci.cursor()
local fs = require "luci.openclash"
local sys = require "luci.sys"
local json = require "luci.jsonc"
local sid = arg[1]

font_red = [[<b style=color:red>]]
font_off = [[</b>]]
bold_on  = [[<strong>]]
bold_off = [[</strong>]]


m = Map(openclash, translate("Config Subscribe Edit"))
m.pageaction = false
m.description=translate("Convert Subscribe function of Online is Supported By subconverter Written By tindy X") ..
"<br/>"..
"<br/>"..translate("API By tindy X & lhie1")..
"<br/>"..
"<br/>"..translate("Subconverter external configuration (subscription conversion template) Description: https://github.com/tindy2013/subconverter#external-configuration-file")..
"<br/>"..
"<br/>"..translate("If you need to customize the external configuration file (subscription conversion template), please write it according to the instructions, upload it to the accessible location of the external network, and fill in the address correctly when using it")..
"<br/>"..
"<br/>"..translate("If you have a recommended external configuration file (subscription conversion template), you can modify by following The file format of /usr/share/openclash/res/sub_ini.list and pr")
m.redirect = luci.dispatcher.build_url("admin/services/openclash/config-subscribe")
if m.uci:get(openclash, sid) ~= "config_subscribe" then
	luci.http.redirect(m.redirect)
	return
end

-- [[ Config Subscribe Setting ]]--
s = m:section(NamedSection, sid, "config_subscribe")
s.anonymous = true
s.addremove   = false

---- name
o = s:option(Value, "name", translate("Config Alias"))
o.description = font_red..bold_on..translate("Name For Distinguishing")..bold_off..font_off
o.placeholder = translate("config")
o.rmempty = true

---- address
o = s:option(Value, "address", translate("Subscribe Address"))
o.template = "cbi/tvalue"
o.rows = 10
o.wrap = "off"
o.description = font_red..bold_on..translate("SS/SSR/Vmess or Other Link And Subscription Address is Supported When Online Subscription Conversion is Enabled, Multiple Links Should be One Per Line or Separated By |")..bold_off..font_off
o.placeholder = translate("Not Null")
o.rmempty = false
function o.validate(self, value)
	if value then
		value = value:gsub("\r\n?", "\n")
		value = value:gsub("%c*$", "")
	end
	return value
end

---- subconverter
o = s:option(Flag, "sub_convert", translate("Subscribe Convert Online"))
o.description = translate("Convert Subscribe Online With Template, Mix Proxies and Keep Settings options Will Not Effect")
o.default = 0

---- Convert Address
o = s:option(Value, "convert_address", translate("Convert Address"))
o.rmempty     = true
o.description = font_red..bold_on..translate("Note: There is A Risk of Privacy Leakage in Online Convert")..bold_off..font_off
o:depends("sub_convert", "1")
o:value("", translate("api.dler.io")..translate("(Default)"))
o:value("", translate("subconverter.herokuapp.com")..translate("(Default)"))
o:value("", translate("v.id9.cc")..translate("(Support Vless By Pinyun)"))
o:value("", translate("sub.id9.cc"))
o:value("", translate("api.wcc.best"))
o.default = ""

---- Template
o = s:option(ListValue, "template", translate("Template Name"))
o.rmempty     = true
o:depends("sub_convert", "1")
file = io.open("/usr/share/openclash/res/sub_ini.list", "r");
for l in file:lines() do
	if l ~= "" and l ~= nil then
		o:value(string.sub(luci.sys.exec(string.format("echo '%s' |awk -F ',' '{print $1}' 2>/dev/null",l)),1,-2))
	end
end
file:close()
o:value("0", translate("Custom Template"))

---- Custom Template
o = s:option(Value, "custom_template_url", translate("Custom Template URL"))
o.rmempty     = true
o.placeholder = translate("Not Null")
o.datatype = "or(host, string)"
o:depends("template", "0")

---- emoji
o = s:option(ListValue, "emoji", translate("Emoji"))
o.rmempty     = false
o:value("false", translate("Disable"))
o:value("true", translate("Enable"))
o.default = "false"
o:depends("sub_convert", "1")

---- udp
o = s:option(ListValue, "udp", translate("UDP Enable"))
o.rmempty     = false
o:value("false", translate("Disable"))
o:value("true", translate("Enable"))
o.default = "false"
o:depends("sub_convert", "1")

---- skip-cert-verify
o = s:option(ListValue, "skip_cert_verify", translate("skip-cert-verify"))
o.rmempty     = false
o:value("false", translate("Disable"))
o:value("true", translate("Enable"))
o.default = "false"
o:depends("sub_convert", "1")

---- sort
o = s:option(ListValue, "sort", translate("Sort"))
o.rmempty     = false
o:value("false", translate("Disable"))
o:value("true", translate("Enable"))
o.default = "false"
o:depends("sub_convert", "1")

---- node type
o = s:option(ListValue, "node_type", translate("Append Node Type"))
o.rmempty     = false
o:value("false", translate("Disable"))
o:value("true", translate("Enable"))
o.default = "false"
o:depends("sub_convert", "1")

---- rule provider
o = s:option(ListValue, "rule_provider", translate("Use Rule Provider"))
o.description = font_red..bold_on..translate("Note: Please Make Sure Backend Service Supports This Feature")..bold_off..font_off
o.rmempty     = false
o:value("false", translate("Disable"))
o:value("true", translate("Enable"))
o.default = "false"
o:depends("sub_convert", "1")

---- key
o = s:option(DynamicList, "keyword", font_red..bold_on..translate("Keyword Match")..bold_off..font_off)
o.description = font_red..bold_on..translate("eg: hk or tw&bgp")..bold_off..font_off
o.rmempty = true

---- exkey
o = s:option(DynamicList, "ex_keyword", font_red..bold_on..translate("Exclude Keyword Match")..bold_off..font_off)
o.description = font_red..bold_on..translate("eg: hk or tw&bgp")..bold_off..font_off
o.rmempty = true

---- de_exkey
o = s:option(MultiValue, "de_ex_keyword", font_red..bold_on..translate("Exclude Keyword Match Default")..bold_off..font_off)
o.rmempty = true
o:depends("sub_convert", 0)
o:value("过期时间")
o:value("剩余流量")
o:value("TG群")
o:value("官网")

local t = {
    {Commit, Back}
}
a = m:section(Table, t)

o = a:option(Button,"Commit", " ")
o.inputtitle = translate("Commit Settings")
o.inputstyle = "apply"
o.write = function()
   m.uci:commit(openclash)
   luci.http.redirect(m.redirect)
end

o = a:option(Button,"Back", " ")
o.inputtitle = translate("Back Settings")
o.inputstyle = "reset"
o.write = function()
   m.uci:revert(openclash, sid)
   luci.http.redirect(m.redirect)
end

m:append(Template("openclash/toolbar_show"))
return m
