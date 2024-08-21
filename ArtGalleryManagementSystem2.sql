CREATE DATABASE ArtGalleryManagementSystem
use ArtGalleryManagementSystem
GO

CREATE TABLE Users (
	UserID INT PRIMARY KEY,
	UserEmail VARCHAR(255) UNIQUE,
	Username VARCHAR(100) UNIQUE,
	Password VARCHAR(255),
	Role VARCHAR(100),
    FirstName VARCHAR(100),
    LastName VARCHAR(100),
	Address VARCHAR(255),
    PhoneNo VARCHAR(20) UNIQUE,
);

GO
-- Indexed view for staff users
CREATE VIEW StaffView
WITH SCHEMABINDING
AS
SELECT UserID, UserEmail, Username, Password, Role, FirstName, LastName, Address, PhoneNo
FROM dbo.Users
WHERE Role = 'Staff';
GO

CREATE UNIQUE CLUSTERED INDEX IX_StaffView_UserID ON StaffView (UserID);
GO

-- Indexed view for client users
CREATE VIEW ClientView
WITH SCHEMABINDING
AS
SELECT UserID, UserEmail, Username, Password, Role, FirstName, LastName, Address, PhoneNo
FROM dbo.Users
WHERE Role = 'Client';
GO

CREATE UNIQUE CLUSTERED INDEX IX_ClientView_UserID ON ClientView (UserID);
GO

-- Indexed view for admin users
CREATE VIEW AdminView
WITH SCHEMABINDING
AS
SELECT UserID, UserEmail, Username, Password, Role, FirstName, LastName, Address, PhoneNo
FROM dbo.Users
WHERE Role = 'Admin';
GO

CREATE UNIQUE CLUSTERED INDEX IX_AdminView_UserID ON AdminView (UserID);
GO

--create view artist
CREATE VIEW ArtistView
WITH SCHEMABINDING
AS
SELECT UserID, UserEmail, Username, Password, Role, FirstName, LastName, Address, PhoneNo
FROM dbo.Users
WHERE Role = 'Artist';
GO

CREATE UNIQUE CLUSTERED INDEX IX_ArtistView_UserID ON ArtistView (UserID);
GO

-- Create Artist table
CREATE TABLE Artist (
     AID INT,
     UserID INT,
     SocialMediaProfile VARCHAR(255),
     SignatureStyle VARCHAR(255),
     CONSTRAINT PKARTIST PRIMARY KEY (AID),
	 CONSTRAINT FKARTUSER FOREIGN KEY (UserID) REFERENCES Users(UserID)
	 )

--Drop existing primary and foreign key constraints
ALTER TABLE Artist DROP CONSTRAINT IF EXISTS PKARTIST;
ALTER TABLE Artist DROP CONSTRAINT IF EXISTS FKARTUSER;

--Add a clustered index on the AID column
CREATE CLUSTERED INDEX IX_Artist_AID ON Artist (AID);

--Add back the primary key and foreign key constraints
ALTER TABLE Artist ADD CONSTRAINT PKARTIST PRIMARY KEY (AID);
ALTER TABLE Artist ADD CONSTRAINT FKARTUSER FOREIGN KEY (UserID) REFERENCES Users(UserID);

-- Create Artwork table
CREATE TABLE Artwork (
    ArtID INT NOT NULL,
	AID INT NOT NULL,
	Title VARCHAR(255),
    Medium VARCHAR(100),
    Dimensions VARCHAR(100),
    DateCompleted DATE,
    Availability VARCHAR(20),
    Price DECIMAL(10, 2),
    CONSTRAINT PKARTWORK PRIMARY KEY (ArtID),
    CONSTRAINT FKART_ARTIST FOREIGN KEY (AID) REFERENCES Artist (AID)

);

SELECT * FROM Artwork

-- Step 1: Drop existing primary and foreign key constraints
ALTER TABLE Artwork DROP CONSTRAINT IF EXISTS PKARTWORK;
ALTER TABLE Artwork DROP CONSTRAINT IF EXISTS FKART_ARTIST;

-- Step 2: Add a clustered index on the Availability column
CREATE CLUSTERED INDEX IX_Artwork_Availability ON Artwork (Availability DESC);

-- Step 3: Add back the primary key and foreign key constraints
ALTER TABLE Artwork ADD CONSTRAINT PKARTWORK PRIMARY KEY (ArtID);
ALTER TABLE Artwork ADD CONSTRAINT FKART_ARTIST FOREIGN KEY (AID) REFERENCES Artist (AID);

