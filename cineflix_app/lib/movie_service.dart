import 'dart:convert';
import 'package:http/http.dart' as http;
import 'movie.dart';

class MovieService {
  static const String apiKey = '10165dc1cbd42c27033330632ddfcb02';
  static const String baseUrl = 'https://api.themoviedb.org/3';

  static Future<List<Movie>> fetchPopular() async {
    final url = Uri.parse('$baseUrl/movie/popular?api_key=$apiKey');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final List results = data['results'];
      return results.map((json) => Movie.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load movies');
    }
  }

  static Future<List<Movie>> fetchTrending() async {
    final url = Uri.parse('$baseUrl/trending/movie/week?api_key=$apiKey');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final List results = data['results'];
      return results.map((json) => Movie.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load movies');
    }
  }

  static Future<List<Movie>> fetchTopRated() async {
    final url = Uri.parse('$baseUrl/movie/top_rated?api_key=$apiKey');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final List results = data['results'];
      return results.map((json) => Movie.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load movies');
    }
  }
}
