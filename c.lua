ESX = exports['es_extended']:getSharedObject()


RegisterNetEvent('pogodaon')
AddEventHandler('pogodaon', function()
    SetWeatherTypeNowPersist("THUNDER")
end)


RegisterNetEvent('pogodaoff')
AddEventHandler('pogodaoff', function()
    ClearWeatherTypePersist()
end)

Citizen.CreateThread(function()
    TriggerEvent('chat:addSuggestion', '/notify:onrestart', 'komenda do restartu serwera', {
        { name = "czas", help = "Czas w minutach, po którym ma nastąpić restart serwera" }
    })
end)

Citizen.CreateThread(function()
    TriggerEvent('chat:addSuggestion', '/notify:offrestart', 'komenda do odwołania restartu, nie odwołasz restartu gdy będzie poniżej 1 minuty.')
end)
