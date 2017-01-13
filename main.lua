local crackedDiceMod = RegisterMod("Cracked Dice", 1);
local game = Game();

function string:split(sSeparator, nMax, bRegexp)
	assert(sSeparator ~= '')
	assert(nMax == nil or nMax >= 1)

	local aRecord = {}

	if self:len() > 0 then
		local bPlain = not bRegexp
		nMax = nMax or -1

		local nField, nStart = 1, 1
		local nFirst,nLast = self:find(sSeparator, nStart, bPlain)
		while nFirst and nMax ~= 0 do
			aRecord[nField] = self:sub(nStart, nFirst-1)
			nField = nField+1
			nStart = nLast+1
			nFirst,nLast = self:find(sSeparator, nStart, bPlain)
			nMax = nMax-1
		end
		aRecord[nField] = self:sub(nStart)
	end

	return aRecord
end


------ to do
-- other dice


--[[New Run--]]
function crackedDiceMod:newRun(player)
  
  local level = game:GetLevel()
  local RNG = player:GetDropRNG()
  
  if Isaac.HasModData(crackedDiceMod) == true then
    
    local loadString = Isaac.LoadModData(crackedDiceMod)
    local loadData = string.split(loadString, "@")
    local loadedSeed = tonumber(loadData[2])
    local loadedDiceCollected = tonumber(loadData[1])
    local thisSeed = RNG:GetSeed()
    
    Isaac.DebugString("---/n/n/n/n/n/n/n----/n/n/n/n/n/----/n")
    Isaac.DebugString(loadedDiceCollected)
    Isaac.DebugString(thisSeed)
    Isaac.DebugString(loadedSeed)
    Isaac.DebugString("---/n/n/n/n/n/n/n----/n/n/n/n/n/----/n")
    Isaac.DebugString(tostring(thisSeed == loadedSeed))
    
    
    if thisSeed == loadedSeed then
      
      Isaac.DebugString(tostring(loadedDiceCollected >= 3))
      
      diceCollected = loadedDiceCollected
      
      if loadedDiceCollected >= 3 then
        DMTransform = true
      else
        DMTransform = false
      end
      
    else
      Isaac.RemoveModData(crackedDiceMod)
      diceCollected = 0
      DMTransform = false
    end
    
  else
    
    diceCollected = 0
    DMTransform = false
  
  end
end



---- transformation cache function
function crackedDiceMod:cacheUpdate(player, cacheFlag)
  if cacheFlag == CacheFlag.CACHE_LUCK then
    if DMTransform == true then
      player.Luck = player.Luck + 5
    --else 
    --  player.Luck = player.Luck
    end
  end
end


-----------------------------
-- get ids for all dice items
-----------------------------

-- our mod
local crackedD4 = Isaac.GetItemIdByName("Cracked D4");
local crackedD6 = Isaac.GetItemIdByName("Cracked D6");
local crackedD7 = Isaac.GetItemIdByName("Cracked D7");
local crackedD8 = Isaac.GetItemIdByName("Cracked D8");
local crackedD20 = Isaac.GetItemIdByName("Cracked D20");


-- norms
local dinfinity = Isaac.GetItemIdByName("D infinity")
local d1 = Isaac.GetItemIdByName("D1")
local d10 = Isaac.GetItemIdByName("D10")
local d12 = Isaac.GetItemIdByName("D12")
local d100 = Isaac.GetItemIdByName("D100")
local d20 = Isaac.GetItemIdByName("D20")
local d4 = Isaac.GetItemIdByName("D4")
local d6 = Isaac.GetItemIdByName("The D6")
local d7 = Isaac.GetItemIdByName("D7")
local d8 = Isaac.GetItemIdByName("D8")





----------------------------------------
-- spawn items for start rooms and debug
----------------------------------------

