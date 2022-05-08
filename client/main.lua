local CruisedSpeed, CruisedSpeedKm, VehicleVectorY = 0, 0, 0

local togglelimiter = false

RegisterCommand("cruise", function(src)
	if IsDriving() and IsDriver() and not IsBoat() and not IsHeli() and not IsPlane() and not IsSub() and not IsTrain() then 
		TriggerCruiseControl()
	end
end)

RegisterKeyMapping("cruise", _U('description'), "keyboard",Config.ToggleKey)

function TriggerCruiseControl()
	if CruisedSpeed == 0 then
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


RegisterCommand("limiter", function(src)
	if IsDriving() and IsDriver() and not IsBoat() and not IsHeli() and not IsPlane() and not IsSub() and not IsTrain() then
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


RegisterCommand("indicator", function(src, args)
	if IsDriving() and IsDriver() and not IsBoat() and not IsHeli() and not IsPlane() and not IsSub() and not IsTrain() then
		if args[1] == "left" then
			TriggerIndicator('left')
		elseif args[1] == "right" then
			TriggerIndicator('right')
		else
			TriggerIndicator('both')
		end
	end
end)

RegisterKeyMapping("indicator left", _U('description3'), "keyboard",Config.ToggleKey3)
RegisterKeyMapping("indicator right", _U('description4'), "keyboard",Config.ToggleKey4)
RegisterKeyMapping("indicator emergency", _U('description5'), "keyboard",Config.ToggleKey5)

function TriggerIndicator (dir)
	local lightstate = GetVehicleIndicatorLights(GetVehicle())
	if dir == 'left' then
		if lightstate == 1 then
			LeftIndicator(false)
			RightIndicator(false)
		else
			LeftIndicator(true)
			RightIndicator(false)
		end
	elseif dir == 'right' then
		if lightstate == 2 then
			LeftIndicator(false)
			RightIndicator(false)
		else
			RightIndicator(true)
			LeftIndicator(false)
		end
	else
		if lightstate == 3 then
			LeftIndicator(false)
			RightIndicator(false)
		else
			LeftIndicator(true)
			RightIndicator(true)
		end
	end
end

function LeftIndicator (toggle)
	SetVehicleIndicatorLights(GetVehicle(), 1, toggle)
end

function RightIndicator (toggle)
	SetVehicleIndicatorLights(GetVehicle(), 0, toggle)
end

function IsTrain ()
	return IsPedInAnyTrain(PlayerPedId(), false)
end

function IsSub ()
	return IsPedInAnySub(PlayerPedId(), false)
end

function IsPlane ()
	return IsPedInAnyPlane(PlayerPedId(), false)
end

function IsHeli ()
	return IsPedInAnyHeli(PlayerPedId(), false)
end

function IsBoat ()
	return IsPedInAnyBoat(PlayerPedId(), false)
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
	if PlayerPedId() == GetPedInVehicleSeat(GetVehiclePedIsIn(PlayerPedId(), false), -1) then
		return true
	end
end

function GetVehicleSpeed ()
	return GetEntitySpeed(GetVehicle())
end

function TransformToKm (speed)
	return math.floor(speed * 3.6 + 0.5)
end
