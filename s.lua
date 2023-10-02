ESX = exports["es_extended"]:getSharedObject()

local odliczanie = false
local czasOdliczania = 0

RegisterCommand('notify:onrestart', function(source, args, rawCommand)
    local czas = tonumber(args[1])
    
    local xPlayer = ESX.GetPlayerFromId(source)

    if xPlayer.getGroup() == 'admin' then -- Możesz zmienić na wyższego group'a żeby żaden admin nie mógł tego użyć
        if czas and czas > 0 then
            if not odliczanie then
                odliczanie = true
                czasOdliczania = czas
                RozpocznijOdliczanie()
            else
                TriggerClientEvent('esx:showNotification', source, 'Restart jest już w toku.')
            end
        else
            TriggerClientEvent('esx:showNotification', source, 'Podaj poprawny czas w minutach.')
        end
    else
        TriggerClientEvent('esx:showNotification', source, 'Nie masz uprawnień do użycia tej komendy.')
    end
end, false)

function RozpocznijOdliczanie()
  Citizen.CreateThread(function()
      while odliczanie do
        TriggerClientEvent('ox_lib:notify', -1,{
            id = 'n-restart',
            title = 'Restart Serwera!',
            description = 'Restart serwera nastąpi za: '..czasOdliczania..'min.',
            duration = 60000,
            position = 'top',
            style = {
                backgroundColor = '#C53030',
                color = '#000000',
                ['.description'] = {
                  color = '#000000'
                }
            },
            type = 'warning',
            iconColor = '#ffffff'
        })
          Citizen.Wait(60000) -- odliczanie co minutę (60 000 milisekund)

          czasOdliczania = czasOdliczania - 1
          if czasOdliczania <= 1 then
            TriggerClientEvent('n-pogodaon', -1)
          end
          if czasOdliczania <= 0 then
              odliczanie = false
              WyrzucWszystkichGraczy()
              Wait(10000)
              TriggerClientEvent('n-pogodaoff', -1)
          end
      end
  end)
end

function WyrzucWszystkichGraczy()
    local xPlayers = ESX.GetPlayers()
    for i=1, #xPlayers, 1 do
        DropPlayer(xPlayers[i], 'Restart Serwera!') -- Tekst w komunikacie można dostosować do własnych potrzeb
    end
end

    --[[Komenda jakbyś chciał odwołać restart]]--

    RegisterCommand('notify:offrestart', function(source, rawCommand)
        local xPlayer = ESX.GetPlayerFromId(source)
    
        if xPlayer.getGroup() == 'admin' then -- Możesz zmienić na wyższego group'a żeby żaden admin nie mógł tego użyć
            offrestart()
        else
            TriggerClientEvent('esx:showNotification', source, 'Nie masz uprawnień do użycia tej komendy.')
            end
    end)

    function offrestart()
            odliczanie = false
            TriggerClientEvent('n-pogodaoff', -1)
            TriggerClientEvent('ox_lib:notify', -1,{
                id = 'n-restart',
                title = 'Restart Serwera!',
                description = 'Restart serwera został odwołany!',
                duration = 10000,
                position = 'top',
                style = {
                    backgroundColor = '#C53030',
                    color = '#000000',
                    ['.description'] = {
                      color = '#000000'
                    }
                },
                type = 'warning',
                iconColor = '#ffffff'
            })
    end