function crackedDiceMod:spawnItem()

    local level = game:GetLevel()
    local player = Isaac.GetPlayer(0)
    local character = player:GetPlayerType()
    local lostID = PlayerType.PLAYER_THELOST
    
    local pos = Isaac.GetFreeNearPosition(player.Position, 80) -- Find an empty space near the player
    
    if level:GetAbsoluteStage() == 1 and level.EnterDoor == -1 and player.FrameCount == 1 and character == lostID then                      -- Only if on the first floor and only on the first frame           
        --Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_COLLECTIBLE, crackedD4, pos, Vector(0,0), player)     -- Spawn an item pedestal with the correct item in the spot from earlier
        
        player:RemoveCollectible(CollectibleType.COLLECTIBLE_D4)
        player:AddCollectible(crackedD4, 3, false)
        
        --debug
        pos = Isaac.GetFreeNearPosition(player.Position, 80)
        Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_COLLECTIBLE, crackedD6, pos, Vector(0,0), player)
        pos = Isaac.GetFreeNearPosition(player.Position, 80)
        Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_COLLECTIBLE, crackedD7, pos, Vector(0,0), player)
        pos = Isaac.GetFreeNearPosition(player.Position, 80)
        Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_COLLECTIBLE, crackedD8, pos, Vector(0,0), player)
        pos = Isaac.GetFreeNearPosition(player.Position, 80)
        Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_COLLECTIBLE, crackedD20, pos, Vector(0,0), player)
        
        
        
    end
end





-------------------------
-- check dice items for transformations
-------------------------
function crackedDiceMod:transform()
  
  local player = Isaac.GetPlayer(0)
  local RNG = player:GetDropRNG()
  local level = game:GetLevel()
  
  -- at start of the game assign all the tracking variables
  if level:GetAbsoluteStage() == 1 and level.EnterDoor == -1 and player.FrameCount == 1 then
    
    -- our mod
    crackedD4Collected = false
    crackedD6Collected = false
    crackedD7Collected = false
    crackedD8Collected = false
    crackedD20Collected = false

    -- norms
    dinfinityCollected = false
    d1Collected = false
    d10Collected = false
    d12Collected = false
    d100Collected = false
    d20Collected = false
    d4Collected = false
    d6Collected = false
    d7Collected = false
    d8Collected = false
    
    -- need to remove these when loading is working correctly
    --diceCollected = 0
    --DMTransform = false
    
    -- debug
    --Isaac.Spawn(5, 100, d100, Vector(200, 200), Vector(0,0), player)
    --Isaac.Spawn(5, 100, d20, Vector(300, 200), Vector(0,0), player)
    --Isaac.Spawn(5, 100, d8, Vector(400, 200), Vector(0,0), player)
  
    player:AddCacheFlags(CacheFlag.CACHE_LUCK)
    player:EvaluateItems()
  
  end

  -----------------------------
  -- check for each of the dice
  -----------------------------
  --- mod dice
  
  if crackedD4Collected == false then
    if player:HasCollectible(crackedD4) then
        crackedD4Collected = true
        diceCollected = diceCollected + 1
    end
  end
  
  if crackedD6Collected == false then
    if player:HasCollectible(crackedD6) then
        crackedD6Collected = true
        diceCollected = diceCollected + 1
    end
  end
  
  if crackedD7Collected == false then
    if player:HasCollectible(crackedD7) then
        crackedD7Collected = true
        diceCollected = diceCollected + 1
    end
  end
  
  if crackedD8Collected == false then
    if player:HasCollectible(crackedD8) then
        crackedD8Collected = true
        diceCollected = diceCollected + 1
    end
  end
  
  if crackedD20Collected == false then
    if player:HasCollectible(crackedD20) then
        crackedD20Collected = true
        diceCollected = diceCollected + 1
    end
  end

  --- non-mod norm dice
  
  if dinfinityCollected == false then
    if player:HasCollectible(dinfinity) then
        dinfinityCollected = true
        diceCollected = diceCollected + 1
    end
  end
  
  if d1Collected == false then
    if player:HasCollectible(d1) then
        d1Collected = true
        diceCollected = diceCollected + 1
    end
  end
  
  if d10Collected == false then
    if player:HasCollectible(d10) then
        d10Collected = true
        diceCollected = diceCollected + 1
    end
  end
  
  if d12Collected == false then
    if player:HasCollectible(d12) then
        d12Collected = true
        diceCollected = diceCollected + 1
    end
  end
  
  if d100Collected == false then
    if player:HasCollectible(d100) then
        d100Collected = true
        diceCollected = diceCollected + 1
    end
  end
  
  if d20Collected == false then
    if player:HasCollectible(d20) then
        d20Collected = true
        diceCollected = diceCollected + 1
    end
  end
  
  if d4Collected == false then
    if player:HasCollectible(d4) then
        d4Collected = true
        diceCollected = diceCollected + 1
    end
  end
  
  
  if d6Collected == false then
    if player:HasCollectible(d6) then
        d6Collected = true
        diceCollected = diceCollected + 1
    end
  end
  
  if d7Collected == false then
    if player:HasCollectible(d7) then
        d7Collected = true
        diceCollected = diceCollected + 1
    end
  end
  
  if d8Collected == false then
    if player:HasCollectible(d8) then
        d8Collected = true
        diceCollected = diceCollected + 1
    end
  end
 
  -- 		     Transform!
  if diceCollected >= 3 and DMTransform == false then
    Isaac.DebugString("yes made it here")
    DMTransform = true
    player:AddCacheFlags(CacheFlag.CACHE_LUCK)
    player:AnimateHappy()
    player:EvaluateItems()
  else
    Isaac.SaveModData(crackedDiceMod, tostring(diceCollected) .. "@" .. tostring(RNG:GetSeed()))
  end
  
  if DMTransform == true then
    player:GetEffects():AddCollectibleEffect(CollectibleType.COLLECTIBLE_MIND, true)
    level:RemoveCurse(LevelCurse.CURSE_OF_BLIND)
    level:RemoveCurse(LevelCurse.CURSE_OF_THE_LOST)
    level:RemoveCurse(LevelCurse.CURSE_OF_THE_UNKNOWN)
    level:ApplyMapEffect()
    level:ApplyCompassEffect()
    level:ApplyBlueMapEffect()
    Isaac.SaveModData(crackedDiceMod, tostring(diceCollected) .. "@" .. tostring(RNG:GetSeed()))
  end



