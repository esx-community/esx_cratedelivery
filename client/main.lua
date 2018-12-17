ESX = nil
local objectList = {}

Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(0)
	end


	for k, v in pairs(Config.DeliveryShops) do
		ESX.Game.SpawnObject('prop_laptop_01a', {
			x = v.x,
			y = v.y,
			z = v.z
		}, function(shopObject)
			SetObjectTargettable(shopObject, true)
			SetEntityHeading(shopObject, v.heading)
	
			SetEntityAsMissionEntity(shopObject, true, true)
			FreezeEntityPosition(shopObject, true)
	
			table.insert(objectList, shopObject)
		end)
	end
end)

AddEventHandler('onResourceStop', function(resource)
	if resource == GetCurrentResourceName() then
		for k, v in pairs(objectList) do
			DeleteEntity(v)
		end
	end
end)

function OpenDeliveryShop()
	local elements = {}

	for i=1, #Config.AvailableWeapons, 1 do
		table.insert(elements, {
			label = ('%s - <span style="color: green;">%s</span>'):format(ESX.GetWeaponLabel(Config.AvailableWeapons[i].weapon), _U('delivery_shop_item', ESX.Math.GroupDigits(Config.AvailableWeapons[i].price))),
			weapon = Config.AvailableWeapons[i].weapon,
			price = Config.AvailableWeapons[i].price
		})
	end

	ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'delivery_shop', {
		title    = _U('delivery_shop_title'),
		align    = 'top-left',
		elements = elements
	}, function(data, menu)
		ESX.TriggerServerCallback('esx_cratedelivery:placeOrder', function(orderPlaced)
			if orderPlaced then
				menu.close()
			else
				ESX.ShowNotification(_U('delivery_shop_cannot_afford'))
			end
		end, data.current.weapon)
	end, function(data, menu)

		menu.close()
	end)

end