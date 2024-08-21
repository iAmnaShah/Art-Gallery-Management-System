import random
from pyodbc import connect
from datetime import datetime

# Define lists for Artwork attributes
art_ids = list(range(1, 101))
titles = [
    "The Starry Night", "The Last Supper", "Mona Lisa", "The Persistence of Memory",
    "Girl with a Pearl Earring", "The Scream", "Guernica", "The Night Watch",
    "The Kiss", "The Birth of Venus", "American Gothic", "Water Lilies",
    "The Garden of Earthly Delights", "The Arnolfini Portrait", "The Hay Wain", "The Fighting Temeraire",
    "Liberty Leading the People", "The Raft of the Medusa", "Las Meninas", "The Son of Man",
    "The Sleeping Gypsy", "The Ambassadors", "No. 5, 1948", "Wanderer above the Sea of Fog",
    "The Great Wave off Kanagawa", "The Third of May 1808", "Starry Night Over the Rhone", "Olympia",
    "Impression, Sunrise", "Bal du moulin de la Galette", "The Storm on the Sea of Galilee",
    "The Card Players", "The Old Guitarist", "A Sunday Afternoon on the Island of La Grande Jatte",
    "The Dance Class", "The Arnolfini Portrait", "The Sleeping Gypsy", "The Ambassadors",
    "The Night Watch", "The Garden of Earthly Delights", "The Kiss", "American Gothic",
    "Water Lilies", "The Persistence of Memory", "Girl with a Pearl Earring", "The Scream",
    "Guernica", "The Last Supper", "The Starry Night", "The Birth of Venus"
]
mediums = [
    "oil", "acrylic", "watercolor", "ink", "charcoal", "pastel", "tempera",
    "gouache", "fresco", "encaustic", "digital"
]
dimensions = [
    "1280x720", "1920x1080", "3840x2160", "800x600", "1024x768", "1600x900", "2560x1440", "1280x960",
    "1366x768", "1440x900", "1680x1050"
]
dates_completed = [
    "2023-01-15", "2023-02-20", "2023-03-18", "2023-04-22", "2023-05-05", "2023-06-11", "2023-07-19",
    "2023-08-24", "2023-09-30", "2023-10-14", "2023-11-23", "2023-12-02"
]
prices = [
    20000, 30000, 40000, 50000, 60000, 70000, 80000, 90000, 100000, 110000, 120000, 130000,
    140000, 150000, 160000, 170000, 180000, 190000, 200000, 210000, 220000, 230000, 240000,
    250000, 260000, 270000, 280000, 290000, 300000, 310000, 320000, 330000, 340000, 350000,
    360000, 370000, 380000, 390000, 400000, 410000, 420000, 430000, 440000, 450000, 460000,
    470000, 480000, 490000, 500000
]
availability = ["Available", "Not for Sale", "Sold"]

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

# Create Artwork table if it doesn't exist
cursor.execute('''
               IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'Artwork')
               CREATE TABLE Artwork
               (
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

               )
               ''')

# Fetch A_IDs from Artist table
cursor.execute('SELECT AID FROM Artist')
artist_ids = [row[0] for row in cursor.fetchall()]

# Randomly select 100 values from the customized lists
artwork_records = list(zip(
    random.sample(art_ids, 100),
    random.choices(artist_ids, k=100),
    random.sample(titles, 50),
    random.choices(mediums, k=100),
    random.choices(dimensions, k=100),
    random.choices(dates_completed, k=100),
    random.choices(prices, k=100),
    random.choices(availability, k=100)
))

# Insert records into the Artwork table
for record in artwork_records:
    # Ensure that the price is set to None if availability is 'Not for Sale'
    if record[7] == 'Not for Sale':
        price = None
    else:
        price = record[6]

    cursor.execute('''
                   INSERT INTO Artwork (ArtID, AID, Title, Medium, Dimensions, DateCompleted, Availability, Price)
                   VALUES (?, ?, ?, ?, ?, ?, ?, ?)
                   ''',
                   record[0], record[1], record[2], record[3], record[4], record[5], record[7], price)
    print("Inserted Successfully")

# Commit the transaction
conn.commit()

# Close the cursor and connection
cursor.close()
conn.close()
