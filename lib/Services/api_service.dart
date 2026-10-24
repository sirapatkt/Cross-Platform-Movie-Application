import 'dart:convert';
import 'package:http/http.dart' as http;
import '../Models/movie.dart';

class ApiService {
  // กุญแจสำหรับการเข้าถึง API (TMDB)
  static const String apiKey = 'fca313334fd49a0895e543bcae054e7e';
  static const String baseUrl = 'https://api.themoviedb.org/3';

  // 1. ดึงข้อมูลหนังยอดนิยมประจำวัน (Trending)
  static Future<List<Movie>> getTrendingMovies() async {
    final response = await http.get(Uri.parse('$baseUrl/trending/movie/day?api_key=$apiKey'));
    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      final List<dynamic> results = data['results'];
      return results.map((json) => Movie.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load trending movies');
    }
  }

  // 2. ดึงหนังยอดนิยมแค่ 10 อันดับแรก (Top 10)
  static Future<List<Movie>> getTopTenMovies() async {
    List<Movie> movies = await getTrendingMovies();
    return movies.take(10).toList();
  }

  // 3. ค้นหาหนังตามชื่อ (Search)
  static Future<List<Movie>> searchMovies(String query) async {
    if (query.isEmpty) return [];
    final response = await http.get(Uri.parse(
        '$baseUrl/search/movie?api_key=$apiKey&query=$query&include_adult=false'));
    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      final List<dynamic> results = data['results'];
      return results.map((json) => Movie.fromJson(json)).toList();
    } else {
      throw Exception("Failed to search movies");
    }
  }

  // 4. ดึง Key ของ Youtube trailer (Video)
  static Future<String?> getTrailerKey(int movieId) async {
    final response = await http.get(Uri.parse("$baseUrl/movie/$movieId/videos?api_key=$apiKey"));
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final List results = data['results'];
      if (results.isNotEmpty) {
        // พยายามหา Type ที่เป็น "Trailer" และอยู่บน "YouTube" ก่อน
        final trailer = results.firstWhere(
          (v) => v['site'] == "YouTube" && v['type'] == "Trailer",
          orElse: () => null,
        );
        // ถ้าหา Trailer ไม่เจอ ให้เอาวิดีโอตัวแรกสุดมาแสดงแทน
        return trailer != null ? trailer['key'] : results[0]['key'];
      }
    }
    return null;
  }
}