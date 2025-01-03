local ESX = exports['es_extended']:getSharedObject()

-- Funkcija za inicijalizaciju i dodatne akcije (ako je potrebno)
Citizen.CreateThread(function()
    while not ESX do
        Citizen.Wait(100) -- Ako ESX nije dostupan odmah, proveravaj ponovo
    end
end)

-- Funkcija za kreiranje blipa
function CreateBlip(coords, sprite, color, name)
    local blip = AddBlipForCoord(coords)

    SetBlipSprite(blip, sprite)
    SetBlipScale(blip, 0.8)
    SetBlipColour(blip, color)
    SetBlipDisplay(blip, 4)
    SetBlipAsShortRange(blip, true)

    BeginTextCommandSetBlipName("STRING")
    AddTextComponentString(name)
    EndTextCommandSetBlipName(blip)

    return blip
end

-- Dodavanje blipova iz konfiguracije
Citizen.CreateThread(function()
    for _, blip in ipairs(Config.Blips) do
        CreateBlip(blip.coords, blip.sprite, blip.color, blip.name)
    end
end)

-- Komanda za dodavanje novog blipa (dostupno samo administratorima ili po želji)
RegisterCommand('addblip', function(source, args, rawCommand)
    local coords = vector3(tonumber(args[1]), tonumber(args[2]), tonumber(args[3]))
    local sprite = tonumber(args[4]) or 361  -- Podrazumevani sprite za gas stanicu
    local color = tonumber(args[5]) or 4     -- Podrazumevana boja (crvena)
    local name = args[6] or "New Location"   -- Podrazumevani naziv

    -- Dodavanje novog blipa
    table.insert(Config.Blips, {coords = coords, sprite = sprite, color = color, name = name})

    -- Kreiranje novog blipa u igri
    CreateBlip(coords, sprite, color, name)
    print("Novi blip dodat na: " .. name)
end, false) -- false znači da komanda nije ograničena samo za admina (možeš dodati proveru ako želiš)