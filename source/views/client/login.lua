local VAR = {
    cbSelectedStatus = false;
    btnLoginSelectedStatus = false;
    socialMediaStatus = false;
    inputsInitialized = false;
    rememberFile = 'remember.xml';
    Input = {
        Username = {name = 'login_username', x = 629.47, y = 421, width = 400, height = 50};
        Password = {name = 'login_password', x = 629.47, y = 499, width = 400, height = 50};
    };
    Remember = {x = 548.44, y = 559.69, width = 24, height = 24};
    Button = {x = 548.47, y = 630, width = 352, height = 70};
    Navigation = {
        Register = {x = 923.91, y = 953.44, width = 56.25, height = 30.94};
        Recovery = {x = 1030.78, y = 953.44, width = 56.25, height = 30.94};
    };
};

local function saveRememberedCredentials(username, password)
    local xml = xmlCreateFile(VAR.rememberFile, 'remember');
    if not xml then
        return;
    end;
    xmlNodeSetValue(xmlCreateChild(xml, 'username'), username);
    xmlNodeSetValue(xmlCreateChild(xml, 'password'), password);
    xmlSaveFile(xml);
    xmlUnloadFile(xml);
end;

local function loadRememberedCredentials()
    if not fileExists(VAR.rememberFile) then
        return nil, nil;
    end;

    local xml = xmlLoadFile(VAR.rememberFile);

    if not xml then
        return nil, nil;
    end;

    local userNode = xmlFindChild(xml, 'username', 0);
    local passNode = xmlFindChild(xml, 'password', 0);
    local username = userNode and xmlNodeGetValue(userNode) or nil;
    local password = passNode and xmlNodeGetValue(passNode) or nil;
    xmlUnloadFile(xml);
    
    return username, password;
end;

local function clearRememberedCredentials()
    if fileExists(VAR.rememberFile) then
        fileDelete(VAR.rememberFile);
    end;
end;

local function drawLabelHeader()
    Text(639.84, 312.19, 52.03, 23.91, 'Login', tocolor(255, 255, 255, 255), FONT.lblHeaderTitle, 'left', 'top');
    Text(639.84, 338.91, 190, 18, 'Preencha os campos abaixo.', tocolor(255, 255, 255, 100), FONT.lblHeaderDescription, 'left', 'top');
end;

local function initializeLoginInputs()
    local username = VAR.Input.Username;
    local password = VAR.Input.Password;

    CreateInput(username.name, username.x, username.y, username.width, username.height, false);
    CreateInput(password.name, password.x, password.y, password.width, password.height, true);

    local savedUsername, savedPassword = loadRememberedCredentials();

    if savedUsername and savedPassword then
        SetInputText(username.name, savedUsername);
        SetInputText(password.name, savedPassword);
        VAR.cbSelectedStatus = true;
    end;
end;

