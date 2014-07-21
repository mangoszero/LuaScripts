--[[
4.0
Transmogrification TBC - Gossip Menu
By Rochet2

Eluna version

TODO:
Make DB saving even better (Deleting)? What about coding?

Fix the cost formula

TODO in the distant future:

Are the qualities right? Blizzard might have changed the quality requirements.
What can and cant be used as source or target..?

Cant transmogrify:
rediculus items -- Foereaper: would be fun to stab people with a fish
-- Cant think of any good way to handle this easily

Cataclysm:
Test on cata : implement UI xD?
Item link icon to Are You sure text
]]

local NPC_Entry =

local RequireGold = 1
local GoldModifier = 1.0
local GoldCost = 100000

local RequireToken = false
local TokenEntry = 49426
local TokenAmount = 1

local Qualities =
{
    [0]  = false, -- AllowPoor     
    [1]  = false, -- AllowCommon   
    [2]  = true , -- AllowUncommon 
    [3]  = true , -- AllowRare     
    [4]  = true , -- AllowEpic     
    [5]  = false, -- AllowLegendary
    [6]  = false, -- AllowArtifact 
    [7]  = true , -- AllowHeirloom 
}

local EQUIPMENT_SLOT_START        = 0
local EQUIPMENT_SLOT_HEAD         = 0
local EQUIPMENT_SLOT_NECK         = 1
local EQUIPMENT_SLOT_SHOULDERS    = 2
local EQUIPMENT_SLOT_BODY         = 3
local EQUIPMENT_SLOT_CHEST        = 4
local EQUIPMENT_SLOT_WAIST        = 5
local EQUIPMENT_SLOT_LEGS         = 6
local EQUIPMENT_SLOT_FEET         = 7
local EQUIPMENT_SLOT_WRISTS       = 8
local EQUIPMENT_SLOT_HANDS        = 9
local EQUIPMENT_SLOT_FINGER1      = 10
local EQUIPMENT_SLOT_FINGER2      = 11
local EQUIPMENT_SLOT_TRINKET1     = 12
local EQUIPMENT_SLOT_TRINKET2     = 13
local EQUIPMENT_SLOT_BACK         = 14
local EQUIPMENT_SLOT_MAINHAND     = 15
local EQUIPMENT_SLOT_OFFHAND      = 16
local EQUIPMENT_SLOT_RANGED       = 17
local EQUIPMENT_SLOT_TABARD       = 18
local EQUIPMENT_SLOT_END          = 19

local INVENTORY_SLOT_BAG_START    = 19
local INVENTORY_SLOT_BAG_END      = 23
    
local INVENTORY_SLOT_ITEM_START   = 23
local INVENTORY_SLOT_ITEM_END     = 39

local INVTYPE_CHEST               = 5
local INVTYPE_WEAPON              = 13
local INVTYPE_ROBE                = 20
local INVTYPE_WEAPONMAINHAND      = 21
local INVTYPE_WEAPONOFFHAND       = 22

local ITEM_CLASS_WEAPON           = 2
local ITEM_CLASS_ARMOR            = 4

local ITEM_SUBCLASS_WEAPON_BOW          = 2
local ITEM_SUBCLASS_WEAPON_GUN          = 3
local ITEM_SUBCLASS_WEAPON_CROSSBOW     = 18
local ITEM_SUBCLASS_WEAPON_FISHING_POLE = 20

local PLAYER_VISIBLE_ITEM_1_ENTRYID = 260

local INVENTORY_SLOT_BAG_0        = 255

