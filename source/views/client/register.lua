local VAR = {
    registerInputsInitialized = false;
    arrowAvatarSelected = false;
    passView = false;
};

local function initializeRegisterInputs()
    CreateInput('register_username', 629.47, 421, 400, 50, false);
    CreateInput('register_password', 629.47, 499, 400, 50, true);
    CreateInput('register_confirm_password', 629.47, 576.56, 400, 50, true);
end;

local function drawLabelHeader()
    Text(639.84, 299.53, 87, 23, 'Cadastro', tocolor(255, 255, 255, 255), FONT.lblHeaderTitle, 'left', 'top');
end;

local function drawArrowAvatar()
    local hoverLeft = HoverEffect('btnArrowLeft', 639.84, 334.69, 35.16, 35.16, { alphaNormal = 0, alphaHover = 255, alphaSelected = 255, scaleNormal = 1, scaleActive = 1, speed = 0.25 });
    local hoverRight = HoverEffect('btnArrowRight', 682.03, 334.69, 35.16, 35.16, { alphaNormal = 0, alphaHover = 255, alphaSelected = 255, scaleNormal = 1, scaleActive = 1, speed = 0.25 });

    Image(639.84, 334.69, 35.16, 35.16, IMG.register.rect_arrow_not_selected);
    Image(682.03, 334.69, 35.16, 35.16, IMG.register.rect_arrow_not_selected);

    if hoverLeft.alpha > 0 then
        Image(639.84, 334.69, 35.16, 35.16, IMG.register.rect_arrow_selected, 0, 0, 0, tocolor(255, 255, 255, hoverLeft.alpha));
    end;

    if hoverRight.alpha > 0 then
        Image(682.03, 334.69, 35.16, 35.16, IMG.register.rect_arrow_selected, 0, 0, 0, tocolor(255, 255, 255, hoverRight.alpha));
    end;

    Image(645.47, 340.31, 23.91, 23.91, IMG.register.arrow_left, 0, 0, 0, tocolor(255, 255, 255, 255));
    Image(687.66, 340.31, 23.91, 23.91, IMG.register.arrow_right, 0, 0, 0, tocolor(255, 255, 255, 255));

    Text(731, 341, 126, 18, 'Mostrando '..AVATAR.id..' de '..AVATAR.max, tocolor(255, 255, 255, 100), FONT.lblHeaderDescription, 'left', 'top');
end;

