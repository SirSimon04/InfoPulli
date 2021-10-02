import sys
import time
from flask import Flask, request, jsonify, Response, send_file, redirect
from multiprocessing import Process
from server_reloader import main
import mysql.connector
import json, logging, math, os, requests, ssl

# Absolute path for raspberry pi
# context = ("/home/pi/Documents/GitHub/InfoPulli/certificates/fullchain1.pem", "/home/pi/Documents/GitHub/InfoPulli/certificates/privkey1.pem")

# Absolute path for NAS-3
context = ("/homes/Lukas/InfoPulli/certificates/fullchain1.pem", "/homes/Lukas/InfoPulli/certificates/privkey1.pem")

app = Flask(__name__)
conn = mysql.connector.connect(
    user="pulli",
    password="Informatik2022",
    host="localhost",
    database="pulli"
)
cursor = conn.cursor()

logging.basicConfig(filename="server.log")
logging.debug("Starting server.py")

# https://www.calculator.net/distance-calculator.html
# https://cs.nyu.edu/visual/home/proj/tiger/gisfaq.html (*)
def d_latlng(cord1, cord2, r = 6371):
    r = r * 1000
    rad = math.pi / 180
    try:
        lat1 = cord1[0] * rad
        lat2 = cord2[0] * rad
        sinDLat = math.sin((cord2[0] - cord1[0]) * rad / 2)
        sinDLng = math.sin((cord2[1] - cord1[1]) * rad / 2)
        a = (sinDLat * sinDLat) + (math.cos(lat1) * math.cos(lat2) * sinDLng * sinDLng)
        c = 2 * math.atan2(math.sqrt(a), math.sqrt(1 - a))
        return r * c
    except Exception as e:
        logging.error(f"An error occured: {e}")
        logging.debug(f"State of variables: r={r}, cord1={cord1}, cord2={cord2}")

# https://developer.tomtom.com/search-api/search-api-documentation-reverse-geocoding/reverse-geocode
def get_street_data(cord):
    data = "not set yet"
    try:
        base_url = "api.tomtom.com"
        version_number = "2"
        position = str(cord[0]) + "," + str(cord[1])
        ext = "JSON"
        key = "uHuXYU2hIlocJtD1UgIwV0O8omx8sZHv"

        req = requests.get(f"https://{base_url}/search/{version_number}/reverseGeocode/{position}.{ext}?key={key}")
        data = json.loads(req.text)
        if len(data["addresses"]) == 0:
            return {"message": "NOT FOUND"}
        addr = data["addresses"][0]["address"]
        #return addr["street"] + " " + addr["streetNumber"]
        return addr
    except Exception as e:
        logging.error(f"An error occured: {e}")
        logging.debug(f"State of variables: cord={cord}, data={data}")

@app.route("/get_all_avgs", methods=["POST"])
def get_scoreboard():
    global conn, cursor

    try: data = json.loads(request.data.decode("UTF-8"))
    except: data = {}

    if not conn.is_connected(): conn.reconnect()

    cursor = conn.cursor()

    board_type = data.get("board_type")
    if not board_type: board_type = "avg_distance"

    if board_type == "avg_distance":
        SQL = "SELECT avg_distance, persons.first, persons.last FROM scanned_locations LEFT JOIN persons WHERE scanned_locations.person_id = persons.id ORDER BY scanned_locations.avg_distance DESC;"
    elif board_type == "count":
        SQL = "SELECT persons.short, COUNT(scanned_locations.id) AS 'Anzahl' FROM scanned_locations JOIN persons WHERE scanned_locations.person_id = persons.id GROUP BY persons.short ORDER BY Anzahl DESC;"

    logging.debug(f"/get_all_avgs: SQL={SQL}")

    return "function not implemented (yet)"

@app.route("/get_counts", methods=["POST"])
def get_counts():
    global conn, cursor

    try: data = json.loads(request.data.decode("UTF-8"))
    except: data = {}

    if not conn.is_connected(): conn.reconnect()

    cursor = conn.cursor()

    SQL = "SELECT persons.short, PersonScanAnzahl.Anzahl, persons.first, persons.last FROM PersonScanAnzahl JOIN persons ON persons.short = PersonScanAnzahl.short ORDER BY Anzahl DESC;"
    cursor.execute(SQL)
    fetched = cursor.fetchall()
    data = []

    for _short, _anzahl, _first, _last in fetched:
        data.append({"short": _short, "count": _anzahl, "first": _first, "last": _last})

    logging.debug(f"/get_counts: data={data}")

    resp = Response(json.dumps({"message": "OK", "content": data}), 200)
    resp.headers["Access-Control-Allow-Origin"] = "*"
    return resp

@app.route("/get_avg_distance", methods=["POST"])
def get_avg_distance():
    global conn, cursor

    try: data = json.loads(request.data.decode("UTF-8"))
    except: data = {}

    if not conn.is_connected(): conn.reconnect()

    cursor = conn.cursor()

    short = data.get("short")
    if not short: return Response("SHORT MISSING", 400)

    SQL = f"SELECT avg_distance FROM scanned_locations JOIN persons WHERE scanned_locations.person_id = persons.id AND persons.short = '{short}' ORDER BY scanned_locations.id DESC LIMIT 1;"
    cursor.execute(SQL)
    fetched = cursor.fetchone()
    data = fetched[0]

    resp = Response(json.dumps({"message": "OK", "content": data}), 200)
    resp.headers["Access-Control-Allow-Origin"] = "*"
    return resp

