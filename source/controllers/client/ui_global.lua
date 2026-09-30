AVATAR = {
    id = 1;
    max = 30;
};

local VAR = {
    Character = {
        startTick = nil;
        x = 1095;
        y = 0;
        width = 828;
        height = 1206;
        entranceDistance = 60;
        floatSpeed = 1.2;
        floatDistance = 8;
        parallaxDistance = 20;
    };
    Navigation = {
        Labels = {
            login = 'Login';
            register = 'Registrar';
            recovery = 'Recuperar';
        };
        Rect = {
            login = {x = 826.47; y = 953; w = 56.25; h = 30.94};
            register = {x = 923.91; y = 953.44; w = 56.25; h = 30.94};
            recovery = {x = 1030.78; y = 953.44; w = 56.25; h = 30.94};
        };
        Icons = {
            login = {x = 846.47; y = 960; w = 16; h = 18; icon = IMG.geral.navbar.login};
            register = {x = 942.19; y = 960; w = 19.69; h = 19.69; icon = IMG.geral.navbar.register};
            recovery = {x = 1050.82; y = 960; w = 16.17; h = 17.81; icon = IMG.geral.navbar.recovery};
        };
        Order = {'login', 'register', 'recovery'};
    };
    Social = {
        y = 615.94;
        size = 42.19;
        Icons = {
            {id = 'twitter', x = 1081.41, icon = IMG.geral.social.twitter, iconW = 19.69, iconH = 19.69};
            {id = 'instagram', x = 1137.66, icon = IMG.geral.social.instagram, iconW = 22.5, iconH = 22.5};
            {id = 'youtube', x = 1193.91, icon = IMG.geral.social.youtube, iconW = 25.31, iconH = 25.31};
            {id = 'discord', x = 1250.16, icon = IMG.geral.social.discord, iconW = 22.5, iconH = 22.5};
        };
    };
    Description = {
        Title = {x = 1050, y = 421, width = 278, height = 38};
        Subtitle = {x = 999.84, y = 475.31, width = 372.66, height = 100};
    };
};

function ResetCharacterAnimation()
    VAR.Character.startTick = getTickCount();
    Animations['character_entrance'] = nil;
    Animations['character_parallax_x'] = nil;
    Animations['character_parallax_y'] = nil;
end;

function drawBackgroundGeneral()
    ImageFull(0, 0, 1920, 1080, IMG.geral.background);

    if not VAR.Character.startTick then
        VAR.Character.startTick = getTickCount();
    end;

    local entrance = Animate('character_entrance', 1, 0.06);
    local entranceEased = easeOutQuad(entrance);
    local entranceOffsetY = (1 - entranceEased) * VAR.Character.entranceDistance;
    local entranceAlpha = entranceEased * 255;
    local elapsed = (getTickCount() - VAR.Character.startTick) / 1000;
    local floatOffsetY = math.sin(elapsed * VAR.Character.floatSpeed) * VAR.Character.floatDistance;

    local mx, my = getCursorPosition();
    mx, my = mx or 0.5, my or 0.5;

    local targetParallaxX = (mx - 0.5) * VAR.Character.parallaxDistance;
    local targetParallaxY = (my - 0.5) * VAR.Character.parallaxDistance;

    local parallaxX = Animate('character_parallax_x', targetParallaxX, 0.05);
    local parallaxY = Animate('character_parallax_y', targetParallaxY, 0.05);

    local finalX = VAR.Character.x + parallaxX;
    local finalY = VAR.Character.y + entranceOffsetY + floatOffsetY + parallaxY;

    Image(finalX, finalY, VAR.Character.width, VAR.Character.height, IMG.geral.character, 0, 0, 0, tocolor(255, 255, 255, entranceAlpha));
end;

