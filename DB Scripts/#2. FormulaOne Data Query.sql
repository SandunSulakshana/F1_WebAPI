SET IDENTITY_INSERT [dbo].[refManufacturer] ON
IF NOT EXISTS (SELECT * FROM [dbo].[refManufacturer] WHERE ManufacturerID = 1)
    INSERT INTO refManufacturer(ManufacturerID, ManufacturerNm,CreatedDate) VALUES(1, 'Red Bull Racing', GETDATE());
IF NOT EXISTS (SELECT * FROM [dbo].[refManufacturer] WHERE ManufacturerID = 2)
    INSERT INTO refManufacturer(ManufacturerID, ManufacturerNm,CreatedDate) VALUES(2, 'Mercedes', GETDATE());
IF NOT EXISTS (SELECT * FROM [dbo].[refManufacturer] WHERE ManufacturerID = 3)
    INSERT INTO refManufacturer(ManufacturerID, ManufacturerNm,CreatedDate) VALUES(3, 'Aston Martin', GETDATE());
IF NOT EXISTS (SELECT * FROM [dbo].[refManufacturer] WHERE ManufacturerID = 4)
    INSERT INTO refManufacturer(ManufacturerID, ManufacturerNm,CreatedDate) VALUES(4, 'McLearn', GETDATE());
IF NOT EXISTS (SELECT * FROM [dbo].[refManufacturer] WHERE ManufacturerID = 5)
    INSERT INTO refManufacturer(ManufacturerID, ManufacturerNm,CreatedDate) VALUES(5, 'Ferrari', GETDATE());
IF NOT EXISTS (SELECT * FROM [dbo].[refManufacturer] WHERE ManufacturerID = 6)
    INSERT INTO refManufacturer(ManufacturerID, ManufacturerNm,CreatedDate) VALUES(6, 'Alpine', GETDATE());
IF NOT EXISTS (SELECT * FROM [dbo].[refManufacturer] WHERE ManufacturerID = 7)
    INSERT INTO refManufacturer(ManufacturerID, ManufacturerNm,CreatedDate) VALUES(7, 'Williams', GETDATE());
IF NOT EXISTS (SELECT * FROM [dbo].[refManufacturer] WHERE ManufacturerID = 8)
    INSERT INTO refManufacturer(ManufacturerID, ManufacturerNm,CreatedDate) VALUES(8, 'AlphaTauri', GETDATE());
IF NOT EXISTS (SELECT * FROM [dbo].[refManufacturer] WHERE ManufacturerID = 9)
    INSERT INTO refManufacturer(ManufacturerID, ManufacturerNm,CreatedDate) VALUES(9, 'Alpha Romeo', GETDATE());
IF NOT EXISTS (SELECT * FROM [dbo].[refManufacturer] WHERE ManufacturerID = 10)
    INSERT INTO refManufacturer(ManufacturerID, ManufacturerNm,CreatedDate) VALUES(10, 'Haas F1 Team', GETDATE());
SET IDENTITY_INSERT [dbo].[refManufacturer] OFF

SET IDENTITY_INSERT [dbo].[refCountry] ON
IF NOT EXISTS (SELECT * FROM [dbo].[refCountry] WHERE CountryID = 1)
    INSERT INTO refCountry(CountryID,CountryNm, Nationality,CreatedDate) VALUES(1, 'England', 'British', GETDATE());
IF NOT EXISTS (SELECT * FROM [dbo].[refCountry] WHERE CountryID = 2)
    INSERT INTO refCountry(CountryID, CountryNm, Nationality, CreatedDate) VALUES(2, 'America', 'American', GETDATE());
IF NOT EXISTS (SELECT * FROM [dbo].[refCountry] WHERE CountryID = 3)
    INSERT INTO refCountry(CountryID, CountryNm, Nationality, CreatedDate) VALUES(3, 'Italy', 'Italian', GETDATE());
IF NOT EXISTS (SELECT * FROM [dbo].[refCountry] WHERE CountryID = 4)
    INSERT INTO refCountry(CountryID, CountryNm, Nationality, CreatedDate) VALUES(4, 'France', 'French', GETDATE());
IF NOT EXISTS (SELECT * FROM [dbo].[refCountry] WHERE CountryID = 5)
    INSERT INTO refCountry(CountryID, CountryNm, Nationality, CreatedDate) VALUES(5, 'Germany', 'German', GETDATE());
IF NOT EXISTS (SELECT * FROM [dbo].[refCountry] WHERE CountryID = 6)
    INSERT INTO refCountry(CountryID, CountryNm, Nationality, CreatedDate) VALUES(6, 'Brazil', 'Brazilian', GETDATE());
IF NOT EXISTS (SELECT * FROM [dbo].[refCountry] WHERE CountryID = 7)
    INSERT INTO refCountry(CountryID, CountryNm, Nationality, CreatedDate) VALUES(7, 'Argentina',  'Argentine', GETDATE());
IF NOT EXISTS (SELECT * FROM [dbo].[refCountry] WHERE CountryID = 8)
    INSERT INTO refCountry(CountryID, CountryNm, Nationality, CreatedDate) VALUES(8, 'South Africa', 'South African', GETDATE());
IF NOT EXISTS (SELECT * FROM [dbo].[refCountry] WHERE CountryID = 9)
    INSERT INTO refCountry(CountryID, CountryNm, Nationality, CreatedDate) VALUES(9, 'Belgium', 'Belgian', GETDATE());
IF NOT EXISTS (SELECT * FROM [dbo].[refCountry] WHERE CountryID = 10)
    INSERT INTO refCountry(CountryID, CountryNm, Nationality, CreatedDate) VALUES(10, 'Switzerland', 'Swiss', GETDATE());
SET IDENTITY_INSERT [dbo].[refCountry] OFF


SET IDENTITY_INSERT [dbo].[refCar] ON
IF NOT EXISTS (SELECT * FROM [dbo].[refCar] WHERE CarID = 1)
    INSERT INTO refCar(CarId, CarNm) VALUES(1, 'FERRARI');
IF NOT EXISTS (SELECT * FROM [dbo].[refCar] WHERE CarID = 2)
    INSERT INTO refCar(CarId, CarNm) VALUES(2, 'RED BULL RACING HONDA RBPT');
SET IDENTITY_INSERT [dbo].[refCar] OFF