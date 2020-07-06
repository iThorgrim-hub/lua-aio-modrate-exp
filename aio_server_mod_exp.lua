local modRateExp = {};

    modRateExp.config = {
        elunaDB = 'ac_eluna';
    };

    modRateExp.text = {
        [0] = 'Your experience mutliplicator is now at',
    };

local AIO = AIO or require("AIO");
local hmod_ExpModifier = AIO.AddHandlers("hmod_ExpModifier", {});

    function modRateExp.sendInformations(msg, player)
        local pGuid = player:GetGUIDLow();

        if not(modRateExp[pGuid])then
            modRateExp[pGuid] = {
                mod_exp = 1;
            };
        end

        return msg:Add("hmod_ExpModifier", "receiveInformations", modRateExp[pGuid].mod_exp);
    end
    AIO.AddOnInit(modRateExp.sendInformations);

    function modRateExp.update(player)
        modRateExp.sendInformations(AIO.Msg(), player):Send(player);
    end

    CharDBExecute('CREATE DATABASE IF NOT EXISTS `'..modRateExp.config.elunaDB..'`;');
    CharDBExecute('CREATE TABLE IF NOT EXISTS `'..modRateExp.config.elunaDB..'`.`characters_exp_rates` (`guid` int(10) NOT NULL, `mod_exp` INT(2) NOT NULL DEFAULT 1, PRIMARY KEY (`guid`)) ENGINE=InnoDB DEFAULT CHARSET=latin1;');

    -- Get player rate from DB
    function modRateExp.onConnect(event, player)
        local pGuid = player:GetGUIDLow();

        if not(modRateExp[pGuid])then
            modRateExp[pGuid] = {
                mod_exp = 1;
            };
        end

        local getRateExp = CharDBQuery('SELECT mod_exp FROM '..modRateExp.config.elunaDB..'.characters_exp_rates WHERE guid = '..pGuid..';');

        if getRateExp ~= nil then
            modRateExp[pGuid].mod_exp = getRateExp:GetUInt32(0);
        else
            local setRateExp = CharDBQuery('INSERT INTO '..modRateExp.config.elunaDB..'.characters_exp_rates (guid, mod_exp) VALUES ('..pGuid..', 1);');
            modRateExp[pGuid].mod_exp = 1;
        end

        modRateExp.update(player);
    end
    RegisterPlayerEvent(3, modRateExp.onConnect);

    -- Save player rate on DB
    function modRateExp.onDisconnect(event, player)
        local pGuid = player:GetGUIDLow();

        if not(modRateExp[pGuid])then
            modRateExp.onConnect(event, player);
        end

        local setRateExp = CharDBQuery('UPDATE '..modRateExp.config.elunaDB..'.characters_exp_rates SET mod_exp = '..modRateExp[pGuid].mod_exp..' WHERE guid = '..pGuid..';');
    end
    RegisterPlayerEvent(4, modRateExp.onDisconnect);

    -- Multiply amountExp * player rate
    function modRateExp.onReceiveExp(event, player, amount)
        local pGuid = player:GetGUIDLow();

        if not(modRateExp[pGuid])then
            modRateExp.onConnect(event, player);
        end

        return amount * modRateExp[pGuid].mod_exp;
    end
    RegisterPlayerEvent(12, modRateExp.onReceiveExp);

    -- Get all players rate
    function modRateExp.getAllPlayerExp(event)
        for i, player in ipairs(GetPlayersInWorld()) do
            modRateExp.onConnect(event, player);
        end
    end
    RegisterServerEvent(33, modRateExp.getAllPlayerExp);

    -- Save all players rate
    function modRateExp.saveAllPlayerExp(event)
        for i, player in ipairs(GetPlayersInWorld()) do
            modRateExp.onDisconnect(event, player);
        end
    end
    RegisterServerEvent(16, modRateExp.saveAllPlayerExp);

    -- Send notification & set new rate
    function hmod_ExpModifier.setRateModifier(player, modifier)
        local pGuid = player:GetGUIDLow();

        if not(modRateExp[pGuid])then
            modRateExp.onConnect(event, player);
        end

        if (modifier >= 1 and modifier <= 3) then
            modRateExp[pGuid].mod_exp = modifier;
            player:SendNotification(modRateExp.text[0]..' '..modRateExp[pGuid].mod_exp..'!');
        end

        modRateExp.update(player, _);
    end