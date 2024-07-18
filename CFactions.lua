local x, y = guiGetScreenSize()
local px, py = 500, 550
local cx, cy = (x / 2) - (px / 2), (y / 2) - (py / 2)

local ui = {}
local invite = {}
local isOpen = false

function DestroyTableElements( table )
    for i, v in pairs( table or { } ) do
        if isElement( v ) then destroyElement( v ) end
    end
    showCursor(false)
end

function AcceptingPlayer(leader)
    local target = client or source

    local wx, wy = 380, 180
    local wcx, wcy = (x / 2) - (wx / 2), (y / 2) - (wy / 2)

    local faction_id = tonumber(getElementData(leader, "faction_id"))
    local faction_name = FACTIONS_NAMES[faction_id].faction_name or "new faction"

    if not isElement(target) then return end

    invite.bg = guiCreateWindow(wcx, wcy, wx, wy, "Приглашение", false)
    invite.text = guiCreateLabel(0, 50, wx, wy, getPlayerName(leader).." приглашает вступить вас\nво фракцию "..faction_name, false, invite.bg)
    invite.btn_accept = guiCreateButton( 50, 120, 100, 29, "Принять", false, invite.bg )
    addEventHandler("onClientGUIClick", invite.btn_accept, function( key )
        if key ~= "left" then return end
        if source == invite.btn_accept then
            triggerServerEvent("onLeaderAcceptPlayer", leader, target)
            DestroyTableElements(invite)
            showCursor(false)
        end
    end)

    invite.btn_decline = guiCreateButton( wx - 150, 120, 100, 29, "Отклонить", false, invite.bg )
    addEventHandler("onClientGUIClick", invite.btn_decline, function( key )
        if key ~= "left" then return end
        if source == invite.btn_decline then
            DestroyTableElements(invite)
            showCursor(false)
        end
    end)

    guiWindowSetMovable(invite.bg, false)
    guiLabelSetHorizontalAlign(invite.text, "center")
    guiWindowSetSizable(invite.bg, false)
    showCursor(true)
end
addEvent("onPlayerTryAcceptInvite", true)
addEventHandler("onPlayerTryAcceptInvite", root, AcceptingPlayer)

function ShowUI()
    local faction_id = tonumber(getElementData(localPlayer, "faction_id"))
    local is_leader = getElementData(localPlayer, "faction_leader")

    if not faction_id or faction_id <= 0 then return end

    ui.window = guiCreateWindow(cx, cy, px, py, "Панель фракции "..FACTIONS_NAMES[faction_id].faction_name, false)
    ui.bg = guiCreateTabPanel ( 0, 20, px, py, false, ui.window )
    ui.tab_members = guiCreateTab("Список участников", ui.bg)
    ui.members_gridlist = guiCreateGridList( 40, 10, px - 100, py - 150, false, ui.tab_members )

    guiWindowSetMovable(ui.window, false)
    guiWindowSetSizable(ui.window, false)
    guiGridListAddColumn( ui.members_gridlist, "ID", 0.3 )
    guiGridListAddColumn( ui.members_gridlist, "Имя", 0.6 )

    for i,v in pairs(getElementsByType("player")) do
        if tonumber(getElementData(v, "faction_id")) == faction_id then
            local row = guiGridListAddRow( ui.members_gridlist )
            guiGridListSetItemText( ui.members_gridlist, row, 1, getElementData(v, "id") or "-", false, false )
            guiGridListSetItemData( ui.members_gridlist, row, 1, v)
            guiGridListSetItemText( ui.members_gridlist, row, 2, getPlayerName(v) or "-", false, false )
            if v == localPlayer then
                guiGridListSetSelectedItem( ui.members_gridlist, row, 1 )
            end
        end
    end

    if is_leader == true then
        ui.btn_accept = guiCreateButton( ((px / 2) - (100 / 2) - 30) - 100, py - 120, 100, 29, "Пригласить", false, ui.tab_members )
        ui.edit_id = guiCreateEdit( ((px / 2) - (100 / 2) - 30) - 100, py - 89, 100, 20, "", false, ui.tab_members )
        addEventHandler("onClientGUIClick", ui.btn_accept, function( key )
            if key ~= "left" then return end
            if source == ui.btn_accept then
                local text = guiGetText ( ui.edit_id )
                if utf8.len(text) <= 0 or not tonumber(text) then return end
                
                local target = nil
                for i, v in pairs(getElementsByType("player")) do
                    local id = getElementData(v, "id")
                    if tonumber(text) ~= id then return end
                    target = v
                end

                -- if target == localPlayer then return end --Запрет на инвайт самого себя во фракцию, если будете тестить - раскомментируйте
                -- if getElementData(target, "faction_leader") == true then return end -- Запрет на инвайт лидера другой фракции. Можете раскомментить для тестов.
                
                if tonumber(getElementData(target, "faction_id")) ~= 0 then return end

                DestroyTableElements(ui)
                triggerServerEvent("onLeaderCheckCooldown", localPlayer, target)
            end
        end)

        ui.btn_dismiss = guiCreateButton( ((px / 2) - (100 / 2) - 30) + 130, py - 120, 100, 29, "Уволить", false, ui.tab_members )
        addEventHandler("onClientGUIClick", ui.btn_dismiss, function( key )
            if key ~= "left" then return end
            if source == ui.btn_dismiss then
                local item = guiGridListGetSelectedItem( ui.members_gridlist )
                if item and item >= 0 then
                    local player = guiGridListGetItemData( ui.members_gridlist, item, 1 )
                    if not isElement(player) then return end
                    -- if player == localPlayer then return end -- Запрет на увольнение себя, если что можете раскомментить.
                    triggerServerEvent("onLeaderDeclinePlayer", localPlayer, player )
                    DestroyTableElements(ui)
                end
            end
        end)
        ui.tab_city_manage = guiCreateTab("Управление городом", ui.bg)
    end
    showCursor(true)
    isOpen = true
end

function PreCheckPanel()
    if isOpen == true then
        DestroyTableElements(ui)
        showCursor(false)
        isOpen = false
    else
        ShowUI()
    end
end
bindKey("p", "down", PreCheckPanel)