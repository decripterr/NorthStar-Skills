local QBCore = exports['qb-core']:GetCoreObject()

RegisterNetEvent('northstar-skills:notifyLevelUp', function(skill, level)
    local label = Config.Skills[skill] and Config.Skills[skill].label or skill
    QBCore.Functions.Notify(("Your %s skill leveled up to %d!"):format(label, level), "success", 5000)
end)

-- /skills command using qb-menu
RegisterCommand("skills", function()
    QBCore.Functions.TriggerCallback("northstar-skills:getSkills", function(skills)
        if not skills then return end

        local menu = {
            {
                header = "📈 Your Skills",
                isMenuHeader = true
            }
        }

        for skill, data in pairs(Config.Skills) do
            local skillData = skills[skill] or { level = 1, xp = 0 }
            local neededXP = Config.XPCurves[data.xpCurve](skillData.level)
            local progress = math.floor((skillData.xp / neededXP) * 100)
            table.insert(menu, {
                header = ("%s: Level %d (%d%% XP)"):format(data.label, skillData.level, progress),
                txt = "",
                disabled = true
            })
        end

        exports['qb-menu']:openMenu(menu)
    end)
end)

-- Request skill data
QBCore.Functions.CreateCallback("northstar-skills:getSkills", function(source, cb)
    local player = QBCore.Functions.GetPlayerData()
    cb(player.metadata and player.metadata.skills or {})
end)
