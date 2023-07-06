carrying = {}
--carrying[source] = targetSource, source is carrying targetSource
carried = {}
--carried[targetSource] = source, targetSource is being carried by source

RegisterServerEvent("CarryPeople:sync")
AddEventHandler("CarryPeople:sync", function(targetSrc)
    local targetSrc = targetSrc
    local sourcePed = GetPlayerPed(source)
    local sourceCoords = GetEntityCoords(sourcePed)
    local targetPed = GetPlayerPed(targetSrc)
    local targetCoords = GetEntityCoords(targetPed)
    if #(sourceCoords - targetCoords) <= 3.0 then 
        TriggerClientEvent("CarryPeople:syncTarget", targetSrc, source)
        carrying[source] = targetSrc
        carried[targetSrc] = source
    end
end)

RegisterServerEvent("CarryPeople:stop")
AddEventHandler("CarryPeople:stop", function(targetSrc)
    local source = source

    if carrying[source] then
        TriggerClientEvent("CarryPeople:cl_stop", targetSrc)
        carrying[source] = nil
        carried[targetSrc] = nil
    elseif carried[source] then
        TriggerClientEvent("CarryPeople:cl_stop", carried[source])            
        carrying[carried[source]] = nil
        carried[source] = nil
    end
end)

AddEventHandler('playerDropped', function(reason)
    local source = source
    
    if carrying[source] then
        TriggerClientEvent("CarryPeople:cl_stop", carrying[source])
        carried[carrying[source]] = nil
        carrying[source] = nil
    end

    if carried[source] then
        TriggerClientEvent("CarryPeople:cl_stop", carried[source])
        carrying[carried[source]] = nil
        carried[source] = nil
    end
end)

RegisterServerEvent("Harv:CarryAccepted")
AddEventHandler("Harv:CarryAccepted", function(senderSrc)
    local senderSrc = senderSrc
    local targetSrc = source
    local targetSrcName = GetPlayerName(targetSrc)
    TriggerClientEvent("CarryNotify",senderSrc, "~g~Carry request accepted.")
    TriggerClientEvent("CarryNotify",senderSrc, "~g~Your carry request to "..targetSrcName.." has been accepted.")
    TriggerClientEvent("Harv:StartCarry", senderSrc, targetSrc)
end)

RegisterServerEvent("Harv:CarryDeclined")
AddEventHandler("Harv:CarryDeclined", function(senderSrc)
    local senderSrc = senderSrc
    local targetSrc = source
    local targetSrcName = GetPlayerName(targetSrc)
    TriggerClientEvent("CarryNotify",senderSrc, "~r~Your carry request to "..targetSrcName.." has been declined.")
    TriggerClientEvent("CarryNotify",senderSrc, "~r~Carry request denied.")
end)

RegisterServerEvent("CarryRequest")
AddEventHandler("CarryRequest", function(targetSrc)
    local targetSrc = targetSrc
    local senderSrc = source
    local senderSrcName = GetPlayerName(senderSrc)
        TriggerClientEvent("CarryNotify",targetSrc, "Player: ~b~"..senderSrcName.."~w~ is trying to carry you, press ~g~=~w~ to accept or ~r~-~w~ to refuse")
        TriggerClientEvent("CarryNotify",senderSrc, "Sent carry request to Temp ID: "..targetSrc)
        TriggerClientEvent('Harv:CarryTargetAsk', targetSrc, senderSrc)
    end)