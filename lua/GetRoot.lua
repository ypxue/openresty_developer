local LIP = require "lua/LIP"
local IpTools = require "lua/IpTools"
local user_dev_conf = "lua/Developer.ini"

local headers = ngx.req.get_headers()
local client_ip = headers['x-real-ip']

if client_ip == nil or string.len(client_ip) == 0 or client_ip == "unknown" then
	client_ip = ngx.var.remote_addr
end

local user_conf = LIP.load(user_dev_conf)
local ip_key = IpTools:ip_to_int(client_ip)
local user_path = "/unknow"
if user_conf.ip[ip_key] ~= nil then
	user_path = user_conf.ip[ip_key]
end

local root_path = ngx.var.root_path
local product_path = ngx.var.product_path

return root_path .. user_path .. product_path

