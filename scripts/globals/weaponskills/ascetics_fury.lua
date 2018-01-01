-----------------------------------
-- Ascetics Fury
-- Hand-to-Hand weapon skill
-- Skill Level: N/A
-- Chance of params.critical hit varies with TP. Glanzfaust: Aftermath effect varies with TP.
-- Available only after completing the Unlocking a Myth (Monk) quest.
-- Aligned with the Flame Gorget & Light Gorget.
-- Aligned with the Flame Belt & Light Belt.
-- Element: None
-- Modifiers: STR:50% ; VIT:50%
-- 100%TP    200%TP    300%TP
-- 1.00      1.00      1.00
-----------------------------------
require("scripts/globals/status");
require("scripts/globals/settings");
require("scripts/globals/weaponskills");
-----------------------------------

function onUseWeaponSkill(player, target, wsID, tp, primary, action, taChar)
    local params = {}
    params.numHits = 1;
    params.ftp100 = 1; params.ftp200 = 1; params.ftp300 = 1;
    params.str_wsc = 0.5; params.dex_wsc = 0.0; params.vit_wsc = 0.5; params.agi_wsc = 0.0; params.int_wsc = 0.0; 
    params.mnd_wsc = 0.0; params.chr_wsc = 0.0;
    params.crit100 = 0.1; params.crit200 = 0.3; params.crit300 = 0.5;
    params.canCrit = true;
    params.acc100 = 0.0; params.acc200= 0.0; params.acc300= 0.0;
    params.atkmulti = 1;

    if (USE_ADOULIN_WEAPON_SKILL_CHANGES == true) then
        params.crit100 = 0.2; params.crit200 = 0.3; params.crit300 = 0.5;
        params.atkmulti = 2.6;
    end

    -- Aftermath calculations from : https://www.bg-wiki.com/bg/Glanzfaust_(Level_75)
    local damage, criticalHit, tpHits, extraHits = doPhysicalWeaponskill(player, target, wsID, tp, primary, action, taChar, params)
    if (damage > 0) then
        local aftermathParams = initAftermathParams()
        aftermathParams.power = player:getAftermathModPower(false)
        if (shouldApplyAftermath(player, aftermathParams.power, tp, AFTERMATH_MYTHIC)) then
            if (tp == 3000) then
                aftermathParams.type = EFFECT_AFTERMATH_LV3
                aftermathParams.subpower.type = MOD_DOUBLE_ATTACK
            elseif (tp >= 2000) then
                aftermathParams.type = EFFECT_AFTERMATH_LV2
                aftermathParams.subpower.type = MOD_ATT
            else
                aftermathParams.type = EFFECT_AFTERMATH_LV1
                aftermathParams.subpower.type = MOD_ACC
            end

            applyMythicAftermath(player, tp, aftermathParams)
        end
    end

    return tpHits, extraHits, criticalHit, damage
end
