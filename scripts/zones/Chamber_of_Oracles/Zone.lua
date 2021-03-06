-----------------------------------
--
-- Zone: Chamber_of_Oracles (168)
--
-----------------------------------
package.loaded["scripts/zones/Chamber_of_Oracles/TextIDs"] = nil;
-----------------------------------
require("scripts/globals/settings");
require("scripts/zones/Chamber_of_Oracles/TextIDs");
-----------------------------------

function onInitialize(zone)
end;

function onConquestUpdate(zone, updatetype)
    dsp.conq.onConquestUpdate(zone, updatetype)
end;

function onZoneIn(player,prevZone)
    local cs = -1;
    if (player:getXPos() == 0 and player:getYPos() == 0 and player:getZPos() == 0) then
        player:setPos(-177.804,-2.765,-37.893,179);
    end
    return cs;
end;

function onRegionEnter(player,region)
end;

function onEventUpdate(player,csid,option)
end;

function onEventFinish(player,csid,option)
end;
