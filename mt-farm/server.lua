local QBCore = exports['qb-core']:GetCoreObject()

-- Apanhar Plantas
RegisterServerEvent('mt-farm:server:Apanhar', function() 
    local src = source
    local Player  = QBCore.Functions.GetPlayer(src)
    local prob = math.random(1, 100)
    local quantity = math.random(1, 2)
    if prob < 30 then
        if Player.Functions.Additem("cebola", quantity) then
            TriggerClientEvent('inventory:client:ItemBox', src, QBCore.Shared.Items["cebola"], 'add')
        else
            TriggerClientEvent('QBCore:Notify', src, 'You have full pockets.', 'error')
        end  
    elseif prob >= 30 and prob < 40 then
        if Player.Functions.AddItem("tomate", quantity) then
            TriggerClientEvent('inventory:client:ItemBox', src, QBCore.Shared.Items["tomate"], 'add')
        else
            TriggerClientEvent('QBCore:Notify', src, 'You have full pockets.', 'error')
        end 
    elseif prob >= 40 and prob < 50 then
        if Player.Functions.AddItem("batatas", quantity) then
            TriggerClientEvent('inventory:client:ItemBox', src, QBCore.Shared.Items["batatas"], 'add')
        else
            TriggerClientEvent('QBCore:Notify', src, 'You have full pockets.', 'error')
        end 
    elseif prob >= 50 and prob < 60 then
        if Player.Functions.AddItem("cenouras", quantity) then
            TriggerClientEvent('inventory:client:ItemBox', src, QBCore.Shared.Items["cenouras"], 'add')
        else
            TriggerClientEvent('QBCore:Notify', src, 'You have full pockets.', 'error')
        end 
    elseif prob >= 60 and prob < 70 then
        if Player.Functions.AddItem("trigo", quantity) then
            TriggerClientEvent('inventory:client:ItemBox', src, QBCore.Shared.Items["trigo"], 'add')
        else
            TriggerClientEvent('QBCore:Notify', src, 'You have full pockets.', 'error')
        end 
    elseif prob >= 70 and prob < 80 then
        if Player.Functions.AddItem("alface", quantity) then
            TriggerClientEvent('inventory:client:ItemBox', src, QBCore.Shared.Items["alface"], 'add')
        else
            TriggerClientEvent('QBCore:Notify', src, 'You have full pockets.', 'error')
        end 
    elseif prob >= 80 and prob < 90 then
        if Player.Functions.AddItem("couve", quantity) then
            TriggerClientEvent('inventory:client:ItemBox', src, QBCore.Shared.Items["couve"], 'add')
        else
            TriggerClientEvent('QBCore:Notify', src, 'You have full pockets.', 'error')
        end      
    else
        TriggerClientEvent('QBCore:Notify', src, 'You Broke the plant..', 'error')
    end
end)

-- Processo
RegisterServerEvent("farm:processo")
AddEventHandler("farm:processo", function()
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    local quantity = math.random(1,2)
    local trigo = Player.Functions.GetItemByName("trigo")
    if trigo ~= nil then

        if trigo.amount >= 1 then
            Player.Functions.RemoveItem("trigo", 1)
            Player.Functions.AddItem("farinha", quantity)
            TriggerClientEvent('inventory:client:ItemBox', source, QBCore.Shared.Items["farinha"], "add")
            TriggerClientEvent('QBCore:Notify', src, 'All Done!.')
        else
            TriggerClientEvent('QBCore:Notify', src, 'Wrong items...', 'error')
        end
    else
        TriggerClientEvent("QBCore:Notify", src, "Missing Something...", "error")
    end
end)

