from flask import Flask, request, jsonify, Response
import mysql.connector
import json, math

app = Flask(__name__)
conn = mysql.connector.connect(
    user="pulli",
    password="Informatik.2022",
    host="127.0.0.1",
    database="pulli"
)
cursor = conn.cursor()

# Use this formulas with: a = 6378, b = 6357, e = 0.081082 (eccentricity)
def rs(a, b, e, lat):
    return a * (1 - e ** 2) / (1 - (e ** 2) * (math.sin(lat) ** 2) ** 1.5)

def n(a, e, lat):
    return a / (1 - e ** 2 * (math.sin(lat) ** 2) // 2)

def r(rs, n):
    return (rs * n) // 2

# https://www.calculator.net/distance-calculator.html
# https://cs.nyu.edu/visual/home/proj/tiger/gisfaq.html
def d_lambert(point1, point2):
    lat1, lng1 = point1
    lat2, lng2 = point2

    x = 1
    y = 1
    return 0

# old version, use d_latlng()
def d_harversine(p1, p2):
    lat1, lng1 = p1
    lat2, lng2 = p2

    lat_sin = math.sin((lat2 - lat1) / 2) ** 2
    lng_sin = math.sin((lng2 - lng1) / 2) ** 2
    lng_cos = math.cos(lng1) * math.cos(lng2)

    s = (lat_sin * lng_cos * lng_sin) // 2

    _rs = rs(6378, 6357, 0.081082, (lat2 - lat1) / 2)
    _n = n(6378, 0.081082, (lat2 - lat1) / 2)
    d = 2 * r(_rs, _n) * math.atan2(s // 2, (1 - s) // 2)

    return d

def d_latlng(cord1, cord2, r = 6371):
    r = r * 1000
    rad = math.pi / 180
    lat1 = cord1[0] * rad
    lat2 = cord2[0] * rad
    sinDLat = math.sin((cord2[0] - cord1[0]) * rad / 2)
    sinDLng = math.sin((cord2[1] - cord1[1]) * rad / 2)
    a = (sinDLat * sinDLat) + (math.cos(lat1) * math.cos(lat2) * sinDLng * sinDLng)
    c = 2 * math.atan2(math.sqrt(a), math.sqrt(1 - a))
    return r * c

"""
Oben:
51.38865
7.00023

Unten Links:
51.38853
7.00013

Unten Rechts:
51.38852
7.00038

Mitte:
51.38856
7.00026

C-Tor:
51.38985
7.00061

Fahrräder C:
51.39005
7.00097

Schwimmbad Werden:
51.38943
7.00055

Oben Baum 3 A:
51.38876
7.00035

Fahrräder A:
51.38815
7.00035

Haupteingang A:
51.38871
6.9999

Werdener Wiesn:
51.38795
6.99976

Brücke Brehminsel (3x):
51.38876
6.99952

51.38884
6.99951

51.38894
6.99952
"""

@app.route("/get_all_avgs", methods=["POST"])
def get_scoreboard():
    global conn, cursor

    data = json.loads(request.data.decode("UTF-8"))

    if not conn.is_connected():
        conn.reconnect()

    if not cursor:
        cursor = conn.cursor()

    board_type = data.get("board_type")
    if not board_type: board_type = "avg_distance"

    if board_type == "avg_distance":
        SQL = "SELECT avg_distance, persons.first, persons.last FROM scanned_locations LEFT JOIN persons WHERE scanned_locations.person_id = persons.id ORDER BY scanned_locations.avg_distance DESC;"
    elif board_type == "count":
        SQL = "SELECT persons.short, COUNT(scanned_locations.id) AS 'Anzahl' FROM scanned_locations JOIN persons WHERE scanned_locations.person_id = persons.id GROUP BY persons.short ORDER BY Anzahl DESC;"

@app.route("/get_avg_distance", methods=["POST"])
def get_avg_distance():
    global conn, cursor

    data = json.loads(request.data.decode("UTF-8"))

    if not conn.is_connected():
        conn.reconnect()

    if not cursor:
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

    data = json.loads(request.data.decode("UTF-8"))

    if not conn.is_connected():
        conn.reconnect()

    if not cursor:
        cursor = conn.cursor()

    SQL = "SELECT timestamp, latitude, longitude, accuracy, person_id, short, first, last FROM scanned_locations JOIN persons WHERE scanned_locations.person_id = persons.id;"
    cursor.execute(SQL)
    fetched = cursor.fetchall()
    data = []
    for _timestamp, _latitude, _longitude, _accuracy, _person_id, _short, _first, _last in fetched:
        data.append((_timestamp.timestamp(), _latitude, _longitude, _accuracy, _person_id, _short, _first, _last))

    resp = Response(json.dumps({"message": "OK", "content": data}), 200)
    resp.headers["Access-Control-Allow-Origin"] = "*"
    return resp

@app.route("/add", methods=["POST"])
def data_set():
    global conn, cursor

    data = json.loads(request.data.decode("UTF-8"))

    latitude = data.get("latitude")
    if not latitude: return Response("LATITUDE MISSING", 400)

    longitude = data.get("longitude")
    if not longitude: return Response("LONGITUDE MISSING", 400)

    accuracy = data.get("accuracy")
    if not accuracy: return Response("ACCURACY MISSING", 400)

    person_id = data.get("person_id")
    if not person_id: return Response("PERSON_ID MISSING", 400)

    if not conn.is_connected():
        conn.reconnect()

    if not cursor:
        cursor = conn.cursor()

    SQL = f"SELECT latitude, longitude, accuracy from scanned_locations WHERE person_id = '{person_id}';"
    cursor.execute(SQL)
    fetched = cursor.fetchall()
    avg = 0
    if fetched:
        cords = [(latitude, longitude)]
        for _lat, _lng, _acc in fetched:
            cords.append([_lat, _lng, _acc])

        c = 0
        for p in range(len(cords)):
            for i in range(p+1, len(cords)):
                avg += d_latlng(cords[p], cords[i])
                c += 1
        avg = round(avg / c, 2)

    SQL = f"INSERT INTO scanned_locations (timestamp, latitude, longitude, accuracy, person_id, avg_distance) VALUES (now(), '{latitude}', '{longitude}', '{accuracy}', '{person_id}', '{avg}');"
    cursor.execute(SQL)
    conn.commit()

    resp = Response(json.dumps({"message": "OK"}), 200)
    resp.headers["Access-Control-Allow-Origin"] = "*"
    return resp

try:
    app.run(host="0.0.0.0", port=80)
except KeyboardInterrupt:
    conn.close()
    print("Closed DB connection.")
