local crackedDiceMod = RegisterMod("Cracked Dice", 1);
local game = Game();
local DMcostume = Isaac.GetCostumeIdByPath("gfx/characters/DMcostume.anm2")


local timer = -1
--local d8Applied = true
--local firstTimeDamage = true
--local firstTimeSpeed = true
--local firstTimeLuck = true
--local firstTimeDelay = true

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



function crackedDiceMod:save()
  
  local player = Isaac.GetPlayer(0)
  local seed = player.DropSeed
  --old one with d8stats 
  --Isaac.SaveModData(crackedDiceMod,    tostring(diceCollected) .. "@" .. tostring(seed) .. "@||"  .. "damage@" .. tostring(d8Stats[CacheFlag.CACHE_DAMAGE]) .. "@speed@" .. tostring(d8Stats[CacheFlag.CACHE_SPEED]) .. "@luck@" .. tostring(d8Stats[CacheFlag.CACHE_LUCK]) .. "@delay@" .. tostring(d8Stats[CacheFlag.CACHE_FIREDELAY])     )
  
  Isaac.SaveModData(crackedDiceMod,    tostring(diceCollected) .. "@" .. tostring(seed))
end





function crackedDiceMod:timer()
  
  local player = Isaac.GetPlayer(0)
  local crackedD6 = Isaac.GetItemIdByName("Cracked D6");

	if Game():GetFrameCount() % 7 == 0 and timer > 0 then
		player:SetActiveCharge(6 - timer)
    timer = timer - 1
	end
	if timer == 0 then
  
    player:SetActiveCharge(6 - timer)
    timer = -1
    crackedDiceMod:D6reroll()
    player:DischargeActiveItem()
	
  end
end



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
  local seed = player.DropSeed
  
  if Isaac.HasModData(crackedDiceMod) == true then
    
    local loadString = Isaac.LoadModData(crackedDiceMod)
    local loadData = string.split(loadString, "@")
    
    --for k,v in pairs(loadData) do
    --  Isaac.DebugString(v)
    --end
    
    local loadedSeed = tonumber(loadData[2])
    local loadedDiceCollected = tonumber(loadData[1])
    
    --Isaac.DebugString(tostring(seed))
    --Isaac.DebugString(tostring(loadedSeed))
    --Isaac.DebugString(tostring(seed == loadedSeed))
    
    
    if seed == loadedSeed then
      
      --Isaac.DebugString(tostring(loadedDiceCollected >= 3))
      
      diceCollected = loadedDiceCollected
      
      if loadedDiceCollected >= 3 then
        DMTransform = true
      else
        DMTransform = false
      end
      
      
      
      --local d8Data = string.split(loadString, "||")[2]
      --local d8StatData = string.split(d8Data, "@")
      --Isaac.DebugString(d8Data)
          -- needed in scope for D8 and cache update      
      --for k,v in pairs(d8StatData) do
      --  Isaac.DebugString(v)
      --end
      
      --d8Stats = {
      --    [CacheFlag.CACHE_DAMAGE] = tonumber(d8StatData[2]), 
      --    [CacheFlag.CACHE_LUCK] = tonumber(d8StatData[6]), 
      --    --[CacheFlag.CACHE_FIREDELAY] = tonumber(d8StatData[8]), 
      --    [CacheFlag.CACHE_SPEED] = tonumber(d8StatData[4])
      -- }

    
    else
      
      Isaac.RemoveModData(crackedDiceMod)
      diceCollected = 0
      DMTransform = false
      
      -- needed in scope for D8 and cache update
      --d8Stats = {
       --   [CacheFlag.CACHE_DAMAGE] = 0.0, 
       --   [CacheFlag.CACHE_LUCK] = 0.0, 
       --   --[CacheFlag.CACHE_FIREDELAY] = 0, 
       --   [CacheFlag.CACHE_SPEED] = 0.0
      --}

    end
    
  else
    
    diceCollected = 0
    DMTransform = false
    
    -- needed in scope for D8 and cache update
    
    --d8Stats = {
    --    [CacheFlag.CACHE_DAMAGE] = 0.0, 
    --    [CacheFlag.CACHE_LUCK] = 0.0, 
     --   --[CacheFlag.CACHE_FIREDELAY] = 0, 
     --   [CacheFlag.CACHE_SPEED] = 0.0
     -- }
  
  end



  --firstTimeDamage = true
  --firstTimeSpeed = true
  --firstTimeLuck = true
  --firstTimeDelay = true
  --d8Applied = false
  --player:AddCacheFlags(CacheFlag.CACHE_DAMAGE)
  --player:EvaluateItems()
  --player:AddCacheFlags(CacheFlag.CACHE_LUCK)
  --player:EvaluateItems()
  --player:AddCacheFlags(CacheFlag.CACHE_FIREDELAY)
  --player:EvaluateItems()
  --player:AddCacheFlags(CacheFlag.CACHE_SPEED)
  --player:EvaluateItems()
  --d8Applied = true

