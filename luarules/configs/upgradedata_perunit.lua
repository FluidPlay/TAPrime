---
--- Created by Breno "MaDDoX" Azevedo.
--- DateTime: 26-Aug-20 8:49 PM
---
--- All per-unit upgrades info (command buttons to unlock, upgrade time, etc)

-- Settings + Button options (as shown in a given unit's command list)
-- Value is used as key of PUU (Per-unit upgrade table)
UnitResearchers = {
    [UnitDefNames["corcom"].id] = "dgun",
    [UnitDefNames["armcom"].id] = "dgun",
    [UnitDefNames["armamex"].id] = "unlockweapon",
    [UnitDefNames["corexp"].id] = "unlockweapon",
    [UnitDefNames["armpw"].id] = "grenade",
    [UnitDefNames["armsam"].id] = "firerain",
    --[UnitDefNames["corvrad"].id] = "resurrect",
    [UnitDefNames["corvrad"].id] = "neutronstrike",
    [UnitDefNames["armmark"].id] = "smokebomb",
    [UnitDefNames["cormist"].id] = "smokebomb",
}

local CMD_CAPTURE = CMD.CAPTURE
local CMD_ATTACK = CMD.ATTACK
local CMD_MANUALFIRE = CMD.MANUALFIRE
local CMD_RESURRECT = CMD.RESURRECT

-- Per-unit upgrades button/CMD entries

CMD.UPG_DGUN = 41999
CMD_UPG_DGUN = CMD.UPG_DGUN

CMD.UPG_GRENADE = 41998
CMD_UPG_GRENADE = CMD.UPG_GRENADE

CMD.UPG_FIRERAIN = 41997
CMD_UPG_FIRERAIN = CMD.UPG_FIRERAIN

CMD.UPG_RESURRECT = 41996
CMD_UPG_RESURRECT = CMD.UPG_RESURRECT

CMD.UPG_NEUTRONSTRIKE = 41995
CMD_UPG_NEUTRONSTRIKE = CMD.UPG_NEUTRONSTRIKE

CMD.UPG_UNLOCKWEAPON = 41994
CMD_UPG_UNLOCKWEAPON = CMD.UPG_UNLOCKWEAPON

CMD.UPG_SMOKEBOMB = 41993
CMD_UPG_SMOKEBOMB = CMD.UPG_SMOKEBOMB

-- Unit Upgrades (as shown in a certain unit's command list)
UnitUpg = {
    dgun = {
        id = "dgun",
        UpgradeCmdDesc = {
            id      = CMD_UPG_DGUN,
            name    = '^ D-Gun',
            action  = 'dgunupgrade',
            cursor  = 'Morph',
            type    = CMDTYPE.ICON,
            tooltip = 'D-Gun Upgrade: Enables D-gun weapon [per unit]\n'..
                    GreenStr..'time:n/a\n'..CyanStr..'metal: n/a\n'..YellowStr..'energy: n/a',
            texture = 'luaui/images/upgrades/cmd_upgdgun.png',
            onlyTexture = true,
            showUnique = true, --required by gui_chili_buildordermenu to show button as 'upgrading'
            --params = { '1', ' Fly ', 'Land'}
        },
        prereq = "T1 Commander",
        metalCost = 200,
        energyCost = 1200,
        upgradeTime = 10 * 30, --5 seconds, in frames
        type = "tech",          -- TODO: Currently unused. Should indicate special types (auras, debuffs, etc)
        alertWhenDone = true, -- [Optional] if true, fires an alert once completed
        buttonToUnlock = CMD_MANUALFIRE,
        buttonToUnlockTooltip = "", --automatically fed when button is locked (@ unit create)
    },
    unlockweapon = {
        id = "unlockweapon",
        UpgradeCmdDesc = {
            id      = CMD_UPG_UNLOCKWEAPON,
            name    = '^ Weapon',
            action  = 'unlockweaponupgrade',
            cursor  = 'Morph',
            type    = CMDTYPE.ICON,
            tooltip = 'Unlock Weapon: Enables primary weapon [per unit]\n'..
                    GreenStr..'time:9\n'..CyanStr..'metal: 150\n'..YellowStr..'energy: 1000',
            texture = 'luaui/images/upgrades/techunlockweapon.dds',
            onlyTexture = true,
            showUnique = true, --required by gui_chili_buildordermenu to show button as 'upgrading'
            --params = { '1', ' Fly ', 'Land'}
        },
        prereq = "Tech1",
        metalCost = 150,
        energyCost = 1000,
        upgradeTime = 9 * 30, --12 seconds, in frames
        type = "tech",          -- TODO: Currently unused. Should indicate special types (auras, debuffs, etc)
        alertWhenDone = false, -- [Optional] if true, fires an alert once completed
        buttonToUnlock = CMD_ATTACK,
        buttonToUnlockTooltip = "", --automatically fed when button is locked (@ unit create)
    },
    grenade = {     -- >> Peewee's Laser Grenade (Per Unit)
        id = "grenade",
        UpgradeCmdDesc = {
            id      = CMD_UPG_GRENADE,
            name    = '^ Grenade',
            action  = 'grenadeupgrade',
            cursor  = 'Morph',
            type    = CMDTYPE.ICON,
            tooltip = 'EMP Grenade upgrade: Enables manual-fire weapon [per unit]\n'..
                    GreenStr..'time:5\n'..CyanStr..'metal: 50\n'..YellowStr..'energy: 480',
            texture = 'luaui/images/upgrades/techempbomb.dds',
            onlyTexture = true,
            showUnique = true, --required by gui_chili_buildordermenu to show button as 'upgrading'
        },
        prereq = "Tech",
        metalCost = 50,
        energyCost = 480,     --6x metalCost
        upgradeTime = 5 * 30, --5 seconds, in frames
        type = "perunit",
        buttonToUnlock = CMD_MANUALFIRE,
        buttonToUnlockTooltip = "",
    },
    smokebomb = {     -- >> Peewee's Laser Grenade (Per Unit)
        id = "smokebomb",
        UpgradeCmdDesc = {
            id      = CMD_UPG_SMOKEBOMB,
            name    = '^ SmokeBomb',
            action  = 'smokebombupgrade',
            cursor  = 'Morph',
            type    = CMDTYPE.ICON,
            tooltip = 'Smoke Bomb upgrade: Enables manual-fire weapon [per unit]\n'..
                    GreenStr..'time:5\n'..CyanStr..'metal: 80\n'..YellowStr..'energy: 480',
            texture = 'luaui/images/upgrades/techsmokebomb.dds',
            onlyTexture = true,
            showUnique = true, --required by gui_chili_buildordermenu to show button as 'upgrading'
        },
        prereq = "Tech1",
        metalCost = 80,
        energyCost = 480,     --6x metalCost
        upgradeTime = 5 * 30, --5 seconds, in frames
        type = "perunit",
        buttonToUnlock = CMD_MANUALFIRE,
        buttonToUnlockTooltip = "",
    },
    firerain = {     -- >> Arm Samson's Missile Shower (Per Unit)
        id = "firerain",
        UpgradeCmdDesc = {
            id      = CMD_UPG_FIRERAIN,
            name    = '^ FireRain',
            action  = 'firerainupgrade',
            cursor  = 'Morph',
            type    = CMDTYPE.ICON,
            tooltip = 'Fire Rain upgrade: Enables manual-fire Fire Rain weapon [per unit]\n'..
                    GreenStr..'time:10\n'..CyanStr..'metal: 250\n'..YellowStr..'energy: 1500',
            texture = 'luaui/images/upgrades/techfirerain.dds',
            onlyTexture = true,
            showUnique = true, --required by gui_chili_buildordermenu to show button as 'upgrading'
        },
        prereq = "Tech1",
        metalCost = 250,
        energyCost = 1500, --960
        upgradeTime = 6 * 30, --10 seconds, in frames
        type = "perunit", --CMDTYPE.ICON_MAP
        buttonToUnlock = CMD_MANUALFIRE,
        buttonToUnlockTooltip = "",
    },
    neutronstrike = {     -- >> Cor Vrad Neutron Hailstorm (Per Unit)
        id = "neutronstrike",
        UpgradeCmdDesc = {
            id      = CMD_UPG_NEUTRONSTRIKE,
            name    = '^ NeutronStrike',
            action  = 'neutronstrikeupgrade',
            cursor  = 'Morph',
            type    = CMDTYPE.ICON,
            tooltip = 'Neutron Strike upgrade: Enables manual-fire Neutron Strike weapon [per unit]\n'..
                    GreenStr..'time:10\n'..CyanStr..'metal: 150\n'..YellowStr..'energy: 960',
            texture = 'luaui/images/upgrades/techfirerain.dds',
            onlyTexture = true,
            showUnique = true, --required by gui_chili_buildordermenu to show button as 'upgrading'
        },
        prereq = "Tech1",
        metalCost = 150,
        energyCost = 960, --960
        upgradeTime = 6 * 30, --10 seconds, in frames
        type = "perunit", --CMDTYPE.ICON_MAP
        buttonToUnlock = CMD_MANUALFIRE,
        buttonToUnlockTooltip = "",
    },
    resurrect = {     -- >> Core Informer Resurrect (Per Unit)
        id = "resurrect",
        UpgradeCmdDesc = {
            id      = CMD_UPG_RESURRECT,
            name    = 'Upg Resurrect',
            action  = 'resurrectupgrade',
            cursor  = 'Morph',
            type    = CMDTYPE.ICON,
            tooltip = 'Resurrect upgrade: Enables ressurect ability [per unit]\n'..
                    GreenStr..'time:10\n'..CyanStr..'metal: 160\n'..YellowStr..'energy: 960',
            texture = 'luaui/images/upgrades/techresurrect.dds',
            onlyTexture = true,
            showUnique = true, --required by gui_chili_buildordermenu to show button as 'upgrading'
        },
        prereq = "Tech1",
        metalCost = 160,
        energyCost = 960,
        upgradeTime = 6 * 30, --10 seconds, in frames
        type = "perunit",
        buttonToUnlock = CMD_RESURRECT,
        buttonToUnlockTooltip = "",
    },
}

---- Which units can research what
--GlobalResearchers = {
--    [UnitDefNames["armtech"].id] = {"capture","throttle","booster1","booster2","booster3"},
--    [UnitDefNames["cortech"].id] = {"capture","throttle","booster1","booster2","booster3"},
--    [UnitDefNames["armtech1"].id] = {"capture","throttle","booster1","booster2","booster3"},
--    [UnitDefNames["cortech1"].id] = {"capture","throttle","booster1","booster2","booster3"},
--    [UnitDefNames["armtech2"].id] = {"capture","throttle","booster1","booster2","booster3"},
--    [UnitDefNames["cortech2"].id] = {"capture","throttle","booster1","booster2","booster3"},
--    [UnitDefNames["armtech3"].id] = {"capture","throttle","booster1","booster2","booster3"},
--    [UnitDefNames["cortech3"].id] = {"capture","throttle","booster1","booster2","booster3"},
--    [UnitDefNames["armtech4"].id] = {"capture","throttle","booster1","booster2","booster3"},
--    [UnitDefNames["cortech4"].id] = {"capture","throttle","booster1","booster2","booster3"},
--}
--
---- Which unitDefs are Tech Centers (Global Researchers)
--TechCenterDefIDs = {
--    [UnitDefNames["armtech"].id] = true,
--    [UnitDefNames["armtech1"].id] = true,
--    [UnitDefNames["armtech2"].id] = true,
--    [UnitDefNames["armtech3"].id] = true,
--    [UnitDefNames["armtech4"].id] = true,
--    [UnitDefNames["cortech"].id] = true,
--    [UnitDefNames["cortech1"].id] = true,
--    [UnitDefNames["cortech2"].id] = true,
--    [UnitDefNames["cortech3"].id] = true,
--    [UnitDefNames["cortech4"].id] = true,
--}