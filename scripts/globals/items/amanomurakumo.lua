-----------------------------------------
-- ID: 18318, 18319, 18646, 18660, 18674, 19755, 19848, 21015, 21016, 21954
-- Item: Amanomurakumo
-- Additional Effect: 10% Attack Down
-----------------------------------------
require("scripts/globals/status");
require("scripts/globals/magic");
require("scripts/globals/msg");
require("scripts/globals/weaponskills");
require("scripts/globals/weaponskillids");
-----------------------------------

local NAME_WEAPONSKILL = "AFTERMATH_AMANO";
local NAME_EFFECT_LOSE = "AFTERMATH_LOST_AMANO";

-- https://www.bg-wiki.com/bg/Relic_Aftermath
local aftermathTable = {};

-- Amanomurakumo 75
aftermathTable[18318] =
{
    power=1,
    duration = function(tp) return math.floor(0.02 * tp); end,
    mods =
    {
        { id=dsp.mod.STORETP, power=7 }
    }
};
aftermathTable[18319] = aftermathTable[18318]; -- Amanomurakumo (80)
aftermathTable[18646] = aftermathTable[18318]; -- Amanomurakumo (85)
aftermathTable[18660] = aftermathTable[18318]; -- Amanomurakumo (90)
aftermathTable[18674] = aftermathTable[18318]; -- Amanomurakumo (95)
aftermathTable[19755] = aftermathTable[18318]; -- Amanomurakumo (99)
aftermathTable[19848] = aftermathTable[18318]; -- Amanomurakumo (99/II)
aftermathTable[21015] = aftermathTable[18318]; -- Amanomurakumo (119)
aftermathTable[21016] = aftermathTable[18318]; -- Amanomurakumo (119/II)

-- Amanomurakumo (119/III)
aftermathTable[21954] =
{
    power=2,
    duration = function(tp) return math.floor(0.06 * tp); end,
    mods =
    {
        { id=dsp.mod.STORETP, power=10 },
        { id=dsp.mod.ZANSHIN, power=10 }
    }
};

function onWeaponskill(user, target, wsid, tp, action)
    if (wsid == dsp.ws.TACHI_KAITEN) then -- Tachi: Kaiten onry
        local itemId = user:getEquipID(dsp.slot.MAIN);
        if (aftermathTable[itemId]) then
            -- Apply the effect and add mods
            addAftermathEffect(user, tp, aftermathTable[itemId]);
            -- Add a listener for when aftermath wears (to remove mods)
            user:addListener("EFFECT_LOSE", NAME_EFFECT_LOSE, aftermathLost);
        end
    end
end

function aftermathLost(target, effect)
    if (effect:getType() == dsp.effect.AFTERMATH) then
        local itemId = target:getEquipID(dsp.slot.MAIN);
        if (aftermathTable[itemId]) then
            -- Remove mods
            removeAftermathEffect(target, aftermathTable[itemId]);
            -- Remove the effect listener
            target:removeListener(NAME_EFFECT_LOSE);
        end
    end
end

function onItemCheck(player, param, caster)
    if (param == dsp.itemCheck.EQUIP) then
        player:addListener("WEAPONSKILL_USE", NAME_WEAPONSKILL, onWeaponskill);
    elseif (param == dsp.itemCheck.UNEQUIP) then
        -- Make sure we clean up the effect and mods
        if (player:hasStatusEffect(dsp.effect.AFTERMATH)) then
            aftermathLost(player, player:getStatusEffect(dsp.effect.AFTERMATH));
        end
        player:removeListener(NAME_WEAPONSKILL);
    end
    
    return 0;
end

function onAdditionalEffect(player,target,damage)
    local chance = 10;

    if (math.random(0,99) >= chance or applyResistanceAddEffect(player,target,dsp.magic.ele.WATER,0) <= 0.5) then
        return 0,0,0;
    else
        target:delStatusEffect(dsp.effect.ATTACK_BOOST);
        target:addStatusEffect(dsp.effect.ATTACK_DOWN, 10, 0, 60); -- Power needs verification/correction
        return dsp.subEffect.ATTACK_DOWN, dsp.msg.basic.ADD_EFFECT_STATUS, dsp.effect.ATTACK_DOWN;
    end
end;