-- Create Gallery table
CREATE TABLE Gallery (
    GID INT,
	UserID INT,
    GalleryName VARCHAR(255),
    Status VARCHAR(50),
    Location VARCHAR(255),
    CONSTRAINT PKGALLERY PRIMARY KEY (GID),
	CONSTRAINT FKGallery_UserID FOREIGN KEY (UserID) REFERENCES Users(UserID)                                        
);

-- Step 1: Drop the existing primary key constraint
ALTER TABLE Gallery DROP CONSTRAINT IF EXISTS PKGALLERY;
ALTER TABLE Gallery DROP CONSTRAINT IF EXISTS FKGallery_UserID;

GO
-- Step 2: Create the clustered index on the GID column
CREATE CLUSTERED INDEX IX_Gallery_GID ON Gallery (GID);
GO

-- Step 3: Add back the primary key constraint
ALTER TABLE Gallery ADD CONSTRAINT PKGALLERY PRIMARY KEY (GID);
ALTER TABLE Gallery ADD CONSTRAINT FKGallery_UserI FOREIGN KEY (UserID) REFERENCES Users(UserID);

-- Create Exhibition table
CREATE TABLE Exhibition (
   EID INT,
   GID INT,
   StartDate DATE,
   EndDate DATE,
   Location VARCHAR(255),
   EName VARCHAR(255),
   Theme VARCHAR(255),
   ArtID INT,
   CONSTRAINT PKEXHIBITION PRIMARY KEY (EID),
   CONSTRAINT FKEXHI_GALLERY FOREIGN KEY (GID) REFERENCES Gallery(GID),
   CONSTRAINT FKEXHI_ART FOREIGN KEY (ArtID) REFERENCES Artwork(ArtID)
);

-- Step 1: Drop the existing primary key constraint and foreign key constraints
ALTER TABLE Exhibition DROP CONSTRAINT IF EXISTS PKEXHIBITION;
ALTER TABLE Exhibition DROP CONSTRAINT IF EXISTS FKEXHI_GALLERY;
ALTER TABLE Exhibition DROP CONSTRAINT IF EXISTS FKEXHI_ART;

-- Step 2: Create the clustered index on the StartDate column
CREATE CLUSTERED INDEX IX_Exhibition_StartDate ON Exhibition (StartDate DESC);

select * from Exhibition
-- Step 3: Add back the primary key constraint and foreign key constraints
ALTER TABLE Exhibition ADD CONSTRAINT PKEXHIBITION PRIMARY KEY (EID);
ALTER TABLE Exhibition ADD CONSTRAINT FKEXHI_GALLERY FOREIGN KEY (GID) REFERENCES Gallery(GID);
ALTER TABLE Exhibition ADD CONSTRAINT FKEXHI_ART FOREIGN KEY (ArtID) REFERENCES Artwork(ArtID);

-- Create Sales table
CREATE TABLE Sales (
	SaleID INT,
    UserID INT, 
    ArtID INT,
    Price DECIMAL(10, 2),
    SaleDate DATE,
    ArtistCommission DECIMAL(10, 2),
    CONSTRAINT PKSALES PRIMARY KEY (SaleID),
    CONSTRAINT FKSALESUSER FOREIGN KEY (UserID) REFERENCES Users(UserID),
    CONSTRAINT FKSALESART FOREIGN KEY (ArtID) REFERENCES Artwork(ArtID),
    CHECK (Price > 0)
);
-- Drop existing primary key and foreign key constraints
ALTER TABLE Sales DROP CONSTRAINT PKSALES
ALTER TABLE Sales DROP CONSTRAINT FKSALESUSER
ALTER TABLE Sales DROP CONSTRAINT FKSALESART

-- Create the clustered index on SaleDate
CREATE CLUSTERED INDEX IX_Sales_SaleDate ON Sales (SaleDate DESC);

-- Recreate primary key and foreign key constraints
ALTER TABLE Sales ADD CONSTRAINT PKSALES PRIMARY KEY (SaleID);
ALTER TABLE Sales ADD CONSTRAINT FKSALESUSER FOREIGN KEY (UserID) REFERENCES Users(UserID);
ALTER TABLE Sales ADD CONSTRAINT FKSALESART FOREIGN KEY (ArtID) REFERENCES Artwork(ArtID);

