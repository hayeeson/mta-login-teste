local function isValidPassword(password)
    return type(password) == 'string' and #password >= _SHARED.Register.MinPasswordLength;
end;

addEvent('onPlayerRecoveryRequest', true);
addEventHandler('onPlayerRecoveryRequest', resourceRoot, function()
    local player = client;
    if not isElement(player) then
        return;
    end;

    local serial = getPlayerSerial(player);

    if not serial then
        Notify.server(player, 'Não foi possível identificar seu dispositivo.', 'error');
        return;
    end;

    local rateLimitId = GetPlayerRateLimitId(player);

    if not rateLimitId then
        Notify.server(player, 'Erro interno ao preparar a recuperação.', 'error');
        return;
    end;

    if not CanExecuteWindow(rateLimitId, 'recovery_list', _SHARED.Recovery.MaxAttempts, _SHARED.Recovery.AttemptsWindowMs) then
        Notify.server(player, 'Muitas tentativas. Aguarde um pouco.', 'error');
        return;
    end;

    Database.query(function(qh)
        if not isElement(player) then
            return;
        end;

        local rows = Database.poll(qh);

        if not rows then
            Notify.server(player, 'Erro ao consultar suas contas.', 'error');
            return;
        end;

        local accounts = {};

        for _, row in ipairs(rows) do
            table.insert(accounts, {
                id = tonumber(row.id);
                username = tostring(row.username)
            });
        end;

        triggerClientEvent(player, 'onRecoveryAccountsReceived', player, accounts);
    end, 'SELECT id, username FROM accounts WHERE serial = ? ORDER BY id ASC', serial);
end);

addEvent('onPlayerRecoveryChangePassword', true);
addEventHandler('onPlayerRecoveryChangePassword', resourceRoot, function(accountId, newPassword)
    local player = client;
    if not isElement(player) then
        return;
    end;

    accountId = tonumber(accountId);
    if not accountId then
        Notify.server(player, 'Conta inválida.', 'error');
        return;
    end;

    if not isValidPassword(newPassword) then
        Notify.server(player, 'Senha muito curta (mínimo ' .. _SHARED.Register.MinPasswordLength .. ' caracteres).', 'error');
        return;
    end;

    local serial = getPlayerSerial(player);
    if not serial then
        Notify.server(player, 'Não foi possível identificar seu dispositivo.', 'error');
        return;
    end;

    local rateLimitId = GetPlayerRateLimitId(player);
    if not rateLimitId then
        Notify.server(player, 'Erro interno ao preparar a recuperação.', 'error');
        return;
    end;

    if not CanExecuteWindow(rateLimitId, 'recovery_password', _SHARED.Recovery.MaxAttempts, _SHARED.Recovery.AttemptsWindowMs) then
        Notify.server(player, 'Muitas tentativas. Aguarde um pouco.', 'error');
        return;
    end;

    Database.query(function(qh)
        if not isElement(player) then
            return;
        end;
        local rows = Database.poll(qh);
        local account = rows and rows[1];
        if not account then
            Notify.server(player, 'Essa conta não pertence a este dispositivo.', 'error');
            return;
        end;
        passwordHash(newPassword, 'bcrypt', {}, function(hash)
            if not isElement(player) then
                return;
            end;

            if not hash then
                Notify.server(player, 'Erro ao processar a nova senha.', 'error');
                return;
            end;

            local success = Database.exec('UPDATE accounts SET password_hash = ? WHERE id = ? AND serial = ?', hash, accountId, serial);
            if not success then
                Notify.server(player, 'Não foi possível alterar a senha.', 'error');
                return;
            end;

            ResetRateLimit(rateLimitId, 'recovery_password');
            Notify.server(player, 'Senha alterada com sucesso! Faça login.', 'success');
            triggerClientEvent(player, 'onRecoverySuccess', player);
        end);

    end, 'SELECT id, username FROM accounts WHERE id = ? AND serial = ?', accountId, serial);
end);