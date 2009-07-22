--[[
format:
{
  buildoptionUnitname = {
    prereqUnitname,
    prereqUnitname,
  },
  ...
}
]]

local anyBarracks = {
  "gbrbarracks",
  "gerbarracks",
  "rusbarracks",
  "usbarracks",
}

local result = {
  gbrgunyard = anyBarracks,
  gbrvehicleyard = anyBarracks,
  gbrtankyard = anyBarracks,
  gbrradar = anyBarracks,
  gergunyard = anyBarracks,
  gervehicleyard = anyBarracks,
  gertankyard = anyBarracks,
  gerradar = anyBarracks,
  rusgunyard = anyBarracks,
  rusvehicleyard = anyBarracks,
  rustankyard = anyBarracks,
  rusradar = anyBarracks,
  usgunyard = anyBarracks,
  usvehicleyard = anyBarracks,
  ustankyard = anyBarracks,
  usradar = anyBarracks,
}

return result
