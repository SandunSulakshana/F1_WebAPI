IF NOT(EXISTS(SELECT * FROM sys.Tables WHERE Name = 'Driver'))
BEGIN
    CREATE TABLE [dbo].[Driver](
	    [DriverID] [int] IDENTITY(1,1) NOT NULL,
	    [DriverNm] [varchar](250) NOT NULL,
	    [DriverAge] [int] NOT NULL,
	    [NationalityID] [int] NOT NULL,
	    [CreatedDate] [datetime] NOT NULL,
	    [UpdatedDate] [datetime] NULL,
	    [ImageID] [varchar](250) NULL,
	    [TeamID] [int] NULL
    ) ON [PRIMARY]
END
GO

IF NOT(EXISTS(SELECT * FROM sys.Tables WHERE Name = 'Race'))
BEGIN
    CREATE TABLE [dbo].[Race](
	    [RaceID] [int] IDENTITY(1,1) NOT NULL,
	    [WinnerID] [int] NOT NULL,
	    [WinnerTime] [datetime] NOT NULL,
	    [GrandPixID] [int] NOT NULL,
	    [Laps] [int] NOT NULL,
	    [CreatedDate] [datetime] NOT NULL,
	    [UpdatedDate] [datetime] NULL,
	    [CarID] [int] NULL,
     CONSTRAINT [PK_Race] PRIMARY KEY CLUSTERED 
    (
	    [RaceID] ASC
    )WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
    ) ON [PRIMARY]
END
GO

IF NOT(EXISTS(SELECT * FROM sys.Tables WHERE Name = 'Team'))
BEGIN
    CREATE TABLE [dbo].[Team](
	    [TeamID] [int] IDENTITY(1,1) NOT NULL,
	    [ManufacturerID] [int] NOT NULL,
	    [DriverFirstID] [int] NOT NULL,
	    [DriverSecondID] [int] NOT NULL,
	    [Image] [varchar](500) NOT NULL,
	    [CreatedDate] [datetime] NOT NULL,
	    [UpdatedDate] [datetime] NULL,
	    [TeamNm] [varchar](250) NOT NULL,
     CONSTRAINT [PK_Team] PRIMARY KEY CLUSTERED 
    (
	    [TeamID] ASC
    )WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
    ) ON [PRIMARY]

    ALTER TABLE [dbo].[Team] ADD  DEFAULT ('') FOR [TeamNm]
END
GO

IF NOT(EXISTS(SELECT * FROM sys.Tables WHERE Name = 'refCar'))
BEGIN
    CREATE TABLE [dbo].[refCar](
	    [CarID] [int] IDENTITY(1,1) NOT NULL,
	    [CarNm] [varchar](250) NOT NULL,
     CONSTRAINT [PK_refCar] PRIMARY KEY CLUSTERED 
    (
	    [CarID] ASC
    )WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
    ) ON [PRIMARY]
END
GO

IF NOT(EXISTS(SELECT * FROM sys.Tables WHERE Name = 'refCountry'))
BEGIN
    CREATE TABLE [dbo].[refCountry](
	    [CountryID] [int] IDENTITY(1,1) NOT NULL,
	    [CountryNm] [varchar](250) NOT NULL,
	    [CreatedDate] [datetime] NOT NULL,
	    [Nationality] [varchar](250) NOT NULL,
     CONSTRAINT [PK_refCountry] PRIMARY KEY CLUSTERED 
    (
	    [CountryID] ASC
    )WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
    ) ON [PRIMARY]

    ALTER TABLE [dbo].[refCountry] ADD  DEFAULT ('') FOR [Nationality]
END
GO

IF NOT(EXISTS(SELECT * FROM sys.Tables WHERE Name = 'refCountry'))
BEGIN
    CREATE TABLE [dbo].[refManufacturer](
	    [ManufacturerID] [int] IDENTITY(1,1) NOT NULL,
	    [ManufacturerNm] [varchar](250) NOT NULL,
	    [CreatedDate] [datetime] NOT NULL,
     CONSTRAINT [PK_refManufacturer] PRIMARY KEY CLUSTERED 
    (
	    [ManufacturerID] ASC
    )WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
    ) ON [PRIMARY]
END
GO

CREATE OR ALTER PROCEDURE [dbo].[DriverDel]
    @intDriverID INT
AS
BEGIN
    DELETE FROM driver WHERE DriverID = @intDriverID;
END
GO

CREATE OR ALTER PROCEDURE [dbo].[DriverGet]
	@intView INT = 0
    ,@intDriverID INT = 0
