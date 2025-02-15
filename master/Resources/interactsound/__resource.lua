-- Manifest Version
resource_manifest_version '77731fab-63ca-442c-a67b-abc70f28dfa5'

-- Client Scripts
client_script 'client/main.lua'

-- Server Scripts
server_script 'server/main.lua'

-- NUI Default Page
ui_page('client/html/index.html')

-- Files needed for NUI
-- DON'T FORGET TO ADD THE SOUND FILES TO THIS!
files {
    'client/html/index.html',
    'client/html/sounds/cuff.ogg',
    'client/html/sounds/carlock.ogg',
    'client/html/sounds/seatbelton.ogg',
    'client/html/sounds/seatbeltoff.ogg',
    'client/html/sounds/uncuff.ogg',
    'client/html/sounds/lockpick.ogg',
    'client/html/sounds/demo.ogg'
}