local SlotNames = {
    [EQUIPMENT_SLOT_HEAD      ] = {"Head",         nil, nil, nil, nil, nil, nil, nil, nil},
    [EQUIPMENT_SLOT_SHOULDERS ] = {"Shoulders",    nil, nil, nil, nil, nil, nil, nil, nil},
    [EQUIPMENT_SLOT_BODY      ] = {"Shirt",        nil, nil, nil, nil, nil, nil, nil, nil},
    [EQUIPMENT_SLOT_CHEST     ] = {"Chest",        nil, nil, nil, nil, nil, nil, nil, nil},
    [EQUIPMENT_SLOT_WAIST     ] = {"Waist",        nil, nil, nil, nil, nil, nil, nil, nil},
    [EQUIPMENT_SLOT_LEGS      ] = {"Legs",         nil, nil, nil, nil, nil, nil, nil, nil},
    [EQUIPMENT_SLOT_FEET      ] = {"Feet",         nil, nil, nil, nil, nil, nil, nil, nil},
    [EQUIPMENT_SLOT_WRISTS    ] = {"Wrists",       nil, nil, nil, nil, nil, nil, nil, nil},
    [EQUIPMENT_SLOT_HANDS     ] = {"Hands",        nil, nil, nil, nil, nil, nil, nil, nil},
    [EQUIPMENT_SLOT_BACK      ] = {"Back",         nil, nil, nil, nil, nil, nil, nil, nil},
    [EQUIPMENT_SLOT_MAINHAND  ] = {"Main hand",    nil, nil, nil, nil, nil, nil, nil, nil},
    [EQUIPMENT_SLOT_OFFHAND   ] = {"Off hand",     nil, nil, nil, nil, nil, nil, nil, nil},
    [EQUIPMENT_SLOT_RANGED    ] = {"Ranged",       nil, nil, nil, nil, nil, nil, nil, nil},
    [EQUIPMENT_SLOT_TABARD    ] = {"Tabard",       nil, nil, nil, nil, nil, nil, nil, nil},
}
local Locales = {
    {"Update menu", nil, nil, nil, nil, nil, nil, nil, nil},
    {"Remove all transmogrifications", nil, nil, nil, nil, nil, nil, nil, nil},
    {"Remove transmogrifications from all equipped items?", nil, nil, nil, nil, nil, nil, nil, nil},
    {"Using this item for transmogrify will bind it to you and make it non-refundable and non-tradeable.\nDo you wish to continue?", nil, nil, nil, nil, nil, nil, nil, nil},
    {"Remove transmogrification from %s?", nil, nil, nil, nil, nil, nil, nil, nil},
    {"Back..", nil, nil, nil, nil, nil, nil, nil, nil},
    {"Remove transmogrification", nil, nil, nil, nil, nil, nil, nil, nil},
    {"Transmogrifications removed from equipped items", nil, nil, nil, nil, nil, nil, nil, nil},
    {"You have no transmogrified items equipped", nil, nil, nil, nil, nil, nil, nil, nil},
    {"%s transmogrification removed", nil, nil, nil, nil, nil, nil, nil, nil},
    {"No transmogrification on %s slot", nil, nil, nil, nil, nil, nil, nil, nil},
    {"%s transmogrified", nil, nil, nil, nil, nil, nil, nil, nil},
    {"Selected items are not suitable", nil, nil, nil, nil, nil, nil, nil, nil},
    {"Selected item does not exist", nil, nil, nil, nil, nil, nil, nil, nil},
    {"Equipment slot is empty", nil, nil, nil, nil, nil, nil, nil, nil},
    {"You don't have enough %ss", nil, nil, nil, nil, nil, nil, nil, nil},
}
local function LocText(id, p) -- "%s":format("test")
    if(Locales[id]) then
        local s = Locales[id][p:GetDbcLocale()+1] or Locales[id][1]
        if(s) then
            return s
        end
    end
    return "Text not found: "..(id or 0)
end
--[[
typedef UNORDERED_MAP<uint32, uint32> transmogData
typedef UNORDERED_MAP<uint32, transmogData> transmogMap
static transmogMap entryMap -- entryMap[pGUID][iGUID] = entry
static transmogData dataMap -- dataMap[iGUID] = pGUID
]]
local entryMap = {}
local dataMap = {}

