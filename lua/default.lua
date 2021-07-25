local COMPS = 0
local function compare(i,j)
	if i > j then
		return 1
	elseif i < j then
		return -1
	else
		return 0
	end
end
local SWAPS = 0
local function swap(a,i,j)
	local h = a[i]
	a[i] = a[j]
	a[j] = h
end
local WRITES = 0
local function inwrite(a,i,j)
	a[i] = j
end
local mainarray = {}
for i = 1,128 do
	table.insert(mainarray,i)
end
local poptions = {GAMESTATE:GetPlayerState(0):GetPlayerOptions('ModsLevel_Song'),GAMESTATE:GetPlayerState(1):GetPlayerOptions('ModsLevel_Song')}
local onplayers = {nil, nil}
local didwehide = false
local currentalgo = 1
local delay = 1/#mainarray
local arrayscale = 128/#mainarray
local index = 1
local bound = #mainarray
local left = 1
local right = #mainarray
local way = 1
local startfromleft = 1
local anyswaps = false
local testpass = false
local shuffleindex = 1
local t = Def.ActorFrame{
	OnCommand = function(self)
		self:playcommand("Display")
		SCREENMAN:GetTopScreen():GetChild('Overlay'):GetChildAt(1):visible(false)
	end,
	DisplayCommand = function(self)		
		onplayers[1] = SCREENMAN:GetTopScreen():GetChild('PlayerP1')
		onplayers[2] = SCREENMAN:GetTopScreen():GetChild('PlayerP2')
		if GAMESTATE:IsPlayerEnabled(0) then
			if SCREENMAN:GetTopScreen():GetChild('ScoreP1') then SCREENMAN:GetTopScreen():GetChild('ScoreP1'):visible(false) end
			if SCREENMAN:GetTopScreen():GetChild('LifeP1') then SCREENMAN:GetTopScreen():GetChild('LifeP1'):visible(false) end
		end
		if GAMESTATE:IsPlayerEnabled(1) then
			if SCREENMAN:GetTopScreen():GetChild('ScoreP2') then SCREENMAN:GetTopScreen():GetChild('ScoreP2'):visible(false) end
			if SCREENMAN:GetTopScreen():GetChild('LifeP2') then SCREENMAN:GetTopScreen():GetChild('LifeP2'):visible(false) end
		end
		for i,v in pairs(onplayers) do
			if v then
				poptions[i]:Cover(999,999)
				poptions[i]:Dark(1,999)
				v:x(SCREEN_CENTER_X)
			end
		end
	end
}
t[#t+1] = Def.Actor{
	OnCommand = function(self)
		MESSAGEMAN:Broadcast("DoShuffle")
	end,
	SortRunMessageCommand = function(self)
		arrayscale = 128/#mainarray
		index = 1
		bound = #mainarray
		left = 0
		right = #mainarray
		way = 1
		startfromleft = 1
		anyswaps = false
		testpass = false
		if currentalgo == 1 then
			self:queuecommand("BubbleSort")
		elseif currentalgo == 2 then
			self:queuecommand("CocktailShakerSort")
		elseif currentalgo == 3 then
			self:queuecommand("OddEvenSort")
		elseif currentalgo == 4 then
			self:queuecommand("GnomeSort")
		elseif currentalgo == 5 then
			self:queuecommand("ClamberSort")
		end
	end,
	BubbleSortCommand = function(self)
		if compare(mainarray[index],mainarray[index+1]) == 1 then
			swap(mainarray,index,index+1)
			SWAPS = SWAPS + 1
			WRITES = WRITES + 2
			anyswaps = true
		end
		COMPS = COMPS + 1
		self:sleep(0.0025)
		index = index + 1
		if index == bound then
			index = 1
			bound = bound - 1
			if anyswaps == false then
				bound = 1
			end
			anyswaps = false
		end
		if bound > 1 then
			SCREENMAN:SystemMessage("Bubble Sort: "..COMPS.." Comparisons, "..SWAPS.." Swaps, "..WRITES.. " Writes")
			self:queuecommand("BubbleSort")
		else
			self:queuecommand("Complete")
		end
	end,
	CocktailShakerSortCommand = function(self)
		if compare(mainarray[index],mainarray[index+1]) == 1 then
			swap(mainarray,index,index+1)
			SWAPS = SWAPS + 1
			WRITES = WRITES + 2
			anyswaps = true
		end
		COMPS = COMPS + 1
		self:sleep(0.0025)
		index = index + way
		if way == 1 and index == right then
			right = right - 1
			index = right
			way = way * -1
			if anyswaps == false then
				right = left
			end
			anyswaps = false
		end
		if way == -1 and index == left then
			left = left + 1
			index = left
			way = way * -1
			if anyswaps == false then
				left = right
			end
			anyswaps = false
		end
		if left < right then
			SCREENMAN:SystemMessage("Cocktail Shaker Sort: "..COMPS.." Comparisons, "..SWAPS.." Swaps, "..WRITES.. " Writes")
			self:queuecommand("CocktailShakerSort")
		else
			self:queuecommand("Complete")
		end
	end,
	OddEvenSortCommand = function(self)
		if compare(mainarray[index],mainarray[index+1]) == 1 then
			swap(mainarray,index,index+1)
			SWAPS = SWAPS + 1
			WRITES = WRITES + 2
			anyswaps = true
		end
		COMPS = COMPS + 1
		self:sleep(0.0025)
		index = index + 2
		if index + 1 > #mainarray then
			if way == 1 then
				index = 2
			end
			if way == -1 then
				index = 1
				if anyswaps == false then
					testpass = true
				end
				anyswaps = false
			end
			way = way * -1
		end
		if testpass == false then
			SCREENMAN:SystemMessage("Odd-Even Sort: "..COMPS.." Comparisons, "..SWAPS.." Swaps, "..WRITES.. " Writes")
			self:queuecommand("OddEvenSort")
		else
			self:queuecommand("Complete")
		end
	end,
	GnomeSortCommand = function(self)
		if compare(mainarray[index],mainarray[index+1]) == 1 then
			swap(mainarray,index,index+1)
			SWAPS = SWAPS + 1
			WRITES = WRITES + 2
			anyswaps = true
		end
		COMPS = COMPS + 1
		self:sleep(0.0025)
		if anyswaps == false then
			startfromleft = startfromleft + 1
			index = startfromleft
		else
			if index > 1 then
				index = index - 1
			else
				startfromleft = startfromleft + 1
				index = startfromleft
			end
			anyswaps = false
		end
		if startfromleft < #mainarray then
			SCREENMAN:SystemMessage("Gnome Sort: "..COMPS.." Comparisons, "..SWAPS.." Swaps, "..WRITES.. " Writes")
			self:queuecommand("GnomeSort")
		else
			self:queuecommand("Complete")
		end
	end,
	ClamberSortCommand = function(self)
		if index > 1 then
			if compare(mainarray[startfromleft],mainarray[index]) == 1 then
				swap(mainarray,startfromleft,index)
				SWAPS = SWAPS + 1
				WRITES = WRITES + 2
			end
			COMPS = COMPS + 1
		end
		self:sleep(0.0025)
		startfromleft = startfromleft + 1
		if startfromleft >= index then
			index = index + 1
			startfromleft = 1
		else
		end
		if index <= #mainarray then
			SCREENMAN:SystemMessage("Clamber Sort: "..COMPS.." Comparisons, "..SWAPS.." Swaps, "..WRITES.. " Writes")
			self:queuecommand("ClamberSort")
		else
			self:queuecommand("Complete")
		end
	end,
	CompleteCommand = function(self)
		SCREENMAN:SystemMessage("Sorting complete: "..COMPS.." Comparisons, "..SWAPS.." Swaps, "..WRITES.. " Writes")
		currentalgo = currentalgo + 1
		self:sleep(1.5):queuecommand("WaitBeforeShuffle")
	end,
	WaitBeforeShuffleCommand = function(self)
		MESSAGEMAN:Broadcast("DoShuffle")
	end
}
for renderindex = 1,#mainarray do
	t[#t+1] = Def.Quad{
		OnCommand = function(self)
			self:valign(1):xy(SCREEN_CENTER_X+arrayscale*8*(renderindex-(#mainarray/2)),SCREEN_BOTTOM):setsize(arrayscale*6,mainarray[renderindex]*arrayscale*5):diffuse(Color.White):queuecommand("Update")
		end,
		UpdateCommand = function(self)
			self:setsize(arrayscale*6,mainarray[renderindex]*arrayscale*5):sleep(0.01):queuecommand("Update")
		end
	}
end
t[#t+1] = Def.Actor{
	DoShuffleMessageCommand = function(self)
		COMPS = 0
		SWAPS = 0
		WRITES = 0
		shuffleindex = 1
		self:sleep(1):queuecommand("Shuffle")
	end,
	ShuffleCommand = function(self)
		if shuffleindex <= #mainarray then
			swap(mainarray,shuffleindex,math.random(shuffleindex,#mainarray))
			shuffleindex = shuffleindex + 1
		end
		self:sleep(delay)
		if shuffleindex <= #mainarray then
			self:queuecommand("Shuffle")
		else
			self:sleep(1.5)
			self:queuecommand("WaitBeforeSort")
		end
	end,
	WaitBeforeSortCommand = function(self)
		MESSAGEMAN:Broadcast("SortRun")
	end
}
t[#t+1] = Def.Actor{
	OnCommand = function(self)
		self:sleep(math.huge)
	end
}
return t