function drawNavBar()
    for _, id in ipairs(VAR.Navigation.Order) do
        local rect = VAR.Navigation.Rect[id];
        local icon = VAR.Navigation.Icons[id];

        local hover = HoverEffect('navbar_' .. id, rect.x, rect.y, rect.w, rect.h, {
            alphaNormal = 0;
            alphaHover = 255;
            alphaSelected = 255;
            scaleNormal = 1;
            scaleActive = 1;
            speed = 0.18;
        });

        local lift = Animate('navbar_' .. id .. '_lift', hover.isHovered and -6 or 0, 0.1);

        if hover.alpha > 1 then
            Image(rect.x, rect.y + lift, rect.w, rect.h, IMG.geral.navbar.rect, 0, 0, 0, tocolor(255, 255, 255, hover.alpha));
        end;

        local iconAlpha = 140 + (hover.alpha * (255 - 140) / 255);

        Image(icon.x, icon.y + lift, icon.w, icon.h, icon.icon, 0, 0, 0, tocolor(255, 255, 255, iconAlpha));

        Text(icon.x - 20, icon.y + icon.h + 6 + lift, icon.w + 40, 16, VAR.Navigation.Labels[id], tocolor(255, 255, 255, iconAlpha), FONT.lblHeaderDescription, 'center', 'top');
    end;
end;

function drawSocialMediaIcons()
    for _, data in ipairs(VAR.Social.Icons) do
        local hover = HoverEffect('social_' .. data.id, data.x, VAR.Social.y, VAR.Social.size, VAR.Social.size, {
            alphaNormal = 150;
            alphaHover = 255;
            alphaSelected = 255;
            scaleNormal = 1;
            scaleActive = 1.20;
            speed = 0.20;
        });

        local floatY = 0;

        if hover.isHovered then
            floatY = math.sin(getTickCount() / 120) * 2;
        end;

        local finalSize = VAR.Social.size * hover.scale;
        local offset = (finalSize - VAR.Social.size) / 2;
        local posX = data.x - offset;
        local posY = VAR.Social.y - offset + floatY;
        local bg = hover.isHovered and IMG.geral.social.bg_social or IMG.geral.social.bg_social_not_selected;

        if bg then
            Image(posX, posY, finalSize, finalSize, bg, 0, 0, 0, tocolor(255, 255, 255, hover.alpha));
        end;

        if data.icon then
            local iconScale = hover.scale;
            local iconW = data.iconW * iconScale;
            local iconH = data.iconH * iconScale;
            local iconX = data.x + ((VAR.Social.size - iconW) / 2);
            local iconY = VAR.Social.y + ((VAR.Social.size - iconH) / 2) + floatY;

            Image(iconX, iconY, iconW, iconH, data.icon);
        end;
    end;
end;

function drawAvatar()
    Image(548.44, 299.53, 70, 70, 'assets/images/avatars/' .. AVATAR.id .. '.png');
end;

function drawDescription()
    Text(VAR.Description.Title.x, VAR.Description.Title.y, VAR.Description.Title.width, VAR.Description.Title.height, _SHARED.Labels.Login.description_title, tocolor(255, 255, 255, 255), FONT.login.description.title, 'center', 'top');

    Text(VAR.Description.Subtitle.x, VAR.Description.Subtitle.y, VAR.Description.Subtitle.width, VAR.Description.Subtitle.height, _SHARED.Labels.Login.description_sub_title, tocolor(255, 255, 255, 50), FONT.login.description.sub_title, 'center', 'top', false, true);
end;

function drawInputCaret(id, designX, designY, height, displayText, font)
    if GetActiveInput() ~= id then
        return;
    end;

    local blinkOn = (math.floor(getTickCount() / 500) % 2) == 0;

    if not blinkOn then
        return;
    end;

    local textWidthDesign = 0;

    if displayText ~= '' then
        local fontEl = isElement(font) and font or LoadFont(font.name, font.size, false, 'cleartype');
        textWidthDesign = dxGetTextWidth(displayText, 1, fontEl) / GetScaleValue();
    end;

    Text(designX + textWidthDesign + 2, designY, 20, height, '|', tocolor(255, 255, 255, 255), font, 'left', 'center');
end;