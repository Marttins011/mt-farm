local QBCore = exports['qb-core']:GetCoreObject()
local spawnedPlants = 0
local farmPlants = {}

-- Criar blip para a "Horta"
Citizen.CreateThread(function()
    local blip = AddBlipForCoord(2298.27, 5140.95, 52.49) -- Mudar coordenadas do blip aqui!
	SetBlipSprite(blip, 113) -- Mudar estilo do blip aqui!
	SetBlipDisplay(blip, 4)
	SetBlipScale(blip, 0.7)
	SetBlipAsShortRange(blip, true)
	SetBlipColour(blip, 3)
	BeginTextCommandSetBlipName("STRING")
	AddTextComponentSubstringPlayerName("Farm") -- Mudar nome do Blip aqui!
    EndTextCommandSetBlipName(blip)
end)

-- Criar blip para o processo
Citizen.CreateThread(function()
    local blip = AddBlipForCoord(2407.35, 5018.57, 45.96) -- Mudar coordenadas do blip aqui!
	SetBlipSprite(blip, 76) -- Mudar estilo do blip aqui!
	SetBlipDisplay(blip, 4)
	SetBlipScale(blip, 0.7)
	SetBlipAsShortRange(blip, true)
	SetBlipColour(blip, 3)
	BeginTextCommandSetBlipName("STRING")
	AddTextComponentSubstringPlayerName("Farm Process") -- Mudar nome do Blip aqui!
    EndTextCommandSetBlipName(blip)
end)

-- Criar blip para venda de alimentos
Citizen.CreateThread(function()
    local blip = AddBlipForCoord(2029.69, 4980.69, 42.1) -- Mudar coordenadas do blip aqui!
	SetBlipSprite(blip, 108) -- Mudar estilo do blip aqui!
	SetBlipDisplay(blip, 4)
	SetBlipScale(blip, 0.7)
	SetBlipAsShortRange(blip, true)
	SetBlipColour(blip, 3)
	BeginTextCommandSetBlipName("STRING")
	AddTextComponentSubstringPlayerName("Farm Sell") -- Mudar nome do Blip aqui!
    EndTextCommandSetBlipName(blip)
end)

-- Apanhar Plantas
RegisterNetEvent('mt-farm:client:Apanhar', function()
	local playerPed = PlayerPedId()
	local coords = GetEntityCoords(playerPed)
	local nearbyObject, nearbyID
	for i=1, #farmPlants, 1 do
		if GetDistanceBetweenCoords(coords, GetEntityCoords(farmPlants[i]), false) < 1.2 then
			nearbyObject, nearbyID = farmPlants[i], i
		end
	end
	QBCore.Functions.TriggerCallback('QBCore:HasItem', function(HasItem)
		if HasItem then
			if nearbyObject and IsPedOnFoot(playerPed) then
				isPickingUp = true
                QBCore.Functions.Progressbar("Apanhar", "CATCHING PLANT..", 5000)
				TaskStartScenarioInPlace(playerPed, 'world_human_gardener_plant', 0, false)
				Wait(6500)
				ClearPedTasks(playerPed)
				Wait(1000)
				DeleteObject(nearbyObject) 
				table.remove(farmPlants, nearbyID)
				spawnedPlants = spawnedPlants - 1
				TriggerServerEvent('mt-farm:server:Apanhar')
			else
				QBCore.Functions.Notify('You are too far way...', 'error', 3500)
			end
		else
			QBCore.Functions.Notify('You dont have a towler!', 'error', 3500)
		end
	end, "trowel")
end)

-- Pegar Coordenadas
CreateThread(function()
	while true do
		Wait(10)
		local coords = GetEntityCoords(PlayerPedId())
		if GetDistanceBetweenCoords(coords, Config.PlantsField, true) < 50 then
			SpawnfarmPlants()
			Wait(500)
		else
			Wait(500)
		end
	end
end)

