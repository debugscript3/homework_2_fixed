addEventHandler( "onClientRender", root, function (  )
    for i, v in ipairs(getElementsByType("player")) do
        if v ~= getLocalPlayer() and getElementDimension(getLocalPlayer()) == getElementDimension(v) then
            local x, y, z = getElementPosition(v)
            z = z + 0.95
            local cameraX, cameraY, cameraZ = getCameraMatrix()
            local distance = getDistanceBetweenPoints3D( x, y, z, cameraX, cameraY, cameraZ )
            local size = 1
            local font = "pricedown"
            
            if ( distance <= 30 ) then
            local sx,sy = getScreenFromWorldPosition( x, y, z, 0 )
                if ( sx and sy ) then
                    local id = getElementData(v, "id")
                    local hp = getElementHealth(v)
                    if hp > 0 then
                        dxDrawText(id, sx, sy, sx+size, sy+size-10, tocolor(0,0,0,255), size, font, "center", "bottom", false, false, false)
                        dxDrawText(id, sx, sy, sx-size, sy-size-10, tocolor(0,0,0,255), size, font, "center", "bottom", false, false, false)
                        dxDrawText(id, sx, sy, sx-size, sy+size-10, tocolor(0,0,0,255), size, font, "center", "bottom", false, false, false)
                        dxDrawText(id, sx, sy, sx+size, sy-size-10, tocolor(0,0,0,255), size, font, "center", "bottom", false, false, false)
                        dxDrawText(id, sx, sy, sx, sy-10, tocolor(255,255,255,255), size, font, "center", "bottom", false, false, false)
                    end
                end
            end
        end
    end 
end)
