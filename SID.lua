IDs = {}

function generateNewID(player)
    local max_id = #IDs
    local new_id = max_id + 1
    IDs[new_id] = player

    return new_id
end

function removeID(player)
    for i, v in pairs(IDs) do
        if v == source then
            IDs[i] = nil
            return
        end
    end
end

addEventHandler ( "onPlayerJoin", root, function()
    local id = generateNewID(source)
    setElementData(source, "id", id)
end)

addEventHandler ( "onPlayerQuit", root, function()
    removeID(source)
end)