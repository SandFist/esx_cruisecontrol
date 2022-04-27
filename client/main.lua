local CruisedSpeed, CruisedSpeedKm, VehicleVectorY = 0, 0, 0

RegisterCommand("cruise", function(src)
	if IsDriving() and IsDriver() and not IsBoat() then 
		TriggerCruiseControl()
	end
end)

RegisterKeyMapping("cruise", _U('description'), "keyboard",Config.ToggleKey)

function TriggerCruiseControl()
	if CruisedSpeed == 0 and IsDriving() then
		if GetVehicleSpeed() > 0 and GetVehicleCurrentGear(GetVehicle()) > 0	then
			CruisedSpeed = GetVehicleSpeed()
			CruisedSpeedKm = TransformToKm(CruisedSpeed)

			ESX.ShowNotification(_U('activated') .. ': ~b~ ' .. CruisedSpeedKm .. ' km/h')

			CreateThread(function ()
				while CruisedSpeed > 0 and IsInVehicle() == PlayerPedId() do
					Wait(0)

					if not IsTurningOrHandBraking() and GetVehicleSpeed() < (CruisedSpeed - 1.5) then
						CruisedSpeed = 0
						ESX.ShowNotification(_U('deactivated'))
						Wait(2000)
						break
					end

					if not IsTurningOrHandBraking() and IsVehicleOnAllWheels(GetVehicle()) and GetVehicleSpeed() < CruisedSpeed then
						SetVehicleForwardSpeed(GetVehicle(), CruisedSpeed)
					end

					if IsControlJustReleased(2, 71) then
						CruisedSpeed = GetVehicleSpeed()
						CruisedSpeedKm = TransformToKm(CruisedSpeed)
						
						ESX.ShowNotification(_U('activated') .. ': ~b~ ' .. CruisedSpeedKm .. ' km/h')
					end

					if IsControlJustPressed(2, 72) then
						CruisedSpeed = 0
						ESX.ShowNotification(_U('deactivated'))
						Wait(2000)
						break
					end
				end
			end)
		end
	end
end

function IsTurningOrHandBraking ()
	return IsControlPressed(2, 76) or IsControlPressed(2, 63) or IsControlPressed(2, 64)
end

function IsDriving ()
	return IsPedInAnyVehicle(PlayerPedId(), false)
end

function GetVehicle ()
	return GetVehiclePedIsIn(PlayerPedId(), false)
end

function IsInVehicle ()
	return GetPedInVehicleSeat(GetVehicle(), -1)
end

function IsDriver ()
	return GetPedInVehicleSeat(GetVehiclePedIsIn(PlayerPedId(), false), -1)
end

function GetVehicleSpeed ()
	return GetEntitySpeed(GetVehicle())
end

function TransformToKm (speed)
	return math.floor(speed * 3.6 + 0.5)
end

-- Speed Limiter

function IsBoat ()
	return IsPedInAnyBoat(PlayerPedId(), false)
end

--

local togglelimiter = false

RegisterCommand("limiter", function(src)
	if IsDriving() and IsDriver() and not IsBoat() then
		TriggerSpeedLimiter()
	end
end)

RegisterKeyMapping("limiter", _U('description2'), "keyboard",Config.ToggleKey2)

function TriggerSpeedLimiter ()
						if togglelimiter then
							SetEntityMaxSpeed(GetVehicle(), GetVehicleHandlingFloat(GetVehicle(),"CHandlingData","fInitialDriveMaxFlatVel"))
							togglelimiter = false
							ESX.ShowNotification(_U('deactivated2'))
						else
							SetEntityMaxSpeed(GetVehicle(), GetVehicleSpeed())
							togglelimiter = true
							ESX.ShowNotification(_U('activated2') .. ': ~b~ ' .. TransformToKm(GetVehicleSpeed()) .. ' km/h')
						end
end
