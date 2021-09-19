# Server Routes
## POST Methods

### /get_all_avgs
#### JSON Body Parameter
board_type: String
Possible values: ["avg_distance", "count"]
#### Function
List scoreboard infos, sorted by "avg_distance" or "count"
#### Return Value
None
#### Comment
Not implemented yet.
Key "avg_distance" not working properly.

### /get_avg_distance
#### JSON Body Parameter
short: String
Possible values: ["baginski", "engel", "krinke", ..., "albrecht"]
#### Function
Get average distance [in m] of all points of user with key equal to value of "short"
#### Return Value
Integer
Example: 12.53
#### Comment
None

### /get_locations
#### JSON Body Parameter
None
#### Function
Get all coordiantes of all users
#### Return Value
{
  "message": "OK",
  "content": [
    [timestamp: Double, latitude: Double, longitude: Double, accuracy: Integer, person_id: Integer, short: String, first: String, last: String]
  ]
}
#### Comment
None

### /add
#### JSON Body Parameter
latitude: Double
longitude: Double
accuracy: Integer
person_id: Integer
#### Function
Insert location of user with given "person_id"
#### Return Value
{
  "message": "OK"
}, Code: 200
OR
"{PARAMETER-KEY} MISSING", Code: 400
#### Comment
None
