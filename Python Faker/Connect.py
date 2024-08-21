import pyodbc as odbc

SERVER_NAME = r'DESKTOP-8J774MH\SQLEXPRESS'
DATABASE_NAME = 'assignment'

# Define connection string
conn_str = (
    f'DRIVER={{ODBC Driver 17 for SQL Server}};'
    f'SERVER={SERVER_NAME};'
    f'DATABASE={DATABASE_NAME};'
    r'Trusted_Connection=yes;'  # For Windows Authentication
)

try:
    # Establish connection
    conn = odbc.connect(conn_str)

    # Create a cursor
    cursor = conn.cursor()

    # Define functions to call stored procedures
    def insert_client(client_email, client_firstname, client_lastname, client_phone, client_address):
        try:
            cursor.execute("EXEC InsertClient ?, ?, ?, ?, ?", (client_email, client_firstname, client_lastname, client_phone, client_address))
            conn.commit()
            print("Client inserted successfully!")
        except odbc.Error as e:
            print(f"Error inserting client: {e}")

    def read_clients():
        try:
            cursor.execute("EXEC ReadClient")
            rows = cursor.fetchall()
            for row in rows:
                print(row)
        except odbc.Error as e:
            print(f"Error reading clients: {e}")

    def update_client(client_id, client_email, client_firstname, client_lastname, client_phone, client_address):
        try:
            cursor.execute("EXEC UpdateClient ?, ?, ?, ?, ?, ?", (client_id, client_email, client_firstname, client_lastname, client_phone, client_address))
            conn.commit()
            print("Client updated successfully!")
        except odbc.Error as e:
            print(f"Error updating client: {e}")

    def delete_client(client_id):
        try:
            cursor.execute("EXEC DeleteClient ?", (client_id,))
            conn.commit()
            print("Client deleted successfully!")
        except odbc.Error as e:
            print(f"Error deleting client: {e}")

    # Example data insertion
    insert_client('example@example.com', 'John', 'Doe', '1234567890', '123 Main Street')
    insert_client('test@test.com', 'Jane', 'Smith', '0987654321', '456 Oak Avenue')

    # Close cursor and connection
    cursor.close()
    conn.close()

except odbc.Error as e:
    print("Error connecting to database:", e)
