local function doWorldClear(cfg, src)
    TriggerClientEvent('worldclear:doClear', -1, cfg)

    if cfg.AnnounceInChat then
        local cleanType = (cfg.ClearProps and not cfg.ClearVehicles and not cfg.ClearPeds and "Prop")
            or (cfg.ClearVehicles and not cfg.ClearProps and not cfg.ClearPeds and "Vehicle")
            or (cfg.ClearPeds and not cfg.ClearProps and not cfg.ClearVehicles and "Ped")
            or "World"

        local finishedMsg = string.format("^1[System]^0: %s Clear Finished.", cleanType)
        TriggerClientEvent('chat:addMessage', -1, {
            args = { finishedMsg }
        })
    end
end

    RegisterCommand(Config.CommandName, function(src, args, raw)
        if Config.UseAcePerms and not IsPlayerAceAllowed(src, 'worldclear.use') then
            TriggerClientEvent('chat:addMessage', src, {
                args = { '^1SYSTEM', 'You don’t have permission.' }
            })
            return
        end

        local arg = string.lower(args[1] or "")
        local isValid = (arg == "" or arg == "props" or arg == "vehicles" or arg == "peds")

        if not isValid then
            if src ~= 0 then
                TriggerClientEvent('worldclear:invalidType', src, arg)
            else
                print(('[worldclear] Invalid clear type from console: %s'):format(arg))
            end
            return
        end

        local localCfg = {
            ClearProps = false,
            ClearVehicles = false,
            ClearPeds = false,
            AnnounceInChat = Config.AnnounceInChat,
            ChatMessage = Config.ChatMessage,
            UseNuiNotify = Config.UseNuiNotify,
            NuiClearText = Config.NuiClearText,
            PreClearEnabled = Config.ClearCountdown,
            PreClearTime = Config.ClearTime,
            PreClearTitle = "SERVER WIDE WORLD CLEAR"
        }

        if arg == "" then
            localCfg.ClearProps = true
            localCfg.ClearVehicles = true
            localCfg.ClearPeds = true
        elseif arg == "props" then
            localCfg.ClearProps = true
            localCfg.PreClearTitle = "SERVER WIDE PROP CLEAR"
        elseif arg == "vehicles" then
            localCfg.ClearVehicles = true
            localCfg.PreClearTitle = "SERVER WIDE VEHICLE CLEAR"
        elseif arg == "peds" then
            localCfg.ClearPeds = true
            localCfg.PreClearTitle = "SERVER WIDE PED CLEAR"
        end

        if localCfg.PreClearEnabled then
            local name = 'Console'
            if src and src ~= 0 then
                name = GetPlayerName(src)
            end
        
            if localCfg.AnnounceInChat then
                local cleanType = (arg == "" and "World" or arg:sub(1,1):upper() .. arg:sub(2):lower())
                local msg = string.format("^1[System]^0: %s Clear In %d Seconds", cleanType, localCfg.PreClearTime)        
                TriggerClientEvent('chat:addMessage', -1, {
                    args = { msg }
                })
            end
            
        
            TriggerClientEvent('worldclear:startCountdown', -1, localCfg.PreClearTime, localCfg.PreClearTitle)
        
            SetTimeout(localCfg.PreClearTime * 1000, function()
                doWorldClear(localCfg, src)
            end)
        else
            doWorldClear(localCfg, src)
        end
    end)

