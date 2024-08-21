import random

import pyodbc as odbc

from datetime import datetime, timedelta



# Define lists for Loan attributes

loan_ids = list(range(1, 101))

durations = [30, 60, 90, 120, 150, 180, 210, 240, 270, 300, 330, 360]

transport_options = ["TCS Service", "FedEx", "DHL", "UPS", "BlueDart"]

monitoring_statuses = ["On track", "Delayed", "Completed"]



# Generate random expiry dates within the next two years

def random_date():

    start_date = datetime(2023, 1, 1)

    end_date = datetime(2025, 1, 1)

    delta = end_date - start_date

    random_days = random.randint(0, delta.days)

    return start_date + timedelta(days=random_days)



# Database connection details

SERVER_NAME = r'DESKTOP-8J774MH\SQLEXPRESS'

DATABASE_NAME = 'ArtGalleryManagementSystem'



# Connection string

conn_str = (

    f'DRIVER={{ODBC Driver 17 for SQL Server}};'

    f'SERVER={SERVER_NAME};'

    f'DATABASE={DATABASE_NAME};'

    r'Trusted_Connection=yes;'

)



# Establish connection

conn = odbc.connect(conn_str)

cursor = conn.cursor()



# Create Loan table if it doesn't exist

cursor.execute('''

               IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'Loan')

               CREATE TABLE Loan

               (

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

                    CONSTRAINT FKLOANART FOREIGN KEY (ArtID) REFERENCES Artwork(ArtID)



               )

               ''')



# Fetch Art_IDs and their corresponding prices from Artwork table for available artworks

cursor.execute('SELECT ArtID, Price FROM Artwork WHERE Availability = \'Available\'')

artworks = cursor.fetchall()

art_ids = [row[0] for row in artworks]

art_prices = {row[0]: row[1] for row in artworks}



# Fetch UserID values from Users table where the role is 'client'

cursor.execute('SELECT UserID FROM Users WHERE Role = \'client\'')

user_ids = [row[0] for row in cursor.fetchall()]



# Ensure unique Loan_ID values by shuffling and slicing the list

random.shuffle(loan_ids)

unique_loan_ids = loan_ids[:100]  # Adjusted to generate 100 records



# Randomly select 100 values from the customized lists

loan_records = []

for loan_id in unique_loan_ids:

    art_id = random.choice(art_ids)

    user_id = random.choice(user_ids)

    loan_amount = art_prices[art_id] / 2

    duration_in_days = random.choice(durations)

    expiry_date = random_date().date()

    transport_tracking = random.choice(transport_options)

    monitoring_status = random.choice(monitoring_statuses)

    loan_records.append((loan_id, user_id, art_id, loan_amount, duration_in_days, expiry_date, transport_tracking, monitoring_status))



# Insert records into the Loan table

for record in loan_records:

    cursor.execute('''

                   INSERT INTO Loan (LoanID, UserID, ArtID, LoanAmount, DurationInDays, ExpiryDate, TransportTracking, MonitoringStatus)

                   VALUES (?, ?, ?, ?, ?, ?, ?, ?)

                   ''',

                   record[0], record[1], record[2], record[3], record[4], record[5], record[6], record[7])

    print("Inserted Successfully")



# Commit the transaction

conn.commit()



# Close the cursor and connection

cursor.close()

conn.close()
