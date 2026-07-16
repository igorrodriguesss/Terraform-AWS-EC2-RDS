from flask import Flask, render_template, request, redirect
import pymysql
import pymysql.cursors

app = Flask(__name__)

DB_CONFIG = {
    "host": "terraform-tbc-mysql.cmlmgkk4qpcu.us-east-1.rds.amazonaws.com",
    "user": "admin",
    "password": "mypassword",
    "database": "mydatabase",
    "port": 3306,
    "cursorclass": pymysql.cursors.DictCursor,
}

def get_connection():
    return pymysql.connect(**DB_CONFIG)

@app.route("/")
def index():
    conn = get_connection()
    try:
        with conn.cursor() as cur:
            cur.execute("SELECT * FROM users")
            data = cur.fetchall()
        return render_template("index.html", users=data)
    finally:
        conn.close()

@app.route("/add", methods=["GET", "POST"])
def add():
    if request.method == "POST":
        name = request.form["name"]
        email = request.form["email"]
        conn = get_connection()
        try:
            with conn.cursor() as cur:
                cur.execute("INSERT INTO users (name, email) VALUES (%s, %s)", (name, email))
            conn.commit()
        finally:
            conn.close()
        return redirect("/")
    return render_template("add.html")

@app.route("/edit/<int:id>", methods=["GET", "POST"])
def edit(id):
    conn = get_connection()
    try:
        with conn.cursor() as cur:
            if request.method == "POST":
                name = request.form["name"]
                email = request.form["email"]
                cur.execute("UPDATE users SET name=%s, email=%s WHERE id=%s", (name, email, id))
                conn.commit()
                return redirect("/")
            cur.execute("SELECT * FROM users WHERE id=%s", [id])
            user = cur.fetchone()
        return render_template("edit.html", user=user)
    finally:
        conn.close()

@app.route("/delete/<int:id>")
def delete(id):
    conn = get_connection()
    try:
        with conn.cursor() as cur:
            cur.execute("DELETE FROM users WHERE id=%s", [id])
        conn.commit()
    finally:
        conn.close()
    return redirect("/")

if __name__ == "__main__":
    app.run(host="0.0.0.0", port=8080)