ESX = nil

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

ESX.RegisterServerCallback('esx_cratedelivery:placeOrder', function(source, cb, weapon)
	local xPlayer = ESX.GetPlayerFromId(source)
	local price, ammo = GetMetaFromWeapon(weapon)
	local dropPoint = RandomDropPoint()

	if price == 0 then
		print(('esx_cratedelivery: %s attempted to get price from %s'):format(xPlayer.identifier, weapon))
		return
	end

	if xPlayer.getMoney() >= price then
		xPlayer.removeMoney(price)
		TriggerClientEvent('esx:showAdvancedNotification', -1, _U('global_title'), _U('global_subject'), _U('global_msg', xPlayer.name, ESX.GetWeaponLabel(weapon)), 'CHAR_PROPERTY_PLANE_SCRAP_YARD', 9)
		TriggerClientEvent('crateDrop', -1, weapon, ammo, false, 1000.0, dropPoint, 'yellow')
		cb(true)
	else
		cb(false)
	end
end)


function GetMetaFromWeapon(weapon)
	for i=1, #Config.AvailableWeapons, 1 do
		if Config.AvailableWeapons[i].weapon == weapon then
			return Config.AvailableWeapons[i].price, Config.AvailableWeapons[i].ammo
		end
	end

	return 0
end

function RandomDropPoint()
	math.randomseed(os.time())

	local randomChild = math.random(1, #Config.DeliveryLocations)

	return Config.DeliveryLocations[randomChild]
end