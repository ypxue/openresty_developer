local LIP = require "lua/LIP"
local IpTools = require "lua/IpTools"
local user_dev_conf = "lua/Developer.ini"

local headers = ngx.req.get_headers()
local client_ip = headers["x-real-ip"]

if client_ip == nil or string.len(client_ip) == 0 or client_ip == "unknown" then
	client_ip = ngx.var.remote_addr
end

if ngx.req.get_method() == "POST" then
	ngx.req.read_body()
	
	local args = ngx.req.get_post_args()
	
	if args.name == nil or args.name == "" then
		ngx.say("The name field cannot be empty!")
		ngx.exit(500)	
	end
	
	local user_conf = LIP.load(user_dev_conf)
	local ip_key = IpTools:ip_to_int(client_ip)
	
	if user_conf == nil then user_conf = {} end
	if user_conf.ip == nil then user_conf.ip = {} end

	user_conf.ip[ip_key] = args.name
	LIP.save(user_dev_conf, user_conf)

	ngx.say("The developer information is saved success!")
	ngx.exit(200)
end