-- Eliminar Plantas ao Apanhar
AddEventHandler('onResourceStop', function(resource)
	if resource == GetCurrentResourceName() then
		for k, v in pairs(farmPlants) do
			DeleteObject(v)
		end
	end
end)

-- Spawn Plantas
function SpawnObject(model, coords, cb)
	local model = (type(model) == 'number' and model or GetHashKey(model))
	RequestModel(model)
	while not HasModelLoaded(model) do
		Wait(1)
	end
    local obj = CreateObject(model, coords.x, coords.y, coords.z, false, false, true)
    SetModelAsNoLongerNeeded(model)
    PlaceObjectOnGroundProperly(obj)
    FreezeEntityPosition(obj, true)
    if cb then
        cb(obj)
    end
end

-- Gerar Coordenadas para as Plantas
function SpawnfarmPlants()
	while spawnedPlants < 15 do
		Wait(1)
		local plantCoords = GeneratePlantsCoords()
		SpawnObject('prop_bush_dead_02', plantCoords, function(obj)
			table.insert(farmPlants, obj)
			spawnedPlants = spawnedPlants + 1
		end)
	end
end 

-- Validar Coordenadas
function ValidatePlantsCoord(plantCoord)
	if spawnedPlants > 0 then
		local validate = true
		for k, v in pairs(farmPlants) do
			if GetDistanceBetweenCoords(plantCoord, GetEntityCoords(v), true) < 5 then
				validate = false
			end
		end
		if GetDistanceBetweenCoords(plantCoord, Config.PlantsField, false) > 50 then
			validate = false
		end
		return validate
	else
		return true
	end
end

-- Gerar Box Coords
function GeneratePlantsCoords()
	while true do
		Wait(1)
		local cokeCoordX, cokeCoordY
		math.randomseed(GetGameTimer())
		local modX = math.random(-15, 15)
		Wait(100)
		math.randomseed(GetGameTimer())
		local modY = math.random(-15, 15)
		cokeCoordX = Config.PlantsField.x + modX
		cokeCoordY = Config.PlantsField.y + modY
		local coordZ = GetCoordZPlants(cokeCoordX, cokeCoordY)
		local coord = vector3(cokeCoordX, cokeCoordY, coordZ)
		if ValidatePlantsCoord(coord) then
			return coord
		end
	end
end

-- Verificar Altura das Coordenadas
function GetCoordZPlants(x, y)
	local groundCheckHeights = { 35, 36.0, 37.0, 38.0, 39.0, 40.0, 41.0, 42.0, 43.0, 44.0, 45.0, 46.0, 47.0, 48.0, 49.0, 50.0, 51.0, 52.0, 53.0, 54.0, 55.0 }
	for i, height in ipairs(groundCheckHeights) do
		local foundGround, z = GetGroundZFor_3dCoord(x, y, height)
		if foundGround then
			return z
		end
	end
	return 53.85
end

--Target para apanha
exports['qb-target']:AddTargetModel(`prop_bush_dead_02`, {
    options = {
        {
            event = "mt-farm:client:Apanhar",
            icon = "fas fa-seedling",
            label = "Harvest Plant",
        },
    },
    distance = 2.0
})

-- Target para processo
Citizen.CreateThread(function ()
    exports['qb-target']:AddBoxZone("farm", vector3(2407.35, 5018.57, 45.96), 2, 2, {
        name = "farm",
        heading = 0,
        debugPoly = false,
    }, {
        options = {
            {
                type = "Client",
                event = "farm:processos",
                icon = "fas fa-seedling",
                label = 'Process Food'
            },
        },
        distance = 2.5
    })
end)

-- Target Venda
Citizen.CreateThread(function ()
    exports['qb-target']:AddBoxZone("vendas", vector3(2033.03, 4980.88, 40.11), 1, 1, {
        name = "vendas",
        heading = 0,
        debugPoly = false,
    }, {
        options = {
            {
                type = "Client",
                event = "mt-farm:client:vendas",
                icon = "fas fa-seedling",
                label = 'Talk with employee'
            },
        },
        distance = 2.5
    })
end)