end



---- transformation cache function
function crackedDiceMod:cacheUpdate(player, cacheFlag)

  --Isaac.DebugString("---------------------yes1--------------------")
  --Isaac.DebugString(tostring(d8Applied))
  --Isaac.DebugString(cacheFlag)
  
  -- cracked D8 stat changes
  -- deleted or firstTimeDelay == true
  --if d8Applied == false or firstTimeDamage == true or firstTimeLuck == true or firstTimeSpeed == true then
    --if cacheFlag == CacheFlag.CACHE_DAMAGE then
    --      Isaac.DebugString("---------------------yes3--------------------")
    --      Isaac.DebugString(player.Damage)
    --      player.Damage = player.Damage + d8Stats[CacheFlag.CACHE_DAMAGE]
    --      Isaac.DebugString(d8Stats[CacheFlag.CACHE_DAMAGE])
    --      Isaac.DebugString(player.Damage)
    --      firstTimeDamage = false
    --end
    
   -- if cacheFlag == CacheFlag.CACHE_LUCK then
   --       player.Luck = player.Luck + d8Stats[CacheFlag.CACHE_LUCK]
   --       firstTimeLuck = false
   -- end
    
    --if cacheFlag == CacheFlag.CACHE_FIREDELAY then
    --      -- broken for now
    --      --player.MaxFireDelay = player.MaxFireDelay - d8Stats[CacheFlag.CACHE_FIREDELAY]
    --      d8TearDelay = player.MaxFireDelay + d8Stats[CacheFlag.CACHE_FIREDELAY]
    --      firstTimeDelay = false
    --end
    
   -- if cacheFlag == CacheFlag.CACHE_SPEED then
   --       player.MoveSpeed = player.MoveSpeed + d8Stats[CacheFlag.CACHE_SPEED]
   --       firstTimeSpeed = false
   -- end
        
  --end
  

  
  -- transformation
  if cacheFlag == CacheFlag.CACHE_LUCK then
    if DMTransform == true then
      player.Luck = player.Luck + 5
    --else 
    --  player.Luck = player.Luck
    end
  end

end




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
        
        if player:GetActiveItem() == CollectibleType.COLLECTIBLE_D4 then
          player:RemoveCollectible(CollectibleType.COLLECTIBLE_D4)
          player:AddCollectible(crackedD4, 3, false)
        end
        
        --debug
        --pos = Isaac.GetFreeNearPosition(player.Position, 80)
        --Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_COLLECTIBLE, crackedD6, pos, Vector(0,0), player)
        --pos = Isaac.GetFreeNearPosition(player.Position, 80)
        --Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_COLLECTIBLE, crackedD7, pos, Vector(0,0), player)
        --pos = Isaac.GetFreeNearPosition(player.Position, 80)
        --Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_COLLECTIBLE, crackedD8, pos, Vector(0,0), player)
        --pos = Isaac.GetFreeNearPosition(player.Position, 80)
        --Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_COLLECTIBLE, crackedD20, pos, Vector(0,0), player)
        
        
        
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
  
    --player:AddCacheFlags(CacheFlag.CACHE_LUCK)
    --player:EvaluateItems()
  
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
    player:AddNullCostume(DMcostume)
  end
  
  if DMTransform == true then
    --player:GetEffects():AddCollectibleEffect(CollectibleType.COLLECTIBLE_MIND, true)
    level:RemoveCurse(LevelCurse.CURSE_OF_BLIND)
    level:RemoveCurse(LevelCurse.CURSE_OF_THE_LOST)
    level:RemoveCurse(LevelCurse.CURSE_OF_THE_UNKNOWN)
    level:ApplyMapEffect()
    level:ApplyCompassEffect()
    level:ApplyBlueMapEffect()
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
  timer = -1
  return true

end

