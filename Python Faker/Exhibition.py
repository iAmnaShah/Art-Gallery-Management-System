import random

from pyodbc import connect

from datetime import datetime, timedelta



# Define lists for Exhibition attributes

e_ids = list(range(1, 121))

start_dates = [

    "2023-01-15", "2023-02-20", "2023-03-18", "2023-04-22", "2023-05-05", "2023-06-11", "2023-07-19",

    "2023-08-24", "2023-09-30", "2023-10-14", "2023-11-23", "2023-12-02"

]

end_dates = []

for start_date in start_dates:

    start_datetime = datetime.strptime(start_date, "%Y-%m-%d")

    max_end_date = start_datetime + timedelta(days=5)

    end_datetime = start_datetime + timedelta(days=random.randint(1, 5))

    # Ensure that the end date is within 5 days after the start date

    if end_datetime > max_end_date:

        end_datetime = max_end_date

    end_dates.append(end_datetime.strftime("%Y-%m-%d"))



locations = [

    "Hyde Park, London", "Louvre, Paris", "Museum of Modern Art, New York", "Tate Modern, London",

    "The Met, New York", "Uffizi Gallery, Florence"

]

e_names = [

    "Solstice", "Artistry Showcase", "Creative Expression Expo", "Visual Delights Exhibition",

    "Palette Perfection Showcase", "Imagination Unleashed Expo", "Cultural Fusion Exhibition", "Canvas Creations Showcase", "Eclectic Artistry Expo",

    "Vibrant Visions Exhibition", "Artisanal Craftsmanship Showcase", "Gallery Galore Expo", "Modern Masterpieces Exhibition",

    "Abstract Adventures Showcase", "Surreal Splendor Expo", "Contemporary Perspectives Exhibition",

    "Artful Endeavors Showcase", "Fusion of Colors Expo", "Urban Artistry Exhibition", "Ephemeral Elegance Showcase",

    "Timeless Treasures Expo", "Harmony in Hues Exhibition", "Nature's Canvas Showcase", "Captivating Contrasts Expo",

    "Whimsical Wonders Exhibition", "Ethereal Essence Showcase", "Serene Symmetry Expo", "Dynamic Dimensions Exhibition",

    "Radiant Realms Showcase", "Enigmatic Expressions Expo", "Transcendent Textures Exhibition",

]

themes = [

    "Nature and Landscapes",

    "Portraits and Figures",

    "Abstract Expressionism",

    "Surrealism",

    "Still Life",

    "Urban Scenes",

    "Mythology and Folklore",

    "Fantasy and Science Fiction",

    "Impressionism",

    "Realism",

    "Wildlife and Animals",

    "Historical Events",

    "Religious and Spiritual",

    "Social and Political Commentary",

    "Romance and Love",

    "Dreams and Imagination",

    "Symbolism",

    "Contemporary Issues",

    "Pop Culture",

    "Environmental Conservation",

    "Cultural Diversity",

    "Technological Advancement",

    "Human Emotions and Psychology",

    "Architectural Wonders",

    "Celestial Bodies and Space Exploration",

    "Mysticism and Esotericism",

    "Nostalgia and Memory",

    "Identity and Self-Discovery",

    "Abstract Concepts and Ideas",

    "Seasons and Weather"

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



# Create Exhibition table if it doesn't exist

cursor.execute('''

               IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'Exhibition')

               CREATE TABLE Exhibition

               (    EID INT,

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



               )

               ''')



# Fetch ArtID values from Artwork table

cursor.execute('SELECT ArtID FROM Artwork')

art_ids = [row[0] for row in cursor.fetchall()]



# Fetch GID values from Gallery table

cursor.execute('SELECT GID FROM Gallery')

gallery_ids = [row[0] for row in cursor.fetchall()]



# Randomly select 120 values from the customized lists

exhibition_records = list(zip(

    random.sample(e_ids, 120),

    random.choices(gallery_ids, k=120),

    random.choices(start_dates, k=120),

    random.choices(end_dates, k=120),

    random.choices(locations, k=120),

    random.choices(e_names, k=120),

    random.choices(themes, k=120),

    random.choices(art_ids, k=120)

))



# Insert records into the Exhibition table

for record in exhibition_records:

    cursor.execute('''

                   INSERT INTO Exhibition (EID, GID, StartDate, EndDate, Location, EName, Theme, ArtID)

                   VALUES (?, ?, ?, ?, ?, ?, ?, ?)

                   ''',

                   record[0], record[1], record[2], record[3], record[4], record[5], record[6], record[7])

    print("Inserted Successfully")



# Commit the transaction

conn.commit()



# Close the cursor and connection

cursor.close()

conn.close()
