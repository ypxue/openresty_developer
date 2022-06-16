# openresty_developer
openresty搭建的通用开发环境

> + 该环境可以省去本地搭建开发环境，如安装phpstudy或wamp等软件的繁琐步骤
>
> + 可实现多人独立研发环境，互不干扰

配置介绍：

```nginx
server {
	lua_code_cache off;	

    listen 6602;
	
    # 此处为web目录
	set $root_path /www/dev/;
    # 此处为项目目录
	set $product_path /trunk/public/;

    # 通过lua脚本获取ip映射开发者信息，获取开发者路径
	set_by_lua_file $root lua/GetRoot.lua;

	root $root;
	index index.html index.htm index.shtml index.php;	

	location /test {
		content_by_lua_block {
			ngx.say(ngx.var.root)		
		}
	}

	location = /config {
		default_type "text/plain";
		access_by_lua_block {
			if ngx.req.get_method() == "GET" then
				return ngx.redirect("/config.html")
			end
		}
		content_by_lua_file lua/SetUserDev.lua;
	}

	location = /config.html {
		root "lua";
	}	
}
```

