local crackedD4Mod = RegisterMod("Cracked D4", 1);
local crackedD4 = Isaac.GetItemIdByName("Cracked D4");
local RNG = RNG();
local game = Game();


function crackedD4Mod:spawnItem()                               -- Main function that contains all the code

    local level = game:GetLevel()                               -- The level which we get from the game
    local player = Isaac.GetPlayer(0)                           -- The player
    local character = player:GetPlayerType()
    local lostID = PlayerType.PLAYER_THELOST
    
    Isaac.DebugString(character)
    Isaac.DebugString(lostID)
    
    local pos = Isaac.GetFreeNearPosition(player.Position, 80) -- Find an empty space near the player
    
    if level:GetAbsoluteStage() == 1 and level.EnterDoor == -1 and player.FrameCount == 1 and character == lostID then                      -- Only if on the first floor and only on the first frame           
        Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_COLLECTIBLE, crackedD4, pos, pos, player)     -- Spawn an item pedestal with the correct item in the spot from earlier
    end
end


function crackedD4Mod:reroll()
  
  local player = Isaac.GetPlayer(0)
  local collectibles = {}
  local other_collectibles = {}
  
  
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
    RNG = player:GetCollectibleRNG(itemRemove)
    itemRemove = collectibles[(RNG:RandomInt(#collectibles) + 1)]
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

end

crackedD4Mod:AddCallback(ModCallbacks.MC_USE_ITEM, crackedD4Mod.reroll, crackedD4);
crackedD4Mod:AddCallback(ModCallbacks.MC_POST_UPDATE, crackedD4Mod.spawnItem)
