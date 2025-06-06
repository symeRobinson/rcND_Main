-- resource/util/shared/config.lua
-- Defines subdivision‐level minimum ranks and role‐level minimum ranks
-- for each agency (SLMPD, STLFD, STLBEMS, DOT).

Config = {}
Config.Version = "1.0.0"

function Config.Util_PrintVersion()
    print("[utils/shared] Resource version: " .. Config.Version)
end
-------------------------------------------------------------------------------
-- Subdivisions and Roles Configuration
-- “minRank” values refer to the 1‐based index in that group’s rank list.
-------------------------------------------------------------------------------
Config.Subdivisions = {
    -----------------------------------------------------------------------------
    -- St. Louis Metropolitan Police Department (SLMPD)
    -----------------------------------------------------------------------------
    slmpd = {
        -- Patrol Division: requires rank index ≥ 1 (“Probationary Officer”)
        patrol = {
            label   = "Patrol Division",
            minRank = 1,
            roles = {
                { label = "Patrol Officer",    minRank = 1 },  -- “Probationary Officer” (index 1)
                { label = "Patrol Lead",       minRank = 3 },  -- “Officer I” (index 3)
                { label = "Patrol Supervisor", minRank = 4 },  -- “Officer II” (index 4)
                { label = "Watch Commander",   minRank = 6 }   -- “Lieutenant” (index 6)
            }
        },

        -- Investigations Division: requires rank index ≥ 5 (“Corporal”)
        investigations = {
            label   = "Investigations Division",
            minRank = 5,
            roles = {
                { label = "Detective",         minRank = 5 },  -- “Corporal” (index 5)
                { label = "Lead Detective",    minRank = 7 },  -- “Lieutenant” (index 7)
                { label = "Investigation Captain", minRank = 8 }-- “Captain” (index 8)
            }
        },

        -- Traffic Unit: requires rank index ≥ 3 (“Officer I”)
        traffic = {
            label   = "Traffic Unit",
            minRank = 3,
            roles = {
                { label = "Traffic Officer",   minRank = 3 },  -- “Officer I” (index 3)
                { label = "Traffic Sergeant",  minRank = 5 },  -- “Corporal” (index 5)
                { label = "Traffic Captain",   minRank = 8 }   -- “Captain” (index 8)
            }
        }
    },

    -----------------------------------------------------------------------------
    -- St. Louis Fire Department (STLFD)
    -----------------------------------------------------------------------------
    stlfd = {
        -- Fire Suppression: requires rank index ≥ 2 (“Probationary Firefighter”)
        fire_suppression = {
            label   = "Fire Suppression",
            minRank = 2,
            roles = {
                { label = "Firefighter",      minRank = 2 },  -- “Probationary Firefighter” (index 2)
                { label = "Driver/Engineer",  minRank = 5 },  -- “Engineer” (index 5)
                { label = "Officer",          minRank = 6 }   -- “Lieutenant” (index 6)
            }
        },

        -- Rescue Company: requires rank index ≥ 1 (“Recruit Firefighter”)
        rescue = {
            label   = "Rescue Company",
            minRank = 1,
            roles = {
                { label = "Can Man",          minRank = 1 },  -- “Recruit Firefighter” (index 1)
                { label = "Driver",           minRank = 3 }   -- “Fire Private” (index 3)
            }
        },

        -- Hazmat Unit: requires rank index ≥ 2 (“Probationary Firefighter”)
        hazmat = {
            label   = "Hazmat Unit",
            minRank = 2,
            roles = {
                { label = "Hazmat Technician", minRank = 2 },  -- “Probationary Firefighter” (index 2)
                { label = "Hazmat Officer",     minRank = 5 }  -- “Engineer” (index 5)
            }
        }
    },

    -----------------------------------------------------------------------------
    -- St. Louis B.E.M.S. (STLBEMS)
    -----------------------------------------------------------------------------
    stlbems = {
        -- Transport Unit: requires rank index ≥ 2 (“EMT-Basic”)
        transport = {
            label   = "Transport Unit",
            minRank = 2,
            roles = {
                { label = "EMT-Basic",               minRank = 2 },  -- “EMT-Basic” (index 2)
                { label = "EMT-Advanced",            minRank = 3 },  -- “EMT-Advanced” (index 3)
                { label = "Paramedic",               minRank = 5 },  -- “Paramedic” (index 5)
                { label = "Paramedic Crew Chief",    minRank = 6 }   -- “Paramedic Crew Chief” (index 6)
            }
        },

        -- Critical Care Team: requires rank index ≥ 3 (“EMT-Advanced”)
        critical_care = {
            label   = "Critical Care Team",
            minRank = 3,
            roles = {
                { label = "Critical Care EMT",       minRank = 3 },  -- “EMT-Advanced” (index 3)
                { label = "Critical Care Paramedic", minRank = 5 },  -- “Paramedic” (index 5)
                { label = "Critical Care Lead",      minRank = 7 }   -- “Paramedic Supervisor” (index 7)
            }
        }
    },

    -----------------------------------------------------------------------------
    -- Department of Transportation (DOT)
    -----------------------------------------------------------------------------
    dot = {
        -- Highway Operations: requires rank index ≥ 2 (“DOT Operator”)
        highway_ops = {
            label   = "Highway Operations",
            minRank = 2,
            roles = {
                { label = "DOT Operator",     minRank = 2 },  -- “DOT Operator” (index 2)
                { label = "DOT Supervisor",   minRank = 4 }   -- “DOT Supervisor” (index 4)
            }
        },

        -- Traffic Control: requires rank index ≥ 1 (“DOT Recruit”)
        traffic_control = {
            label   = "Traffic Control",
            minRank = 1,
            roles = {
                { label = "Traffic Control Officer", minRank = 1 },  -- “DOT Recruit” (index 1)
                { label = "Traffic Control Manager", minRank = 3 }   -- “DOT Operator II” (index 3)
            }
        }
    }
}

-------------------------------------------------------------------------------
-- Utility Functions
-------------------------------------------------------------------------------

-- Returns the subdivision table if it exists, otherwise nil.
-- Example: Config.GetSubdivision("slmpd", "patrol")
function Config.GetSubdivision(groupKey, subdivisionKey)
    if Config.Subdivisions[groupKey] then
        return Config.Subdivisions[groupKey][subdivisionKey]
    end
    return nil
end

-- Returns the minRank for a given subdivision.
-- Example: Config.GetSubdivisionMinRank("slmpd", "patrol") → 1
function Config.GetSubdivisionMinRank(groupKey, subdivisionKey)
    local subs = Config.GetSubdivision(groupKey, subdivisionKey)
    return subs and subs.minRank or nil
end

-- Returns the roles array for a given subdivision.
-- Example: Config.GetSubdivisionRoles("stlfd", "fire_suppression")
function Config.GetSubdivisionRoles(groupKey, subdivisionKey)
    local subs = Config.GetSubdivision(groupKey, subdivisionKey)
    return subs and subs.roles or nil
end

-------------------------------------------------------------------------------
-- Return the Config table
-------------------------------------------------------------------------------
return Config
