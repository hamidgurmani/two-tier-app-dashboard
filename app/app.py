from flask import Flask, render_template, request, redirect
import os
import psycopg2

app = Flask(__name__)

def get_db_connection():
    return psycopg2.connect(
        host=os.getenv("DB_HOST"),
        database=os.getenv("DB_NAME"),
        user=os.getenv("DB_USER"),
        password=os.getenv("DB_PASSWORD"),
    )

# ✅ HEALTHCHECK ENDPOINT (NO DATABASE)
@app.route("/health")
def health():
    return {"status":"OK"}, 200

@app.route("/", methods=["GET", "POST"])
def index():
    if request.method == "POST":
        name = request.form["name"]

        conn = get_db_connection()
        cur = conn.cursor()
        cur.execute("INSERT INTO users (name) VALUES (%s)", (name,))
        conn.commit()
        cur.close()
        conn.close()

        return redirect("/")

    conn = get_db_connection()
    cur = conn.cursor()
    cur.execute("SELECT * FROM users")
    users = cur.fetchall()
    cur.close()
    conn.close()

    return render_template("index.html", users=users)

if __name__ == "__main__":
    app.run(host="0.0.0.0", port=5000)

