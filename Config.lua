Config = {}

-- general behaviour
Config.DrawUI = false
Config.TickSeconds = 10
Config.AutoSaveSeconds = 120
Config.DamagePerTick = 2
Config.MinValue = 0
Config.MaxValue = 100

Config.BlizzardMode = {
    enabled = true,
    thirstDecayMul = 1.50,
    hungerDecayMul = 1.25,
    energyDecayMul = 1.20,
    stressBaseGain = 0.04
}

Config.Policy = {
    enableFromTemperature = true,
    enableFromWetness = true,
    enableFromStamina = true,
    enableFromInjury = true,
    enableFromSickness = true,
    temperature = {
        cold = { hungerDecayMul = 1.25, thirstDecayMul = 1.50, energyDecayMul = 1.20 }
    },
    wetness = {
        soaked = { energyDecayMul = 1.25, stressAdd = 2 }
    },
    stamina = {
        exhaustedBlackoutMs = 400
    },
    injury = {
        bleeding = { energyDecayMul = 1.15, stressAdd = 5 },
        fracture = { energyDecayMul = 1.15, stressAdd = 7 }
    },
    sickness = {
        fever = { thirstDecayMul = 1.30, energyDecayMul = 1.20 },
        foodpoison = { hungerDecayMul = 1.30 }
    }
}

-- Status definitions
Config.Statuses = {
    hunger = {
        label = 'Hunger',
        range = {0,100},
        default = 100,
        decay = 0.15,
        restoreOnSpawn = true,
        persistence = true,
        thresholds = {
            { lt = 50, effects = { {type='staminaRegen', value=-0.15} } },
            { lt = 25, effects = { {type='staminaRegen', value=-0.30} } },
            { lt = 10, effects = { {type='blackout', value=500} } }
        }
    },
    thirst = {
        label = 'Thirst',
        range = {0,100},
        default = 100,
        decay = 0.20,
        restoreOnSpawn = true,
        persistence = true,
        thresholds = {
            { lt = 50, effects = { {type='staminaRegen', value=-0.10} } },
            { lt = 25, effects = { {type='shake', value=0.12}, {type='breath', value='fast'} } },
            { lt = 5, effects = { {type='blackout', value=500}, {type='shake', value=0.25} } }
        }
    },
    energy = {
        label = 'Energy',
        range = {0,100},
        default = 100,
        decay = 0.12,
        restoreOnSpawn = true,
        persistence = true,
        thresholds = {
            { lt = 40, effects = { {type='sway', value='low'} } },
            { lt = 20, effects = { {type='stumble', value=0.20} } },
            { lt = 10, effects = { {type='pace', value='slow'} } }
        }
    },
    stress = {
        label = 'Stress',
        range = {0,100},
        default = 0,
        decay = 0.00,
        restoreOnSpawn = true,
        persistence = true,
        thresholds = {
            { gt = 60, effects = { {type='shake', value=0.15}, {type='breath', value='tight'} } },
            { gt = 85, effects = { {type='shake', value=0.30}, {type='desaturate', value='med'} } }
        }
    }
}

Config.Items = {
    water = { thirst = 25, time = 2000, anim = 'WORLD_HUMAN_DRINKING' },
    bread = { hunger = 20, time = 2500, anim = 'PROP_HUMAN_BUM_BIN' },
    canned_food = { hunger = 35, thirst = -5, time = 3000, anim = 'PROP_HUMAN_BBQ' },
    coffee = { energy = 20, thirst = 5, time = 2500, anim = 'WORLD_HUMAN_AA_COFFEE' },
    energy_drink = { energy = 40, thirst = 15, time = 3000, anim = 'WORLD_HUMAN_DRINKING', debuff = { thirstDecayMul = 1.25, duration = 300 } },
    cigarette = { stress = -15, thirst = -5, time = 3500, anim = 'WORLD_HUMAN_SMOKING' }
}

return Config
