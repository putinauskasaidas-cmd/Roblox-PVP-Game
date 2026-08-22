-- GameManager.lua
-- Pagrindinė žaidimo logika

local GameManager = {}
GameManager.__index = GameManager

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

function GameManager.new()
	local self = setmetatable({}, GameManager)
	self.activeMatches = {}
	self.playerQueue = {}
	self.matchId = 0
	return self
end

-- Pridėti žaidėją į eilę
function GameManager:addPlayerToQueue(player)
	table.insert(self.playerQueue, player)
	print(player.Name .. " pridėtas į eilę. Žaidėjai eilėje: " .. #self.playerQueue)
	self:checkForMatch()
end

-- Pašalinti žaidėją iš eilės
function GameManager:removePlayerFromQueue(player)
	for i, p in ipairs(self.playerQueue) do
		if p == player then
			table.remove(self.playerQueue, i)
			print(player.Name .. " pašalintas iš eilės")
			break
		end
	end
end

-- Patikrinti ar galima pradėti mačą
function GameManager:checkForMatch()
	if #self.playerQueue >= 1 and #self.playerQueue <= 5 then
		self:startMatch(self.playerQueue)
		self.playerQueue = {}
	end
end

-- Pradėti mačą
function GameManager:startMatch(players)
	self.matchId = self.matchId + 1
	local match = {
		id = self.matchId,
		players = players,
		scores = {},
		active = true,
		startTime = tick()
	}
	
	-- Inicijuoti žaidėjų skores
	for _, player in ipairs(players) do
		match.scores[player.UserId] = {
			kills = 0,
			deaths = 0,
			money = 1000
		}
	end
	
	table.insert(self.activeMatches, match)
	print("Mač #" .. match.id .. " pradėtas! Žaidėjai: " .. #players)
	
	-- Nusiųsti žaidėjus į areną
	self:sendPlayersToArena(match)
end

-- Nusiųsti žaidėjus į areną
function GameManager:sendPlayersToArena(match)
	-- Čia būtų logika žaidėjus perkelti į areną
	print("Žaidėjai siunčiami į areną #" .. match.id)
end

-- Žaidėjas numuša kitą
function GameManager:playerKilled(killer, victim, matchId)
	local match = self:getMatch(matchId)
	if match then
		match.scores[killer.UserId].kills = match.scores[killer.UserId].kills + 1
		match.scores[victim.UserId].deaths = match.scores[victim.UserId].deaths + 1
		
		print(killer.Name .. " numuša " .. victim.Name .. "! Taškų: " .. match.scores[killer.UserId].kills)
		
		-- Patikrinti ar mač pabaiga
		self:checkMatchEnd(match)
	end
end

-- Patikrinti ar mač baigtas
function GameManager:checkMatchEnd(match)
	for userId, stats in pairs(match.scores) do
		if stats.kills >= 5 then
			-- Mač baigtas!
			self:endMatch(match, userId)
			return
		end
	end
end

-- Užbaigti mačą
function GameManager:endMatch(match, winnerUserId)
	match.active = false
	
	-- Nusiųsti laimėtoją į lobby su 500 pinigų premija
	local winner = Players:GetPlayerByUserId(winnerUserId)
	if winner then
		local leaderstats = winner:FindFirstChild("leaderstats")
		if leaderstats then
			local money = leaderstats:FindFirstChild("Money")
			if money then
				money.Value = money.Value + 500
			end
		end
		print(winner.Name .. " laimėjo mačą! Gauna 500 pinigų")
	end
	
	-- Grąžinti visus į lobby
	for _, player in ipairs(match.players) do
		-- Grąžinti į lobby (implementuoti pagal tavo lobby sistemą)
	end
	
	-- Pašalinti mačą iš aktyvių
	for i, m in ipairs(self.activeMatches) do
		if m.id == match.id then
			table.remove(self.activeMatches, i)
			break
		end
	end
end

-- Gauti mačą pagal ID
function GameManager:getMatch(matchId)
	for _, match in ipairs(self.activeMatches) do
		if match.id == matchId then
			return match
		end
	end
	return nil
end

return GameManager