-- Create Loan table
CREATE TABLE Loan (
    LoanID INT,
	UserID INT, 
    ArtID INT,
	LoanAmount DECIMAL(10, 2),
    DurationInDays INT,
    ExpiryDate DATE,
    TransportTracking VARCHAR(100),
    MonitoringStatus VARCHAR(50),
    CONSTRAINT PKLOAN PRIMARY KEY (LOANID),
    CONSTRAINT FKLOANUSER FOREIGN KEY (UserID) REFERENCES Users(UserID),
    CONSTRAINT FKLOANART FOREIGN KEY (ArtID) REFERENCES Artwork(ArtID),

);
--Drop the primary key and foreign key constraints
ALTER TABLE Loan DROP CONSTRAINT PKLOAN;
ALTER TABLE Loan DROP CONSTRAINT FKLOANUSER;
ALTER TABLE Loan DROP CONSTRAINT FKLOANART;

--Create the clustered index on ExpiryDate in descending order
CREATE CLUSTERED INDEX IX_Loan_ExpiryDate ON Loan (ExpiryDate DESC);

--Re-add the primary key and foreign key constraints
ALTER TABLE Loan ADD CONSTRAINT PKLOAN PRIMARY KEY (LoanID);
ALTER TABLE Loan ADD CONSTRAINT FKLOANUSER FOREIGN KEY (UserID) REFERENCES Users(UserID);
ALTER TABLE Loan ADD CONSTRAINT FKLOANART FOREIGN KEY (ArtID) REFERENCES Artwork(ArtID);


SELECT * FROM Users -- make seperate views for these user tables 
SELECT * FROM StaffView
SELECT * FROM ClientView
SELECT * FROM AdminView
SELECT * FROM ArtistView

SELECT * FROM Artist

SELECT * FROM Artwork -- if not for sale then do null

SELECT * FROM Loan
SELECT * FROM Gallery

SELECT * FROM Exhibition

SELECT * FROM Sales



GO

-- Complex Views
GO
-- Artist Sales Report Through Complex View
CREATE VIEW SalesReportByArtist AS
SELECT 
    AR.UserID AS ArtistID,
    CONCAT(U.FirstName, ' ', U.LastName) AS ArtistName,
    A.Title AS ArtworkTitle,
    S.SaleDate,
    S.Price,
    S.ArtistCommission
FROM 
    Sales S
JOIN 
    Artwork A ON S.ArtID = A.ArtID
JOIN 
    Artist AR ON A.AID = AR.AID
JOIN 
    Users U ON AR.UserID = U.UserID;
GO

Select * from SalesReportByArtist

GO
-- Exhibition Details Report
CREATE VIEW ExhibitionDetails AS
SELECT 
    E.EName AS ExhibitionName,
    E.StartDate,
    E.EndDate,
    G.GalleryName,
    G.Location,
    STRING_AGG(A.Title, ', ') AS ArtworkTitles
FROM 
    Exhibition E
JOIN 
    Gallery G ON E.GID = G.GID
JOIN 
    Artwork A ON E.ArtID = A.ArtID
GROUP BY 
    E.EName, E.StartDate, E.EndDate, G.GalleryName, G.Location;
GO

 Select * from ExhibitionDetails

 GO
 --Loan Status Report
CREATE VIEW LoanStatusReport AS
SELECT 
    L.LoanID,
    A.Title AS ArtworkTitle,
    L.LoanAmount,
    L.DurationInDays,
    L.ExpiryDate,
    CONCAT(U.FirstName, ' ', U.LastName) AS BorrowerName,
    L.MonitoringStatus
FROM 
    Loan L
JOIN 
    Artwork A ON  L.ArtID = A.ArtID
JOIN 
    Users U ON L.UserID = U.UserID
WHERE 
    L.ExpiryDate >= GETDATE();  -- Filter for active loans
GO

SELECT * FROM LoanStatusReport ORDER BY ExpiryDate DESC;



GO
CREATE VIEW ArtistPerformanceReport AS
SELECT
    A.AID AS ArtistID,
    CONCAT(U.FirstName, ' ', U.LastName) AS ArtistName,
    COUNT(W.ArtID) AS UploadedArtworks,
    SUM(S.Price) AS TotalRevenue,
    SUM(S.ArtistCommission) AS TotalCommissionEarned
FROM
    Artist A
JOIN
    Users U ON A.UserID = U.UserID
LEFT JOIN
    Artwork W ON A.AID = W.AID
