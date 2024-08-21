import random

from pyodbc import connect



# Define lists for Gallery attributes

g_ids = list(range(1, 101))

gallery_names = [

    "Artful Ancestry", "Skarstedt Fine Art", "Modern Masterpieces", "Creative Expressions",

    "Heritage Gallery", "Visionary Art"

]

statuses = ["Open", "Closed"]

locations = [

    "Block C, Cornellia St.", "Avenue 5, Blueberry Hill", "Sector 10, Riverside", "Lot 23, Maple Street"

]



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

conn = connect(conn_str)

cursor = conn.cursor()



# Create Gallery table if it doesn't exist

cursor.execute('''

               IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'Gallery')

               CREATE TABLE Gallery

               (

                        GID INT,

                        GalleryName VARCHAR(255),

                        Status VARCHAR(50),

                        Location VARCHAR(255),

                        CONSTRAINT PKGALLERY PRIMARY KEY (GID)

                                   )

               ''')



# Randomly select 2 values from the customized lists

selected_gallery_names = random.sample(gallery_names, 2)

selected_statuses = random.sample(statuses, 2)

selected_locations = random.sample(locations, 2)



# Generate 60 records by cycling through the selected values

gallery_records = list(zip(

    random.sample(g_ids, 2),

    [selected_gallery_names[i % 2] for i in range(5)],

    [selected_statuses[i % 2] for i in range(5)],

    [selected_locations[i % 2] for i in range(5)]

))



# Insert records into the Gallery table

for record in gallery_records:

    cursor.execute('''

                   INSERT INTO Gallery (GID, GalleryName, Status, Location)

                   VALUES (?, ?, ?, ?)

                   ''',

                   record[0], record[1], record[2], record[3])

    print("Inserted Successfully")



# Commit the transaction

conn.commit()



# Close the cursor and connection

cursor.close()

conn.close()

