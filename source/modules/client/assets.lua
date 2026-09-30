IMG = {
    geral = {
        background = 'assets/images/background_all.png';
        character = 'assets/images/character.png';
        avatars = 'assets/images/avatars/1.png';
        eye = 'assets/images/ic_eye.png';
        navbar = {
            login = 'assets/images/login/nav_ic_login.png';
            register = 'assets/images/login/nav_ic_register.png';
            recovery = 'assets/images/login/nav_ic_recovery.png';
            rect = 'assets/images/login/nav_rect.png';
        };
        social = {
            twitter = 'assets/images/login/ic_twitter.png';
            youtube = 'assets/images/login/ic_youtube.png';
            discord = 'assets/images/login/ic_discord.png';
            instagram = 'assets/images/login/ic_instagram.png';
            bg_social = 'assets/images/login/bg_social_media.png';
            bg_social_not_selected = 'assets/images/login/bg_social_media_not_selected.png';
        };
    };
    login = {
        bar = 'assets/images/login/bar.png';
        f_user_icon = 'assets/images/login/field_icon_user.png';
        f_pass_icon = 'assets/images/login/field_icon_pass.png';
        separator = 'assets/images/login/sep_user_pass.png';
        bg_mini_field_login = 'assets/images/login/field_mini_rect.png';
        bg_field = 'assets/images/login/field_rectangle.png';
        field_info = 'assets/images/login/field_info.png';
        button_login = 'assets/images/login/btn_connect.png';
        button_login_not_selected = 'assets/images/login/btn_connect_not_selected.png';
        cbRemember = 'assets/images/login/checkbox_remember.png';
        cbRememberNotSelected = 'assets/images/login/checkbox_remember_not_selected.png';
    };
    register = {
        arrow_left = 'assets/images/register/ic_arrow_left.png';
        arrow_right = 'assets/images/register/ic_arrow_right.png';
        rect_arrow_not_selected = 'assets/images/register/rect_arrow_not_selected.png';
        rect_arrow_selected = 'assets/images/register/rect_arrow_selected.png';
    };
    recovery = {
        profile = 'assets/images/recovery/profile.png';
        bg_rect_accounts = 'assets/images/recovery/bg_rect_accounts.png';
        rect_selected_account = 'assets/images/recovery/rect_selected_account.png';
    };
}

FONT = {
    lblHeaderTitle = LoadFont('heavy', 19);
    lblHeaderDescription = LoadFont('medium', 15.47);
    login = {
        description = {
            title = LoadFont('heavy', 32);
            sub_title = LoadFont('medium', 13);
            btn_login = LoadFont('heavy', 19.69)
        };
    };
    recovery = {
        title = LoadFont('heavy', 14);
        sub_title = LoadFont('medium', 11);
        account_title = LoadFont('bold', 13);
        account = LoadFont('medium', 11);
    }
}