Config = {}

-- You can add or remove weapons that should spawn as a prop on the player body in the list below
Config.Weapons = {
    {
        PropHash = `w_ar_carbinerifle`,     -- The hash of the prop that should be spawned
        WeaponHash = `weapon_carbinerifle`, -- The hash of the weapon
        Item = 'weapon_carbinerifle',       -- The item name, when using esx or qb this is the same as WeaponHash (just the name so use '' instead of ``). For ox-inventory you can change weapon names so it could differ from the WeaponHash
        Bone = 24818,                       -- The bone of the ped, to which the weapon attaches. (see https://docs.altv.mp/gta/articles/ped/bones.html for more bones)
        Position = {                        -- The positions of the weapon, based on the used clothing (only works with skinchanger, if you dont have this script it will pick the default position)
            -- The positions for the male ped
            male = {
                -- First we have the default position of the weapon
                default = { -0.02, -0.14, 0.13, 0.00, 2.50, 5.00 },

                -- Then we have a position based on the clothes of the player. In this case, two special locations for bproof_1:1 and bproof_1:4 are defined
                bproof_1 = {
                    [1] = { -0.10, 0.20, 0.04, 177.50, -120.50, 0.00 },
                    [4] = { 0.06, -0.16, -0.09, 0.00, 42.50, 1.00 },
                },

                -- If the player is wearing neither bproof_1:1 or bproof_1:4, we continue the checking other clothes. Next is tshirt_1:15
                tshirt_1 = {
                    [15] = { -0.03, -0.15, 0.17, 94.00, 4.50, 10.00 },
                },

                -- If no specific clothing matches, the default position is used. It can be seen that the vertical order of the configure clothes is important, as the first matching clothing piece will be used

            },
            -- The positions for the female ped
            female = {
                default = { 0.08, -0.14, 0.12, 0.0, 0.0, 0.0 },
            },
        },
    },
    {
        PropHash = `w_pi_pistol`,
        WeaponHash = `weapon_pistol`,
        Item = 'weapon_pistol',
        Bone = 11816,
        Position = {
            male = {
                default = { 0.00, -0.01, -0.22, -90.00, 2.00, 3.50 },

                tshirt_1 = {
                    [154] = { 0.01, -0.02, 0.20, -98.50, -3.00, -9.00 },
                },
            },
            female = {
                default = { -0.08, -0.14, 0.01, -5.00, 20.00, -2.50 },
            },
        },
    },
}

-- If you set Config.Debug to true, the code in client/cl_debug.lua will be run. This enables the use of the command "/weaponprop_spawn [propName] [boneIndex = 24818 by default]" for all players. So this should only be true for development purposes.
-- After using the command (for example: "/weaponprop_spawn w_ar_carbinerifle"), the weaponProp will spawn and attach to the player. This weapon can be moved around to the desired position, which allows you to easily configure weapon positions, the weapon position is copied to your clipboard.
-- You can move around the weaponProp via the following buttons:
-- NUMPAD-RIGHT (6)                 = Positive translation of prop over X-axis
-- NUMPAD-RIGHT (6) + L-SHIFT       = Positive Rotation of prop over X-axis
-- NUMPAD-LEFT (4)                  = Negative translation of prop over X-axis
-- NUMPAD-LEFT (4) + L-SHIFT        = Negative Rotation of prop over X-axis
-- NUMPAD-UP (8)                    = Positive translation of prop over Y-axis
-- NUMPAD-UP (8) + L-SHIFT          = Positive Rotation of prop over Y-axis
-- NUMPAD-CENTER (5)                = Negative translation of prop over Y-axis
-- NUMPAD-CENTER (5) + L-SHIFT      = Negative Rotation of prop over Y-axis
-- NUMPAD-TOP-LEFT (7)              = Positive translation of prop over Z-axis
-- NUMPAD-TOP-LEFT (7) + L-SHIFT    = Positive Rotation of prop over Z-axis
-- NUMPAD-TOP-RIGHT (9)             = Negative translation of prop over Z-axis
-- NUMPAD-TOP-RIGHT (9) + L-SHIFT   = Negative Rotation of prop over Z-axis
-- BACKSPACE or X                   = Despawn the prop
Config.Debug = false