local function drawFieldUserAndPass()
    local activeInput = GetActiveInput();

    local userHover = HoverEffect('input_username', 629.47, 421, 400, 50, { alphaNormal = 190, alphaHover = 255, alphaSelected = 255, scaleNormal = 1, scaleActive = 1, speed = 0.25, selected = activeInput == 'register_username' });
    local passHover = HoverEffect('input_password', 629.47, 499, 400, 50, { alphaNormal = 190, alphaHover = 255, alphaSelected = 255, scaleNormal = 1, scaleActive = 1, speed = 0.25, selected = activeInput == 'register_password' });
    local confirmPassHover = HoverEffect('input_confirm_password', 629.47, 576.56, 400, 50, { alphaNormal = 190, alphaHover = 255, alphaSelected = 255, scaleNormal = 1, scaleActive = 1, speed = 0.25, selected = activeInput == 'register_confirm_password' });

    Image(548.44, 397.97, 351.56, 63.28, IMG.login.bg_field, 0, 0, 0, tocolor(255, 255, 255, userHover.alpha));
    Image(548.44, 475.31, 351.56, 63.28, IMG.login.bg_field, 0, 0, 0, tocolor(255, 255, 255, passHover.alpha));
    Image(548.44, 552.66, 351.56, 63.28, IMG.login.bg_field, 0, 0, 0, tocolor(255, 255, 255, confirmPassHover.alpha));

    Image(616.49, 421.8, 1.41, 15.4, IMG.login.separator, 0, 0, 0, tocolor(255, 255, 255, userHover.alpha));
    Image(616.49, 498.8, 1.41, 15.4, IMG.login.separator, 0, 0, 0, tocolor(255, 255, 255, passHover.alpha));
    Image(616.49, 576.05, 1.41, 15.4, IMG.login.separator, 0, 0, 0, tocolor(255, 255, 255, confirmPassHover.alpha));

    Image(558.28, 407.81, 43.59, 43.59, IMG.login.bg_mini_field_login, 0, 0, 0, tocolor(255, 255, 255, userHover.alpha));
    Image(558.28, 485.16, 43.59, 43.59, IMG.login.bg_mini_field_login, 0, 0, 0, tocolor(255, 255, 255, passHover.alpha));
    Image(558.28, 562.5, 43.59, 43.59, IMG.login.bg_mini_field_login, 0, 0, 0, tocolor(255, 255, 255, confirmPassHover.alpha));

    Image(566.72, 416.25, 26.72, 26.72, IMG.login.f_user_icon, 0, 0, 0, tocolor(255, 255, 255, userHover.alpha));
    Image(569.53, 496.41, 21.09, 21.09, IMG.login.f_pass_icon, 0, 0, 0, tocolor(255, 255, 255, passHover.alpha));
    Image(569.53, 573.75, 21.09, 21.09, IMG.login.f_pass_icon, 0, 0, 0, tocolor(255, 255, 255, confirmPassHover.alpha));

    local username = GetInputText('register_username');
    local password = GetInputText('register_password');
    local confirmPassword = GetInputText('register_confirm_password');

    local maskedPassword = string.rep('•', #password);
    local maskedConfirmPassword = string.rep('•', #confirmPassword);

    if username == '' and activeInput ~= 'register_username' then
        Text(629.47, 421, 253, 17, 'Digite seu usuário...', tocolor(255, 255, 255, 120), FONT.login.description.sub_title, 'left', 'top');
    else
        Text(629.47, 421, 253, 17, username, tocolor(255, 255, 255, 255), FONT.login.description.sub_title, 'left', 'top');
    end;

    if password == '' and activeInput ~= 'register_password' then
        Text(629.47, 499, 253, 17, 'Digite sua senha...', tocolor(255, 255, 255, 120), FONT.login.description.sub_title, 'left', 'top');
    else
        Text(629.47, 499, 253, 17, maskedPassword, tocolor(255, 255, 255, 255), FONT.login.description.sub_title, 'left', 'top');
    end;

    if confirmPassword == '' and activeInput ~= 'register_confirm_password' then
        Text(629.47, 576.56, 253, 17, 'Confirme sua senha...', tocolor(255, 255, 255, 120), FONT.login.description.sub_title, 'left', 'top');
    else
        Text(629.47, 576.56, 253, 17, maskedConfirmPassword, tocolor(255, 255, 255, 255), FONT.login.description.sub_title, 'left', 'top');
    end;

    drawInputCaret('register_username', 629.47, 421, 17, username, FONT.login.description.sub_title);
    drawInputCaret('register_password', 629.47, 499, 17, maskedPassword, FONT.login.description.sub_title);
    drawInputCaret('register_confirm_password', 629.47, 576.56, 17, maskedConfirmPassword, FONT.login.description.sub_title);
end;

local function drawIconShowPassword()
    if VAR.passView then
        Image(914.06, 495, 23.91, 23.91, IMG.login.eye, 0, 0, 0, tocolor(255, 255, 255, 255));
        Image(914.06, 572.34, 23.91, 23.91, IMG.login.eye, 0, 0, 0, tocolor(255, 255, 255, 255));
    else
        Image(914.06, 495, 23.91, 23.91, IMG.login.eye, 0, 0, 0, tocolor(255, 255, 255, 80));
        Image(914.06, 572.34, 23.91, 23.91, IMG.login.eye, 0, 0, 0, tocolor(255, 255, 255, 80));
    end;
end;

local function drawBar()
    Image(548.44, 637.03, 352.03, 1.41, IMG.login.bar);
    Text(693, 627, 64.09, 18, 'continuar', tocolor(255, 255, 255, 255), FONT.login.description.sub_title, 'center', 'top');
end;

local function drawButtonRegister()
    local hover = HoverEffect('btn_register', 548.47, 669.38, 352, 70, { alphaNormal = 0, alphaHover = 255, alphaSelected = 255, scaleNormal = 1, scaleActive = 1, speed = 0.25 });

    Image(548.47, 669.38, 352, 70, IMG.login.button_login_not_selected);

    if hover.alpha > 1 then
        Image(548.47, 669.38, 352, 70, IMG.login.button_login, 0, 0, 0, tocolor(255, 255, 255, hover.alpha));
    end;

    Text(696.29, 690, 57.73, 23.91, 'Registrar', tocolor(255, 255, 255, 255), FONT.login.description.btn_login, 'center', 'top');
end;

local function drawFieldInfo()
    Image(548.44, 753.75, 351.56, 77.34, IMG.login.field_info);
end;

function CreateRegisterUI()
    local offsetX, shouldDraw = GetPageTransitionOffset('register');

    if not shouldDraw then
        if UI_STATE.page ~= 'register' and not UI_STATE.transitioning and VAR.registerInputsInitialized then
            DestroyInput('register_username');
            DestroyInput('register_password');
            DestroyInput('register_confirm_password');
            VAR.registerInputsInitialized = false;
        end;
        return;
    end;

    if not VAR.registerInputsInitialized then
        initializeRegisterInputs();
        VAR.registerInputsInitialized = true;
    end;

    SetGlobalOffsetX(offsetX);
    drawNavBar();
    drawSocialMediaIcons();
    drawAvatar();
    drawLabelHeader();
    drawArrowAvatar();
    drawDescription();
    drawFieldUserAndPass();
    drawIconShowPassword();
    drawBar();
    drawButtonRegister();
    drawFieldInfo();
    showCursor(true);
    SetGlobalOffsetX(0);
end;

addEventHandler('onClientClick', root, function(button, state)
    if button ~= 'left' or state ~= 'down' then
        return;
    end;

    if UI_STATE.transitioning or UI_STATE.page ~= 'register' then
        return;
    end;

    if isMouseOverButton(639.84, 334.69, 35.16, 35.16) then
        AVATAR.id = AVATAR.id - 1;
        if AVATAR.id < 1 then
            AVATAR.id = AVATAR.max;
        end;
        return;
    end;

    if isMouseOverButton(682.03, 334.69, 35.16, 35.16) then
        AVATAR.id = AVATAR.id + 1;
        if AVATAR.id > AVATAR.max then
            AVATAR.id = 1;
        end;
        return;
    end;

    if isMouseOverButton(629.47, 421, 400, 50) then
        SetInputFocus('register_username');
        return;
    end;

    if isMouseOverButton(629.47, 499, 400, 50) then
        SetInputFocus('register_password');
        return;
    end;

    if isMouseOverButton(629.47, 576.56, 400, 50) then
        SetInputFocus('register_confirm_password');
        return;
    end;

    if isMouseOverButton(548.47, 669.38, 352, 70) then
        local username = GetInputText('register_username');
        local password = GetInputText('register_password');
        local confirmPassword = GetInputText('register_confirm_password');

        triggerServerEvent('onPlayerRegisterRequest', resourceRoot, username, password, confirmPassword, AVATAR.id);
        return;
    end;

    if isMouseOverButton(826.47, 953, 56.25, 30.94) then
        SetUIPage('login');
        return;
    end;

    if isMouseOverButton(1030.78, 953.44, 56.25, 30.94) then
        SetUIPage('recovery');
        return;
    end;
end);

addEvent('onRegisterSuccess', true);
addEventHandler('onRegisterSuccess', localPlayer, function()
    SetUIPage('login');
end);