LEFT JOIN
    Sales S ON W.ArtID = S.ArtID
GROUP BY
    A.AID, U.FirstName, U.LastName;
GO

SELECT * FROM ArtistPerformanceReport

GO
CREATE VIEW ClientPurchaseHistoryReport AS
SELECT
    C.UserID AS ClientID,
    CONCAT(U.FirstName, ' ', U.LastName) AS ClientName,
    P.ArtID,
    W.Title AS ArtworkTitle,
    P.SaleDate AS PurchaseDate
FROM
    Users U
JOIN
    Sales P ON U.UserID = P.UserID
JOIN
    Artwork W ON P.ArtID = W.ArtID
JOIN
    Artist A ON W.AID = A.AID
JOIN
    Users C ON A.UserID = C.UserID;
GO

SELECT * FROM ClientPurchaseHistoryReport

GO
CREATE VIEW FinancialSummaryReport AS
SELECT
    SUM(S.Price) AS TotalSalesRevenue,
    SUM(S.ArtistCommission) AS TotalArtistCommissions,
    SUM(L.LoanAmount) AS TotalLoanIncome
FROM
    Sales S
JOIN
    Users U ON S.UserID = U.UserID
LEFT JOIN
    Loan L ON S.ArtID = L.ArtID;
GO

SELECT * FROM FinancialSummaryReport


GO
-- MATERIALIZE VIEW Total sales by Artist
CREATE VIEW Materialized_ArtistSalesSummary
WITH SCHEMABINDING
AS
SELECT 
    AR.UserID AS ArtistID,
    CONCAT(U.FirstName, ' ', U.LastName) AS ArtistName,
    AR.SocialMediaProfile,
    SUM(S.Price) AS TotalSales
FROM 
    dbo.Sales S
JOIN 
    dbo.Artwork A ON S.ArtID = A.ArtID
JOIN 
    dbo.Artist AR ON A.AID = AR.AID
JOIN 
    dbo.Users U ON AR.UserID = U.UserID
GROUP BY 
    AR.UserID, U.FirstName, U.LastName, AR.SocialMediaProfile;
GO

Select * from Materialized_ArtistSalesSummary

GO
-- Report For Available Artwork
CREATE VIEW Materialized_ArtworkAvailability
WITH SCHEMABINDING
AS
SELECT 
    A.ArtID,
    A.Title AS ArtworkTitle,
    CONCAT(U.FirstName, ' ', U.LastName) AS ArtistName,
    AR.SocialMediaProfile,
    A.Availability
FROM 
    dbo.Artwork A
JOIN 
    dbo.Artist AR ON A.AID = AR.AID
JOIN 
    dbo.Users U ON AR.UserID = U.UserID
WHERE 
    A.Availability = 'Available';
GO

select * from Materialized_ArtworkAvailability

GO
-- Report For Exhibition Details
CREATE VIEW Materialized_ExhibitionDetails
WITH SCHEMABINDING
AS
SELECT 
    E.EID,
    E.EName AS ExhibitionName,
    E.StartDate,
    E.EndDate,
    G.GalleryName,
    G.Location,
    A.Title AS ArtworkTitle,
    A.Availability
FROM 
    dbo.Exhibition E
JOIN 
    dbo.Gallery G ON E.GID = G.GID
JOIN 
    dbo.Artwork A ON E.ArtID = A.ArtID;
GO

select * from Materialized_ExhibitionDetails


-- PROCEDURES :
GO
CREATE PROCEDURE InsertUserData
    @UserID INT,
    @UserEmail VARCHAR(255),
    @Username VARCHAR(100),
    @Password VARCHAR(255),
    @Role VARCHAR(100),
    @FirstName VARCHAR(100),
    @LastName VARCHAR(100),
    @Address VARCHAR(255),
    @PhoneNo VARCHAR(20),
    @RowsAffected INT OUTPUT
AS
BEGIN
    -- Insert into Users table
    INSERT INTO Users (UserID, UserEmail, Username, Password, Role, FirstName, LastName, Address, PhoneNo)
    VALUES (@UserID, @UserEmail, @Username, @Password, @Role, @FirstName, @LastName, @Address, @PhoneNo);

    -- Get the number of rows affected
    SET @RowsAffected = @@ROWCOUNT;
END;
GO

-- Execute the stored procedure to insert a new user
DECLARE @RowsAffected INT;