AS
BEGIN
	SET NOCOUNT ON;

    IF(@intView = 0)
    BEGIN
        SELECT 
            d.DriverID
            ,d.DriverNm
            ,d.ImageID
            ,d.DriverAge
            ,d.TeamID
            ,m.ManufacturerNm AS TeamNm
            ,d.NationalityID
            ,c.Nationality AS NationalityNm
        FROM Driver d
            LEFT JOIN Team t ON d.TeamID = t.TeamID
            LEFT JOIN refManufacturer m ON t.ManufacturerID = m.ManufacturerID
            LEFT JOIN refCountry c ON d.NationalityID = c.CountryID
    END
    ELSE
    BEGIN
        SELECT 
            d.DriverID
            ,d.DriverNm
            ,d.ImageID
            ,d.DriverAge
            ,d.TeamID
            ,m.ManufacturerNm AS TeamNm
            ,d.NationalityID
            ,c.Nationality AS NationalityNm
        FROM Driver d
            LEFT JOIN Team t ON d.TeamID = t.TeamID
            LEFT JOIN refManufacturer m ON t.ManufacturerID = m.ManufacturerID
            LEFT JOIN refCountry c ON d.NationalityID = c.CountryID
         WHERE d.DriverID = @intDriverID
    END
END
GO

CREATE OR ALTER PROCEDURE [dbo].[DriverUpd]
    @intDriverID INT = 0
    ,@strDriverNm VARCHAR(250)
    ,@intDriverAge INT
    ,@strImageID VARCHAR(250)
    ,@intNationalityID INT
    ,@intTeamID INT
AS
BEGIN
    MERGE
    INTO dbo.Driver AS t
    USING
    (
        SELECT
            DriverID = @intDriverID
           ,DriverNm = @strDriverNm
           ,ImageID = @strImageID
           ,DriverAge = @intDriverAge
           ,NationalityID = @intNationalityID
           ,TeamID = @intTeamID
    ) AS s (DriverID, DriverNm, ImageID, DriverAge, NationalityID, TeamID)
    ON (t.DriverID = s.DriverID)
    WHEN MATCHED
        THEN UPDATE
            SET
                DriverNm = s.DriverNm
               ,ImageID = s.ImageID
               ,DriverAge = s.DriverAge
               ,NationalityID = s.NationalityID
               ,TeamID = s.TeamID
               ,UpdatedDate = GETDATE()

    WHEN NOT MATCHED
        THEN INSERT (DriverNm, ImageID, DriverAge, NationalityID, CreatedDate, TeamID)
            VALUES
                (s.DriverNm, s.ImageID, s.DriverAge, s.NationalityID, GETDATE(), s.TeamID);
END
GO

CREATE OR ALTER PROCEDURE [dbo].[RaceDel]
    @intRaceID INT
AS
BEGIN
    DELETE FROM Race WHERE RaceID = @intRaceID;
END

CREATE OR ALTER PROCEDURE [dbo].[RaceGet]
	@intView INT = 0
    ,@intRaceID INT = 0
AS
BEGIN
	SET NOCOUNT ON;

    IF(@intView = 0)
    BEGIN
        SELECT 
            r.RaceID
            ,d.DriverNm AS WinnerNm
            ,D.DriverID AS WinnerID
            ,r.WinnerTime
            ,r.GrandPixID
            ,c.CountryNm AS GrandPixNm
            ,r.CarID
            ,c1.CarNm
            ,r.Laps
        FROM Race r
        LEFT JOIN Driver d ON r.WinnerID = d.DriverID
        LEFT JOIN refCountry c ON r.GrandPixID = c.CountryID
        LEFT JOIN refCar c1 ON r.CarID = c1.CarID
    END
    ELSE
    BEGIN
        SELECT 
            r.RaceID
            ,d.DriverNm AS WinnerNm
            ,D.DriverID AS WinnerID
            ,r.WinnerTime
            ,r.GrandPixID
            ,c.CountryNm AS GrandPixNm
            ,r.CarID
            ,c1.CarNm
            ,r.Laps
        FROM Race r
            LEFT JOIN Driver d ON r.WinnerID = d.DriverID
            LEFT JOIN refCountry c ON r.GrandPixID = c.CountryID
            LEFT JOIN refCar c1 ON r.CarID = c1.CarID
        WHERE r.RaceID = @intRaceID
    END
END
GO

CREATE OR ALTER PROCEDURE [dbo].[RaceUpd]
    @intRaceID INT = 0
    ,@intWinnerID INT
    ,@dtWinnerTime DATETIME
    ,@intGrandPixID INT
    ,@intCarID INT
    ,@intLaps INT
AS
BEGIN
    MERGE
    INTO dbo.Race AS t
    USING
    (
        SELECT
            RaceID = @intRaceID
           ,WinnerID = @intWinnerID
           ,WinnerTime = @dtWinnerTime
           ,GrandPixID = @intGrandPixID
           ,CarID = @intCarID
           ,Laps = @intLaps
    ) AS s (RaceID, WinnerID, WinnerTime, GrandPixID, CarID, Laps)
    ON (t.RaceID = s.RaceID)
    WHEN MATCHED
        THEN UPDATE
            SET
                WinnerID = s.WinnerID
               ,WinnerTime = s.WinnerTime
               ,GrandPixID = s.GrandPixID
               ,CarID = s.CarID
               ,Laps = s.Laps
               ,UpdatedDate = GETDATE()

    WHEN NOT MATCHED
        THEN INSERT (WinnerID, WinnerTime, GrandPixID, CarID, Laps, CreatedDate)
            VALUES
                (s.WinnerID, s.WinnerTime, s.GrandPixID, s.CarID, s.Laps, GETDATE());
