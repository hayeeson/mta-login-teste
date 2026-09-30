Database = {
    Connection = nil;
};

function Database.query(callback, query, ...)
    if not Database.Connection then
        print('[DATABASE] Conexão não inicializada.');
        return false;
    end;
    return dbQuery(callback, Database.Connection, query, ...);
end;

function Database.exec(query, ...)
    if not Database.Connection then
        print('[DATABASE] Conexão não inicializada.');
        return false;
    end;
    return dbExec(Database.Connection, query, ...);
end;

function Database.poll(queryHandle)
    if not queryHandle then
        return false;
    end;
    return dbPoll(queryHandle, 0);
end;

function ConnectSQLite()
    local connection = dbConnect('sqlite', 'database.db');

    if not connection then
        print('[DATABASE] Não foi possível conectar ao SQLite.');
        return false;
    end;

    print('[DATABASE] Conectado ao SQLite com sucesso.');
    return connection;
end;

function InitializeSQLite(connection)
    if not connection then
        return false;
    end;

    local success = dbExec(connection, [[
        CREATE TABLE IF NOT EXISTS accounts (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            username TEXT NOT NULL UNIQUE COLLATE NOCASE,
            password_hash TEXT NOT NULL,
            serial TEXT NOT NULL,
            avatar INTEGER NOT NULL DEFAULT 1,
            created_at INTEGER NOT NULL
        )
    ]]);

    if not success then
        print('[DATABASE] Não foi possível inicializar a tabela accounts.');
        return false;
    end;

    print('[DATABASE] Tabela accounts verificada com sucesso.');
    return true;
end;

function ConnectMySQL()
    local connectionString = 'dbname=' .. MySQLConfig.Database .. ';host=' .. MySQLConfig.Host .. ';port=' .. MySQLConfig.Port .. ';charset=' .. MySQLConfig.Charset;
    local connection = dbConnect('mysql', connectionString, MySQLConfig.Username, MySQLConfig.Password, 'share=1');

    if not connection then
        print('[DATABASE] Não foi possível conectar ao MySQL.');
        return false;
    end;

    print('[DATABASE] Conectado ao MySQL com sucesso.');
    return connection;
end;

function InitializeMySQL(connection)
    if not connection then
        return false;
    end;

    local success = dbExec(connection, [[
        CREATE TABLE IF NOT EXISTS accounts (
            id INT UNSIGNED NOT NULL AUTO_INCREMENT,
            username VARCHAR(20) NOT NULL,
            password_hash VARCHAR(255) NOT NULL,
            serial VARCHAR(64) NOT NULL,
            avatar INT NOT NULL DEFAULT 1,
            created_at INT NOT NULL,
            PRIMARY KEY (id),
            UNIQUE KEY unique_username (username),
            INDEX idx_serial (serial),
            INDEX idx_username (username)
        ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci
    ]]);

    if not success then
        print('[DATABASE] Não foi possível inicializar a tabela accounts.');
        return false;
    end;

    print('[DATABASE] Tabela accounts verificada com sucesso.');
    return true;
end;

addEventHandler('onResourceStart', resourceRoot, function()
    if _SHARED.DatabaseType == 'sqlite' then
        Database.Connection = ConnectSQLite();

        if Database.Connection then
            InitializeSQLite(Database.Connection);
        end;

    elseif _SHARED.DatabaseType == 'mysql' then
        Database.Connection = ConnectMySQL();

        if Database.Connection then
            InitializeMySQL(Database.Connection);
        end;

    else
        print('[DATABASE] Tipo de banco inválido: ' .. tostring(_SHARED.DatabaseType));
    end;
end);