@app.route("/get_locations", methods=["POST"])
def get_locations():
    global conn, cursor

    try: data = json.loads(request.data.decode("UTF-8"))
    except: data = {}

    if not conn.is_connected(): conn.reconnect()

    cursor = conn.cursor()

    SQL = "SELECT timestamp, latitude, longitude, accuracy, person_id, short, first, last, street_name, message FROM scanned_locations JOIN persons WHERE scanned_locations.person_id = persons.id;"
    cursor.execute(SQL)
    fetched = cursor.fetchall()
    data = []
    for _timestamp, _latitude, _longitude, _accuracy, _person_id, _short, _first, _last, _street_name, _message in fetched:
        data.append((_timestamp.timestamp(), _latitude, _longitude, _accuracy, _person_id, _short, _first, _last, _street_name, _message))

    resp = Response(json.dumps({"message": "OK", "content": data}), 200)
    resp.headers["Access-Control-Allow-Origin"] = "*"
    return resp

@app.route("/add", methods=["POST"])
def data_add():
    global conn, cursor

    try: data = json.loads(request.data.decode("UTF-8"))
    except: data = {}

    logging.debug(data)

    if not conn.is_connected(): conn.reconnect()

    cursor = conn.cursor()

    latitude = data.get("latitude")

    longitude = data.get("longitude")

    accuracy = data.get("accuracy")
    if not accuracy: return Response("ACCURACY MISSING", 400)

    person_id = data.get("person_id")
    if not person_id: return Response("PERSON_ID MISSING", 400)

    message = data.get("message")

    if person_id != -1:
        logging.debug("person_id != -1")
        SQL = f"SELECT latitude, longitude, accuracy from scanned_locations WHERE person_id = '{person_id}';"
        cursor.execute(SQL)
        fetched = cursor.fetchall()
        avg = 0

        if fetched:
            cords = []
            for _lat, _lng, _acc in fetched:
                cords.append([_lat, _lng, _acc])
            cords.append([latitude, longitude, accuracy])

            logging.debug(f"cords={cords}")

            c = 0
            for p in range(len(cords)):
                if not None in cords[p]:
                    for i in range(p+1, len(cords)):
                        if not None in cords[i]:
                            avg += d_latlng(cords[p], cords[i])
                            c += 1
            logging.debug(f"c={c}")
            logging.debug(f"avg={avg}")
            if c > 0: avg = round(avg / c, 2)
            else: avg = 0
            logging.debug(f"avg={avg}")
    else: avg = 0

    if latitude and longitude: addr = get_street_data((latitude, longitude))
    else: addr = None

    try: street_name = addr["streetName"] + " " + addr["streetNumber"]
    except:
        try: street_name = addr["freeformAddress"]
        except: pass
        street_name = "Unbekannte Straße"
        if not addr: street_name = ""

    logging.debug(f"street_name={street_name}")

    latitude = '\'' + str(latitude) + '\'' if latitude else 'NULL'
    longitude = '\'' + str(longitude) + '\'' if longitude else 'NULL'
    message = '\'' + str(message) + '\'' if message else 'NULL'
    SQL = f"INSERT INTO scanned_locations (timestamp, latitude, longitude, accuracy, person_id, avg_distance, street_name, message) VALUES (now(), {latitude}, {longitude}, '{accuracy}', '{person_id}', '{avg}', '{street_name}', {message});"
    cursor.execute(SQL)
    conn.commit()

    logging.debug(f"/add: SQL={SQL}")

    resp = Response(json.dumps({"message": "OK"}), 200)
    resp.headers["Access-Control-Allow-Origin"] = "*"
    return resp

@app.route("/")
def index():
    return redirect("/index.html")

@app.route("/<path:directories>", methods=["GET", "POST"])
def path(directories):
    if request.method == "POST":
        if directories == "github":
            from server_reloader import trigger_reload
            trigger_reload()
            return ""
        return ""
    else:
        # Absolute path for raspberry pi
        # BASE_DIR = "/home/pi/Documents/GitHub/InfoPulli/build/web/"

        # Absolute path for NAS-3
        BASE_DIR = "/homes/Lukas/InfoPulli/build/web/"

        abs_path = os.path.join(BASE_DIR, directories)

        filename = ""
        for i in range(len(abs_path.split("/"))-1, -1, -1):
            if abs_path.split("/")[i] != "":
                filename = abs_path.split("/")[i]
                break

        if filename in ["baginski", "engel", "krinke", "boettger", "thomas", "wendland", "soentgerath", "albrecht"]:
            return redirect(f"/index.html?scan={filename}")

        try: return send_file(abs_path)
        except FileNotFoundError: pass

        return ""

def git_pull():
    logging.debug("git pull -v baginski master")
    os.system("git pull -v baginski master")

main(
    lambda: app.run(host="0.0.0.0", port=1443, ssl_context=context),
    before_reload = git_pull
)
