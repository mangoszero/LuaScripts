--
-- Kobold Vermin - Random Say on Aggro
-- NPC Entry 6
-- Script Complete 100%
--

NPC_KOBOLD_VERMIN = 6

local SAY_KOBOLD_VERMIN_1 = "You no take candle!"
local SAY_KOBOLD_VERMIN_2 = "Yiieeeee! Me run!"

local function KoboldVerminOnEnterCombat(event, creature, target)
    local chance = math.random(1, 2)

    if (chance == 1) then
        creature:SendUnitSay(SAY_KOBOLD_VERMIN_1, 0)
    elseif (chance == 2) then
        creature:SendUnitSay(SAY_KOBOLD_VERMIN_2, 0)
    end
end

local function KoboldVerminOnLeaveCombat(event, creature)
    creature:RemoveEvents()
end

RegisterCreatureEvent(NPC_KOBOLD_VERMIN, 1, KoboldVerminOnEnterCombat)
RegisterCreatureEvent(NPC_KOBOLD_VERMIN, 2, KoboldVerminOnLeaveCombat)

--
-- Defias Thug - Random Say on Aggro
-- NPC Entry 38
-- Script Complete 100%
--

NPC_DEFIAS_THUG = 38

local SAY_DEFIAS_THUG_1 = "The Brotherhood will not tolerate your actions."
local SAY_DEFIAS_THUG_2 = "Ah, a chance to use this freshly sharpened blade."
local SAY_DEFIAS_THUG_3 = "Feel the power of the Brotherhood!"

local function DefiasThugOnEnterCombat(event, creature, target)
    local chance = math.random(1, 3)

    if (chance == 1) then
        creature:SendUnitSay(SAY_DEFIAS_THUG_1, 0)
    elseif (chance == 2) then
        creature:SendUnitSay(SAY_DEFIAS_THUG_2, 0)
    elseif (chance == 3) then
        creature:SendUnitSay(SAY_DEFIAS_THUG_3, 0)
    end
end

local function DefiasThugOnLeaveCombat(event, creature)
    creature:RemoveEvents()
end

RegisterCreatureEvent(NPC_DEFIAS_THUG, 1, DefiasThugOnEnterCombat)
RegisterCreatureEvent(NPC_DEFIAS_THUG, 2, DefiasThugOnLeaveCombat)

--
-- Thuros Lightfingers - Random Say on Aggro
-- NPC Entry 61
-- Script Complete 100%
--

NPC_THUROS_LIGHTFINGERS = 61

local SAY_THUROS_LIGHTFINGERS_1 = "The Brotherhood will not tolerate your actions."
local SAY_THUROS_LIGHTFINGERS_2 = "Ah, a chance to use this freshly sharpened blade."
local SAY_THUROS_LIGHTFINGERS_3 = "Feel the power of the Brotherhood!"

local function ThurosLightfingersOnEnterCombat(event, creature, target)
    local chance = math.random(1, 3)

    if (chance == 1) then
        creature:SendUnitSay(SAY_THUROS_LIGHTFINGERS_1, 0)
    elseif (chance == 2) then
        creature:SendUnitSay(SAY_THUROS_LIGHTFINGERS_2, 0)
    elseif (chance == 3) then
        creature:SendUnitSay(SAY_THUROS_LIGHTFINGERS_3, 0)
    end
end

local function ThurosLightfingersOnLeaveCombat(event, creature)
    creature:RemoveEvents()
end

RegisterCreatureEvent(NPC_THUROS_LIGHTFINGERS, 1, ThurosLightfingersOnEnterCombat)
RegisterCreatureEvent(NPC_THUROS_LIGHTFINGERS, 2, ThurosLightfingersOnLeaveCombat)

--
-- Kobold Labourer - Random Say on Aggro
-- NPC Entry 80
-- Script Complete 100%
--

NPC_KOBOLD_LABOURER = 80

local SAY_KOBOLD_LABOURER_1 = "You no take candle!"
local SAY_KOBOLD_LABOURER_2 = "Yiieeeee! Me run!"

local function KoboldLabourerOnEnterCombat(event, creature, target)
    local chance = math.random(1, 2)

    if (chance == 1) then
        creature:SendUnitSay(SAY_KOBOLD_LABOURER_1, 0)
    elseif (chance == 2) then
        creature:SendUnitSay(SAY_KOBOLD_LABOURER_2, 0)
    end
end

local function KoboldLabourerOnLeaveCombat(event, creature)
    creature:RemoveEvents()
end

RegisterCreatureEvent(NPC_KOBOLD_LABOURER, 1, KoboldLabourerOnEnterCombat)
RegisterCreatureEvent(NPC_KOBOLD_LABOURER, 2, KoboldLabourerOnLeaveCombat)
