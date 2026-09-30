local function isValidUsername(username)
    if type(username) ~= 'string' then
        return false;
    end;
    local len = #username;
    if len < _SHARED.Register.MinUsernameLength or len > _SHARED.Register.MaxUsernameLength then
        return false;
    end;
    return username:match('^[%w_]+$') ~= nil;
end;

local function isValidPassword(password)
    return type(password) == 'string' and #password >= _SHARED.Register.MinPasswordLength;
end;

local function isValidAvatar(avatar)
    avatar = tonumber(avatar);
    if not avatar then
        return false;
    end;
    return avatar >= 1 and avatar <= _SHARED.Register.MaxAvatars;
end;

local function finishRegister(player, username, passwordHashResult, serial, rateLimitId, avatar)
    if not isElement(player) then
        return;
    end;
    local success = Database.exec('INSERT INTO accounts (username, password_hash, serial, avatar, created_at) VALUES (?, ?, ?, ?, ?)', username, passwordHashResult, serial, avatar, getRealTime().timestamp);
    if not success then
        Notify.server(player, 'Erro ao criar a conta. Tente novamente.', 'error');
        return;
    end;
    Database.query(function(qh)
        if not isElement(player) then
            return;
        end;
        local rows = Database.poll(qh);
        local account = rows and rows[1];
        if account and account.id then
            setElementData(player, 'ID', tonumber(account.id), false);
            setElementData(player, 'accountId', tonumber(account.id), false);
            setElementData(player, 'avatar', tonumber(account.avatar) or 1, false);
        end;
        if rateLimitId then
            ResetRateLimit(rateLimitId, 'register');
        end;
        Notify.server(player, 'Conta criada com sucesso! Faça login.', 'success');
        triggerClientEvent(player, 'onRegisterSuccess', player);
    end, 'SELECT id, avatar FROM accounts WHERE username = ?', username);
end;

-- local function handleRegisterChecksResult(qh, player, username, password, serial, rateLimitId, avatar)
--     if not isElement(player) then
--         return;
--     end;
--     local rows = dbPoll(qh, 0);
--     local usernameTaken = false;
--     local serialCount = 0;
--     if rows then
--         for _, row in ipairs(rows) do
--             if row.username and row.username:lower() == username:lower() then
--                 usernameTaken = true;
--             end;
--             if row.serial == serial then
--                 serialCount = serialCount + 1;
--             end;
--         end;
--     end;
--     if serialCount >= _SHARED.Register.MaxAccountsPerSerial then
--         Notify.server(player, 'Este dispositivo já atingiu o limite de contas permitidas.', 'error');
--         return;
--     end;
--     if usernameTaken then
--         Notify.server(player, 'Esse usuário já existe.', 'error');
--         return;
--     end;
--     passwordHash(password, 'bcrypt', {}, function(hash)
--         if not hash then
--             if isElement(player) then
--                 Notify.server(player, 'Erro ao processar senha. Tente novamente.', 'error');
--             end;
--             return;
--         end;
--         finishRegister(player, username, hash, serial, rateLimitId, avatar);
--     end);
-- end;

addEvent('onPlayerRegisterRequest', true);
addEventHandler('onPlayerRegisterRequest', resourceRoot, function(username, password, confirmPassword, avatar)
    local player = client;

    if not isElement(player) then 
        return; 
    end;

    local rateLimitId = GetPlayerRateLimitId(player);

    if not rateLimitId then
        Notify.server(player, 'Erro interno ao preparar o cadastro.', 'error');
        return;
    end;

    if not CanExecuteWindow(rateLimitId, 'register', _SHARED.Register.MaxAttempts, _SHARED.Register.AttemptsWindowMs) then
        Notify.server(player, 'Muitas tentativas. Aguarde um pouco.', 'error');
        return;
    end;

    if not isValidUsername(username) then
        Notify.server(player, 'Usuário inválido (3-20 caracteres, letras/números/underline).', 'error');
        return;
    end;

    if not isValidPassword(password) then
        Notify.server(player, 'Senha muito curta (mínimo ' .. _SHARED.Register.MinPasswordLength .. ' caracteres).', 'error');
        return;
    end;

    if password ~= confirmPassword then
        Notify.server(player, 'As senhas não coincidem.', 'error');
        return;
    end;

    avatar = tonumber(avatar) or 1;

    if not isValidAvatar(avatar) then
        Notify.server(player, 'Avatar inválido.', 'error');
        return;
    end;

    local serial = getPlayerSerial(player);
    if not serial then
        Notify.server(player, 'Não foi possível identificar seu dispositivo.', 'error');
        return;
    end;

    Database.query(function(qh)
        if not isElement(player) then return; end;
        local rows = Database.poll(qh);
        if not rows then
            Notify.server(player, 'Erro ao consultar o banco de dados.', 'error');
            return;
        end;
        
        local serialCount = 0;
        local usernameTaken = false;

        if rows[1] then
            serialCount = tonumber(rows[1].serial_count) or 0;
            usernameTaken = tonumber(rows[1].username_count) > 0;
        end;

        if serialCount >= _SHARED.Register.MaxAccountsPerSerial then
            Notify.server(player, 'Este dispositivo já atingiu o limite de ' .. _SHARED.Register.MaxAccountsPerSerial .. ' contas permitidas.', 'error');
            return;
        end;

        if usernameTaken then
            Notify.server(player, 'Esse usuário já existe.', 'error');
            return;
        end;

        passwordHash(password, 'bcrypt', {}, function(hash)
            if not hash then
                if isElement(player) then
                    Notify.server(player, 'Erro ao processar senha. Tente novamente.', 'error');
                end;
                return;
            end;
            finishRegister(player, username, hash, serial, rateLimitId, avatar);
        end);
    end, [[
        SELECT
            (SELECT COUNT(*) FROM accounts WHERE serial = ?) AS serial_count,
            (SELECT COUNT(*) FROM accounts WHERE username = ?) AS username_count
    ]], serial, username);
end);