local function GetSlotName(slot, locale)
    if(not SlotNames[slot]) then return end
    return SlotNames[slot][locale and locale+1 or 1]
end

local function GetFakePrice(item)
    local sellPrice = item:GetSellPrice()
    local minPrice = item:GetRequiredLevel() * 1176
    if (sellPrice < minPrice) then
        sellPrice = minPrice
    end
    return sellPrice
end

local function GetFakeEntry(item)
    local guid = item and item:GetGUIDLow()
    if(guid and dataMap[guid]) then
        if(entryMap[dataMap[guid]]) then
            return entryMap[dataMap[guid]][guid]
        end
    end
end

local function DeleteFakeFromDB(itemGUID)
    if (dataMap[itemGUID]) then
        if(entryMap[dataMap[itemGUID]]) then
            entryMap[dataMap[itemGUID]][itemGUID] = nil
        end
        dataMap[itemGUID] = nil
    end
    CharDBExecute("DELETE FROM custom_transmogrification WHERE GUID = "..itemGUID)
end

local function DeleteFakeEntry(item)
    if (not GetFakeEntry(item)) then
        return false
    end
    item:GetOwner():UpdateUInt32Value(PLAYER_VISIBLE_ITEM_1_ENTRYID + (item:GetSlot() * 12), item:GetEntry())
    DeleteFakeFromDB(item:GetGUIDLow())
    return true
end

local function SetFakeEntry(item, entry)
    local player = item:GetOwner()
    if(player) then
        local pGUID = player:GetGUIDLow()
        local iGUID = item:GetGUIDLow()
        player:UpdateUInt32Value(PLAYER_VISIBLE_ITEM_1_ENTRYID + (item:GetSlot() * 12), entry)
        if(not entryMap[pGUID]) then
            entryMap[pGUID] = {}
        end
        entryMap[pGUID][iGUID] = entry
        dataMap[iGUID] = pGUID
        CharDBExecute("REPLACE INTO custom_transmogrification (GUID, FakeEntry, Owner) VALUES ("..iGUID..", "..entry..", "..pGUID..")")
    end
end

local function SuitableForTransmogrification(player, oldItem, newItem)
    -- not possibly the best structure here, but atleast I got my head around this
    if (not Qualities[newItem:GetQuality()]) then
        return false
    end
    if (not Qualities[oldItem:GetQuality()]) then
        return false
    end

    if(oldItem:GetDisplayId() == newItem:GetDisplayId()) then
        return false
    end
    --if (GetFakeEntry(oldItem))
    --    if (const ItemTemplate* fakeItemTemplate = sObjectMgr:GetItemTemplate(GetFakeEntry(oldItem)))
    --        if (fakeItemTemplate:DisplayInfoID == newItem:GetTemplate():DisplayInfoID)
    --            return false
    local fentry = GetFakeEntry(oldItem)
    if(fentry and fentry == newItem:GetEntry()) then
        return false
    end
    
    if (player:CanUseItem(newItem) ~= 0) then
        return false
    end
    local newClass = newItem:GetClass()
    local oldClass = oldItem:GetClass()
    local newSubClass = newItem:GetSubClass()
    local oldSubClass = oldItem:GetSubClass()
    local newInventorytype = newItem:GetInventoryType()
    local oldInventorytype = oldItem:GetInventoryType()
    if (newClass ~= oldClass) then
        return false
    end
    if (newClass == ITEM_CLASS_WEAPON and newSubClass ~= ITEM_SUBCLASS_WEAPON_FISHING_POLE and oldSubClass ~= ITEM_SUBCLASS_WEAPON_FISHING_POLE) then
        if (newSubClass == oldSubClass or ((newSubClass == ITEM_SUBCLASS_WEAPON_BOW or newSubClass == ITEM_SUBCLASS_WEAPON_GUN or newSubClass == ITEM_SUBCLASS_WEAPON_CROSSBOW) and (oldSubClass == ITEM_SUBCLASS_WEAPON_BOW or oldSubClass == ITEM_SUBCLASS_WEAPON_GUN or oldSubClass == ITEM_SUBCLASS_WEAPON_CROSSBOW))) then
            if (newInventorytype == oldInventorytype or (newInventorytype == INVTYPE_WEAPON and (oldInventorytype == INVTYPE_WEAPONMAINHAND or oldInventorytype == INVTYPE_WEAPONOFFHAND))) then
                return true
            else
                return false
            end
        else
            return false
        end
    elseif (newClass == ITEM_CLASS_ARMOR) then
        if (newSubClass == oldSubClass) then
            if (newInventorytype == oldInventorytype or (newInventorytype == INVTYPE_CHEST and oldInventorytype == INVTYPE_ROBE) or (newInventorytype == INVTYPE_ROBE and oldInventorytype == INVTYPE_CHEST)) then
                return true
            else
                return false
            end
        else
            return false
        end
    end
    return false
