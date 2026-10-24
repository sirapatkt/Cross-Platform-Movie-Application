import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';

const String apiKey = 'fca313334fd49a0895e543bcae054e7e';

Future<String?> getTrailer(int vidId) async {
  String url = 'https://api.themoviedb.org/3/movie/$vidId/videos?api_key=$apiKey';
  try {
    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      var result = json.decode(response.body);
      List results = result['results'];
      if (results.isNotEmpty) {
        var trailer = results.firstWhere(
          (v) => v['site'] == "YouTube" && v['type'] == "Trailer",
          orElse: () => null,
        );
        if (trailer != null) return trailer['key'];
        return results[0]['key'];
      }
    }
  } catch (e) {
    debugPrint("Error getting trailer: $e");
  }
  return null;
}