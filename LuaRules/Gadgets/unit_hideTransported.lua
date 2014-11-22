function gadget:GetInfo()
  return {
    name      = "Transport Helper",
    desc      = "Hides units when inside a closed transport, issues stop command to units trying to enter a full transport",
    author    = "FLOZi",
    date      = "09/02/10",
    license   = "PD",
    layer     = 0,
    enabled   = true  --  loaded by default?
  }
end


if (gadgetHandler:IsSyncedCode()) then

-- Unsynced Ctrl
local SetUnitNoDraw         = Spring.SetUnitNoDraw
-- Synced Read
local GetUnitDefID          = Spring.GetUnitDefID
local GetUnitTeam           = Spring.GetUnitTeam
local GetUnitPosition       = Spring.GetUnitPosition
local GetUnitTransporter    = Spring.GetUnitTransporter
local GetUnitsInCylinder    = Spring.GetUnitsInCylinder
local GetUnitSensorRadius   = Spring.GetUnitSensorRadius
-- Synced Ctrl
local GiveOrderToUnit       = Spring.GiveOrderToUnit
local SetUnitNeutral        = Spring.SetUnitNeutral
local SetUnitSensorRadius   = Spring.SetUnitSensorRadius

-- Constants
local CMD_LOAD_ONTO = CMD.LOAD_ONTO
local CMD_STOP = CMD.STOP
local LOS_TYPES = {"los", "airLos", "radar", "sonar", "seismic", "radarJammer", "sonarJammer"}
-- Variables
local massLeft = {}
local toBeLoaded = {}
local savedRadius = {}


local DelayCall = GG.Delay.DelayCall

local function StoreLOSRadius(unitID, unitDefID)
	if not savedRadius[unitDefID] then
		radiusArray = {}
		for i, losType in pairs(LOS_TYPES) do
			radiusArray[i] = GetUnitSensorRadius(unitID, losType)
			SetUnitSensorRadius(unitID, losType, 0)
		end
		savedRadius[unitDefID] = radiusArray
	else
		for i, losType in pairs(LOS_TYPES) do
			SetUnitSensorRadius(unitID, losType, 0)
		end
	end
end

local function RestoreLOSRadius(unitID, unitDefID)
	radiusArray = savedRadius[unitDefID]
	for i, losType in pairs(LOS_TYPES) do
		SetUnitSensorRadius(unitID, losType, radiusArray[i])
	end
end

function gadget:AllowCommand(unitID, unitDefID, unitTeam, cmdID, cmdParams, cmdOptions)
	if cmdID == CMD_LOAD_ONTO then
		local transportID = cmdParams[1]
		toBeLoaded[unitID] = transportID
	end
	return true
end


function gadget:UnitCreated(unitID, unitDefID, teamID)
	local unitDef = UnitDefs[unitDefID]
	local maxMass = unitDef.transportMass
	if maxMass then
		massLeft[unitID] = maxMass
	end
end

function gadget:UnitDestroyed(unitID, unitDefID, unitTeam)
	massLeft[unitID] = nil
	toBeLoaded[unitID] = nil
end

local function TransportIsFull(transportID)
	for unitID, targetTransporterID in pairs(toBeLoaded) do
		if targetTransporterID == transportID then
			GiveOrderToUnit(unitID, CMD_STOP, {}, {})
			toBeLoaded[unitID] = nil
		end
	end
end

function gadget:UnitLoaded(unitID, unitDefID, unitTeam, transportID, transportTeam)
	--Spring.Echo("UnitLoaded")
	local transportDef = UnitDefs[GetUnitDefID(transportID)]
	local unitDef = UnitDefs[unitDefID]
	-- Check if transport is full (former crash risk!)
	if massLeft[transportID] then
		massLeft[transportID] = massLeft[transportID] - unitDef.mass
	
		if massLeft[transportID] == 0 then
			TransportIsFull(transportID)
		end
		if unitDef.xsize == 2 and not (transportDef.minWaterDepth > 0) and not unitDef.customParams.hasturnbutton then 
			-- transportee is Footprint of 1 (doubled by engine) and transporter is not a boat and transportee is not an infantry gun
			SetUnitNoDraw(unitID, true)
			SetUnitNeutral(unitID, true)
			StoreLOSRadius(unitID, unitDefID)
		end
	end
	Spring.SetUnitNoMinimap(unitID, true)
end

function gadget:UnitUnloaded(unitID, unitDefID, teamID, transportID)
	--Spring.Echo("UnitUnloaded")
	local transportDef = UnitDefs[GetUnitDefID(transportID)]
	local unitDef = UnitDefs[unitDefID]
	massLeft[transportID] = massLeft[transportID] + unitDef.mass
	if unitDef.xsize == 2 and not (transportDef.minWaterDepth > 0) and not unitDef.customParams.hasturnbutton then 
		SetUnitNoDraw(unitID, false)
		SetUnitNeutral(unitID, false)
		RestoreLOSRadius(unitID, unitDefID)
	end
	DelayCall(Spring.SetUnitVelocity, {unitID, 0, 0, 0}, 16)
	Spring.SetUnitNoMinimap(unitID, false)
end

function gadget:Initialize()
	for _, unitID in ipairs(Spring.GetAllUnits()) do
		local unitTeam = GetUnitTeam(unitID)
		local unitDefID = GetUnitDefID(unitID)
		gadget:UnitCreated(unitID, unitDefID, unitTeam)
	end
end

else

end