end

local menu_id = math.random(1000)

local function OnGossipHello(event, player, creature)
    player:GossipClearMenu()
    for slot = EQUIPMENT_SLOT_START, EQUIPMENT_SLOT_END-1 do
        local newItem = player:GetItemByPos(-1, slot)
        if (newItem) then
            if (Qualities[newItem:GetQuality()]) then
                local slotName = GetSlotName(slot, player:GetDbcLocale())
                if (slotName) then
                    player:GossipMenuAddItem(3, slotName, EQUIPMENT_SLOT_END, slot)
                end
            end
        end
    end
    player:GossipMenuAddItem(4, LocText(2, player), EQUIPMENT_SLOT_END+2, 0, false, LocText(3, player), 0)
    player:GossipMenuAddItem(7, LocText(1, player), EQUIPMENT_SLOT_END+1, 0)
    player:GossipSendMenu(100, creature, menu_id)
end

local _items = {}
local function OnGossipSelect(event, player, creature, sender, uiAction)
    if sender == EQUIPMENT_SLOT_END then -- Show items you can use
        local oldItem = player:GetItemByPos(-1, uiAction)
        if (oldItem) then
            local lowGUID = player:GetGUIDLow()
            _items[lowGUID] = {} -- Remove this with logix
            local limit = 0
            local price = 0
            if(RequireGold == 1) then
                price = GetFakePrice(oldItem)*GoldModifier
            elseif(RequireGold == 2) then
                price = GoldCost
            end

            for i = INVENTORY_SLOT_ITEM_START, INVENTORY_SLOT_ITEM_END-1 do
                if (limit > 30) then
                    break
                end
                local newItem = player:GetItemByPos(-1, i)
                if (newItem) then
                    local display = newItem:GetDisplayId()
                    if (SuitableForTransmogrification(player, oldItem, newItem)) then
                        if (not _items[lowGUID][display]) then
                            limit = limit + 1
                            _items[lowGUID][display] = newItem
                            local popup = LocText(4, player).."\n\n"..newItem:GetItemLink(player:GetDbcLocale()).."\n"
                            if(RequireToken) then
                                popup = popup.."\n"..TokenAmount.." x "..GetItemLink(TokenEntry, player:GetDbcLocale())
                            end
                            player:GossipMenuAddItem(4, newItem:GetItemLink(player:GetDbcLocale()), uiAction, display, false, popup, price)
                        end
                    end
                end
            end

            for i = INVENTORY_SLOT_BAG_START, INVENTORY_SLOT_BAG_END-1 do
                local bag = player:GetItemByPos(-1, i)
                if (bag) then
                    for j = 0, bag:GetBagSize()-1 do
                        if (limit > 30) then
                            break
                        end
                        local newItem = player:GetItemByPos(i, j)
                        if (newItem) then
                            local display = newItem:GetDisplayId()
                            if (SuitableForTransmogrification(player, oldItem, newItem)) then
                                if (not _items[lowGUID][display]) then
                                    limit = limit + 1
                                    _items[lowGUID][display] = newItem
                                    player:GossipMenuAddItem(4, newItem:GetItemLink(player:GetDbcLocale()), uiAction, display, false, popup, price)
                                end
                            end
                        end
                    end
                end
            end

            player:GossipMenuAddItem(4, LocText(7, player), EQUIPMENT_SLOT_END+3, uiAction, false, LocText(5, player):format(GetSlotName(uiAction, player:GetDbcLocale())))
            player:GossipMenuAddItem(7, LocText(6, player), EQUIPMENT_SLOT_END+1, 0)
            player:GossipSendMenu(100, creature, menu_id)
        else
            OnGossipHello(event, player, creature)
        end
    elseif sender == EQUIPMENT_SLOT_END+1 then -- Back
        OnGossipHello(event, player, creature)
    elseif sender == EQUIPMENT_SLOT_END+2 then -- Remove Transmogrifications
        local removed = false
        for slot = EQUIPMENT_SLOT_START, EQUIPMENT_SLOT_END-1 do
            local newItem = player:GetItemByPos(-1, slot)
            if (newItem) then
                if (DeleteFakeEntry(newItem) and not removed) then
                    removed = true
                end
            end
        end
        if (removed) then
            player:SendAreaTriggerMessage(LocText(8, player))
            -- player:PlayDirectSound(3337)
        else
            player:SendNotification(LocText(9, player))
        end
        OnGossipHello(event, player, creature)
    elseif sender == EQUIPMENT_SLOT_END+3 then -- Remove Transmogrification from single item
        local newItem = player:GetItemByPos(-1, uiAction)
        if (newItem) then
            if (DeleteFakeEntry(newItem)) then
                player:SendAreaTriggerMessage(LocText(10, player):format(GetSlotName(uiAction, player:GetDbcLocale())))
                -- player:PlayDirectSound(3337)
            else
                player:SendNotification(LocText(11, player):format(GetSlotName(uiAction, player:GetDbcLocale())))
            end
        end
        OnGossipSelect(event, player, creature, EQUIPMENT_SLOT_END, uiAction)
    else -- Transmogrify
        local lowGUID = player:GetGUIDLow()
        if(not RequireToken or player:GetItemCount(TokenEntry) >= TokenAmount) then
            local oldItem = player:GetItemByPos(-1, sender)
            if (oldItem) then
                if (_items[lowGUID] and _items[lowGUID][uiAction] and _items[lowGUID][uiAction]) then
                    local newItem = _items[lowGUID][uiAction]
                    if (newItem:GetOwnerGUID() == player:GetGUID() and (newItem:IsInBag() or newItem:GetBagSlot() == INVENTORY_SLOT_BAG_0) and SuitableForTransmogrification(player, oldItem, newItem)) then
                        local price
                        if(RequireGold == 1) then
                            price = GetFakePrice(oldItem)*GoldModifier
                        elseif(RequireGold == 2) then
                            price = GoldCost
                        end
                        if(price) then player:ModifyMoney(-1*price) end
                        if(RequireToken) then
                            player:RemoveItem(TokenEntry, TokenAmount)
                        end
                        SetFakeEntry(oldItem, newItem:GetEntry())
                        -- newItem:SetNotRefundable(player)
                        newItem:SetBinding(1)
                        -- player:PlayDirectSound(3337)
                        player:SendAreaTriggerMessage(LocText(12, player):format(GetSlotName(sender, player:GetDbcLocale())))
                    else
                        player:SendNotification(LocText(13, player))
                    end
                else
                    player:SendNotification(LocText(14, player))
                end
            else
                player:SendNotification(LocText(15, player))
            end
        else
            player:SendNotification(LocText(16, player):format(GetItemLink(TokenEntry, player:GetDbcLocale())))
        end
        _items[lowGUID] = {}
        OnGossipSelect(event, player, creature, EQUIPMENT_SLOT_END, sender)
    end
