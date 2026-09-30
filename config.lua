_SHARED = {
    DatabaseType = 'sqlite';
    Labels = {
        Login = {
            description_title = 'TESTE ROLEPLAY';
            description_sub_title = 'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat.';
        };
    };
    Login = {
        MaxAttempts = 5;
        AttemptsWindowMs = 60000;
    };
    Register = {
        MinUsernameLength = 3;
        MaxUsernameLength = 20;
        MinPasswordLength = 6;
        MaxAttempts = 3;
        AttemptsWindowMs = 60000;
        MaxAccountsPerSerial = 3;
        MaxAvatars = 30;
    };
    Recovery = {
        MaxAttempts = 5;
        AttemptsWindowMs = 60000;
    };
}