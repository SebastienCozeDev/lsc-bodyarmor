-- Component variables
local ALL_SEX_BODYARMOR = {9, 8, 2}
local BODYCAM_BODYARMOR = {1, 108, 1}

-- Variables to store the initial state
local savedMask = nil
local savedBodyArmor = nil

-- [DO NOT WORK] Function to check if the current player is near of vehicles
local function IsVehicleNearby(radius)
    local playerPed = PlayerPedId()
    local playerCoords = GetEntityCoords(playerPed)
    local vehicles = GetGamePool('CVehicle')
    for _, vehicle in ipairs(vehicles) do
        local vehicleCoords = GetEntityCoords(vehicle)
        local distance = Vdist(playerCoords.x, playerCoords.y, playerCoords.z, vehicleCoords.x, vehicleCoords.y, vehicleCoords.z)
        if distance <= radius then
            return true
        end
    end
    return false
end

-- Function to show notification
local function ShowNotification(text)
    SetNotificationTextEntry("STRING")
    AddTextComponentString(text)
    DrawNotification(false, true)
end

-- Function to apply a outfit component
local function applyComponent(ped, component)
    SetPedComponentVariation(ped, component[1], component[2] - 1, component[3] - 1, 0)
end

-- Function to equip the heavy bodyarmor and the bodycam
local function equipHeavyArmor()
    local playerPed = PlayerPedId()
    savedMask = {1, GetPedDrawableVariation(playerPed, 1) + 1, GetPedTextureVariation(playerPed, 1) + 1}
    savedBodyArmor = {9, GetPedDrawableVariation(playerPed, 9) + 1, GetPedTextureVariation(playerPed, 9) + 1}
    applyComponent(playerPed, ALL_SEX_BODYARMOR)
    applyComponent(playerPed, BODYCAM_BODYARMOR)
    SetPedArmour(playerPed, 100)
	  ShowNotification("Vous avez équipé un gilet lourd.");
end

-- Function to unequip the heavy bodyarmor and the bodycam
local function removeHeavyArmor()
    local playerPed = PlayerPedId()
    if savedMask then
        applyComponent(playerPed, savedMask)
    end
    if savedBodyArmor then
        applyComponent(playerPed, savedBodyArmor)
    end
    SetPedArmour(playerPed, 25)
    ShowNotification("Vous avez retiré le gilet lourd.");
end

-- Function to check the actual state and equip or unequip the heavy bodyarmor
local function toggleHeavyArmor()
    local playerPed = PlayerPedId()
    local currentBodyArmor = {9, GetPedDrawableVariation(playerPed, 9) + 1, GetPedTextureVariation(playerPed, 9) + 1}
  	if false then  -- TODO Check if the player is near of vehicles
          ShowNotification("Vous devez être près de votre véhicule.");
  	else
          if currentBodyArmor[2] == ALL_SEX_BODYARMOR[2] and currentBodyArmor[3] == ALL_SEX_BODYARMOR[3] then
              removeHeavyArmor();
          else
              equipHeavyArmor();
          end
  	end
end

-- Register the gpbsd command to (un)equip the heavy bodyarmor
RegisterCommand('gpbsd', function()
    toggleHeavyArmor()
end, false)