--------------------------
-- cracked D6 use function
--------------------------
function crackedDiceMod:D6reroll()
  
  local entities = Isaac.GetRoomEntities();
  local player = Isaac.GetPlayer(0)
  local RNG = player:GetDropRNG()
  local collectSeed = RNG:GetSeed()
  local room = game:GetRoom()
  local collectibles = {}
  local other_collectibles = {}

  -- check if item pedestals remain in the room
  local itemCheck = 0
  for i = 1, #entities do
    if entities[i].Variant == PickupVariant.PICKUP_COLLECTIBLE then
      itemPed = entities[i]:ToPickup()
      if itemPed.SubType ~= 0 and itemPed.SubType ~= crackedD6 then
        itemCheck = itemCheck + 1
      end
    end
  end
  
  Isaac.DebugString(tostring(itemCheck))
  if itemCheck > 0 then
    
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
        local itemPed = entities[i]:ToPickup()
        
        -- if not a shop item
        if itemPed:IsShopItem() == false then
          if itemPed.SubType ~= 0 and itemPed.SubType ~= crackedD6 then
            -- odds for getting poop
            local rerollChance = RNG:RandomInt(4)
            --local itemNew = other_collectibles[(RNG:RandomInt(#other_collectibles) + 1)]
            local itemNew = room:GetSeededCollectible(collectSeed)
            local pedPos = entities[i].Position
      
            if rerollChance > 0 then
              itemPed:Morph(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_COLLECTIBLE, itemNew, false);
            else
              --player:AnimateSad()
              -- spawn a poop
              entities[i]:Remove()
              Isaac.Spawn(EntityType.ENTITY_POOP,0,0, pedPos, Vector(0.0, 0.0), player);
              -- if last item don't reroll
              if itemCheck == 1 then
                player:AnimateSad()
                return true
              end
            end
          end
          
        else
          --Isaac.DebugString("We got a shop item here!")
          -- it is a shop item
          -- odds for getting poop
          local rerollChance = RNG:RandomInt(4)
          --local itemNew = other_collectibles[(RNG:RandomInt(#other_collectibles) + 1)]
          local itemNew = room:GetSeededCollectible(collectSeed)
          local pedPos = entities[i].Position
          
          if rerollChance > 0 then
            itemPed:Morph(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_COLLECTIBLE, itemNew, true);
          else
            --player:AnimateSad()
            -- spawn a poop
            entities[i]:Remove()
            Isaac.Spawn(EntityType.ENTITY_POOP,0,0, pedPos, Vector(0.0, 0.0), player);
            -- if last item don't reroll
            if itemCheck == 1 then
              player:AnimateSad()
              return true
            end
          end
          
        end
      end
    end
    
    -- timer that controls rate of recharging EACH INT IS 7 frames
    timer = 6
  end

  return true

end

--------------------------
-- cracked D7 use function
--------------------------
function crackedDiceMod:D7reroll()
  
  local player = Isaac.GetPlayer(0)
  local room = game:GetRoom()
  --local seed = room:GetSpawnSeed()
  
  if room:IsClear() then
    
    room:RespawnEnemies()
    room:SetAmbushDone(false)
    
    local entities = Isaac.GetRoomEntities();
    local livingEnemies = 0
    
    for i = 1, #entities do
    
      if entities[i]:IsActiveEnemy() == true then
        local enemy = entities[i]:ToNPC()
        local pos = Isaac.GetFreeNearPosition(enemy.Position, 80)
        
        if enemy:IsChampion() == false then
          enemy:MakeChampion(math.random(1000,1000000))
        end
        
        -- create a new enemy
        local newEnemy = Isaac.Spawn(enemy.Type, enemy.Variant, enemy.SubType, pos, Vector(0.0, 0.0), player)
        
        --make NPC type
        newEnemy = newEnemy:ToNPC()
        
        if newEnemy:IsChampion() == false then
          newEnemy:MakeChampion(math.random(1000,1000000))
        end
        
        
        -- track how many enemies there are
        livingEnemies = livingEnemies + 1
      
      end
    
    end
  
    
    if livingEnemies > 0 then
      local i = 0
      while i < livingEnemies do
        room:SpawnClearAward()
        i = i + 1
      end
    else
      player:AnimateSad()
    end
   
  else
    
    player:AnimateSad()
    
  end
  
  return true
  
  
end

--------------------------
-- cracked D8 use function
--------------------------
function crackedDiceMod:D8reroll()
  
  local player = Isaac.GetPlayer(0)
  --local RNG = RNG()
  --RNG:SetSeed(seed, 0)
  
  --local statChoice = {
  --  [0] = CacheFlag.CACHE_DAMAGE, 
  --  [1] = CacheFlag.CACHE_LUCK, 
    --[3] = CacheFlag.CACHE_FIREDELAY, 
  --  [2] = CacheFlag.CACHE_SPEED
  --}
  --local statVals = {
  --  [CacheFlag.CACHE_DAMAGE] = 1.5, 
   -- [CacheFlag.CACHE_LUCK] = 1.0, 
    --[CacheFlag.CACHE_FIREDELAY] = -1, 
   -- [CacheFlag.CACHE_SPEED] = 0.2
 -- }
  
  local d8Direc = math.random(0,1)
  -- only three options currently becuase teardelay is bugged
  --local choiceFlag = statChoice[math.random(0,3)]
  local pillChoice = math.random(0,3)
  --local d8Value = statVals[choiceFlag]
  --d8Applied = false
  
  Isaac.DebugString(d8Direc)
  Isaac.DebugString(pillChoice)
  
  
  -- PillEffect.PILLEFFECT_HEALTH_DOWN 
  -- PILLEFFECT_HEALTH_UP
  
  -- PILLEFFECT_RANGE_DOWN 
  -- PILLEFFECT_RANGE_UP 0
  
  -- PILLEFFECT_SPEED_DOWN 
  -- PILLEFFECT_SPEED_UP 1
  
  -- PILLEFFECT_TEARS_DOWN 
  -- PILLEFFECT_TEARS_UP 2
  
  -- PILLEFFECT_LUCK_DOWN 
  -- PILLEFFECT_LUCK_UP 3
  

  if d8Direc == 0 then
    player:AnimateHappy()
    
    if pillChoice == 0 then
      player:UsePill(PillEffect.PILLEFFECT_RANGE_UP, PillColor.PILL_NULL)
    elseif pillChoice == 1 then
      player:UsePill(PillEffect.PILLEFFECT_SPEED_UP, PillColor.PILL_NULL)
    elseif pillChoice == 2 then
       player:UsePill(PillEffect.PILLEFFECT_TEARS_UP, PillColor.PILL_NULL)
    elseif pillChoice == 3 then
      player:UsePill(PillEffect.PILLEFFECT_LUCK_UP, PillColor.PILL_NULL)
    end
    
    --d8Stats[choiceFlag] = d8Stats[choiceFlag] + d8Value
    --player:AddCacheFlags(choiceFlag)
    --player:EvaluateItems()
    --d8Applied = true
  else
    player:AnimateSad()
    
    if pillChoice == 0 then
      player:UsePill(PillEffect.PILLEFFECT_RANGE_DOWN, PillColor.PILL_NULL)
    elseif pillChoice == 1 then
      player:UsePill(PillEffect.PILLEFFECT_SPEED_DOWN, PillColor.PILL_NULL)
    elseif pillChoice == 2 then
       player:UsePill(PillEffect.PILLEFFECT_TEARS_DOWN, PillColor.PILL_NULL)
    elseif pillChoice == 3 then
      player:UsePill(PillEffect.PILLEFFECT_LUCK_DOWN, PillColor.PILL_NULL)
    end
    
    --d8Stats[choiceFlag] = d8Stats[choiceFlag] - d8Value
    --player:AddCacheFlags(choiceFlag)
    --player:EvaluateItems()
    --d8Applied = true
  end

  return true
  
  
  
end

--------------------------
-- cracked D20 use function
--------------------------
function crackedDiceMod:D20reroll()
  
  local entities = Isaac.GetRoomEntities();
  local player = Isaac.GetPlayer(0)
  local RNG = player:GetDropRNG()
  local room = game:GetRoom()
  local pickups = {}

  local createSeed = RNG:RandomInt(47)
  local createType = PickupVariant.PICKUP_HEART
  
  if createSeed >= 0 and createSeed < 6 then
    createType = PickupVariant.PICKUP_HEART
  elseif createSeed >= 6 and createSeed < 12 then
    createType = PickupVariant.PICKUP_COIN
  elseif createSeed >= 12 and createSeed < 18 then
    createType = PickupVariant.PICKUP_KEY
  elseif createSeed >= 18 and createSeed < 24 then
    createType = PickupVariant.PICKUP_BOMB
  elseif createSeed >= 24 and createSeed < 26 then
    createType = PickupVariant.PICKUP_CHEST
  elseif createSeed >= 26 and createSeed < 27 then
    createType = PickupVariant.PICKUP_BOMBCHEST
  elseif createSeed >= 27 and createSeed < 28 then
    createType = PickupVariant.PICKUP_SPIKEDCHEST
  elseif createSeed >= 28 and createSeed < 29 then
    createType = PickupVariant.PICKUP_ETERNALCHEST
  elseif createSeed >= 29 and createSeed < 30 then
    createType = PickupVariant.PICKUP_LOCKEDCHEST
  elseif createSeed >= 30 and createSeed < 34 then
    createType = PickupVariant.PICKUP_PILL
  elseif createSeed >= 34 and createSeed < 39 then
    createType = PickupVariant.PICKUP_LIL_BATTERY
  elseif createSeed >= 39 and createSeed < 43 then
    createType = PickupVariant.PICKUP_TAROTCARD
  elseif createSeed >= 43 and createSeed < 46 then
    createType = PickupVariant.PICKUP_TRINKET
  elseif createSeed >= 46 and createSeed < 47 then
    createType = PickupVariant.PICKUP_REDCHEST
  end  
  
  
  
  
  

  -- check if item pedestals remain in the room
  local itemCheck = 0
  for i = 1, #entities do
    if ( entities[i].Variant == PickupVariant.PICKUP_HEART or
         entities[i].Variant == PickupVariant.PICKUP_COIN  or 
         entities[i].Variant == PickupVariant.PICKUP_KEY  or 
         entities[i].Variant == PickupVariant.PICKUP_BOMB  or 
         entities[i].Variant == PickupVariant.PICKUP_CHEST  or 
         entities[i].Variant == PickupVariant.PICKUP_BOMBCHEST  or 
         entities[i].Variant == PickupVariant.PICKUP_SPIKEDCHEST  or 
         entities[i].Variant == PickupVariant.PICKUP_ETERNALCHEST  or 
         entities[i].Variant == PickupVariant.PICKUP_LOCKEDCHEST  or 
         entities[i].Variant == PickupVariant.PICKUP_PILL   or 
         entities[i].Variant == PickupVariant.PICKUP_LIL_BATTERY 	  or 
         entities[i].Variant == PickupVariant.PICKUP_TAROTCARD   or 
         entities[i].Variant == PickupVariant.PICKUP_TRINKET   or 
         entities[i].Variant == PickupVariant.PICKUP_REDCHEST ) then
      
      pickup = entities[i]:ToPickup()
      table.insert(pickups, pickup)
      itemCheck = itemCheck + 1
    
    end
  end
  
  if itemCheck > 0 then
    -- spawn new item
    for i = 1, #pickups do
        
        local pickup = pickups[i]
        local pickPos = pickup.Position
        
        -- if not a shop item
        if pickup:IsShopItem() == false then
          
          pickup:Remove()
          Isaac.Spawn(EntityType.ENTITY_PICKUP, createType, 0, pickPos, Vector(0.0, 0.0), player);

        end
    end

  end

  return true
  
  
end





------------
-- callbacks
------------

crackedDiceMod:AddCallback(ModCallbacks.MC_POST_PLAYER_INIT, crackedDiceMod.newRun)
crackedDiceMod:AddCallback(ModCallbacks.MC_USE_ITEM, crackedDiceMod.D4reroll, crackedD4);
crackedDiceMod:AddCallback(ModCallbacks.MC_USE_ITEM, crackedDiceMod.D6reroll, crackedD6);
crackedDiceMod:AddCallback(ModCallbacks.MC_POST_UPDATE, crackedDiceMod.timer)
crackedDiceMod:AddCallback(ModCallbacks.MC_USE_ITEM, crackedDiceMod.D7reroll, crackedD7);
crackedDiceMod:AddCallback(ModCallbacks.MC_USE_ITEM, crackedDiceMod.D8reroll, crackedD8);
crackedDiceMod:AddCallback(ModCallbacks.MC_USE_ITEM, crackedDiceMod.D20reroll, crackedD20);
crackedDiceMod:AddCallback(ModCallbacks.MC_POST_UPDATE, crackedDiceMod.spawnItem)
crackedDiceMod:AddCallback(ModCallbacks.MC_POST_UPDATE, crackedDiceMod.transform)
crackedDiceMod:AddCallback(ModCallbacks.MC_EVALUATE_CACHE, crackedDiceMod.cacheUpdate );
crackedDiceMod:AddCallback(ModCallbacks.MC_POST_UPDATE, crackedDiceMod.save)


