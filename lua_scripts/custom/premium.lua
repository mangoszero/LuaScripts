-- Include sc_default
require "lua_scripts/base/sc_default"

-- NOTE: need to insert character_premium.sql in your characters database

local function PremiumOnLogin(event, player)  -- Send a welcome massage to player and tell him is premium or not
    local result = CharDBQuery("SELECT AccountId FROM premium WHERE active=1 and AccountId = "..player:GetAccountId())
    if (result) then
        player:SendBroadcastMessage("|CFFE55BB0[Premium]|r|CFFFE8A0E Welcome "..player:GetName().." you are Premium! |r")
    else
        player:SendBroadcastMessage("|CFFE55BB0[Premium]|r|CFFFE8A0E Welcome "..player:GetName().." you are NOT Premium! |r")
    end
end

local function PremiumOnChat(event, player, msg, _, lang)
    local result = CharDBQuery("SELECT AccountId FROM premium WHERE active=1 and AccountId = "..player:GetAccountId())
    if (msg == "#premium") then  -- Use #premium for sending the gossip menu
        if (result) then
            OnPremiumHello(event, player)
        else
            player:SendBroadcastMessage("|CFFE55BB0[Premium]|r|CFFFE8A0E Sorry "..player:GetName().." you are NOT Premium! |r")
        end
    end
end

function OnPremiumHello(event, player)
    player:GossipClearMenu()
    player:GossipMenuAddItem(0, "Show Bank", 0, 3)
    player:GossipMenuAddItem(0, "Show AuctionsHouse", 0, 4)
    player:GossipMenuAddItem(0, "Nevermind..", 0, 1)
    -- Room for more premium things
    player:GossipSetText("|CFFFF0303Hello "..player:GetName().."|r")
    player:GossipSendMenu(0x7FFFFFFF, player, 100)
end

function OnPremiumSelect(event, player, _, sender, intid, code)
    if (intid == 1) then                     -- Close the Gossip
        player:GossipComplete()
    elseif (intid == 2) then                 -- Go back to main menu
        OnPremiumHello(event, player)
    elseif (intid == 3) then                 -- Send Bank Window
        player:SendShowBank(player)
    elseif (intid == 4) then                 -- Send Auctions Window
        player:SendAuctionMenu(player)
    end
    -- Room for more premium things
end

RegisterPlayerEvent(3, PremiumOnLogin)              -- Register Event On Login
RegisterPlayerEvent(18, PremiumOnChat)              -- Register Evenet on Chat Command use
RegisterPlayerGossipEvent(100, 2, OnPremiumSelect)  -- Register Event for Gossip Select