EXEC InsertUserData 
    @UserID = 300,
    @UserEmail = 'user300@example.com',
    @Username = 'user3',
    @Password = 'user3!',
    @Role = 'Admin',
    @FirstName = 'Rebecca',
    @LastName = 'Johnson',
    @Address = '3 Maple Street',
    @PhoneNo = '123-456-7803',
    @RowsAffected = @RowsAffected OUTPUT;


-- Check the number of rows affected
SELECT @RowsAffected AS RowsAffected;
GO

SELECT * FROM Users

-- Verify the insertion by selecting from the Users table
SELECT * FROM Users WHERE UserEmail = 'user3@example.com';

GO
-- Procedure For Updating Artwork
CREATE PROCEDURE UpdateArtworkData
    @ArtID INT,
    @Availability VARCHAR(20),
    @Price DECIMAL(10, 2)
AS
BEGIN
    -- Select rows before update
    SELECT * FROM Artwork WHERE ArtID = @ArtID AND Availability = 'Available';

    -- Update Artwork table
    UPDATE Artwork
    SET Availability = @Availability,
        Price = @Price
    WHERE ArtID = @ArtID;

    -- Select rows after update
    SELECT * FROM Artwork WHERE ArtID = @ArtID;

    -- Check the number of rows affected
    DECLARE @RowsAffected INT;
    SET @RowsAffected = @@ROWCOUNT;

    -- Output the number of rows affected
    SELECT @RowsAffected AS RowsAffected;
END;

GO
DECLARE @RowsAffected INT;

-- Execute the stored procedure
EXEC UpdateArtworkData 
    @ArtID = 62,
    @Availability = 'Available',
    @Price = 160000;

-- Select rows to verify the update
SELECT * FROM Artwork WHERE ArtID = 62;



GO
-- Create the procedure
CREATE PROCEDURE DeleteUserDataAndRelated
    @UserID INT,
    @RowsAffected INT OUTPUT
AS
BEGIN
    -- Declare a variable to store the total number of rows affected
    DECLARE @TotalRowsAffected INT = 0;

    -- Delete related records in Artist table
    DELETE FROM Artist
    WHERE UserID = @UserID;

    -- Update the total number of rows affected
    SET @TotalRowsAffected = @TotalRowsAffected + @@ROWCOUNT;

    -- Delete related records in Gallery table
    DELETE FROM Gallery
    WHERE UserID = @UserID;

    -- Update the total number of rows affected
    SET @TotalRowsAffected = @TotalRowsAffected + @@ROWCOUNT;

    -- Delete from Users table
    DELETE FROM Users
    WHERE UserID = @UserID;

    -- Update the total number of rows affected
    SET @TotalRowsAffected = @TotalRowsAffected + @@ROWCOUNT;

    -- Set the output parameter
    SET @RowsAffected = @TotalRowsAffected;
END;
GO

-- Example usage of the procedure
DECLARE @RowsAffected INT;

-- Execute the stored procedure to delete a user and related data
EXEC DeleteUserDataAndRelated 
    @UserID = 71,
    @RowsAffected = @RowsAffected OUTPUT;

-- Output the number of rows affected
SELECT @RowsAffected AS RowsAffected;

-- Verify deletion
select * from Artwork
SELECT * FROM Users WHERE UserID = 71;
SELECT * FROM Artist WHERE UserID = 71;
SELECT * FROM Gallery WHERE UserID = 71;
GO


-- Procedure For Sales Report By Range
CREATE PROCEDURE sp_SalesReportByDateRange
    @StartDate DATE,
    @EndDate DATE
AS
BEGIN
    SELECT 
        S.SaleID,
        S.SaleDate,
        A.Title AS ArtworkTitle,
        U.FirstName + ' ' + U.LastName AS BuyerName,
        S.Price,
        S.ArtistCommission
    FROM 
        Sales S
        JOIN Artwork A ON S.ArtID = A.ArtID
        JOIN Users U ON S.UserID = U.UserID
    WHERE 
        S.SaleDate BETWEEN @StartDate AND @EndDate
    ORDER BY 
        S.SaleDate;
END;
GO

\

-- Procedure For Loan Report 
CREATE PROCEDURE sp_LoanReportByUser
    @UserID INT