local function drawFieldUserAndPass()
    local user = VAR.Input.Username;
    local pass = VAR.Input.Password;

    local userHover = HoverEffect('input_username', user.x, user.y, user.width, user.height, { alphaNormal = 190, alphaHover = 255, alphaSelected = 255, scaleNormal = 1, scaleActive = 1, speed = 0.25, selected = (GetActiveInput() == user.name) });
    local passHover = HoverEffect('input_password', pass.x, pass.y, pass.width, pass.height, { alphaNormal = 190, alphaHover = 255, alphaSelected = 255, scaleNormal = 1, scaleActive = 1, speed = 0.25, selected = (GetActiveInput() == pass.name) });

    Image(549, 398, 351.51, 63, IMG.login.bg_field, 0, 0, 0, tocolor(255, 255, 255, userHover.alpha));
    Image(549, 475, 351.51, 63, IMG.login.bg_field, 0, 0, 0, tocolor(255, 255, 255, passHover.alpha));

    Image(616.49, 421.8, 1.41, 15.4, IMG.login.separator, 0, 0, 0, tocolor(255, 255, 255, userHover.alpha));
    Image(616.49, 498.8, 1.41, 15.4, IMG.login.separator, 0, 0, 0, tocolor(255, 255, 255, passHover.alpha));

    Image(558.84, 407.8, 43.59, 43.4, IMG.login.bg_mini_field_login, 0, 0, 0, tocolor(255, 255, 255, userHover.alpha));
    Image(558.84, 484.8, 43.59, 43.4, IMG.login.bg_mini_field_login, 0, 0, 0, tocolor(255, 255, 255, passHover.alpha));

    Image(567.28, 416.02, 26.71, 26.6, IMG.login.f_user_icon, 0, 0, 0, tocolor(255, 255, 255, userHover.alpha));
    Image(570.09, 496, 21.09, 21, IMG.login.f_pass_icon, 0, 0, 0, tocolor(255, 255, 255, passHover.alpha));

    local username = GetInputText(user.name);
    local password = GetInputText(pass.name);
    local maskedPassword = string.rep('•', #password);

    if username == '' and GetActiveInput() ~= user.name then
        Text(user.x, user.y, 253, 17, 'Digite seu usuário...', tocolor(255, 255, 255, 120), FONT.login.description.sub_title, 'left', 'top');
    else
        Text(user.x, user.y, 253, 17, username, tocolor(255, 255, 255, 255), FONT.login.description.sub_title, 'left', 'top');
    end;

    if password == '' and GetActiveInput() ~= pass.name then
        Text(pass.x, pass.y, 253, 17, 'Digite sua senha...', tocolor(255, 255, 255, 120), FONT.login.description.sub_title, 'left', 'top');
    else
        Text(pass.x, pass.y, 253, 17, maskedPassword, tocolor(255, 255, 255, 255), FONT.login.description.sub_title, 'left', 'top');
    end;

    drawInputCaret(user.name, user.x, user.y, 17, username, FONT.login.description.sub_title);
    drawInputCaret(pass.name, pass.x, pass.y, 17, maskedPassword, FONT.login.description.sub_title);
end;

local function drawCheckBoxRememberMe()
    local remember = VAR.Remember;
    local hover = HoverEffect('remember_checkbox', remember.x, remember.y, remember.width, remember.height, { alphaNormal = 200, alphaHover = 255, alphaSelected = 255, scaleNormal = 1, scaleActive = 1.08, speed = 0.25, selected = VAR.cbSelectedStatus });
    local selectAlpha = Animate('remember_select_alpha', VAR.cbSelectedStatus and 255 or 0, 0.25);
    local finalSize = remember.width * hover.scale;
    local offset = (finalSize - remember.width) / 2;
    local posX = remember.x - offset;
    local posY = remember.y - offset;

    Image(posX, posY, finalSize, finalSize, IMG.login.cbRememberNotSelected, 0, 0, 0, tocolor(255, 255, 255, hover.alpha));

    if selectAlpha > 1 then
        Image(posX, posY, finalSize, finalSize, IMG.login.cbRemember, 0, 0, 0, tocolor(255, 255, 255, selectAlpha));
    end;

    Text(582.25, 563, 101.19, 18.07, 'Lembrar dados', tocolor(255, 255, 255, VAR.cbSelectedStatus and 255 or 200), FONT.login.description.sub_title, 'left', 'center');
end;

local function drawBar()
    Image(548.44, 606.09, 352.03, 1.41, IMG.login.bar);
    Text(693, 596, 64.09, 18, 'continuar', tocolor(255, 255, 255, 255), FONT.login.description.sub_title, 'center', 'top');
end;

local function drawButtonLogin()
    local button = VAR.Button;
    local hover = HoverEffect('btn_login', button.x, button.y, button.width, button.height, { alphaNormal = 0, alphaHover = 255, alphaSelected = 255, scaleNormal = 1, scaleActive = 1, speed = 0.25 });

    Image(button.x, button.y, button.width, button.height, IMG.login.button_login_not_selected);

    if hover.alpha > 1 then
        Image(button.x, button.y, button.width, button.height, IMG.login.button_login, 0, 0, 0, tocolor(255, 255, 255, hover.alpha));
    end;

    Text(696.29, 650, 57.73, 23.91, 'Entrar', tocolor(255, 255, 255, 255), FONT.login.description.btn_login, 'center', 'top');
end;

local function drawFieldInfo()
    Image(548.44, 714.38, 352.03, 77.34, IMG.login.field_info);
end;

addEventHandler('onClientClick', root, function(button, state)
    if button ~= 'left' or state ~= 'down' then
        return;
    end;

    if UI_STATE.transitioning or UI_STATE.page ~= 'login' then
        return;
    end;

    local username = VAR.Input.Username;
    local password = VAR.Input.Password;
    local remember = VAR.Remember;
    local loginButton = VAR.Button;
    local navigation = VAR.Navigation;

    if isMouseOverButton(username.x, username.y, username.width, username.height) then
        SetInputFocus(username.name);
        return;
    end;

    if isMouseOverButton(password.x, password.y, password.width, password.height) then
        SetInputFocus(password.name);
        return;
    end;

    if isMouseOverButton(remember.x, remember.y, remember.width, remember.height) then
        VAR.cbSelectedStatus = not VAR.cbSelectedStatus;
        return;
    end;

    if isMouseOverButton(loginButton.x, loginButton.y, loginButton.width, loginButton.height) then
        local usernameText = GetInputText(username.name);
        local passwordText = GetInputText(password.name);
        triggerServerEvent('onPlayerLoginRequest', resourceRoot, usernameText, passwordText);
        return;
    end;

    if isMouseOverButton(navigation.Register.x, navigation.Register.y, navigation.Register.width, navigation.Register.height) then
        SetUIPage('register');
        return;
    end;

    if isMouseOverButton(navigation.Recovery.x, navigation.Recovery.y, navigation.Recovery.width, navigation.Recovery.height) then
        SetUIPage('recovery');
        return;
    end;
end);

addEvent('onLoginSuccess', true);

addEventHandler('onLoginSuccess', localPlayer, function()
    if VAR.cbSelectedStatus then
        saveRememberedCredentials(GetInputText(VAR.Input.Username.name), GetInputText(VAR.Input.Password.name));
    else
        clearRememberedCredentials();
    end;

    DestroyInput(VAR.Input.Username.name);
    DestroyInput(VAR.Input.Password.name);

    VAR.inputsInitialized = false;

    showCursor(false);
    UI_STATE.visible = false;
end);

function CreateLoginUI()
    local offsetX, shouldDraw = GetPageTransitionOffset('login');

    if not shouldDraw then
        if UI_STATE.page ~= 'login' and not UI_STATE.transitioning and VAR.inputsInitialized then
            DestroyInput(VAR.Input.Username.name);
            DestroyInput(VAR.Input.Password.name);
            VAR.inputsInitialized = false;
        end;
        return;
    end;

    if not VAR.inputsInitialized then
        initializeLoginInputs();
        VAR.inputsInitialized = true;
    end;

    SetGlobalOffsetX(offsetX);
    drawAvatar();
    drawFieldUserAndPass();
    drawCheckBoxRememberMe();
    drawBar();
    drawButtonLogin();
    drawFieldInfo();
    drawDescription();
    drawSocialMediaIcons();
    drawNavBar();
    drawLabelHeader();
    showCursor(true);
    SetGlobalOffsetX(0);
end;