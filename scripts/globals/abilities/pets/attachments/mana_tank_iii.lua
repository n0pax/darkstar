-----------------------------------
-- Attachment: Mana Tank III
-----------------------------------
require("scripts/globals/status");

function onEquip(pet)
    pet:addMod(dsp.mod.MPP, 15);
end

function onUnequip(pet)
    pet:delMod(dsp.mod.MPP, 15);
end

-- refresh values from http://wiki.ffo.jp/html/5330.html
local prefix = "manaTank3_"
local refreshValues =
{
    [1] = {base=3, pct=0.6},
    [2] = {base=1, pct=0.2},
    [3] = {base=1, pct=0.2},
}

function onManeuverGain(pet,maneuvers)
    local rVals = refreshValues[maneuvers]
    local power = math.floor(rVals.base + (pet:getMaxMP() * rVals.pct / 100))

    pet:setLocalVar(prefix .. maneuvers, power)
    pet:addMod(dsp.mod.REFRESH, power)
end

function onManeuverLose(pet,maneuvers)
    pet:delMod(dsp.mod.REFRESH, pet:getLocalVar(prefix .. maneuvers))
    pet:setLocalVar(prefix .. maneuvers, 0)
end