AS
BEGIN
    SELECT 
        L.LoanID,
        L.LoanAmount,
        L.DurationInDays,
        L.ExpiryDate,
        L.TransportTracking,
        L.MonitoringStatus,
        A.Title AS ArtworkTitle
    FROM 
        Loan L
        JOIN Artwork A ON L.ArtID = A.ArtID
    WHERE 
        L.UserID = @UserID
    ORDER BY 
        L.ExpiryDate DESC;
END;
GO

select * from Users
EXEC sp_LoanReportByUser @UserID = 81;
GO

-- Procedure For Artist Contribution Report
CREATE PROCEDURE sp_TotalSalesAndCommissionByArtist
    @StartDate DATE,
    @EndDate DATE
AS
BEGIN
    SELECT 
        AR.UserID,
        U.FirstName + ' ' + U.LastName AS ArtistName,
        SUM(S.Price) AS TotalSales,
        SUM(S.ArtistCommission) AS TotalCommission
    FROM 
        Sales S
        JOIN Artwork A ON S.ArtID = A.ArtID
        JOIN Artist AR ON A.AID = AR.AID
        JOIN Users U ON AR.UserID = U.UserID
    WHERE 
        S.SaleDate BETWEEN @StartDate AND @EndDate
    GROUP BY 
        AR.UserID, U.FirstName, U.LastName
    ORDER BY 
        TotalSales DESC;
END;
GO

EXEC sp_TotalSalesAndCommissionByArtist @StartDate = '2024-01-01', @EndDate = '2024-08-31';
GO

-- Procedure For Exhibition Report For A Gallery
CREATE PROCEDURE sp_ExhibitionReportByGallery
    @GalleryID INT
AS
BEGIN
    SELECT 
        E.EID,
        E.EName,
        E.StartDate,
        E.EndDate,
        E.Location,
        E.Theme,
        A.Title AS ArtworkTitle
    FROM 
        Exhibition E
        JOIN Artwork A ON E.ArtID = A.ArtID
    WHERE 
        E.GID = @GalleryID
    ORDER BY 
        E.StartDate DESC;
END;
GO


EXEC sp_ExhibitionReportByGallery @GalleryID = 21;
GO


-- TRIGGERS:

-- Ensure that only available artworks can be purchased
ALTER TABLE Sales
ADD CONSTRAINT chk_ArtworkAvailabilityForPurchase
CHECK (ArtID NOT IN (SELECT ArtID FROM Artwork WHERE Availability != 'available'));

-- Ensure that only available artworks can be loaned
ALTER TABLE Loan
ADD CONSTRAINT chk_ArtworkAvailabilityForLoan
CHECK (Art_ID NOT IN (SELECT ArtID FROM Artwork WHERE Availability != 'available'));


---
GO
-- Trigger to prevent deletion of Artwork when its availability is 'Sold' or 'On Loan'
CREATE TRIGGER trg_PreventArtworkDeletion
ON Artwork
AFTER DELETE
AS
BEGIN
    -- Check if any of the deleted artworks are 'Sold' or 'On Loan'
    IF EXISTS (SELECT * FROM deleted WHERE Availability IN ('Sold', 'On Loan'))
    BEGIN
        -- If any deleted artwork is 'Sold' or 'On Loan', display a message and roll back the deletion
        RAISERROR ('Artwork cannot be deleted because it is either Sold or On Loan.', 16, 1);
        ROLLBACK TRANSACTION;
    END
    ELSE
    BEGIN
        -- If none of the deleted artworks are 'Sold' or 'On Loan', proceed with the deletion
        DELETE FROM Artwork WHERE ArtID IN (SELECT ArtID FROM deleted);
    END
END;



GO
-- Ensure Artwork Availability is updated upon purchase or loan
CREATE TRIGGER trg_UpdateArtworkAvailabilityOnPurchase
ON Sales
AFTER INSERT
AS
BEGIN
    UPDATE Artwork
    SET Availability = 'sold'
    WHERE ArtID IN (SELECT ArtID FROM inserted);
END;
GO



CREATE TRIGGER trg_UpdateArtworkAvailabilityOnLoan
ON Loan
AFTER INSERT
AS
BEGIN
    UPDATE Artwork
    SET Availability = 'on loan'
    WHERE ArtID IN (SELECT ArtID FROM inserted);
END;
GO



CREATE TRIGGER trg_SetPriceToNullForNotForSale
ON Artwork
AFTER UPDATE
AS
BEGIN
    IF EXISTS (SELECT * FROM inserted WHERE Availability = 'Not for Sale')
    BEGIN
        UPDATE Artwork
        SET Price = NULL
        WHERE ArtID IN (SELECT ArtID FROM inserted WHERE Availability = 'Not for Sale');
    END
