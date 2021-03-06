-----------------------------------------
-- ID: 14493
-- Item: Healing Vest
-- Item Effect: Restores 90-105 HP
-----------------------------------------
require("scripts/globals/msg");

function onItemCheck(target)
    if (target:getHP() == target:getMaxHP()) then
        return dsp.msg.basic.ITEM_UNABLE_TO_USE;
    end
    return 0;
end;

function onItemUse(target)
    local hpHeal = math.random(90,105);
    local dif = target:getMaxHP() - target:getHP();
    if (hpHeal > dif) then
        hpHeal = dif;
    end
    target:addHP(hpHeal);
    target:messageBasic(dsp.msg.basic.RECOVERS_HP,0,hpHeal);
end;
