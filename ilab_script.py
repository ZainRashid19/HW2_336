import sys
import psycopg2
import pandas as pd

# 1. Get the query from the command line
query = sys.argv[1]

# 2. Connect to the Rutgers Postgres server
conn = psycopg2.connect(
    host="postgres.cs.rutgers.edu",
    database="your_ned_id",
    user="your_net_id",
    password="net_id_password!"
)

# 3. Run and print the table
df = pd.read_sql_query(query, conn)
print(df.to_string(index=False))
