-- ShopSystem.lua
-- Ginklų ir armor parduotuvė

local ShopSystem = {}
ShopSystem.__index = ShopSystem

function ShopSystem.new()
	local self = setmetatable({}, ShopSystem)
	
	-- Ginklai: {name, price, ammo}
	self.weapons = {
		{name = "Blogas Pistoletas", price = 1000, ammo = 10, damage = 10},
		{name = "Vidutinis Šautuvas", price = 3000, ammo = 10, damage = 25},
		{name = "Geras Snaiperinis", price = 5000, ammo = 10, damage = 50}
	}
	
	-- Armor
	self.armor = {
		{name = "Apsauga", price = 10000, healthBonus = 100}
	}
	
	return self
end

-- Pirkti ginklą
function ShopSystem:buyWeapon(player, weaponIndex)
	local weapon = self.weapons[weaponIndex]
	if not weapon then
		print("Ginklas nerastas!")
		return false
	end
	
	local leaderstats = player:FindFirstChild("leaderstats")
	if leaderstats then
		local money = leaderstats:FindFirstChild("Money")
		if money and money.Value >= weapon.price then
			money.Value = money.Value - weapon.price
			print(player.Name .. " pirko: " .. weapon.name .. " už " .. weapon.price .. " pinigų")
			return true
		else
			print(player.Name .. " neturi pakankamai pinigų! Reikia: " .. weapon.price)
			return false
		end
	end
	return false
end

-- Pirkti armor
function ShopSystem:buyArmor(player, armorIndex)
	local armor = self.armor[armorIndex]
	if not armor then
		print("Armor nerastas!")
		return false
	end
	
	local leaderstats = player:FindFirstChild("leaderstats")
	if leaderstats then
		local money = leaderstats:FindFirstChild("Money")
		if money and money.Value >= armor.price then
			money.Value = money.Value - armor.price
			
			-- Pridėti health bonus
			local playerStats = player:FindFirstChild("PlayerStats")
			if playerStats then
				local hasArmor = playerStats:FindFirstChild("HasArmor")
				if hasArmor then
					hasArmor.Value = true
				end
			end
			
			print(player.Name .. " pirko armor už " .. armor.price .. " pinigų")
			return true
		else
			print(player.Name .. " neturi pakankamai pinigų! Reikia: " .. armor.price)
			return false
		end
	end
	return false
end

-- Gauti visus ginklus
function ShopSystem:getAllWeapons()
	return self.weapons
end

-- Gauti visą armor
function ShopSystem:getAllArmor()
	return self.armor
end

return ShopSystem
