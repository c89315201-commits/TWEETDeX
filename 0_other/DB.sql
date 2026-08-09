"""
Simple connection script for the simpletwitterserver database
hosted on freesqldatabase.com.

Requires: pip install pymysql
"""

import pymysql

DB_CONFIG = {
    "host": "sql5.freesqldatabase.com",
    "port": 3306,
    "user": "sql5834481",
    "password": "gRWCi3eqSC",
    "database": "sql5834481",
    "charset": "utf8mb4",
    "cursorclass": pymysql.cursors.DictCursor,
    "connect_timeout": 10,
}


def get_connection():
    """Open and return a new database connection."""
    return pymysql.connect(**DB_CONFIG)


def test_connection():
    """Quick sanity check: connect, list tables, print row counts."""
    try:
        conn = get_connection()
    except pymysql.err.OperationalError as e:
        print(f"Connection failed: {e}")
        return

    try:
        with conn.cursor() as cur:
            cur.execute("SHOW TABLES;")
            tables = [list(row.values())[0] for row in cur.fetchall()]
            print(f"Connected. Tables found: {tables}")

            for table in tables:
                cur.execute(f"SELECT COUNT(*) AS cnt FROM `{table}`;")
                count = cur.fetchone()["cnt"]
                print(f"  {table}: {count} row(s)")
    finally:
        conn.close()


def get_accounts():
    """Fetch all accounts (omit sensitive fields)."""
    conn = get_connection()
    try:
        with conn.cursor() as cur:
            cur.execute(
                "SELECT ID, Username, FullName, IsVerified, RegistrationTS FROM accounts;"
            )
            return cur.fetchall()
    finally:
        conn.close()


def get_recent_tweets(limit=20):
    """Fetch the most recent tweets, joined with the poster's username."""
    conn = get_connection()
    try:
        with conn.cursor() as cur:
            cur.execute(
                """
                SELECT t.ID, t.Text, t.Timestamp, a.Username
                FROM tweets t
                JOIN accounts a ON a.ID = t.PosterUserID
                ORDER BY t.Timestamp DESC
                LIMIT %s;
                """,
                (limit,),
            )
            return cur.fetchall()
    finally:
        conn.close()


if __name__ == "__main__":
    test_connection()