end

local function OnLogin(event, player)
    local playerGUID = player:GetGUIDLow()
    entryMap[playerGUID] = {}
    local result = CharDBQuery("SELECT GUID, FakeEntry FROM custom_transmogrification WHERE Owner = "..playerGUID)
    if (result) then
        repeat
            local itemGUID = result:GetUInt32(0)
            local fakeEntry = result:GetUInt32(1)
            -- if (sObjectMgr:GetItemTemplate(fakeEntry)) then
            -- {
                   dataMap[itemGUID] = playerGUID
                   entryMap[playerGUID][itemGUID] = fakeEntry
            -- }
            -- else
            --     sLog:outError(LOG_FILTER_SQL, "Item entry (Entry: %u, itemGUID: %u, playerGUID: %u) does not exist, deleting.", fakeEntry, itemGUID, playerGUID)
            --     Transmogrification::DeleteFakeFromDB(itemGUID)
            -- end
        until not result:NextRow()

        for slot = EQUIPMENT_SLOT_START, EQUIPMENT_SLOT_END-1 do
            local item = player:GetItemByPos(-1, slot)
            if (item) then
                if(entryMap[playerGUID]) then
                    if(entryMap[playerGUID][item:GetGUIDLow()]) then
                        player:UpdateUInt32Value(PLAYER_VISIBLE_ITEM_1_ENTRYID + (item:GetSlot() * 12), entryMap[playerGUID][item:GetGUIDLow()])
                    end
                end
            end
        end
    end
