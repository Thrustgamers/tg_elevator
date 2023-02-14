local zones = {}
local location = {}

--Functions
local function teleportPlayer(coords)
    lib.hideContext()
    if lib.progressCircle({
        duration = 4000,
        position = 'bottom',
        useWhileDead = false,
        canCancel = true,
        disable = {
            car = true,
            move = true,
            combat = true,
            mouse = false,
        },
        anim = {
            dict = 'random@shop_tattoo',
            clip = '_idle_a'
        },
    }) 
    then
        SetEntityCoords(cache.ped, coords, 1, 0, 0, 0) 
    else 
        lib.notify({title = 'Cancelled', type = 'error'})
    end   
end

for name, _ in pairs(Config.Locations) do 
    for _, v in pairs(Config.Locations[name]) do 
        zones = lib.zones.box({
            coords = v.coords,
            size = vec3(3, 3, 2),
            rotation = 0.0,
            inside  = function()
                lib.showTextUI('Elevator')
                if IsControlJustReleased(0, 38) then
                    local options = {}

                    for k, v in pairs(Config.Locations[name]) do
                        options[#options+1] = {
                            title = v.name,
                            onSelect = function()
                                teleportPlayer(Config.Locations[name][k].coords)
                            end,
                        }
                    end
                    lib.registerContext({id = 'ELEVATOR', title = 'Elevator', options = options})
                    lib.showContext('ELEVATOR')   
                end
            end,
            onExit = function()
                lib.hideTextUI()
            end
        })
    end
end