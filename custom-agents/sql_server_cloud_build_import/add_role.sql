USE {{DATABASE_NAME}};

IF NOT EXISTS (SELECT * FROM sys.database_principals WHERE name = '{{USERNAME}}')
BEGIN
    CREATE USER [{{USERNAME}}] FOR LOGIN [{{USERNAME}}];
END
GO

-- Check if the user exists in the database
IF EXISTS (SELECT 1 FROM sys.database_principals WHERE name = '{{USERNAME}}')
BEGIN    
    -- Add the user to the db_owner role
    EXEC sp_addrolemember 'db_owner', '{{USERNAME}}';
    PRINT 'Added {{USERNAME}} to db_owner role.';
END
ELSE
BEGIN
    PRINT 'User {{USERNAME}} does not exist in the database.';
END