end
--------------------------
-- cracked D4 use function
--------------------------

function crackedDiceMod:D4reroll()
  
  local player = Isaac.GetPlayer(0)
  local collectibles = {}
  local other_collectibles = {}
  local RNG = player:GetDropRNG()
  
  
  for i=1, CollectibleType.NUM_COLLECTIBLES do 
    --Iterate over all collectibles to see if the player has it, as far as I know you can't get the current collectible list
    if player:HasCollectible(i) and i ~= crackedD4 then --If they have it add it to the table
      table.insert(collectibles, i)
    else
      table.insert(other_collectibles, i)
    end
  end
 
  
  if #collectibles >= 1 then --If the player has collectibles
    
    local itemRemove = collectibles[(RNG:RandomInt(#collectibles) + 1)]
    local itemAdd = other_collectibles[(RNG:RandomInt(#other_collectibles) + 1)]

    --Isaac.DebugString("Removing item: " .. itemRemove)
    --Isaac.DebugString("Adding item: " .. itemAdd)
    
    
    -- remove a random item
    while player:HasCollectible(itemRemove) do
      player:RemoveCollectible(itemRemove) --Randomly select a collectible from the table and remove it
      player:FlushQueueItem()
    end
    
    player:AddCollectible(itemAdd, 0, false) -- add a new item
    -- need to check that the item is added correctly. Some items (like 61) fail to add, stating a config error.
    while player:HasCollectible(itemAdd) == false do
      itemAdd = other_collectibles[(RNG:RandomInt(#other_collectibles) + 1)]
      player:AddCollectible(itemAdd, 0, false) -- add a new item
      player:FlushQueueItem()
    end
    

    -- create recursive function to ensure active items are not added
    
    function activeItemiIsCrackedD4(active)
      
      if active == crackedD4 then
        return true
      
      else
        player:RemoveCollectible(active)
        player:AddCollectible(crackedD4, 0, false)
        itemAdd = other_collectibles[(RNG:RandomInt(#other_collectibles) + 1)]
        player:AddCollectible(itemAdd, 0, false) -- add a new item
        while player:HasCollectible(itemAdd) == false do
          itemAdd = other_collectibles[(RNG:RandomInt(#other_collectibles) + 1)]
          player:AddCollectible(itemAdd, 0, false) -- add a new item
          player:FlushQueueItem()
        end
        return activeItemiIsCrackedD4(player:GetActiveItem())
      
      end
    
    end
    
    -- call the checker function
    activeItemiIsCrackedD4(player:GetActiveItem())
        
  end
  
  player:EvaluateItems()
  return true

end

--------------------------
-- cracked D6 use function
--------------------------
function crackedDiceMod:D6reroll()
  -- game:GetFrameCount()
  -- And I assume to make it do something when the frame count hits 60 seconds you can do:
    --if Game:GetFrameCount() % 1800 then
  -- 60 frames is one second
  -- every 20 frames add a charge, at 120 reroll
  -- good 75% bad 25%
  -- if good, reroll item, start charge chain again
    -- interrupt charge cycle if no item pedestals left
    -- no charge if leave the room
  -- if bad, delete item pedestal, no recharge
  
  function rerollFunc(entities, player, RNG, collectibles, other_collectibles)
  
    local startFrame = game:GetFrameCount()
    Isaac.DebugString(startFrame)
    
    -- check if item pedestals remain in the room
    local itemCheck = false
    for i = 1, #entities do
      if entities[i].Variant == PickupVariant.PICKUP_COLLECTIBLE then
        itemCheck = true
      end
    end
    
    Isaac.DebugString(tostring(itemCheck))
    if itemCheck == true then
      
      -- do the reroll
      for i=1, CollectibleType.NUM_COLLECTIBLES do 
        --Iterate over all collectibles to see if the player has it, as far as I know you can't get the current collectible list
        if player:HasCollectible(i) then --If they have it add it to the table
          table.insert(collectibles, i)
        else
          table.insert(other_collectibles, i)
        end
      end
      
      -- spawn new item
      for i = 1, #entities do
        if entities[i].Variant == PickupVariant.PICKUP_COLLECTIBLE then
          local rerollChance = RNG:RandomInt(4)
          local itemNew = other_collectibles[(RNG:RandomInt(#other_collectibles) + 1)]
          local pedPos = entities[i].Position
          entities[i]:Remove()
          if rerollChance > 0 then
            Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_COLLECTIBLE, itemNew, pedPos, Vector(0.0, 0.0), player);
          end
        end
      end
      
      local newEntities = Isaac.GetRoomEntities();
      
      --wait before rerolling
      --local currentFrame = game:GetFrameCount()
      --while currentFrame - startFrame < 120 do
      --  currentFrame = game:GetFrameCount()
      --  Isaac.DebugString(currentFrame)
      --end
      
      if newEntities == entities then
        return true
      else
        return rerollFunc(newEntities, player, RNG, collectibles, other_collectibles)
      end
      
    else
      -- no items left
      return true
    
    end
    
  end
  
  local entities = Isaac.GetRoomEntities();
  local player = Isaac.GetPlayer(0)
  local RNG = player:GetDropRNG()
  local collectibles = {}
  local other_collectibles = {}
  
  
  return rerollFunc(entities, player, RNG, collectibles, other_collectibles)
  
  
  -- wait 2 sec
  --    local currentFrame = game:GetFrameCount()
   --   while currentFrame - startFrame < 120 do
   --     currentFrame = game:GetFrameCount()
   --   end
      
      -- go again

end

--------------------------
-- cracked D7 use function
--------------------------
function crackedDiceMod:D7reroll()
  -- RespawnEnemies()
end

--------------------------
-- cracked D8 use function
--------------------------
function crackedDiceMod:D8reroll()
end

--------------------------
-- cracked D20 use function
--------------------------
function crackedDiceMod:D20reroll()
end





------------
-- callbacks
------------

crackedDiceMod:AddCallback(ModCallbacks.MC_POST_PLAYER_INIT, crackedDiceMod.newRun)
crackedDiceMod:AddCallback(ModCallbacks.MC_USE_ITEM, crackedDiceMod.D4reroll, crackedD4);
crackedDiceMod:AddCallback(ModCallbacks.MC_USE_ITEM, crackedDiceMod.D6reroll, crackedD6);
crackedDiceMod:AddCallback(ModCallbacks.MC_USE_ITEM, crackedDiceMod.D7reroll, crackedD7);
crackedDiceMod:AddCallback(ModCallbacks.MC_USE_ITEM, crackedDiceMod.D8reroll, crackedD8);
crackedDiceMod:AddCallback(ModCallbacks.MC_USE_ITEM, crackedDiceMod.D20reroll, crackedD20);
crackedDiceMod:AddCallback(ModCallbacks.MC_POST_UPDATE, crackedDiceMod.spawnItem)
crackedDiceMod:AddCallback(ModCallbacks.MC_POST_UPDATE, crackedDiceMod.transform)
crackedDiceMod:AddCallback(ModCallbacks.MC_EVALUATE_CACHE, crackedDiceMod.cacheUpdate );
