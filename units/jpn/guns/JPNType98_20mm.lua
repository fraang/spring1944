local JPN_Type98_20mm_Truck = AAGunTractor:New{
	name					= "Towed Type 98 20mm Gun",
	buildCostMetal			= 1250,
	corpse					= "JPNIsuzuTX40_Abandoned", -- TODO: grumble
	trackOffset				= 10,
	trackWidth				= 13,
}

local JPN_Type98_20mm_Stationary = AAGun:New{
	name					= "Deployed Type 98 20mm Gun",
	corpse					= "JPNType98_20mm_Destroyed",
	script					= "ITABreda20_Stationary.cob",
	customParams = {
		weaponcost	= 2,
	},
	weapons = {
		[1] = { -- AA
			name				= "Type9820mmAA",
		},
		[2] = { -- HE
			name				= "Type9820mmHE",
		},
	},
}

return lowerkeys({
	["JPNType98_20mm_Truck"] = JPN_Type98_20mm_Truck,
	["JPNType98_20mm_Stationary"] = JPN_Type98_20mm_Stationary,
})
