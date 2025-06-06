-- modules/agencies/server/main.lua
-- Tracks each player’s assignment (group/subdivision/role), and broadcasts updates.

local PlayerAssignments = {}

-- Broadcast everyone's assignments to all clients
local function broadcastAssignments()
    TriggerClientEvent('agencies:updatePlayerAssignments', -1, PlayerAssignments)
end

-- When a client sets their unit
RegisterNetEvent('agencies:setPlayerUnit')
AddEventHandler('agencies:setPlayerUnit', function(groupKey, subdivisionKey, roleLabel)
    local src = source

    -- Optional: Validate that groupKey/subdivisionKey/roleLabel exist in Config
    if
        not Config.Subdivisions[groupKey]
        or not Config.Subdivisions[groupKey][subdivisionKey]
    then
        TriggerClientEvent('agencies:assignmentError', src, "Invalid subdivision.")
        return
    end

    local validRole = false
    for _, r in ipairs(Config.Subdivisions[groupKey][subdivisionKey].roles) do
        if r.label == roleLabel then
            validRole = true
            break
        end
    end

    if not validRole then
        TriggerClientEvent('agencies:assignmentError', src, "Invalid role.")
        return
    end

    -- Store the assignment
    PlayerAssignments[src] = {
        group       = groupKey,
        subdivision = subdivisionKey,
        role        = roleLabel
    }

    -- Confirm back to that player
    TriggerClientEvent('agencies:confirmMyAssignment', src, PlayerAssignments[src])

    -- Broadcast to everyone
    broadcastAssignments()
end)

-- When a client requests all assignments (e.g. on resource start)
RegisterNetEvent('agencies:requestAllAssignments')
AddEventHandler('agencies:requestAllAssignments', function()
    local src = source
    TriggerClientEvent('agencies:updatePlayerAssignments', src, PlayerAssignments)
end)

-- Clean up if someone disconnects
AddEventHandler('playerDropped', function(reason)
    local src = source
    if PlayerAssignments[src] then
        PlayerAssignments[src] = nil
        broadcastAssignments()
    end
end)