END;
GO




CREATE TRIGGER trg_DeleteArtworkReferences
ON Artwork
AFTER DELETE
AS
BEGIN
    DECLARE @ArtID INT;
    SELECT @ArtID = ArtID FROM deleted;

    DELETE FROM Sales WHERE ArtID = @ArtID;
    DELETE FROM Loan WHERE ArtID = @ArtID;
    DELETE FROM Exhibition WHERE ArtID = @ArtID;
END;
GO



CREATE TRIGGER trg_DeleteArtistReferences
ON Artist
AFTER DELETE
AS
BEGIN
    DECLARE @AID INT;
    SELECT @AID = AID FROM deleted;

    DELETE FROM Artwork WHERE AID = @AID;

    DELETE FROM Sales WHERE ArtID IN (SELECT ArtID FROM Artwork WHERE AID = @AID);
    DELETE FROM Loan WHERE ArtID IN (SELECT ArtID FROM Artwork WHERE AID = @AID);
    DELETE FROM Exhibition WHERE ArtID IN (SELECT ArtID FROM Artwork WHERE AID = @AID);
END;
GO


CREATE TRIGGER trg_DeleteStaffUserReferences
ON Users
AFTER DELETE
AS
BEGIN
    DECLARE @UserID INT;
    DECLARE @Role VARCHAR(100);
    
    SELECT @UserID = UserID, @Role = Role FROM deleted;

    IF @Role = 'staff'
    BEGIN
        DELETE FROM Sales WHERE UserID = @UserID;
        DELETE FROM Loan WHERE UserID = @UserID;
    END
END;
GO


CREATE TRIGGER trg_EnsureAvailableArtworkForPurchase
ON Sales
INSTEAD OF INSERT
AS
BEGIN
    IF EXISTS (
        SELECT 1
        FROM inserted i
        JOIN Artwork a ON i.ArtID = a.ArtID
        WHERE a.Availability != 'available'
    )
    BEGIN
        RAISERROR ('Artwork is not available for purchase.', 16, 1);
    END
    ELSE
    BEGIN
        INSERT INTO Sales (SaleID, UserID, ArtID, Price, SaleDate, ArtistCommission)
        SELECT SaleID, UserID, ArtID, Price, SaleDate, ArtistCommission
        FROM inserted;
        
        UPDATE Artwork
        SET Availability = 'sold'
        WHERE ArtID IN (SELECT ArtID FROM inserted);
        
        DELETE FROM Exhibition WHERE ArtID IN (SELECT ArtID FROM inserted);
    END
END;
GO


CREATE TRIGGER trg_EnsureAvailableArtworkForLoan
ON Loan
INSTEAD OF INSERT
AS
BEGIN
    IF EXISTS (
        SELECT 1
        FROM inserted i
        JOIN Artwork a ON i.ArtID = a.ArtID
        WHERE a.Availability != 'available'
    )
    BEGIN
        RAISERROR ('Artwork is not available for loan.', 16, 1);
    END
    ELSE
    BEGIN
        INSERT INTO Loan (LoanID, UserID, ArtID, LoanAmount, DurationInDays, ExpiryDate, TransportTracking, MonitoringStatus)
        SELECT LoanID, UserID, ArtID, LoanAmount, DurationInDays, ExpiryDate, TransportTracking, MonitoringStatus
        FROM inserted;
        
        UPDATE Artwork
        SET Availability = 'on loan'
        WHERE ArtID IN (SELECT ArtID FROM inserted);
        
        DELETE FROM Exhibition WHERE ArtID IN (SELECT ArtID FROM inserted);
    END
END;
GO


-- Trigger to delete dependent records in Sales, Loan, and Gallery tables when a User is deleted
CREATE TRIGGER trg_DeleteDependentRecordsOnUserDelete
ON Users
INSTEAD OF DELETE
AS
BEGIN
    DELETE FROM Sales WHERE UserID IN (SELECT UserID FROM deleted);
    DELETE FROM Loan WHERE UserID IN (SELECT UserID FROM deleted);
    DELETE FROM Gallery WHERE UserID IN (SELECT UserID FROM deleted);
    DELETE FROM Users WHERE UserID IN (SELECT UserID FROM deleted);
END;
GO



