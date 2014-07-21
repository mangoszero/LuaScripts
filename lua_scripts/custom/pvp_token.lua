-- -- -- -- -- -- -- -- -- -- -- -- --
-- -- PvP Token System by Salja. -- --
-- -- -- -- -- -- -- -- -- -- -- -- --

-- Include sc_default
require "lua_scripts/base/sc_default"

-- Settings
local ItemOrGold = 0                     -- 0 = Gold and Item, 1 = Only Item, 2 = Only Gold
local WorldAnnounce = true               -- Sends a World Announce false = Off, true = On
local GoldCount = 10000                  -- Reward in copper
local ItemEntry = 20558                  -- Warsong Gulch Mark of Honor
local ItemCount = 1                      -- Count of the Item
local ItemName = GetItemLink(ItemEntry)
local KillCooldown = 180                 -- Wehn you kill the same player in this time you become not gold or item (set to 0 for disable)


local function PvPTokenSystem(event, killer, killed)
    local receiver = killer:GetGUIDLow()

    if (WorldAnnounce == 1) then
        SendWorldMessage("[PVP] |Hplayer:"..killer:GetName().."|h["..killer:GetName().."]|h killed |Hplayer:"..killed:GetName().."|h["..killed:GetName().."]|h")
    end

    if (ItemOrGold ~= 2) then
        if killed:GetLuaCooldown() == 0 then
            if (killer:AddItem(ItemEntry, ItemCount)) then
                if (ItemCount == 1) then
                    killer:SendBroadcastMessage("|CFF20C000 You get: "..ItemName.."|CFF20C000.|r")
                    killed:SetLuaCooldown(KillCooldown)
                else
                    killer:SendBroadcastMessage("|CFF20C000 You get: "..ItemName.."|CFF20C000 x"..ItemCount..".|r")
                    killed:SetLuaCooldown(KillCooldown)
                end
            else
                killer:SendBroadcastMessage("|cffff0000 Your bags are full, we will send it by mail.|r")
                SendMail("PvP Token System", "Your Bags are full we send via Mail", receiver, nil, 41, nil, ItemEntry, ItemCount)
                killed:SetLuaCooldown(KillCooldown)
            end
        else
            killer:SendBroadcastMessage(string.format("Set Cooldown for "..killed:GetName()..", to %s seconds for next token kill", math.ceil(killed:GetLuaCooldown())))
            killed:SendBroadcastMessage(string.format("Set YOUR Cooldown, to %s seconds for next token kill", math.ceil(killed:GetLuaCooldown())))
        end
    end

    if (ItemOrGold ~= 1) then
        if killed:GetLuaCooldown() == 0 then
            killer:ModifyMoney(GoldCount)
            killer:SendBroadcastMessage("|CFF20C000 You get: "..GoldCount.."|CFF20C000 Copper.|r")
            killed:SetLuaCooldown(KillCooldown)
        else
            killer:SendBroadcastMessage(string.format("Set Cooldown for "..killed:GetName()..", to %s seconds for next token kill", math.ceil(killed:GetLuaCooldown())))
            killed:SendBroadcastMessage(string.format("Set YOUR Cooldown, to %s seconds for next token kill", math.ceil(killed:GetLuaCooldown())))
        end
    end
end

RegisterPlayerEvent(6, PvPTokenSystem)