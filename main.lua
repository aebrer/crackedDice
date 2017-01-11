local crackedDiceMod = RegisterMod("Cracked Dice", 1);
local game = Game();



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
        Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_COLLECTIBLE, crackedD4, pos, Vector(0,0), player)     -- Spawn an item pedestal with the correct item in the spot from earlier
    end
end





-------------------------
-- check dice items for transformations
-------------------------
function crackedDiceMod:transform()
  
  local player = Isaac.GetPlayer(0)
  local level = game:GetLevel()
  
  -- at start of the game assign all the tracking variables
  if level:GetAbsoluteStage() == 1 and level.EnterDoor == -1 and player.FrameCount == 1 then
    
    -- our mod
    crackedD4Collected = false

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
    
    
    diceCollected = 0
    DMTransform = false
    
    -- debug
    Isaac.Spawn(5, 100, d100, Vector(200, 200), Vector(0,0), player)
    --Isaac.Spawn(5, 100, d20, Vector(300, 200), Vector(0,0), player)
    --Isaac.Spawn(5, 100, d8, Vector(400, 200), Vector(0,0), player)
  
    player:AddCacheFlags(CacheFlag.CACHE_LUCK)
    player:EvaluateItems()
  
  end

  -----------------------------
  -- check for each of the dice
  -----------------------------
  
  if crackedD4Collected == false then
    if player:HasCollectible(crackedD4) then
        crackedD4Collected = true
        diceCollected = diceCollected + 1
    end
  end
  
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
    DMTransform = true
    player:AddCacheFlags(CacheFlag.CACHE_LUCK)
    player:AnimateHappy()
    player:EvaluateItems()
  end
  
  if DMTransform == true then
    player:GetEffects():AddCollectibleEffect(CollectibleType.COLLECTIBLE_MIND, true)
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
  
  return true

end





------------
-- callbacks
------------

crackedDiceMod:AddCallback(ModCallbacks.MC_USE_ITEM, crackedDiceMod.D4reroll, crackedD4);
crackedDiceMod:AddCallback(ModCallbacks.MC_POST_UPDATE, crackedDiceMod.spawnItem)
crackedDiceMod:AddCallback(ModCallbacks.MC_POST_UPDATE, crackedDiceMod.transform)
crackedDiceMod:AddCallback(ModCallbacks.MC_EVALUATE_CACHE, crackedDiceMod.cacheUpdate );
