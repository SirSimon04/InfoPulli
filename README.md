# InfoPulli
This project is created for the Informatik LK.<br>
The frontend (web-)app is made by [SirSimon04](https://github.com/SirSimon04/),<br>
the server and data storage created and served by [LukasBaginski](https://github.com/LukasBaginski/).<br>

# Documentation
The server is available at [pulli.noskiller.de](https://pulli.noskiller.de/).<br>
All parameters have to be JSON formatted, all responses with status code *200* return a valid JSON response, all responses with status code *400* are plain text. Errors with code *400* are returned because of a missing key in the JSON parameter.<br>
The server understands eight more routes which redirect to [pulli.noskiller.de/?scan=ONE_OF_EIGHT](https://pulli.noskiller.de/?scan=ONE_OF_EIGHT).<br>
These eight routes are the names which are written on the scannable QR code since QR codes do not save GET-parameters.<br>
<br>
Note: *All keys in 200 responses followed by a datatype (e.g. *timestamp*: Integer) are explainations and are replaced with values of the given datatype (=> 1632495418.*<br>

## /get_locations
### Function
Returns all scanned locations in which latitude and longitude are not NULL<br>
### Parameter
None<br>
### Responses
*200*:<br>
{<br>
  "message": "OK",<br>
  "content": [<br>
    [*timestamp*: Double, *latitude*: Double, *longitude*: Double, *accuracy*: Integer, *person_id*: Integer, *short*:<br> String, *first*: String, *last*: String, *street_name*: String, *message*: String]<br>
  ]<br>
}<br>
### Comment
None<br>

## /add
### Function
Append a scan for the given **person_id**<br>
### Parameter
latitude: Double || NULL<br>
longitude: Double || NULL<br>
accuracy: Integer<br>
person_id: Integer<br>
message: String<br>
### Reponses
*200*:<br>
{<br>
  "message": "OK"<br>
}<br>
*400*:<br>
"{missing_parameter} MISSING"<br>
### Comment
If latitude and longitude are NULL the scan will be added but not listed in **/get_location**<br>

## /get_avg_distance
### Function
Get average distance in m of all scanned locations of user with key **short**<br>
### Parameter
short: String<br>
### Responses
*200*:
*distance*: Integer
### Comment
**WHAT THE FUCK? PLEASE SEND A *JSON* RESPONSE! THANKS.**<br>

## /get_all_avgs
### Function
List scoreboard infos, sorted by "avg_distance" or "count"<br>
### Parameter
board_type: String (Possible values: ["avg_distance", "count"])<br>
### Responses
### Comment
Not implemented yet<br>
