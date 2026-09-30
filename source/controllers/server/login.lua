local function isValidCredentials(username, password)
    return type(username) == 'string' and username ~= '' and type(password) == 'string' and password ~= '';
end;

local function finishLogin(player, account, rateLimitId)
    if not isElement(player) then
        return;
    end;
    
    local accountId = tonumber(account.id);

    if not accountId then
        Notify.server(player, 'Erro ao carregar sua conta.', 'error');
        return;
    end;

    setElementData(player, 'ID', accountId, false);
    setElementData(player, 'accountId', accountId, false);
    setElementData(player, 'avatar', tonumber(account.avatar) or 1, false);
    setElementData(player, 'loggedIn', true, false);

    if rateLimitId then
        ResetRateLimit(rateLimitId, 'login');
    end;

    Notify.server(player, 'Login realizado com sucesso!', 'success');

    triggerClientEvent(player, 'onLoginSuccess', player);
    triggerEvent('onPlayerLoggedIn', player, accountId);
end;

local function handleAccountQueryResult(qh, player, password, rateLimitId)
    if not isElement(player) then
        return;
    end;

    local rows = Database.poll(qh);
    if not rows then
        Notify.server(player, 'Erro ao consultar sua conta.', 'error');
        return;
    end;

    local account = rows[1];
    if not account then
        Notify.server(player, 'Usuário ou senha incorretos.', 'error');
        return;
    end;

    if not account.password_hash then
        Notify.server(player, 'Erro nos dados da conta.', 'error');
        return;
    end;

    passwordVerify(password, account.password_hash, {}, function(match)
        if not isElement(player) then
            return;
        end;
        --print('pass qual boolean: ' .. tostring(match));
        if not match then
            Notify.server(player, 'Usuário ou senha incorretos.', 'error');
            return;
        end;
        finishLogin(player, account, rateLimitId);
    end);
end;

addEvent('onPlayerLoginRequest', true);
addEventHandler('onPlayerLoginRequest', resourceRoot, function(username, password)
    local player = client;

    if not isElement(player) then
        return;
    end;

    --print('in testi ' .. getPlayerName(player) .. ' | usr: ' .. tostring(username));
    if getElementData(player, 'loggedIn') then
        Notify.server(player, 'Já está logado.', 'error');
        return;
    end;

    local rateLimitId = GetPlayerRateLimitId(player);
    if not rateLimitId then
        Notify.server(player, 'Erro interno ao preparar o login.', 'error');
        return;
    end;

    if not CanExecuteWindow(rateLimitId, 'login', _SHARED.Login.MaxAttempts, _SHARED.Login.AttemptsWindowMs) then
        Notify.server(player, 'Muitas tentativas. Aguarde um pouco.', 'error');
        return;
    end;

    if not isValidCredentials(username, password) then
        Notify.server(player, 'Preencha usuário e senha.', 'error');
        return;
    end;

    if not Database.Connection then
        Notify.server(player, 'Erro no banco de dados.', 'error');
        return;
    end;

    --print('acc: ' .. tostring(username));
    Database.query(function(qh)
        handleAccountQueryResult(qh, player, password, rateLimitId);
    end, 'SELECT id, password_hash, avatar FROM accounts WHERE username = ?', username);
end);