import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shop/Movie/Movie.dart'; // Убедитесь, что путь верный

class MovieRepository {
  final String _baseUrlKP = "https://api.kinopoisk.dev/v1.4";
  final String _baseUrl = "https://22084nhw-8080.euw.devtunnels.ms/api/movies";
  final String _apiKey = "FN6JC85-QRKMEJF-Q947MTT-NTRDRG3";

  //KP API
  Future<List<Movie>> findMovieByNameKP(String movieName, int limit) async {
    if (movieName.isEmpty) {
      return [];
    }
    final url = Uri.parse('$_baseUrlKP/movie/search?page=1&limit=${limit}&query=$movieName');

    final response = await http.get(
      url,
      headers: {
        "Accept": "application/json",
        "X-API-KEY": _apiKey,
      },
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);

      final List<dynamic> movieDocs = data['docs'];
      
      if (movieDocs.isEmpty) {
        return [];
      }
      
      return movieDocs.map((movieJson) => Movie.fromJson(movieJson)).toList();
    } else {
      throw Exception('Ошибка загрузки фильмов: ${response.statusCode}');
    }
  }

  Future<Movie> getRandomMovieKP() async {
    try{
      var response = await http.get(
        Uri.parse(_baseUrlKP + "/movie/random"),
        headers: {
          "Accept": "application/json",
          "X-API-KEY": _apiKey,
        }
      ); 

      if(response.statusCode != 200){
        throw new Exception(response.statusCode);
      }
      else{
        Map<String, dynamic> json = jsonDecode(response.body);

        Movie movie = Movie.fromJson(json);

        return movie;
      }
    }
    catch(e){
      throw e;
    }
  }

  //My API
  Future<List<Movie>> findAllMovies() async {
    try {
      final response = await http.get(Uri.parse(_baseUrl));

      if (response.statusCode == 200) {
        final List<dynamic> moviesJson = json.decode(utf8.decode(response.bodyBytes));

        return moviesJson.map((json) => Movie.fromJson(json)).toList();
      } else {
        throw Exception('Ошибка загрузки фильмов с вашего API: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Не удалось выполнить запрос к вашему API: $e');
    }
  }

  Future<List<Movie>> findAllMoviesByUserEmail(String userEmail) async {
    if (userEmail.isEmpty) {
      throw ArgumentError('userEmail cannot be empty.');
    }

    final uri = Uri.parse('$_baseUrl/search').replace(
      queryParameters: {
        'userEmail': userEmail,
      },
    );

    final response = await http.get(uri);

    if (response.statusCode == 200) {
      final List<dynamic> jsonList = jsonDecode(response.body);

      return jsonList.map((json) => Movie.fromJson(json)).toList();

    } else {
      throw Exception('Failed to load movies. Status code: ${response.statusCode}');
    }
  }

  Future<Movie> saveMovie(Movie movie, String email) async {
    final Map<String, dynamic> movieData = {
      "id": movie.id,
      "name": movie.name,
      "year": movie.year,
      "description": movie.description,
      "ratingKp": movie.ratingKp,
      "posterUrl": movie.posterUrl,
      "isStar": movie.isStar,
      "userEmail": email,
    };

    final response = await http.post(
      Uri.parse("$_baseUrl/create"),
      headers: {
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(movieData),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      final Map<String, dynamic> json = jsonDecode(utf8.decode(response.bodyBytes));
      return Movie.fromJson(json);
    } else {
      throw Exception('Ошибка сохранения фильма: ${response.statusCode}, тело: ${response.body}');
    }
  }

  Future<void> deleteMovieById(int id) async {
    final response = await http.delete(
      Uri.parse(_baseUrl + "/${id}")
    );
    if(response.statusCode != 200){
      throw new Exception(response.statusCode);
    }
  }
}