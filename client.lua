local inElevator = nil
local zones = {}

--Functions
local function teleportPlayer(index, coords)
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
        SetEntityCoords(cache.ped, coords[index], 1, 0, 0, 0) 
    else 
        lib.notify({title = 'Cancelled', type = 'error'})
    end   
end

for name, _ in pairs(Config.Locations) do 
    for _, coords in pairs(Config.Locations[name]) do 
        zones = lib.zones.box({
            coords = coords,
            size = vec3(3, 3, 2),
            rotation = 0.0,
            inside  = function()
                inElevator = true
                lib.showTextUI('Elevator')
                if IsControlJustReleased(0, 38) then
                    local options = {}

                    for i=1, #Config.Locations[name] do
                        options[#options+1] = {
                            title = 'Floor '..i,
                            onSelect = function()
                                teleportPlayer(i, Config.Locations[name])
                            end,
                        }
                    end
                    lib.registerContext({id = 'ELEVATOR', title = 'Hospital Elevator', options = options})
                    lib.showContext('ELEVATOR')   
                end
            end,
            onExit = function()
                lib.hideTextUI()
                inElevator = false
            end
        })
    end
end