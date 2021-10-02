from flask import Flask, redirect

app = Flask(__name__)

@app.route("/")
def index():
    return redirect("https://pulli.noskiller.de/")

@app.route("/<path:directories>")
def index_dir(directories):
    return redirect("https://pulli.noskiller.de/" + str(directories))

app.run(host="0.0.0.0", port=1080)
