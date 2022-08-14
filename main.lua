Buff = {
  name = nil,
  active = false
}

local buffs = {
  TrueBearing = {name = "True Bearing", active = false},
  RuthlessPrecision = {name = "Ruthless Precision", active = false},
  SkullAndCrossbones = {name = "Skull and Crossbones", active = false},
  GrandMelee = {name = "Grand Melee", active = false},
  BroadSide = {name = "Broadside", active = false},
  BuriedTreasure = {name = "Buried Treasure", active = false},
}

local function shouldRoll()
  local activebuffs = 0
  for _, v in pairs(buffs) do
    if v.active then
      activebuffs = activebuffs + 1
    end
  end

  start, duration, enabled = GetSpellCooldown("Roll the Bones", "BOOKTYPE_SPELL")

  if start + duration - GetTime() then
    return false
  end

  return not (buffs.BroadSide.active or
          buffs.SkullAndCrossbones.active or
          (activebuffs >= 2 and
                  (buffs.GrandMelee.active or buffs.BuriedTreasure.active)
          ) or
          activebuffs == 3)
end

local frame = CreateFrame("Frame")

frame:RegisterEvent("UNIT_AURA")
frame:SetScript("OnEvent", function (self, event, ...)
  local unit = ...

  if unit ~= "player" then
    return
  end

  for _, v in pairs(buffs) do
    v.active = UnitBuff("player", v)
  end

  if shouldRoll() then
    print("Roll now!")
  end

end)

