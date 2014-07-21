-- Include sc_default
require "lua_scripts/base/sc_default"

local NPC_ENTRY =

local ITEM_1_ENTRY = 20558 -- Warsong Gulch Mark of Honor
local ITEM_2_ENTRY = 20559 -- Arathi Basin Mark of Honor

local ITEM_1_COUNT = 2
local ITEM_2_COUNT = 1

local ITEM_1_NAME = GetItemLink(ITEM_1_ENTRY)
local ITEM_2_NAME = GetItemLink(ITEM_2_ENTRY)

local function ItemExChangeOnHello(event, player, unit)
    player:GossipMenuAddItem(0, "Convert "..ITEM_1_COUNT.."x "..ITEM_1_NAME.."to "..ITEM_2_COUNT.."x "..ITEM_2_NAME.."", 0, 1)
    player:GossipMenuAddItem(0, "Nevermind..", 0, 2)
    player:GossipSetText("|CFFFF0303Hello "..player:GetName().."|r")
    player:GossipSendMenu(0x7FFFFFFF, unit)
end

local function ItemExChangeOnSelect(event, player, unit, sender, intid, code)
    if (intid == 1) then
        if (player:HasItem(ITEM_1_ENTRY, ITEM_1_COUNT)) then
            player:RemoveItem(ITEM_1_ENTRY, ITEM_1_COUNT)
            player:SendBroadcastMessage("|CFF7BBEF7 Remove "..ITEM_1_COUNT.."x "..ITEM_1_NAME.." |r")
            player:AddItem(ITEM_2_ENTRY, ITEM_2_COUNT)
            player:SendBroadcastMessage("|CFF7BBEF7 Added "..ITEM_2_COUNT.."x "..ITEM_2_NAME.." |r")
        else
            player:SendBroadcastMessage("|CFF7BBEF7 You need "..ITEM_1_COUNT.."x "..ITEM_1_NAME.."|CFF7BBEF7 for Convert to "..ITEM_2_COUNT.."x "..ITEM_2_NAME.."|r")
        end
    elseif (intid == 2) then
        player:GossipComplete()
    end
end

RegisterCreatureGossipEvent(NPC_ENTRY, 1, ItemExChangeOnHello)
RegisterCreatureGossipEvent(NPC_ENTRY, 2, ItemExChangeOnSelect)