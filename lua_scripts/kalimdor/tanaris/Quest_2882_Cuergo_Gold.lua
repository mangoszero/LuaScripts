--[[
    EmuDevs <http://emudevs.com/forum.php>
    Eluna Lua Engine <https://github.com/ElunaLuaEngine/Eluna>
    Eluna Scripts <https://github.com/ElunaLuaEngine/Scripts>
    Eluna Wiki <http://wiki.emudevs.com/doku.php?id=eluna>

    -= Script Information =-
    * Zone: Tanaris
    * Script Type: Quest (Cuergo's Gold 2882)
    * Creature: Sailor boys (Treasure Hunting Pirate: 7899, Treasure Hunting Swashbuckler: 7901, Treasure Hunting Buccaneer: 7902)
    * Game object: Pirate's treasure chest (142194)
    * Version: tested on Zero
--]]

-- This creates the table used to localize all variables and functions
local CuergoGold = {
    GO_INCONSPICUOUS_LANDMARK = 142189,
    NPC_PIRATE = 7899,
    NPC_SWASHBUCKLER = 7901,
    NPC_BUCCANEER = 7902,
    GO_PIRATE_TREASURE = 142194,    
    SPAWN_DURATION = 600000 -- pirates and chest will exist in world for 10 minutes
}

function CuergoGold.PirateTreasure_OnUse(event, player, go)
    -- despawn the chest
    go:Despawn(10)
end

function CuergoGold.SpawnPirates(player, totalPirates)
    for i = 1, totalPirates, 1 do
    	local X, Y, Z, O = player:GetLocation()
        local X = X + math.random(5)
        local Y = Y + math.random(5)
        local pirate = math.random(1,3)
        if pirate == 1 then
            player:SummonCreature(CuergoGold.NPC_PIRATE, X, Y, Z, O, 1, CuergoGold.SPAWN_DURATION)
        elseif pirate == 2 then
            player:SummonCreature(CuergoGold.NPC_SWASHBUCKLER, X, Y, O, 0, 1, CuergoGold.SPAWN_DURATION)
        else 
            player:SummonCreature(CuergoGold.NPC_BUCCANEER, X, Y, Z, O, 1, CuergoGold.SPAWN_DURATION)
        end
    end
end

function CuergoGold.InconspicuousLandmark_OnUse(event, player, go)
    local totalPirates = math.random(4,5)
    SpawnPirates(player, totalPirates)
    -- spawn the chest
    player:SummonGameObject(CuergoGold.GO_PIRATE_TREASURE, -10117.715, -4051.644, 5.407, 0, CuergoGold.SPAWN_DURATION)
end

-- Register the events
RegisterGameObjectGossipEvent(CuergoGold.GO_INCONSPICUOUS_LANDMARK, 1, CuergoGold.InconspicuousLandmark_OnUse)
RegisterGameObjectGossipEvent(CuergoGold.GO_PIRATE_TREASURE, 1, CuergoGold.PirateTreasure_OnUse) 
