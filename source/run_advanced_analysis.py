import sqlite3
from pathlib import Path

conn = sqlite3.connect("sales.db")

sql = Path("src/advanced_analysis.sql").read_text()

# Take only the first query
query = sql.split(";")[2]

result = conn.execute(query)

columns = [description[0] for description in result.description]

print("\nFEBRUARY RCA")
print("-" * 70)
print(" | ".join(columns))

for row in result.fetchall():
    print(" | ".join(str(value) for value in row))

conn.close()