-- Spawn ped vendas
local cokePed = {
	{2033.03, 4980.88, 40.11,"Sr Manel",224.61,0x94562DD7,"a_m_m_farmer_01"},
  
  }
  Citizen.CreateThread(function()
	  for _,v in pairs(cokePed) do
		  RequestModel(GetHashKey(v[7]))
		  while not HasModelLoaded(GetHashKey(v[7])) do
			  Wait(1)
		  end
		  CokeProcPed =  CreatePed(4, v[6],v[1],v[2],v[3], 3374176, false, true)
		  SetEntityHeading(CokeProcPed, v[5])
		  FreezeEntityPosition(CokeProcPed, true)
		  SetEntityInvincible(CokeProcPed, true)
		  SetBlockingOfNonTemporaryEvents(CokeProcPed, true)
		  TaskStartScenarioInPlace(CokeProcPed, "WORLD_HUMAN_STAND_MOBILE_UPRIGHT", 0, true) 
	  end
  end)

-- Thread para processo
RegisterNetEvent('farm:processo')
AddEventHandler("farm:processo", function()
    QBCore.Functions.Progressbar("farm_process", "A Processar Alimentos", 5000, false, true, {
        disableMovement = true,
        disableCarMovement = true,
        disableMouse = false,
        disableCombat = true,
    }, {
        animDict = "mini@repair",
        anim = "fixing_a_player",
        flags = 16,
    }, {}, {}, function() 
        local playerPed = PlayerPedId()
        local success = exports['qb-lock']:StartLockPickCircle(1,30)
   if success then
        StopAnimTask(ped, dict, "machinic_loop_mechandplayer", 1.0)
        TriggerServerEvent("farm:processo")
        ClearPedTasks(playerPed)
    else
        QBCore.Functions.Notify("Failed!", "error")
        ClearPedTasks(playerPed)
        end
    end)
end)

-- Menu processo
RegisterNetEvent('farm:processos', function()
    exports['qb-menu']:openMenu({
        {
            id = 1,
            header = "make flour",
            txt = "Necessário: 1 Trigo"
        },
        {
            id = 2,
            header = "Start",
            txt = "",
            params = {
                event = "farm:processo",
            }
        },
        {
            id = 3,
            header = "Close",
            txt = "",
            params = {
                event = "qb-menu:closeMenu",
            }
        },

    })
end)

RegisterNetEvent('mt-farm:client:vendas')
AddEventHandler('mt-farm:client:vendas', function()
    exports['qb-menu']:openMenu({
		{
            header = "Sell Food",
            isMenuHeader = true
        },
        {
            header = "Tomato",
            txt = "Price: $2",
            params = {
				isServer = true,
                event = "mt-farm:server:vendas",
				args = 1
            }
        },
        {
            header = "Flour",
            txt = "Price: $5",
            params = {
				isServer = true,
                event = "mt-farm:server:vendas",
				args = 2
            }
        },
		{
            header = "Lectuce",
            txt = "Price: $2",
            params = {
				isServer = true,
                event = "mt-farm:server:vendas",
				args = 3 
            }
        },
        {
            header = "Onion",
            txt = "Price: $2",
            params = {
				isServer = true,
                event = "mt-farm:server:vendas",
				args = 4
            }
        },
		{
            header = "Potatos",
            txt = "Price: $2",
            params = {
				isServer = true,
                event = "mt-farm:server:vendas",
				args = 5
            }
        },	
        {
            header = "Carot",
            txt = "Price: $2",
            params = {
				isServer = true,
                event = "mt-farm:server:vendas",
				args = 6
            }
        },	
        {
            header = "Green cabbage",
            txt = "Price: $2",
            params = {
				isServer = true,
                event = "mt-farm:server:vendas",
				args = 7
            }
        },				
        {
            header = "< Close",
            txt = "",
            params = {
                event = "qb-menu:closeMenu"
            }
        },
    })
end)
