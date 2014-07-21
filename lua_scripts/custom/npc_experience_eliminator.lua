-- Include sc_default
require "lua_scripts/base/sc_default"

local NpcId =
local MoneyCount = 100000

local function GossipHello_ExperienceEliminator(event, player, unit)

    if (player:HasFlag(190, 524288)) then
        player:GossipMenuAddItem(0, "I want to be able to gain experience again.", 0, 1)
    else
        player:GossipMenuAddItem(0, "I don't want to gain experience anymore.", 0, 2)
    end
	
    player:GossipMenuAddItem(0, "I need nothing...", 0, 3)
    player:GossipSetText("Hello "..player:GetName().." it costs "..MoneyCount.." Chopper!")
    player:GossipSendMenu(0x7FFFFFFF, unit)
end

local function GossipSelect_ExperienceEliminator(event, player, unit, sender, intid, code)
    if (intid == 1) then
        if (player:GetCoinage() < MoneyCount) then
            unit:SendUnitSay("Too little money "..player:GetName().." come back when you have "..MoneyCount.." Chopper!", 0)
        else
            player:ModifyMoney(-MoneyCount)
            player:RemoveFlag(190, 524288)
            unit:SendUnitSay("Thanks! "..player:GetName().." see you.", 0)
        end
        player:GossipComplete()
    elseif (intid == 2) then
        if (player:GetCoinage() < MoneyCount) then
            unit:SendUnitSay("Too little money "..player:GetName().." come back when you have "..MoneyCount.." Chopper!", 0)
        else
            player:ModifyMoney(-MoneyCount)
            player:SetFlag(190, 524288)
            unit:SendUnitSay("Thanks! "..player:GetName().." see you.", 0)
        end
        player:GossipComplete()
    elseif (intid == 3) then
        player:GossipComplete()
    end
end

RegisterCreatureGossipEvent(NpcId, 1, GossipHello_ExperienceEliminator)
RegisterCreatureGossipEvent(NpcId, 2, GossipSelect_ExperienceEliminator)