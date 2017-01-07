local crackedD4Mod = RegisterMod("Cracked D4", 1);
local crackedD4 = Isaac.GetItemIdByName("Cracked D4");
local RNG = RNG();

function crackedD4Mod:reroll()
  
  local player = Isaac.GetPlayer(0)
  
  -- Isaac.DebugString(player:GetCollectibleCount())
  
  if player:GetCollectibleCount() >= 1 then --If the player has collectibles
            
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
  
    
    local itemRemove = collectibles[(RNG:RandomInt(#collectibles) + 1)]
    local itemAdd = other_collectibles[(RNG:RandomInt(#other_collectibles) + 1)]

    
    -- remove a random item
    player:RemoveCollectible(itemRemove) --Randomly select a collectible from the table and remove it
    
    -- add a new item
    player:AddCollectible(itemAdd, 0, false)
    
      
    -- create recursive function to ensure active items are not added
    
    function activeItemiIsCrackedD4(active)
      if active ~= crackedD4 then
        player:RemoveCollectible(active)
        player:AddCollectible(crackedD4, 0, false)
        itemAdd = other_collectibles[(RNG:RandomInt(#other_collectibles) + 1)]
        player:AddCollectible(itemAdd, 0, false)
        local newActive = player:GetActiveItem()
        return activeItemiIsCrackedD4(newActive)
      else
        return true
      end
    end

    activeItemiIsCrackedD4(player:GetActiveItem())
        
  end

end

crackedD4Mod:AddCallback(ModCallbacks.MC_USE_ITEM, crackedD4Mod.reroll, crackedD4);
