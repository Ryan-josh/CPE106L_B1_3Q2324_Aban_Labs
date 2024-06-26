USE [master]
GO
/****** Object:  Database [Main]    Script Date: 5/8/2024 10:11:17 AM ******/
CREATE DATABASE [Main]
 CONTAINMENT = NONE
 ON  PRIMARY 
( NAME = N'Main', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL16.MSSQLSERVER01\MSSQL\DATA\Main.mdf' , SIZE = 8192KB , MAXSIZE = UNLIMITED, FILEGROWTH = 65536KB )
 LOG ON 
( NAME = N'Main_log', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL16.MSSQLSERVER01\MSSQL\DATA\Main_log.ldf' , SIZE = 8192KB , MAXSIZE = 2048GB , FILEGROWTH = 65536KB )
 WITH CATALOG_COLLATION = DATABASE_DEFAULT, LEDGER = OFF
GO
ALTER DATABASE [Main] SET COMPATIBILITY_LEVEL = 160
GO
IF (1 = FULLTEXTSERVICEPROPERTY('IsFullTextInstalled'))
begin
EXEC [Main].[dbo].[sp_fulltext_database] @action = 'enable'
end
GO
ALTER DATABASE [Main] SET ANSI_NULL_DEFAULT OFF 
GO
ALTER DATABASE [Main] SET ANSI_NULLS OFF 
GO
ALTER DATABASE [Main] SET ANSI_PADDING OFF 
GO
ALTER DATABASE [Main] SET ANSI_WARNINGS OFF 
GO
ALTER DATABASE [Main] SET ARITHABORT OFF 
GO
ALTER DATABASE [Main] SET AUTO_CLOSE OFF 
GO
ALTER DATABASE [Main] SET AUTO_SHRINK OFF 
GO
ALTER DATABASE [Main] SET AUTO_UPDATE_STATISTICS ON 
GO
ALTER DATABASE [Main] SET CURSOR_CLOSE_ON_COMMIT OFF 
GO
ALTER DATABASE [Main] SET CURSOR_DEFAULT  GLOBAL 
GO
ALTER DATABASE [Main] SET CONCAT_NULL_YIELDS_NULL OFF 
GO
ALTER DATABASE [Main] SET NUMERIC_ROUNDABORT OFF 
GO
ALTER DATABASE [Main] SET QUOTED_IDENTIFIER OFF 
GO
ALTER DATABASE [Main] SET RECURSIVE_TRIGGERS OFF 
GO
ALTER DATABASE [Main] SET  DISABLE_BROKER 
GO
ALTER DATABASE [Main] SET AUTO_UPDATE_STATISTICS_ASYNC OFF 
GO
ALTER DATABASE [Main] SET DATE_CORRELATION_OPTIMIZATION OFF 
GO
ALTER DATABASE [Main] SET TRUSTWORTHY OFF 
GO
ALTER DATABASE [Main] SET ALLOW_SNAPSHOT_ISOLATION OFF 
GO
ALTER DATABASE [Main] SET PARAMETERIZATION SIMPLE 
GO
ALTER DATABASE [Main] SET READ_COMMITTED_SNAPSHOT OFF 
GO
ALTER DATABASE [Main] SET HONOR_BROKER_PRIORITY OFF 
GO
ALTER DATABASE [Main] SET RECOVERY FULL 
GO
ALTER DATABASE [Main] SET  MULTI_USER 
GO
ALTER DATABASE [Main] SET PAGE_VERIFY CHECKSUM  
GO
ALTER DATABASE [Main] SET DB_CHAINING OFF 
GO
ALTER DATABASE [Main] SET FILESTREAM( NON_TRANSACTED_ACCESS = OFF ) 
GO
ALTER DATABASE [Main] SET TARGET_RECOVERY_TIME = 60 SECONDS 
GO
ALTER DATABASE [Main] SET DELAYED_DURABILITY = DISABLED 
GO
ALTER DATABASE [Main] SET ACCELERATED_DATABASE_RECOVERY = OFF  
GO
EXEC sys.sp_db_vardecimal_storage_format N'Main', N'ON'
GO
ALTER DATABASE [Main] SET QUERY_STORE = ON
GO
ALTER DATABASE [Main] SET QUERY_STORE (OPERATION_MODE = READ_WRITE, CLEANUP_POLICY = (STALE_QUERY_THRESHOLD_DAYS = 30), DATA_FLUSH_INTERVAL_SECONDS = 900, INTERVAL_LENGTH_MINUTES = 60, MAX_STORAGE_SIZE_MB = 1000, QUERY_CAPTURE_MODE = AUTO, SIZE_BASED_CLEANUP_MODE = AUTO, MAX_PLANS_PER_QUERY = 200, WAIT_STATS_CAPTURE_MODE = ON)
GO
USE [Main]
GO
/****** Object:  User [AdminTest]    Script Date: 5/8/2024 10:11:18 AM ******/
CREATE USER [AdminTest] FOR LOGIN [AdminTest] WITH DEFAULT_SCHEMA=[dbo]
GO
/****** Object:  DatabaseRole [Consumer]    Script Date: 5/8/2024 10:11:18 AM ******/
CREATE ROLE [Consumer]
GO
/****** Object:  DatabaseRole [Admin]    Script Date: 5/8/2024 10:11:18 AM ******/
CREATE ROLE [Admin]
GO
ALTER ROLE [Admin] ADD MEMBER [AdminTest]
GO
/****** Object:  Table [dbo].[Admin]    Script Date: 5/8/2024 10:11:18 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Admin](
	[AdminID] [varchar](50) NOT NULL,
	[Password] [varchar](50) NULL,
 CONSTRAINT [PK_Admin] PRIMARY KEY CLUSTERED 
(
	[AdminID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Cart]    Script Date: 5/8/2024 10:11:18 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Cart](
	[UserID] [varchar](50) NOT NULL,
	[ItemID] [varchar](50) NOT NULL,
	[Quantity] [tinyint] NOT NULL,
	[Price] [decimal](15, 2) NOT NULL,
	[TotalPrice] [decimal](15, 2) NULL,
	[TotalCartPrice] [decimal](15, 2) NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Item Catalog]    Script Date: 5/8/2024 10:11:18 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Item Catalog](
	[ItemID] [varchar](50) NOT NULL,
	[Price] [decimal](15, 2) NOT NULL,
	[Stock] [tinyint] NOT NULL,
 CONSTRAINT [PK_Item Catalog] PRIMARY KEY CLUSTERED 
(
	[ItemID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Receipt]    Script Date: 5/8/2024 10:11:18 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Receipt](
	[UserID] [varchar](50) NOT NULL,
	[ItemID] [varchar](50) NULL,
	[Quantity] [tinyint] NULL,
	[TotalPrice] [decimal](15, 2) NULL,
	[TotalCartPrice] [decimal](15, 2) NULL,
	[Date] [datetime] NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Transaction]    Script Date: 5/8/2024 10:11:18 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Transaction](
	[TransactionID] [varchar](100) NOT NULL,
	[UserID] [varchar](50) NOT NULL,
	[TransactionItems] [varchar](max) NULL,
	[TransactionPrice] [decimal](15, 2) NULL,
	[TransactionDate] [datetime] NULL,
 CONSTRAINT [PK_Transaction] PRIMARY KEY CLUSTERED 
(
	[TransactionID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[User]    Script Date: 5/8/2024 10:11:18 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[User](
	[UserID] [varchar](50) NOT NULL,
 CONSTRAINT [PK_Testing] PRIMARY KEY CLUSTERED 
(
	[UserID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Cart]  WITH CHECK ADD  CONSTRAINT [FK_Cart_Item Catalog] FOREIGN KEY([ItemID])
REFERENCES [dbo].[Item Catalog] ([ItemID])
ON UPDATE CASCADE
GO
ALTER TABLE [dbo].[Cart] CHECK CONSTRAINT [FK_Cart_Item Catalog]
GO
ALTER TABLE [dbo].[Cart]  WITH NOCHECK ADD  CONSTRAINT [FK_Cart_User] FOREIGN KEY([UserID])
REFERENCES [dbo].[User] ([UserID])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[Cart] NOCHECK CONSTRAINT [FK_Cart_User]
GO
ALTER TABLE [dbo].[Receipt]  WITH CHECK ADD  CONSTRAINT [FK_Receipt_User] FOREIGN KEY([UserID])
REFERENCES [dbo].[User] ([UserID])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[Receipt] CHECK CONSTRAINT [FK_Receipt_User]
GO
/****** Object:  StoredProcedure [dbo].[AdminAddItem]    Script Date: 5/8/2024 10:11:18 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[AdminAddItem]
@ItemID varchar(50),
@ItemDes varchar(max),
@price decimal(15,2),
@stock tinyint,
@RVal INT = NULL OUTPUT 
AS
BEGIN
	IF EXISTS(SELECT 1 FROM [dbo].[Item Catalog] WHERE @ItemID = ItemID)
	BEGIN
		PRINT 'ITEM ALREADY EXISTS'
		SET @RVal = -1
	END
	ELSE
	BEGIN
		INSERT INTO [dbo].[Item Catalog] (ItemID, ItemDescription, Price, Stock) VALUES (@ItemID,@ItemDes,@price,@stock)
		SET @RVal = 0
	END
END
GO
/****** Object:  StoredProcedure [dbo].[AdminCreateAccount]    Script Date: 5/8/2024 10:11:18 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[AdminCreateAccount]
    @adminID varchar(50),
	@password varchar(50)
AS
BEGIN
    DECLARE @SQL NVARCHAR(MAX) = N'';

    IF NOT EXISTS(SELECT 1 FROM dbo.[Admin] WHERE AdminID = @adminID)
    BEGIN
        SET @SQL = N'CREATE LOGIN ' + QUOTENAME(@adminID) + N' WITH PASSWORD = ''' + @password + N''', DEFAULT_DATABASE=[master], DEFAULT_LANGUAGE=[us_english];';
        EXEC sp_executesql @SQL;

        SET @SQL = N'CREATE USER ' + QUOTENAME(@adminID) + N' FOR LOGIN ' + QUOTENAME(@adminID) + N';';
        EXEC sp_executesql @SQL;

        SET @SQL = N'EXEC sp_addrolemember ''Admin'', ' + QUOTENAME(@adminID) + N';';
        EXEC sp_executesql @SQL;

		INSERT INTO [dbo].[Admin] (AdminID, Password) VALUES (@adminID, @password)

        PRINT 'Admin created with specified password and Admin role';
    END
    ELSE
    BEGIN
        PRINT 'Admin ID already exists';
    END
END

GO
/****** Object:  StoredProcedure [dbo].[AdminDeleteItem]    Script Date: 5/8/2024 10:11:18 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[AdminDeleteItem]
@ItemID varchar(50),
@Rval INT = NULL OUTPUT
AS
BEGIN
	IF EXISTS(SELECT 1 FROM DBO.[Item Catalog] WHERE ItemID = @ItemID)
	BEGIN
		DELETE FROM DBO.[Item Catalog] WHERE ItemID = @ItemID;
		PRINT 'ITEM SUCCESSFULLY DELETED'
		SET @Rval = 0
	END
	ELSE
	BEGIN
		PRINT 'ITEM DOES NOT EXIST'
		SET @Rval = -1;
	END
END
GO
/****** Object:  StoredProcedure [dbo].[AdminEditAccount]    Script Date: 5/8/2024 10:11:18 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[AdminEditAccount]
    @newPassword VARCHAR(50)
AS
BEGIN
    DECLARE @adminID VARCHAR(50)
    SET @adminID = SUSER_NAME();

    DECLARE @sql NVARCHAR(MAX)
    SET @sql = 'ALTER LOGIN ' + QUOTENAME(@adminID) + ' WITH PASSWORD = ''' + @newPassword + ''''

    IF EXISTS(SELECT * FROM dbo.[Admin] WHERE AdminID = @adminID)
    BEGIN
        UPDATE dbo.[Admin]
        SET Password = @newPassword
        WHERE AdminID = @adminID;

        EXEC sp_executesql @sql

        PRINT 'Password updated successfully.';
    END
    ELSE
    BEGIN
        PRINT 'AdminID not found.';
    END
END;
GO
/****** Object:  StoredProcedure [dbo].[AdminEditItem]    Script Date: 5/8/2024 10:11:18 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[AdminEditItem]
    @OldItemID VARCHAR(50),
    @NewItemID VARCHAR(50) = NULL,
    @Price DECIMAL(15, 2) = NULL,
    @Stock TINYINT = NULL,
    @Rval INT = NULL OUTPUT
AS
BEGIN
    IF EXISTS(SELECT 1 FROM DBO.[Item Catalog] WHERE ItemID = @OldItemID)
    BEGIN
        DECLARE @HasChanges BIT = 0;
        IF @NewItemID IS NOT NULL OR @Price IS NOT NULL OR @Stock IS NOT NULL
        BEGIN
            UPDATE DBO.[Item Catalog]
            SET 
                ItemID = COALESCE(@NewItemID, ItemID),
                Price = COALESCE(@Price, Price),
                Stock = COALESCE(@Stock, Stock)
            WHERE ItemID = @OldItemID;
            SET @Rval = 0;
            PRINT 'Item edited successfully';
            SET @HasChanges = 1;
        END

        IF @HasChanges = 0
        BEGIN
            SET @Rval = -2;
            PRINT 'No changes provided';
        END
    END
    ELSE
    BEGIN
        SET @Rval = -1;
        PRINT 'ItemID does not exist';
    END
END
GO
/****** Object:  StoredProcedure [dbo].[AdminViewHistory]    Script Date: 5/8/2024 10:11:18 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[AdminViewHistory]
    @userID VARCHAR(50) = NULL
AS
BEGIN
    IF @userID IS NOT NULL
    BEGIN
        IF EXISTS(SELECT * FROM dbo.[Transaction] WHERE UserID = @userID)
        BEGIN
            SELECT * FROM dbo.[Transaction] WHERE UserID = @userID;
        END
        ELSE
        BEGIN
            PRINT 'ID NOT FOUND'
        END
    END
    ELSE
    BEGIN
        SELECT * FROM dbo.[Transaction];
    END
END;
GO
/****** Object:  StoredProcedure [dbo].[DeleteAdminAccount]    Script Date: 5/8/2024 10:11:18 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[DeleteAdminAccount]
    @AdminID VARCHAR(128)
AS
BEGIN
    IF EXISTS (SELECT 1 FROM [dbo].[Admin] WHERE AdminID = @AdminID)
    BEGIN
        DELETE FROM [dbo].[Admin] WHERE AdminID = @AdminID;
        PRINT 'Admin deleted from the database table';
    END
    ELSE
    BEGIN
        PRINT 'Admin does not exist in the database table';
    END

    IF EXISTS (SELECT 1 FROM sys.server_principals WHERE name = @AdminID AND type = 'S')
    BEGIN
        DECLARE @DropLoginSQL NVARCHAR(200);
        SET @DropLoginSQL = N'DROP LOGIN ' + QUOTENAME(@AdminID) + ';';
        EXEC sp_executesql @DropLoginSQL;
        PRINT 'Login dropped from the server';
    END
    ELSE
    BEGIN
        PRINT 'Login does not exist on the server';
    END
END
GO
/****** Object:  StoredProcedure [dbo].[DeleteUserAccount]    Script Date: 5/8/2024 10:11:18 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[DeleteUserAccount]
AS
BEGIN
	DECLARE @UserID VARCHAR(50);
	SET @UserID = SUSER_NAME();
    IF EXISTS (SELECT 1 FROM [dbo].[User] WHERE UserID = @UserID)
    BEGIN
        DELETE FROM [dbo].[User] WHERE UserID = @UserID;
        DELETE FROM [dbo].[Cart] WHERE UserID = @UserID;
        DELETE FROM [dbo].[Receipt] WHERE UserID = @UserID;
        PRINT 'User deleted from the database tables';
    END
    ELSE
    BEGIN
        PRINT 'User does not exist in the database tables';
    END

    DECLARE @DropUserSQL NVARCHAR(200);
    SET @DropUserSQL = N'DROP USER ' + QUOTENAME(@UserID) + ';';
    EXEC sp_executesql @DropUserSQL;
    PRINT 'User dropped from the database';

    DECLARE @DropLoginSQL NVARCHAR(200);
    SET @DropLoginSQL = N'DROP LOGIN ' + QUOTENAME(@UserID) + ';';
    EXEC sp_executesql @DropLoginSQL;
    PRINT 'Login dropped from the server';
END
GO
/****** Object:  StoredProcedure [dbo].[ReceiptHistory]    Script Date: 5/8/2024 10:11:18 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[ReceiptHistory]
AS
BEGIN
    SET NOCOUNT ON;

    INSERT INTO dbo.[Transaction] (TransactionID, UserID, TransactionItems, TransactionPrice, TransactionDate)
    SELECT 
        CONCAT(UserID, '_', FORMAT(GETDATE(), 'yyyyMMddHHmmss'), '_', NEWID()), 
        UserID, 
        STUFF((SELECT ', ' + ItemID + ' ' + CAST(Quantity AS VARCHAR(10)) 
               FROM dbo.Receipt AS r2 
               WHERE r2.UserID = r.UserID 
               FOR XML PATH('')), 1, 2, ''), 
        SUM(TotalPrice), -- Change TotalPrice to SUM(TotalPrice)
        MAX(Date)
    FROM dbo.Receipt AS r
    GROUP BY UserID, TotalCartPrice; -- Add TotalCartPrice to the GROUP BY clause
END;
GO
/****** Object:  StoredProcedure [dbo].[UserAddToCart]    Script Date: 5/8/2024 10:11:18 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[UserAddToCart]
    @ItemID VARCHAR(50),
    @Quantity TINYINT,
    @Rval INT = NULL OUTPUT
AS 
BEGIN
	DECLARE @UserID VARCHAR(50)
	SET @UserID = SUSER_NAME();
    DECLARE @AvailStock INT;
    DECLARE @Price DECIMAL(15, 2);
    DECLARE @TotalPrice DECIMAL(15, 2);
    DECLARE @TotalCartPrice DECIMAL(15, 2);

    IF EXISTS (SELECT 1 FROM [dbo].[User] WHERE @UserID = UserID)
    BEGIN
        IF EXISTS (SELECT 1 FROM [dbo].[Item Catalog] WHERE @ItemID = ItemID)
        BEGIN
            SELECT @AvailStock = Stock, @Price = Price FROM [dbo].[Item Catalog] WHERE ItemID = @ItemID;

            IF @Quantity > 0
            BEGIN
                IF @Quantity <= @AvailStock
                BEGIN
                    SET @TotalPrice = @Quantity * @Price;

                    IF NOT EXISTS (SELECT 1 FROM [dbo].[Cart] WHERE UserID = @UserID AND ItemID = @ItemID)
                    BEGIN
                        INSERT INTO [dbo].[Cart] (UserID, ItemID, Quantity, Price, TotalPrice) 
                        VALUES (@UserID, @ItemID, @Quantity, @Price, @TotalPrice);

                        SELECT @TotalCartPrice = SUM(TotalPrice)
                        FROM [dbo].[Cart]
                        WHERE UserID = @UserID;

                        UPDATE [dbo].[Cart]
                        SET TotalCartPrice = @TotalCartPrice
                        WHERE UserID = @UserID;

                        SET @Rval = 0;
                    END
                    ELSE
                    BEGIN
                        PRINT 'THE USER ALREADY HAS THAT ITEM';
                        SET @Rval = -5;
                    END
                END
                ELSE
                BEGIN
                    PRINT 'NOT ENOUGH STOCK';
                    SET @Rval = -3;
                END
            END
            ELSE
            BEGIN
                PRINT 'Quantity must be higher than 0';
                SET @Rval = -4;
            END
        END
        ELSE
        BEGIN
            PRINT 'ITEM DOES NOT EXIST';
            SET @Rval = -2;
        END 
    END
    ELSE
    BEGIN
        PRINT 'USER DOES NOT EXIST';
        SET @Rval = -1;
    END
END;
GO
/****** Object:  StoredProcedure [dbo].[UserCheckOut]    Script Date: 5/8/2024 10:11:18 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[UserCheckOut]
	@Rval INT = NULL OUTPUT
AS
BEGIN
	DECLARE @userID VARCHAR(50)
	SET @userID = SUSER_NAME();
    IF NOT EXISTS (SELECT 1 FROM dbo.receipt WHERE UserID = @userID AND CONVERT(DATE, Date) = CONVERT(DATE, GETDATE()))
    BEGIN
        INSERT INTO dbo.receipt (UserID, ItemID, Quantity, TotalPrice, TotalCartPrice, Date)
        SELECT @userID, ItemID, Quantity, TotalPrice,
               (SELECT SUM(TotalPrice) FROM dbo.cart WHERE userID = @userID),
               GETDATE()
        FROM (
            SELECT DISTINCT ItemID, Quantity, TotalPrice
            FROM dbo.cart
            WHERE userID = @userID
        ) AS DistinctItems;

        UPDATE dbo.[Item Catalog]
        SET Stock = Stock - c.Quantity
        FROM dbo.cart c
        INNER JOIN dbo.[Item Catalog] ON c.ItemID = dbo.[Item Catalog].ItemID
        WHERE c.userID = @userID;
		SET @Rval = 0;
		EXECUTE ReceiptHistory 
		EXECUTE UserViewReceipt @userID
		EXECUTE DeleteUserAccount @userID
    END
    ELSE
    BEGIN
        PRINT 'Receipt already generated for User ' + @userID + ' today.';
		SET @Rval = -1;
    END
END;
GO
/****** Object:  StoredProcedure [dbo].[UserCreateAccount]    Script Date: 5/8/2024 10:11:18 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[UserCreateAccount]
    @UserID VARCHAR(128)
AS
BEGIN
    IF NOT EXISTS(SELECT 1 FROM [dbo].[User] WHERE @UserID = UserID)
    BEGIN
        INSERT INTO dbo.[User] (UserID) VALUES (@UserID);

        DECLARE @CreateLoginSQL NVARCHAR(200) = 'CREATE LOGIN ' + QUOTENAME(@UserID) + ' WITH PASSWORD = ''Tite'';';
        EXEC sp_executesql @CreateLoginSQL;

        DECLARE @AddUserSQL NVARCHAR(200) = 'CREATE USER ' + QUOTENAME(@UserID) + ' FOR LOGIN ' + QUOTENAME(@UserID) + ';';
        EXEC sp_executesql @AddUserSQL;

        DECLARE @AssignRoleSQL NVARCHAR(200) = 'ALTER ROLE Consumer ADD MEMBER ' + QUOTENAME(@UserID) + ';';
        EXEC sp_executesql @AssignRoleSQL;

        DECLARE @GrantRoleSQL NVARCHAR(200) = 'USE master; ALTER SERVER ROLE Consumer ADD MEMBER ' + QUOTENAME(@UserID) + ';';
        EXEC sp_executesql @GrantRoleSQL;

        PRINT 'User created with login and assigned to the Consumer role';
    END
    ELSE
    BEGIN
        PRINT 'User already exists';
    END
END
GO
/****** Object:  StoredProcedure [dbo].[UserEditCart]    Script Date: 5/8/2024 10:11:18 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[UserEditCart]
    @ItemID VARCHAR(50),
    @QuantityToAdd INT,
    @Rval INT = NULL OUTPUT
AS
BEGIN
	DECLARE @userID VARCHAR(50)
	SET @userID = SUSER_NAME();
    DECLARE @Price DECIMAL(15, 2)
    DECLARE @AvailableStock INT

    SELECT @Price = Price,
           @AvailableStock = Stock
    FROM [dbo].[Item Catalog]
    WHERE ItemID = @ItemID

    IF NOT EXISTS (SELECT 1 FROM [dbo].[Cart] WHERE UserID = @UserID)
    BEGIN
        SET @Rval = -1
        PRINT 'UserID does not exist'
        RETURN
    END

    IF NOT EXISTS (SELECT 1 FROM [dbo].[Item Catalog] WHERE ItemID = @ItemID)
    BEGIN
        SET @Rval = -2
        PRINT 'ItemID does not exist'
        RETURN
    END

    IF EXISTS (SELECT 1 FROM [dbo].[Cart] WHERE UserID = @UserID AND ItemID = @ItemID)
    BEGIN
        DECLARE @CurrentQuantity INT
        SELECT @CurrentQuantity = Quantity
        FROM [dbo].[Cart]
        WHERE UserID = @UserID AND ItemID = @ItemID

        DECLARE @NewQuantity INT
        SET @NewQuantity = @CurrentQuantity + @QuantityToAdd

        IF @NewQuantity <= @AvailableStock AND @NewQuantity >= 0
        BEGIN
            UPDATE [dbo].[Cart]
            SET Quantity = @NewQuantity
            WHERE UserID = @UserID AND ItemID = @ItemID
            SET @Rval = CASE 
                            WHEN @QuantityToAdd > 0 THEN 0
                            WHEN @QuantityToAdd < 0 THEN 1
                            ELSE @Rval
                        END
            IF @NewQuantity = 0
            BEGIN
                DELETE FROM [dbo].[Cart]
                WHERE UserID = @UserID AND ItemID = @ItemID
                SET @Rval = 2
                PRINT 'Item Removed'
            END
            ELSE
            BEGIN
                PRINT 'Quantity ' + CASE 
                                    WHEN @QuantityToAdd > 0 THEN 'added'
                                    WHEN @QuantityToAdd < 0 THEN 'decreased'
                                    ELSE ''
                                    END
            END
        END
        ELSE IF @NewQuantity < 0
        BEGIN
            DELETE FROM [dbo].[Cart]
            WHERE UserID = @UserID AND ItemID = @ItemID
            SET @Rval = 2
            PRINT 'Item Removed'
        END
        ELSE
        BEGIN
            SET @Rval = -3
            PRINT 'Cannot add more than available stock'
        END
    END
    ELSE
    BEGIN
        IF @QuantityToAdd <= @AvailableStock
        BEGIN
            INSERT INTO [dbo].[Cart] (UserID, ItemID, Quantity)
            VALUES (@UserID, @ItemID, @QuantityToAdd)
            SET @Rval = 0
            PRINT 'Quantity added'
        END
        ELSE
        BEGIN
            SET @Rval = -3
            PRINT 'Cannot add more than available stock'
        END
    END

	UPDATE [dbo].[Cart]
    SET TotalPrice = Quantity * @Price,
        TotalCartPrice = (
                          SELECT SUM(Quantity * Price) 
                          FROM [dbo].[Cart] c
                          WHERE c.UserID = @UserID
                        )
    WHERE UserID = @UserID AND ItemID = @ItemID;
END
GO
/****** Object:  StoredProcedure [dbo].[UserSearchItem]    Script Date: 5/8/2024 10:11:18 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[UserSearchItem]
    @searchTerm VARCHAR(MAX) = NULL
AS
BEGIN
    IF @searchTerm IS NULL
    BEGIN
        SELECT * FROM dbo.[Item Catalog];
    END
    ELSE
    BEGIN
        SELECT * 
        FROM dbo.[Item Catalog]
        WHERE ItemID LIKE '%' + @searchTerm + '%';
    END
END;
GO
/****** Object:  StoredProcedure [dbo].[UserViewCart]    Script Date: 5/8/2024 10:11:18 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[UserViewCart]
    @Rval INT = NULL OUTPUT
AS
BEGIN
	DECLARE @userID VARCHAR(50)
	SET @userID = SUSER_NAME();
    SET NOCOUNT ON;
    IF EXISTS (SELECT 1 FROM [dbo].[User] WHERE UserID = @UserID)
    BEGIN
        -- Fetch the total cart price from the Cart table for the given user
        DECLARE @TotalCartPrice decimal(15,2);
        SELECT @TotalCartPrice = TotalCartPrice FROM [dbo].[Cart] WHERE UserID = @UserID;

        -- Output individual items in the cart along with their total prices and the total price of the entire cart
        SELECT 
            ItemID, 
            Quantity, 
            Price, 
            TotalPrice,
            @TotalCartPrice AS TotalCartPrice
        FROM 
            [dbo].[Cart]
        WHERE 
            UserID = @UserID;

		SET @Rval = 0;
    END
    ELSE
    BEGIN
        PRINT 'USER NOT FOUND';
		SET @Rval = -1;
    END
END;
GO
/****** Object:  StoredProcedure [dbo].[UserViewReceipt]    Script Date: 5/8/2024 10:11:18 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[UserViewReceipt]
    @Rval INT = NULL OUTPUT
AS
BEGIN
    SET NOCOUNT ON;
	DECLARE @userID VARCHAR(50)
	SET @userID = SUSER_NAME();
    IF EXISTS (SELECT 1 FROM [dbo].[User] WHERE UserID = @UserID)
    BEGIN
        DECLARE @TotalCartPrice DECIMAL(15,2);
        SELECT @TotalCartPrice = MAX(TotalCartPrice) FROM [dbo].[Receipt] WHERE UserID = @UserID;

        SELECT 
            CASE WHEN ROW_NUMBER() OVER (PARTITION BY UserID ORDER BY Date) = 1 THEN UserID ELSE '' END AS UserID,
            ItemID, 
            Quantity, 
            TotalPrice, 
            CASE WHEN ROW_NUMBER() OVER (PARTITION BY UserID ORDER BY Date) = 1 THEN @TotalCartPrice ELSE NULL END AS TotalCartPrice,
            CASE WHEN ROW_NUMBER() OVER (PARTITION BY UserID ORDER BY Date) = 1 THEN CONVERT(VARCHAR(10), Date, 120) ELSE NULL END AS Date
        FROM 
            [dbo].[Receipt]
        WHERE 
            UserID = @UserID;

        SET @Rval = 0;
    END
    ELSE
    BEGIN
        PRINT 'USER NOT FOUND';
        SET @Rval = -1;
    END
END;
GO
USE [master]
GO
ALTER DATABASE [Main] SET  READ_WRITE 
GO