END
GO

CREATE OR ALTER PROCEDURE [dbo].[ReferenceGet]
	@strReferenceType VARCHAR(250)
AS
BEGIN
	SET NOCOUNT ON;
     
    IF(@strReferenceType = 'Country')
    BEGIN
    	SELECT
            c.CountryID AS ReferenceValue
            ,c.CountryNm AS ReferenceLabel
        FROM refCountry c
    END
    ELSE IF(@strReferenceType = 'Nationality')
    BEGIN
        SELECT
            c.CountryID AS ReferenceValue
            ,c.Nationality AS ReferenceLabel
        FROM refCountry c
    END
    ELSE IF(@strReferenceType = 'Car')
    BEGIN
        SELECT
            c.CarID AS ReferenceValue
            ,c.CarNm AS ReferenceLabel
        FROM refCar c
    END
    ELSE IF(@strReferenceType = 'Manufacturer')
    BEGIN
        SELECT
            m.ManufacturerID AS ReferenceValue
            ,m.ManufacturerNm AS ReferenceLabel
        FROM refManufacturer m
    END 
    ELSE IF(@strReferenceType = 'Team')
    BEGIN
        SELECT
            m.ManufacturerID AS ReferenceValue
            ,m.ManufacturerNm AS ReferenceLabel
        FROM Team t JOIN refManufacturer m ON t.ManufacturerID = m.ManufacturerID
    END 
    ELSE IF(@strReferenceType = 'Driver')
    BEGIN
        SELECT
            d.DriverID AS ReferenceValue
            ,d.DriverNm AS ReferenceLabel
        FROM Driver d
    END    
END
GO

CREATE OR ALTER PROCEDURE [dbo].[TeamDel]
    @intTeamID INT
AS
BEGIN
    DELETE FROM Team WHERE TeamID = @intTeamID;
END
GO

ALTER PROCEDURE [dbo].[TeamGet]
	@intView INT = 0
    ,@intTeamID INT = 0
AS
BEGIN
	SET NOCOUNT ON;

    IF(@intView = 0)
    BEGIN
        SELECT 
            t.TeamID
            ,t.TeamNm
            ,d.DriverID AS DirverFirstID
            ,d.DriverNm AS DirverFirstNm
            ,d1.DriverID AS DriverSecondID
            ,d1.DriverNm AS DriverSecondNm
            ,T.Image
            ,m.ManufacturerID
        FROM Team t
            LEFT JOIN refManufacturer m ON t.ManufacturerID = m.ManufacturerID
            LEFT JOIN Driver d ON t.DriverFirstID = d.DriverID
            LEFT JOIN Driver d1 ON t.DriverSecondID = d1.DriverID
    END
    ELSE
    BEGIN
        SELECT 
           t.TeamID
            ,t.TeamNm
            ,d.DriverID AS DirverFirstID
            ,d.DriverNm AS DirverFirstNm
            ,d1.DriverID AS DriverSecondID
            ,d1.DriverNm AS DriverSecondNm
            ,T.Image
            ,m.ManufacturerID
        FROM Team t
            LEFT JOIN refManufacturer m ON t.ManufacturerID = m.ManufacturerID
            LEFT JOIN Driver d ON t.DriverFirstID = d.DriverID
            LEFT JOIN Driver d1 ON t.DriverSecondID = d1.DriverID
        WHERE t.TeamID = @intTeamID
    END
END
GO

CREATE OR ALTER PROCEDURE [dbo].[TeamUpd]
    @intTeamID INT = 0
    ,@strTeamNm VARCHAR(250)
    ,@intManufacturerID INT
    ,@intDriverFirstID INT
    ,@intDriverSecondID INT
    ,@strImage VARCHAR(500)
AS
BEGIN
    MERGE
    INTO dbo.Team AS t
    USING
    (
        SELECT
            TeamID = @intTeamID
            ,TeamNm = @strTeamNm
           ,ManufacturerID = @intManufacturerID
           ,DriverFirstID = @intDriverFirstID
           ,DriverSecondID = @intDriverSecondID
           ,Image = @strImage
    ) AS s (TeamID, TeamNm, ManufacturerID, DriverFirstID, DriverSecondID, Image)
    ON (t.TeamID = s.TeamID)
    WHEN MATCHED
        THEN UPDATE
            SET
                TeamNm = s.TeamNm
               ,ManufacturerID = s.ManufacturerID
               ,DriverFirstID = s.DriverFirstID
               ,DriverSecondID = s.DriverSecondID
               ,Image = s.Image
               ,UpdatedDate = GETDATE()

    WHEN NOT MATCHED
        THEN INSERT (TeamNm, ManufacturerID, DriverFirstID, DriverSecondID, Image, CreatedDate)
            VALUES
                (s.TeamNm, s.ManufacturerID, s.DriverFirstID, s.DriverSecondID, s.Image, GETDATE());
END
GO