-- Trigger to delete dependent records in Exhibition table when an Artwork is deleted
CREATE TRIGGER trg_DeleteDependentRecordsOnArtworkDelete
ON Artwork
AFTER DELETE
AS
BEGIN
    DELETE FROM Exhibition WHERE ArtID IN (SELECT ArtID FROM deleted);
    DELETE FROM Sales WHERE ArtID IN (SELECT ArtID FROM deleted);
    DELETE FROM Loan WHERE ArtID IN (SELECT ArtID FROM deleted);
END;
GO



-- Trigger to delete dependent records in Artwork and other tables when an Artist is deleted
CREATE TRIGGER trg_DeleteDependentRecordsOnArtistDelete
ON Artist
AFTER DELETE
AS
BEGIN
    DELETE FROM Artwork WHERE AID IN (SELECT AID FROM deleted);
    DELETE FROM Exhibition WHERE ArtID IN (SELECT ArtID FROM Artwork WHERE AID IN (SELECT AID FROM deleted));
    DELETE FROM Sales WHERE ArtID IN (SELECT ArtID FROM Artwork WHERE AID IN (SELECT AID FROM deleted));
    DELETE FROM Loan WHERE ArtID IN (SELECT ArtID FROM Artwork WHERE AID IN (SELECT AID FROM deleted));
    DELETE FROM Artist WHERE AID IN (SELECT AID FROM deleted);
END;
GO


-- Drop existing foreign key constraints if any
ALTER TABLE Artist DROP CONSTRAINT IF EXISTS FK_Artist_UserID;
ALTER TABLE Artwork DROP CONSTRAINT IF EXISTS FK_Artwork_AID;
ALTER TABLE Exhibition DROP CONSTRAINT IF EXISTS FK_Exhibition_ArtID;
ALTER TABLE Exhibition DROP CONSTRAINT IF EXISTS FK_Exhibition_GID;
ALTER TABLE Sales DROP CONSTRAINT IF EXISTS FK_Sales_ArtID;
ALTER TABLE Sales DROP CONSTRAINT IF EXISTS FK_Sales_UserID;
ALTER TABLE Loan DROP CONSTRAINT IF EXISTS FK_Loan_ArtID;
ALTER TABLE Loan DROP CONSTRAINT IF EXISTS FK_Loan_UserID;
ALTER TABLE Gallery DROP CONSTRAINT IF EXISTS FK_Gallery_UserID;

-- Add foreign key constraints with cascading deletes

-- Artist to Users
ALTER TABLE Artist
ADD CONSTRAINT FK_Artist_UserID
FOREIGN KEY (UserID)
REFERENCES Users(UserID)
ON DELETE CASCADE;

-- Artwork to Artist
ALTER TABLE Artwork
ADD CONSTRAINT FK_Artwork_AID
FOREIGN KEY (AID)
REFERENCES Artist(AID)
ON DELETE CASCADE;

-- Exhibition to Artwork
ALTER TABLE Exhibition
ADD CONSTRAINT FK_Exhibition_ArtID
FOREIGN KEY (ArtID)
REFERENCES Artwork(ArtID)
ON DELETE CASCADE;

-- Exhibition to Gallery
ALTER TABLE Exhibition
ADD CONSTRAINT FK_Exhibition_GID
FOREIGN KEY (GID)
REFERENCES Gallery(GID)
ON DELETE CASCADE;

-- Sales to Artwork
ALTER TABLE Sales
ADD CONSTRAINT FK_Sales_ArtID
FOREIGN KEY (ArtID)
REFERENCES Artwork(ArtID)
ON DELETE CASCADE;

-- Loan to Artwork
ALTER TABLE Loan
ADD CONSTRAINT FK_Loan_ArtID
FOREIGN KEY (ArtID)
REFERENCES Artwork(ArtID)
ON DELETE CASCADE;

-- Sales to Users
ALTER TABLE Sales
ADD CONSTRAINT FK_Sales_UserID
FOREIGN KEY (UserID)
REFERENCES Users(UserID)
ON DELETE CASCADE;

-- Loan to Users
ALTER TABLE Loan
ADD CONSTRAINT FK_Loan_UserID
FOREIGN KEY (UserID)
REFERENCES Users(UserID)
ON DELETE CASCADE;

-- Gallery to Users
ALTER TABLE Gallery
ADD CONSTRAINT FK_Gallery_UserID
FOREIGN KEY (UserID)
REFERENCES Users(UserID)
ON DELETE CASCADE;





