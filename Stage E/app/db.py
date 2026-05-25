"""
db.py - Database access layer for the Restaurant Management GUI.
Connects to the integrated PostgreSQL database (Stages A-D) via psycopg2.
"""
import psycopg2
import psycopg2.extras

# Connection parameters (the database runs in Docker, exposed on localhost:5432)
CONFIG = {
    "host": "localhost",
    "port": 5432,
    "dbname": "DB5786David",
    "user": "MyUser",
    "password": "password",
}


def set_credentials(user: str, password: str):
    """Update the active credentials (called by the login screen)."""
    CONFIG["user"] = user
    CONFIG["password"] = password


def get_connection():
    return psycopg2.connect(**CONFIG)


def try_login(user: str, password: str) -> bool:
    """Attempt a real connection with the given credentials (used as login)."""
    cfg = dict(CONFIG)
    cfg["user"] = user
    cfg["password"] = password
    conn = psycopg2.connect(**cfg)
    conn.close()
    return True


def fetch_dicts(query, params=None):
    """Run a SELECT and return a list of dict rows."""
    with get_connection() as conn:
        with conn.cursor(cursor_factory=psycopg2.extras.RealDictCursor) as cur:
            cur.execute(query, params)
            return cur.fetchall()


def fetch_table(query, params=None):
    """Run a SELECT and return (columns, rows) where rows are tuples."""
    with get_connection() as conn:
        with conn.cursor() as cur:
            cur.execute(query, params)
            cols = [d[0] for d in cur.description] if cur.description else []
            rows = cur.fetchall() if cur.description else []
            return cols, rows


def execute(query, params=None):
    """Run an INSERT/UPDATE/DELETE. Returns affected row count."""
    with get_connection() as conn:
        with conn.cursor() as cur:
            cur.execute(query, params)
            conn.commit()
            return cur.rowcount


def call_procedure(call_sql, params=None):
    """CALL a stored procedure and capture the NOTICE messages it raises."""
    conn = get_connection()
    try:
        with conn.cursor() as cur:
            cur.execute(call_sql, params)
        conn.commit()
        notices = list(conn.notices)
        return notices
    finally:
        conn.close()
