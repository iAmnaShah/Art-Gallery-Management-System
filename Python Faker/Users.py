import random
import pyodbc as odbc

# Define customized list of user attributes
user_ids = list(range(1, 102))  # 100 User IDs from 1 to 100
emails = [
    f"user{i}@example.com" for i in range(1, 101)
]

usernames = [
    f"user{i}" for i in range(1, 101)
]

passwords = [
    f"Password{i}!" for i in range(1, 101)
]

roles = ["Admin", "Staff", "Client", "Artist"]

first_names = [
    "John", "Alice", "Bob", "Carol", "David", "Emma", "Frank", "Grace", "Henry", "Ivy",
    "Jack", "Linda", "Michael", "Susan", "Peter", "Sophia", "Robert", "Jennifer", "William", "Jessica",
    "Daniel", "Mary", "Christopher", "Karen", "Matthew", "Nancy", "Joshua", "Lisa", "Andrew", "Samantha",
    "James", "Karen", "Joseph", "Emily", "Ryan", "Nicole", "Richard", "Michelle", "David", "Angela",
    "Charles", "Kimberly", "Thomas", "Melissa", "Steven", "Patricia", "Donald", "Amy", "Mark", "Laura",
    "Paul", "Rebecca", "Kevin", "Stephanie", "George", "Elizabeth", "Brian", "Julie", "Edward", "Heather",
    "Matthew", "Sarah", "Adam", "Nathan", "Chris", "Lauren", "Brandon", "Amber", "Patrick", "Danielle",
    "Olivia", "Sophia", "Emma", "Isabella", "Ava", "Mia", "Evelyn", "Harper", "Camila", "Gianna",
    "Abigail", "Luna", "Ella", "Elizabeth", "Sofia", "Emily", "Avery", "Mila", "Scarlett", "Aria",
    "Chloe", "Layla", "Amelia", "Hannah", "Lily", "Zoey", "Riley", "Nora", "Liam", "Mason"
]

last_names = [
    "Smith", "Johnson", "Williams", "Jones", "Brown", "Davis", "Miller", "Wilson", "Moore", "Taylor",
    "Anderson", "Thomas", "Jackson", "White", "Harris", "Martin", "Thompson", "Garcia", "Martinez", "Robinson",
    "Clark", "Rodriguez", "Lewis", "Lee", "Walker", "Hall", "Allen", "Young", "Hernandez", "King",
    "Wright", "Lopez", "Hill", "Scott", "Green", "Adams", "Baker", "Gonzalez", "Nelson", "Carter",
    "Mitchell", "Perez", "Roberts", "Turner", "Phillips", "Campbell", "Parker", "Evans", "Edwards", "Collins",
    "Stewart", "Sanchez", "Morris", "Rogers", "Reed", "Cook", "Morgan", "Bell", "Murphy", "Bailey",
    "Sullivan", "Price", "Perry", "Powell", "Russell", "Reed", "Watson", "Brooks", "Sanders", "Wood",
    "Ward", "Torres", "Peterson", "Gray", "Ramirez", "James", "Watson", "Brooks", "Kelly", "Sanders",
    "Price", "Bennett", "Wood", "Barnes", "Ross", "Henderson", "Coleman", "Jenkins", "Perry", "Powell",
    "Long", "Patterson", "Hughes", "Flores", "Washington", "Butler", "Simmons", "Foster", "Gonzales", "Bryant"
]

addresses = [
    f"{i} Maple Street" for i in range(1, 101)
]

phone_numbers = [
    f"123-456-78{str(i).zfill(2)}" for i in range(1, 101)
]

# Randomly select 30 unique users from the list
selected_indices = random.sample(range(100), 100)
selected_users = [(user_ids[i], emails[i], usernames[i], passwords[i], first_names[i], last_names[i], addresses[i], phone_numbers[i]) for i in selected_indices]

# Ensure there are exactly 2 Admin roles, 8 Staff, 10 Clients, and 10 Artists
roles_list = ["Admin"] * 10 + ["Staff"] * 20 + ["Client"] * 45 + ["Artist"] * 25
random.shuffle(roles_list)

# Combine selected_users with roles
selected_users_with_roles = [(user[0], user[1], user[2], user[3], roles_list[i], user[4], user[5], user[6], user[7]) for i, user in enumerate(selected_users)]

# Sort users by user_id for deterministic order
selected_users_with_roles.sort(key=lambda user: user[0])

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

# Create the Users table if it doesn't exist
cursor.execute('''
               IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'Users')
               CREATE TABLE Users
               (    UserID INT PRIMARY KEY,
                    UserEmail VARCHAR(255) UNIQUE,
                    Username VARCHAR(100) UNIQUE,
                    Password VARCHAR(255),
                    Role VARCHAR(100),
                    FirstName VARCHAR(100),
                    LastName VARCHAR(100),
                    Address VARCHAR(255),
                    PhoneNo VARCHAR(20) UNIQUE)
               ''')

# Insert records into the Users table
insert_query = '''
INSERT INTO Users (UserID, UserEmail, Username, Password, Role, FirstName, LastName, Address, PhoneNo)
VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)
'''

for user in selected_users_with_roles:
    cursor.execute(insert_query, user)
    print("Inserted Successfully")

# Commit the transaction
conn.commit()

# Close the cursor and connection
cursor.close()
conn.close()
