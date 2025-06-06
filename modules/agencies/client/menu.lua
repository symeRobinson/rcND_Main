-- resource/modules/agencies/client/menu.lua
-- Make sure you have a dependency on whatever menu resource provides `lib` (e.g. ox_lib, qb-menu, etc.)
-- In all examples below, `lib.registerMenu` / `lib.showMenu` / `lib.hideMenu` are assumed to be available.


local assignments = {}   -- Will hold all players’ assignments, as sent from the server
local myAssignment = nil

--------------------------------------------------------------------------------
-- Helper: get this player’s ND-Core group+rank.
-- Replace these exports with whatever you actually use in your server. 
-- We assume: 
--   exports['nd-core']:GetPlayerGroup()         → "slmpd", "stlfd", etc.
--   exports['nd-core']:GetPlayerRankIndex()     → a 1-based index into that group’s ranks.
--------------------------------------------------------------------------------
local function getMyGroupAndRank()
    local groupKey  = exports['nd-core']:GetPlayerGroup() or "civilian"
    local rankIndex = exports['nd-core']:GetPlayerRankIndex() or 1
    return groupKey, rankIndex
end

--------------------------------------------------------------------------------
-- (1) When the user picks a subdivision, we open the Role menu
local function openRoleMenu(groupKey, subdivisionKey, rankIndex)
    local subData = Config.Subdivisions[groupKey][subdivisionKey]
    if not subData then return end

    -- Build one button per valid role
    local roleOptions = {}
    for _, roleInfo in ipairs(subData.roles) do
        if rankIndex >= roleInfo.minRank then
            table.insert(roleOptions, {
                label = roleInfo.label,
                args  = {
                    subdivisionKey = subdivisionKey,
                    roleLabel      = roleInfo.label
                }
            })
        end
    end

    if #roleOptions == 0 then
        lib.notify({ type = "error", description = "No eligible roles in this subdivision." })
        return
    end

    lib.registerMenu({
        id       = "agencies_select_role",
        title    = "Choose Role: " .. subData.label,
        position = "top-left",
        options  = roleOptions
    },
    function(selectedIndex, scrollIndex, args)
        lib.hideMenu(true)
        if args and args.roleLabel then
            -- Tell the server: “I want to be (groupKey, subdivisionKey, roleLabel)”
            TriggerServerEvent("agencies:setPlayerUnit", groupKey, subdivisionKey, args.roleLabel)
        end
    end)

    lib.showMenu("agencies_select_role")
end

--------------------------------------------------------------------------------
-- (2) When the user picks “Set My Unit” from the Main menu, we open Subdivision menu
local function openSubdivisionMenu()
    local groupKey, rankIndex = getMyGroupAndRank()
    local subs = Config.Subdivisions[groupKey]
    if not subs then
        lib.notify({ type = "error", description = "No subdivisions defined for your group!" })
        return
    end

    -- Build one button per subdivision you are eligible for
    local subdivOptions = {}
    for subKey, subData in pairs(subs) do
        if rankIndex >= subData.minRank then
            table.insert(subdivOptions, {
                label = subData.label,
                args  = { subdivisionKey = subKey }
            })
        end
    end

    if #subdivOptions == 0 then
        lib.notify({ type = "error", description = "You do not meet the minimum rank for any subdivision." })
        return
    end

    lib.registerMenu({
        id       = "agencies_select_subdivision",
        title    = "Choose Subdivision",
        position = "top-left",
        options  = subdivOptions
    },
    function(selectedIndex, scrollIndex, args)
        lib.hideMenu(true)
        if args and args.subdivisionKey then
            openRoleMenu(groupKey, args.subdivisionKey, rankIndex)
        end
    end)

    lib.showMenu("agencies_select_subdivision")
end

--------------------------------------------------------------------------------
-- (3) “View All Units” → show a read‐only list of assignments, one per player
local function openViewAllUnitsMenu()
    local viewOptions = {}
    for serverId, data in pairs(assignments) do
        -- If the player is still in the session, we can get their name:
        local playerPed = GetPlayerFromServerId(serverId)
        local playerName = GetPlayerName(playerPed) or ("ID: " .. serverId)

        local line = ("%s  —  %s / %s"):format(
            playerName,
            data.subdivision, 
            data.role
        )
        table.insert(viewOptions, { label = line, args = {} })
    end

    if #viewOptions == 0 then
        table.insert(viewOptions, { label = "No one is assigned to any unit.", args = {} })
    end

    lib.registerMenu({
        id        = "agencies_view_all",
        title     = "Active Unit Assignments",
        position  = "top-left",
        canClose  = true,
        options   = viewOptions
    },
    function(selectedIndex, scrollIndex, args)
        -- Just read‐only; do nothing on select
    end)

    lib.showMenu("agencies_view_all")
end

--------------------------------------------------------------------------------
-- (4) Main Duty Menu: “Set My Unit” vs “View All Units”
local function openMainMenu()
    local mainOptions = {
        { label = "Set My Unit",    args = {} },
        { label = "View All Units", args = {} }
    }

    lib.registerMenu({
        id       = "agencies_main",
        title    = "Duty Menu",
        position = "top-left",
        options  = mainOptions
    },
    function(selectedIndex, scrollIndex, args)
        lib.hideMenu(true)

        if selectedIndex == 1 then
            openSubdivisionMenu()
        elseif selectedIndex == 2 then
            openViewAllUnitsMenu()
        end
    end)

    lib.showMenu("agencies_main")
end

--------------------------------------------------------------------------------
-- (5) Listen for server → client “broadcast” of everyone’s assignments
RegisterNetEvent("agencies:updatePlayerAssignments")
AddEventHandler("agencies:updatePlayerAssignments", function(allAssignments)
    assignments = allAssignments or {}
end)

--------------------------------------------------------------------------------
-- (6) Listen for confirmation of “my own” assignment
RegisterNetEvent("agencies:confirmMyAssignment")
AddEventHandler("agencies:confirmMyAssignment", function(myData)
    myAssignment = myData
    lib.notify({
        type        = "success",
        description = ("You are now: %s / %s"):format(myData.subdivision, myData.role)
    })
end)

--------------------------------------------------------------------------------
-- (7) Expose a small helper so that `main.lua` can open /dmenu
return {
    OpenDutyMenu = openMainMenu
}
