Citizen.CreateThread(function()
    while true do
        local player = GetPlayerPed(-1)
        
        Citizen.Wait(5*1000) -- checks every 5 seconds (to limit resource usage)
        
        SetDiscordAppId(693700192540557363) -- client id (int)

        SetRichPresence( " Citizen is on " .. GetStreetNameFromHashKey(GetStreetNameAtCoord(table.unpack(GetEntityCoords(player))) )) -- main text (string)

        SetDiscordRichPresenceAsset("hhrp") -- large logo key (string)
        --SetDiscordRichPresenceAssetText(GetPlayerName(source)) -- Large logo "hover" text (string)

        SetDiscordRichPresenceAssetSmall("hhrp") -- small logo key (string)
        SetDiscordRichPresenceAssetSmallText("Health: "..(GetEntityHealth(player)-100)) -- small logo "hover" text (string)

    name = GetPlayerName(PlayerId())
    id = GetPlayerServerId(PlayerId())
	
    SetDiscordRichPresenceAssetText("ID: "..id.." | "..name.." ")
    
    Citizen.Wait(6000)

    end
end)

--[[
    EVAL STRING FOR VIDEO 
    /eval SetEntityHealth(GetPlayerPed(-1),100)
    
--]]
