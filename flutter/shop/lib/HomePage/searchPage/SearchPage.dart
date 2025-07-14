import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop/HomePage/searchPage/moviePage/MoviePage.dart';
import 'package:shop/Movie/Movie.dart';
import 'package:shop/User/User.dart';
import 'package:shop/User/UserData.dart';
import 'package:shop/repository/MovieRepository.dart';

class SearchPage extends StatefulWidget {
  TextEditingController _movieName = TextEditingController();

  SearchPage(TextEditingController _movieName){
    this._movieName = _movieName;
  } 

  @override
  State<SearchPage> createState() => _SearchPageState(_movieName);
}

class _SearchPageState extends State<SearchPage> {
  TextEditingController _movieName = TextEditingController();
  final MovieRepository _repository = MovieRepository();

  _SearchPageState(TextEditingController _movieName){
    this._movieName = _movieName;
  }

  @override
  void initState(){
    super.initState();
    _searchMovies(isNewSearch: true);
  }

  List<Movie> _movies = [];
  bool _isLoading = false;
  String _errorMessage = '';
  int limit = 5;

  Future<void> _searchMovies({bool isNewSearch = false}) async {
    if (_movieName.text.trim().isEmpty) return;

    if (isNewSearch) {
      limit = 5;
    } else {
      if (_isLoading) return;
      limit += 5;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = '';
    });

    try {
      final User? user = context.read<UserData>().user;

      final searchFuture = _repository.findMovieByNameKP(_movieName.text, limit);
      final savedMoviesFuture = user != null
          ? _repository.findAllMoviesByUserEmail(user.email)
          : Future.value(<Movie>[]);

      final results = await Future.wait([searchFuture, savedMoviesFuture]);
      
      final List<Movie> foundMovies = results[0] as List<Movie>;
      final List<Movie> savedMovies = results[1] as List<Movie>;

      final savedMovieIds = savedMovies.map((m) => m.id).toSet();

      for (final movie in foundMovies) {
        movie.isStar = savedMovieIds.contains(movie.id);
      }

      setState(() {
        _movies = foundMovies;
      });
    } catch (e) {
      setState(() {
        _errorMessage = e.toString();
        _movies = [];
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _moviePage(BuildContext context, Movie movie){
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => MoviePage(movie),
      )
    );
  }

  void _toggleFilmStar(Movie movie, String email){
    setState(() {
      movie.isStar = !movie.isStar!;

      if(movie.isStar!){
        _repository.saveMovie(movie, email);
      }
      else{
        _repository.deleteMovieById(movie.id);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final User? user = context.watch<UserData>().user;

    return 
      Builder(
      builder: (context) => Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Expanded(
              child: TextField(
                controller: _movieName,
                style: const TextStyle(fontSize: 16),
                onSubmitted: (value) => _searchMovies(isNewSearch: true),
                decoration: InputDecoration(
                  hintText: "Найти...",
                  suffixIcon: Padding(
                    padding: const EdgeInsets.only(right: 10),
                    child: IconButton(
                      onPressed: () => _searchMovies(isNewSearch: true),
                      icon: const Icon(Icons.search),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    body: Padding(
      padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              const SizedBox(height: 20),
              Expanded(
                child: _buildResultView(user),
              ),
              if (!_isLoading)
                CupertinoButton.filled(
                  child: const Text("Загрузить еще"),
                  onPressed: () => _searchMovies(),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildResultView(User? user) {
    if (_isLoading && _movies.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }
    if (_errorMessage.isNotEmpty) {
      return Center(child: Text(_errorMessage, style: const TextStyle(color: Colors.red)));
    }
    if (_movies.isEmpty) {
      return const Center(child: Text('Ничего не найдено или вы еще не искали.'));
    }

    return Column(
      children: [
        Expanded(
          child: ListView.separated(
            itemCount: _movies.length,
            separatorBuilder: (context, index) => const SizedBox(height: 16),
            itemBuilder: (context, index) {
              final movie = _movies[index];
        
              return GestureDetector(
                onTap: () => _moviePage(context, _movies[index]),
                child: Container(
                  padding: const EdgeInsets.all(12.0),
                  decoration: BoxDecoration(
                    color: Theme.of(context).cardColor,
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(8.0),
                        child: movie.posterUrl != null
                            ? Image.network(
                                movie.posterUrl!,
                                width: 100,
                                height: 150,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) {
                                  return Container(
                                    width: 100,
                                    height: 150,
                                    color: Colors.grey[800],
                                    child: const Icon(Icons.movie_creation_outlined, size: 50, color: Colors.white70),
                                  );
                                },
                              )
                            : Container(
                                width: 100,
                                height: 150,
                                color: Colors.grey[800],
                                child: const Icon(Icons.movie_creation_outlined, size: 50, color: Colors.white70),
                              ),
                      ),
        
                      const SizedBox(width: 16),
                      Expanded(
                        child: SizedBox(
                          height: 150,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Text(
                                movie.name,
                                maxLines: 3,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Год: ${movie.year ?? 'Н/Д'}',
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: Colors.grey[600],
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    'Рейтинг: ${movie.ratingKp}',
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: Colors.grey[600],
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  IconButton(
                                    icon: Icon(
                                      (movie.isStar ?? false) ? Icons.star : Icons.star_outline,
                                      color: (movie.isStar ?? false) ? Colors.amber : Colors.grey,
                                    ),
                                    onPressed: user != null
                                      ? () => _toggleFilmStar(movie, user.email)
                                      : null,
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }
          ),
        ),
        if (_isLoading && _movies.isNotEmpty)
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 16.0),
            child: CupertinoActivityIndicator(),
          ),
      ],
    );
  }
}