end

local function OnLogout(event, player)
    local pGUID = player:GetGUIDLow()
    entryMap[pGUID] = nil
end

local function OnEquip(event, player, item, bag, slot)
    local fentry = GetFakeEntry(item)
    if (fentry) then
        if(item:GetOwnerGUID() ~= player:GetGUID()) then
            DeleteFakeFromDB(item:GetGUIDLow())
            return
        end
        player:SetUInt32Value(PLAYER_VISIBLE_ITEM_1_ENTRYID + (slot * 12), fentry)
    else
        -- player:SetUInt32Value(PLAYER_VISIBLE_ITEM_1_ENTRYID + (slot * 12), pItem:GetEntry())
    end
end

-- Note, Query is instant when Execute is delayed
CharDBQuery([[
CREATE TABLE IF NOT EXISTS `custom_transmogrification` (
	`GUID` INT(10) UNSIGNED NOT NULL COMMENT 'Item guidLow',
	`FakeEntry` INT(10) UNSIGNED NOT NULL COMMENT 'Item entry',
	`Owner` INT(10) UNSIGNED NOT NULL COMMENT 'Player guidLow',
	PRIMARY KEY (`GUID`)
)
COMMENT='version 4.0'
COLLATE='latin1_swedish_ci'
ENGINE=InnoDB;
]])

print("Deleting non-existing transmogrification entries...")
CharDBQuery("DELETE FROM custom_transmogrification WHERE NOT EXISTS (SELECT 1 FROM item_instance WHERE item_instance.guid = custom_transmogrification.GUID)")

RegisterPlayerEvent(3, OnLogin)
RegisterPlayerEvent(4, OnLogout)
RegisterPlayerEvent(29, OnEquip)

-- Test code
--RegisterPlayerEvent(18, function(e,p,m,t,l) if(m == "test") then OnGossipHello(e,p,p) end end)
--RegisterPlayerGossipEvent(menu_id, 2, OnGossipSelect)

RegisterCreatureGossipEvent(NPC_Entry, 1, OnGossipHello)
RegisterCreatureGossipEvent(NPC_Entry, 2, OnGossipSelect)

local plrs = GetPlayersInWorld()
if(plrs) then
    for k, player in ipairs(plrs) do
        OnLogin(k, player)
    end
end