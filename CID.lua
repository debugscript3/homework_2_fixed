local x, y = guiGetScreenSize()
local id = getElementData(localPlayer, "id")

addEventHandler ( "onClientRender", root, function()
    if not tonumber(id) then return end -- я бы вообще кикнул игрока :D
    local id_label = dxDrawText ( "ID:"..id, x - 70, 0, x, y, tocolor ( 255, 255, 255, 255 ), 1, "default", "right" )
end)