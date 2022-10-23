import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';

final url = Uri.parse("https://shazam.p.rapidapi.com/search?term=the%20real%20slim%20shady&locale=en-US&offset=0&limit=5");

Future<Map> getData() async{
  final request = await http.get(
    url,
    headers: {"X-RapidAPI-Key": "e6d4cd37admshef43665725291cbp18da32jsn74987144ffff",
      "X-RapidAPI-Host": "shazam.p.rapidapi.com"}
  );
  http.Response response = request;
  return json.decode(response.body);
}

