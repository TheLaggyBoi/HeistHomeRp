## Instalation
- Back up your base chat. (resources > gameplay)
- Replace it with this resource.

## Features  
- Easy color configuration.
- `/twt` for twitter, `/ooc` for out of character, `/web` for dark web and `/adv` for advertisment. (These can be changed in `commands.lua` Muts be at least 3 letters.)
- `/clear` for the invoker
- Local /say. (Can change it chat based by commenting out lines `240` in `cl_chat.lua` and commenting in lines )
- Can't send messages without a valid /command. (Prevents accidents.)

## Optional (Must comment in)
- Join and leave notifications. (Lines `59` and `66` in `sv_chat.lua` )
- Uncomment lines `73-75` or `77-70` in `sv_chat.lua` to add /say into the chat rather than on person. (Must comment it out in `cl_chat.lua`)

## Notes
I've commented on most things you may want to change so please look before asking for help.

Edited by: RemBestGirl#1186