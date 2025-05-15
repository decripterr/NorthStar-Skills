Config = {}

Config.Skills = {
    strength = { label = "Strength", maxLevel = 100, xpCurve = "normal" },
    stamina = { label = "Stamina", maxLevel = 100, xpCurve = "normal" },
    shooting = { label = "Shooting", maxLevel = 100, xpCurve = "hard" },
    driving = { label = "Driving", maxLevel = 100, xpCurve = "normal" },
    crafting = { label = "Crafting", maxLevel = 100, xpCurve = "easy" },
    hacking = { label = "Hacking", maxLevel = 100, xpCurve = "hard" },
    fishing = { label = "Fishing", maxLevel = 100, xpCurve = "easy" },
    mining = { label = "Mining", maxLevel = 100, xpCurve = "normal" },
    farming = { label = "Farming", maxLevel = 100, xpCurve = "easy" },
    cooking = { label = "Cooking", maxLevel = 100, xpCurve = "normal" }
}

Config.XPCurves = {
    easy = function(level) return level * 10 end,
    normal = function(level) return level * 25 end,
    hard = function(level) return level * 50 end
}