-- Venda items
RegisterNetEvent('mt-farm:server:vendas', function(args) 
	local src = source
    local Player = QBCore.Functions.GetPlayer(src)
	local args = tonumber(args)
	if args == 1 then 
		local tomate = Player.Functions.GetItemByName("tomate")
		if tomate ~= nil then
			local payment = 2
			Player.Functions.RemoveItem("tomate", 1, k)
			Player.Functions.AddMoney('bank', payment , "tomate-sell")
			TriggerClientEvent('inventory:client:ItemBox', source, QBCore.Shared.Items['tomate'], "remove", 1)
			TriggerClientEvent('QBCore:Notify', src, "1 "..source.." sell for $"..payment, "success")
			TriggerClientEvent("qb-caca:client:vendercarne", source)
		else
		    TriggerClientEvent('QBCore:Notify', src, "You dont have anything to sell", "error")
        end
	elseif args == 2 then
		local farinha = Player.Functions.GetItemByName("farinha")
		if farinha ~= nil then
			local payment = 5
			Player.Functions.RemoveItem("farinha", 1, k)
			Player.Functions.AddMoney('bank', payment , "farinha-sell")
			TriggerClientEvent('inventory:client:ItemBox', source, QBCore.Shared.Items['farinha'], "remove", 1)
			TriggerClientEvent('QBCore:Notify', src, "1 "..source.."  sell for $"..payment, "success")
			TriggerClientEvent("qb-caca:client:vendercarne", source)
		else
		    TriggerClientEvent('QBCore:Notify', src, "You dont have anything to sell", "error")
        end
	elseif args == 3 then
		local alface = Player.Functions.GetItemByName("alface") 
		if alface ~= nil then
			local payment = 2
			Player.Functions.RemoveItem("alface", 1, k)
			Player.Functions.AddMoney('bank', payment , "alface-sell")
			TriggerClientEvent('inventory:client:ItemBox', source, QBCore.Shared.Items['alface'], "remove", 1)
			TriggerClientEvent('QBCore:Notify', src, "1 "..source.." sell for $"..payment, "success")
			TriggerClientEvent("qb-caca:client:vendercarne", source)
		else
			TriggerClientEvent('QBCore:Notify', src, "You dont have anything to sellr", "error")
		end
	elseif args == 4 then
		local cebola = Player.Functions.GetItemByName("cebola")
		if cebola ~= nil then
			local payment = 2
			Player.Functions.RemoveItem("cebola", 1, k)
			Player.Functions.AddMoney('bank', payment , "cebola-sell")
			TriggerClientEvent('inventory:client:ItemBox', source, QBCore.Shared.Items['cebola'], "remove", 1)
			TriggerClientEvent('QBCore:Notify', src, "1 "..source.." sell for $"..payment, "success")
			TriggerClientEvent("qb-caca:client:vendercarne", source)
		else
		    TriggerClientEvent('QBCore:Notify', src, "You dont have anything to sell", "error")
		end
    elseif args == 5 then
		local batatas = Player.Functions.GetItemByName("batatas")
		if batatas ~= nil then
			local payment = 2
			Player.Functions.RemoveItem("batatas", 1, k)
			Player.Functions.AddMoney('bank', payment , "batatas-sell")
			TriggerClientEvent('inventory:client:ItemBox', source, QBCore.Shared.Items['batatas'], "remove", 1)
			TriggerClientEvent('QBCore:Notify', src, "1 "..source.." sell for $"..payment, "success")
			TriggerClientEvent("qb-caca:client:vendercarne", source)
		else
		    TriggerClientEvent('QBCore:Notify', src, "You dont have anything to sell", "error")
		end
    elseif args == 6 then
		local cenoura = Player.Functions.GetItemByName("cenoura")
		if cenoura ~= nil then
			local payment = 2
			Player.Functions.RemoveItem("cenoura", 1, k)
			Player.Functions.AddMoney('bank', payment , "cenoura-sell")
			TriggerClientEvent('inventory:client:ItemBox', source, QBCore.Shared.Items['cenoura'], "remove", 1)
			TriggerClientEvent('QBCore:Notify', src, "1 "..source.." sell for $"..payment, "success")
			TriggerClientEvent("qb-caca:client:vendercarne", source)
		else
		    TriggerClientEvent('QBCore:Notify', src, "You dont have anything to sell", "error")
		end
    elseif args == 7 then
		local couve = Player.Functions.GetItemByName("couve")
		if couve ~= nil then
			local payment = 2
			Player.Functions.RemoveItem("couve", 1, k)
			Player.Functions.AddMoney('bank', payment , "couve-sell")
			TriggerClientEvent('inventory:client:ItemBox', source, QBCore.Shared.Items['couve'], "remove", 1)
			TriggerClientEvent('QBCore:Notify', src, "1 "..source.." sell for $"..payment, "success")
			TriggerClientEvent("qb-caca:client:vendercarne", source)
		else
		    TriggerClientEvent('QBCore:Notify', src, "You dont have anything to sell", "error")
		end
    end
end)
