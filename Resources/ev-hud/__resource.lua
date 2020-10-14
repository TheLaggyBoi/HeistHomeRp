resource_manifest_version '77731fab-63ca-442c-a67b-abc70f28dfa5'

--[[client_script {
	'client.lua',
	'config.lua'
}

server_script {
	'server.lua'
}

ui_page('html/ui.html')

files({
	"html/js/app.js",
	"html/jquery.min.js",
	"html/jquery-ui.min.js",
	--CSS
	"html/css/main.css",
	"html/css/AlegreyaSansSC-Black.tttf",
	"html/css/gta-ui.tttf",
	"html/css/AlegreyaSansSC-Bold.tttf",
	"html/css/pdown.tttf",
	"html/css/pricedown_bl-webfont",
	
	
	
	"html/img/*.svg",
	"html/ui.html",
})--]]

server_scripts {
    "config.lua",
    "server.lua",
}

client_scripts {
    "config.lua",
    "client/main.lua",
}

ui_page {
    'html/ui.html'
}

files {
    'html/seatbelt-on.png',
    'html/seatbelt.png',
    'html/engine-red.png',
    'html/engine.png',
    'html/ui.html',
    'html/css/main.css',
    'html/css/pricedown_bl-webfont.ttf',
    'html/css/pricedown_bl-webfont.woff',
    'html/css/pricedown_bl-webfont.woff2',
    'html/css/gta-ui.ttf',
    'html/js/app.js',
    'html/css/pdown.ttf',
    'html/css/AlegreyaSansSC-Bold.tttf',
    'html/css/AlegreyaSansSC-Black.ttf',
    'html/css/PRIMETIME.tttf',
    'html/css/QUARTZO.tttf',
}