local QBCore = exports['qb-core']:GetCoreObject()

-- Initialize skills if not set
local function InitPlayerSkills(player)
    player.Functions.SetMetaData('skills', player.PlayerData.metadata.skills or {})
    for skill, data in pairs(Config.Skills) do
        if not player.PlayerData.metadata.skills[skill] then
            player.PlayerData.metadata.skills[skill] = { level = 1, xp = 0 }
        end
    end
end

-- Add XP to a skill
local function AddSkillXP(src, skill, amount)
    local player = QBCore.Functions.GetPlayer(src)
    if not player or not Config.Skills[skill] then return end

    InitPlayerSkills(player)

    local skillData = player.PlayerData.metadata.skills[skill]
    local level = skillData.level
    local xp = skillData.xp + amount
    local neededXP = Config.XPCurves[Config.Skills[skill].xpCurve](level)

    while xp >= neededXP and level < Config.Skills[skill].maxLevel do
        xp = xp - neededXP
        level = level + 1
        TriggerClientEvent('northstar-skills:notifyLevelUp', src, skill, level)
        neededXP = Config.XPCurves[Config.Skills[skill].xpCurve](level)
    end

    player.PlayerData.metadata.skills[skill] = { level = level, xp = xp }
    player.Functions.SetMetaData('skills', player.PlayerData.metadata.skills)
end

RegisterNetEvent('northstar-skills:addXP', function(skill, amount)
    local src = source
    AddSkillXP(src, skill, amount)
end)

-- Admin command: /setskill [id] [skill] [level]
QBCore.Commands.Add('setskill', 'Set a player's skill level', {{name = 'id', help = 'Player ID'}, {name = 'skill', help = 'Skill name'}, {name = 'level', help = 'Level'}}, true, function(source, args)
    local target = QBCore.Functions.GetPlayer(tonumber(args[1]))
    local skill = tostring(args[2])
    local level = tonumber(args[3])
    if target and Config.Skills[skill] then
        InitPlayerSkills(target)
        target.PlayerData.metadata.skills[skill] = { level = level, xp = 0 }
        target.Functions.SetMetaData('skills', target.PlayerData.metadata.skills)
        TriggerClientEvent('QBCore:Notify', source, 'Skill updated.', 'success')
    else
        TriggerClientEvent('QBCore:Notify', source, 'Invalid skill or player.', 'error')
    end
end)

-- Exported functions
exports('AddXP', function(src, skill, amount)
    AddSkillXP(src, skill, amount)
end)

exports('GetSkill', function(src, skill)
    local player = QBCore.Functions.GetPlayer(src)
    if player and player.PlayerData.metadata.skills[skill] then
        return player.PlayerData.metadata.skills[skill]
    end
    return { level = 1, xp = 0 }
end)
