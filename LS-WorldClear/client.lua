local function EnumerateEntities(init, move, fin)
    return coroutine.wrap(function()
      local iter, ent = init()
      if not iter or ent == 0 then
        fin(iter)
        return
      end
      repeat
        coroutine.yield(ent)
        local ok
        ok, ent = move(iter)
      until not ok
      fin(iter)
    end)
  end
  
  local EnumerateVehicles = function() return EnumerateEntities(FindFirstVehicle, FindNextVehicle, EndFindVehicle) end
  local EnumerateObjects  = function() return EnumerateEntities(FindFirstObject,  FindNextObject,  EndFindObject)  end
  local EnumeratePeds     = function() return EnumerateEntities(FindFirstPed,     FindNextPed,     EndFindPed)     end
  
  TriggerEvent('chat:addSuggestion', '/' .. Config.CommandName, 'Clear world entities', {
    { name = "type", help = "Optional: props / vehicles / peds" }
})


RegisterNetEvent('worldclear:invalidType')
AddEventHandler('worldclear:invalidType', function(wrongArg)
    if Config.UseNuiNotify then
        SendNUIMessage({
            action = 'notify',
            title = '🚫 INVALID CLEAR TYPE'
        })
    else
        TriggerEvent('chat:addMessage', {
            args = { '^1SYSTEM', 'Invalid clear type: ' .. wrongArg }
        })
    end
end)

  RegisterNetEvent('worldclear:startCountdown')
  AddEventHandler('worldclear:startCountdown', function(timeLeft, title)
    SendNUIMessage({ action = 'start', time = timeLeft, title = title })
  end)
  
  RegisterNetEvent('worldclear:doClear')
  AddEventHandler('worldclear:doClear', function(cfg)

    if cfg.UseNuiNotify then
      SendNUIMessage({ action = 'clear', text = cfg.NuiClearText })
    else
      TriggerEvent('chat:addMessage', { args = { '^1SYSTEM', cfg.NuiClearText } })
    end
  
    if cfg.ClearVehicles then
      for veh in EnumerateVehicles() do
        DeleteEntity(veh)
      end
    end

    if cfg.ClearProps then
      for obj in EnumerateObjects() do
        DeleteEntity(obj)
      end
    end

    if cfg.ClearPeds then
      for ped in EnumeratePeds() do
        if not IsPedAPlayer(ped) then
          DeleteEntity(ped)
        end
      end
    end
  end)
  