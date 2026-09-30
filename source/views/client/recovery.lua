local VAR = {
    accounts = {};
    selectedAccount = nil;
    recoveryInputsInitialized = false;
    requestedAccounts = false
}

local function initializeRecoveryInputs()
    CreateInput('recovery_email', 631, 625, 246, 18, false);
end

local function drawProfile()
    Image(548.44, 299.53, 70.31, 70.31, IMG.recovery.profile);
    Text(639.84, 312.19, 98, 23, 'Recuperar', tocolor(255, 255, 255, 255), FONT.recovery.title, 'left', 'top');
    Text(639.84, 338.91, 186, 18, 'Selecione a conta desejada', tocolor(255, 255, 255, 50), FONT.recovery.sub_title, 'left', 'top');
end

local function drawAccounts()
    Image(548.44, 397.97, 351.56, 189.84, IMG.recovery.bg_rect_accounts)
    Text(569.53, 419.06, 51, 18, 'Contas', tocolor(255, 255, 255, 255), FONT.recovery.account_title, 'left', 'top');
    local startY = 447.19
    for i, account in ipairs(VAR.accounts) do
        local y = startY + ((i - 1) * 48);

        if y + 42 > 580 then
            break
        end

        local selected = VAR.selectedAccount == i;

        Image(548.44, y, 351.56, 42.19, IMG.recovery.rect_selected_account, 0, 0, 0, tocolor(255, 255, 255, selected and 255 or 150));
        Image(569.53, y + 8.44, 25.31, 25.31, IMG.login.f_user_icon, 0, 0, 0, tocolor(255, 255, 255, 255));
        Text(603.28, y + 12.65, 285, 17, account.username, tocolor(255, 255, 255, selected and 255 or 180), FONT.recovery.account, 'left', 'top');
    end
    if #VAR.accounts == 0 then
        Text(569.53, 475, 300, 18, 'Nenhuma conta encontrada.', tocolor(255, 255, 255, 150), FONT.recovery.account, 'left', 'top');
    end
end

local function drawNewPassword()
    Image(548.44, 601.88, 351.56, 63.28, IMG.login.bg_field, 0, 0, 0, tocolor(255, 255, 255, 255));
    Image(615.94, 625.78, 1.41, 15.47, IMG.login.separator, 0, 0, 0, tocolor(255, 255, 255, 255));
    Image(558.28, 611.72, 43.59, 43.59, IMG.login.bg_mini_field_login, 0, 0, 0, tocolor(255, 255, 255, 255));
    Image(569.53, 622.97, 21.09, 21.09, IMG.login.f_pass_icon, 0, 0, 0, tocolor(255, 255, 255, 255));

    local password = GetInputText('recovery_email');
    local maskedPassword = string.rep('•', #password);

    if password == '' and GetActiveInput() ~= 'recovery_email' then
        Text(631, 625, 246, 18, 'Digite sua nova senha...', tocolor(255, 255, 255, 120), FONT.login.description.sub_title, 'left', 'top');
    else
        Text(631, 625, 246, 18, maskedPassword, tocolor(255, 255, 255, 255), FONT.login.description.sub_title, 'left', 'top');
    end

    drawInputCaret('recovery_email', 631, 625, 18, maskedPassword, FONT.login.description.sub_title);
end

local function drawBarRecovery()
    Image(548.44, 686.25, 351.56, 1.41, IMG.login.bar);
    Text(693, 675, 64.09, 18, 'continuar', tocolor(255, 255, 255, 255), FONT.login.description.sub_title, 'center', 'top');
end

local function drawButtonRecovery()
    local hover = HoverEffect('btn_recovery', 548.47, 718.59, 351.56, 70, { alphaNormal = 0, alphaHover = 255, alphaSelected = 255, scaleNormal = 1, scaleActive = 1, speed = 0.25 });

    Image(548.47, 718.59, 351.56, 70, IMG.login.button_login_not_selected);

    if hover.alpha > 1 then
        Image(548.47, 718.59, 351.56, 70, IMG.login.button_login, 0, 0, 0, tocolor(255, 255, 255, hover.alpha));
    end

    Text(675, 737, 98, 23, 'Recuperar', tocolor(255, 255, 255, 255), FONT.login.description.btn_login, 'center', 'top');
end

local function drawFieldInfo()
    Image(548.44, 802.97, 352.03, 77.34, IMG.login.field_info);
end

function CreateRecoveryUI()
    local offsetX, shouldDraw = GetPageTransitionOffset('recovery');
    if not shouldDraw then
        if UI_STATE.page ~= 'recovery' and not UI_STATE.transitioning and VAR.recoveryInputsInitialized then
            DestroyInput('recovery_email');
            VAR.recoveryInputsInitialized = false;
        end
        return
    end

    if not VAR.recoveryInputsInitialized then
        initializeRecoveryInputs();
        VAR.recoveryInputsInitialized = true;
    end

    if not VAR.requestedAccounts then
        VAR.requestedAccounts = true;
        triggerServerEvent('onPlayerRecoveryRequest', resourceRoot);
    end

    SetGlobalOffsetX(offsetX);
    drawNavBar();
    drawSocialMediaIcons();
    drawProfile();
    drawDescription();
    drawAccounts();
    drawNewPassword();
    drawBarRecovery();
    drawButtonRecovery();
    drawFieldInfo();
    showCursor(true);
    SetGlobalOffsetX(0);
end

addEventHandler('onClientClick', root, function(button, state)
    if button ~= 'left' or state ~= 'down' then
        return;
    end
    
    if UI_STATE.transitioning or UI_STATE.page ~= 'recovery' then
        return;
    end

    for i, account in ipairs(VAR.accounts) do
        local y = 447.19 + ((i - 1) * 48);
        if y + 42 <= 580 then
            if isMouseOverButton(548.44, y, 351.56, 42.19) then
                VAR.selectedAccount = i;
                return;
            end
        end
    end

    if isMouseOverButton(548.47, 718.59, 351.56, 70) then
        if not VAR.selectedAccount then
            Notify.client(localPlayer, 'Selecione uma conta primeiro.', 'error');
            return;
        end

        local account = VAR.accounts[VAR.selectedAccount];

        if not account then
            return;
        end

        local newPassword = GetInputText('recovery_email');

        if not newPassword or newPassword == '' then
            Notify.client(localPlayer, 'Digite uma nova senha.', 'error');
            return;
        end

        triggerServerEvent('onPlayerRecoveryChangePassword', resourceRoot, account.id, newPassword);
        return;
    end

    if isMouseOverButton(631, 625, 246, 18) then
        SetInputFocus('recovery_email');
        return;
    end

    if isMouseOverButton(826.47, 953, 56.25, 30.94) then
        SetUIPage('login');
        return;
    end

    if isMouseOverButton(1030.78, 953.44, 56.25, 30.94) then
        SetUIPage('register');
        return;
    end
end)

addEvent('onRecoveryAccountsReceived', true)

addEventHandler('onRecoveryAccountsReceived', localPlayer,
function(accounts)
    VAR.accounts = accounts or {};
    VAR.selectedAccount = nil;

    if #VAR.accounts > 0 then
        VAR.selectedAccount = 1;
    end
end)

addEvent('onRecoverySuccess', true)
addEventHandler('onRecoverySuccess', localPlayer,
function()
    SetUIPage('login');
end)