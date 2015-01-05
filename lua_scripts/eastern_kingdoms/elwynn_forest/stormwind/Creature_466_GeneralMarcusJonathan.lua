--[[
    EmuDevs <http://emudevs.com/forum.php>
    Eluna Lua Engine <https://github.com/ElunaLuaEngine/Eluna>
    Eluna Scripts <https://github.com/ElunaLuaEngine/Scripts>
    Eluna Wiki <http://wiki.emudevs.com/doku.php?id=eluna>

    -= Script Information =-
    * Zone: Stormwind
    * Script Type: Creature
    * Creature: Jonathan (General Marcus Jonathan, Entry: 466)
	* Version: tested on Zero
--]]

-- This creates the table used to localize all variables and functions
local Jonathan = {
    EMOTE_RECEIVE_WAVE = 101,    -- wave emote from player character
    EMOTE_RECEIVE_SALUTE = 78,   -- salute emote from player character
    EMOTE_SEND_SALUTE = 66,      -- salute emote by creature
    ID = 466                     -- creature_template Entry for General Marcus Jonathan
}


-- handle the incoming emotes
function Jonathan.OnReceiveEmote(event, creature, player, emoteid) 
    if (emoteid == Jonathan.EMOTE_RECEIVE_WAVE) then
        creature:SendUnitSay("Greetings, citizen.",7);
    elseif (emoteid == Jonathan.EMOTE_RECEIVE_SALUTE) then
        creature:Emote(Jonathan.EMOTE_SEND_SALUTE);
    end	
end

-- Register the event
RegisterCreatureEvent(Jonathan.ID, 8, Jonathan.OnReceiveEmote)

-- for more creature events: http://wiki.emudevs.com/doku.php?id=eluna_creature_events
-- for other in-game events: http://wiki.emudevs.com/doku.php?id=eluna

