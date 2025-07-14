import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop/HomePage/searchPage/moviePage/MoviePage.dart';
import 'package:shop/Movie/Movie.dart';
import 'package:shop/User/User.dart';
import 'package:shop/User/UserData.dart';
import 'package:shop/repository/MovieRepository.dart';

class StarPage extends StatefulWidget {
  const StarPage({super.key});

  @override
  State<StarPage> createState() => _StarPageState();
}

class _StarPageState extends State<StarPage> {
  final MovieRepository _repository = MovieRepository();
  List<Movie> _savedMovies = [];
  bool _isLoading = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _fetchSavedMovies();
  }

  Future<void> _fetchSavedMovies() async {
    final User? user = context.read<UserData>().user;

    if (user == null || user.email.isEmpty) {
      if (mounted) {
        setState(() {
          _isLoading = false;
          _savedMovies = [];
        });
      }
      return;
    }

    try {
      final movies = await _repository.findAllMoviesByUserEmail(user.email);
      if (mounted) {
        setState(() {
          _savedMovies = movies;
          _isLoading = false;
          _errorMessage = null;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
          _errorMessage = 'Ошибка загрузки: $e';
        });
      }
    }
  }

  void _moviePage(BuildContext context, Movie movie) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => MoviePage(movie),
      ),
    ).then((_) {
      _fetchSavedMovies();
    });
  }

  void _deleteStarMovie(Movie movie) async {
    setState(() {
      _savedMovies.removeWhere((m) => m.id == movie.id);
    });

    try {
      await _repository.deleteMovieById(movie.id);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Не удалось удалить фильм. Попробуйте снова.'),
            backgroundColor: Colors.red,
          ),
        );
        _fetchSavedMovies();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Избранное'),
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_errorMessage != null) {
      return Center(child: Text(_errorMessage!));
    }

    if (_savedMovies.isEmpty) {
      return const Center(child: Text('Вы ничего не добавили в избранное.'));
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      child: _buildResultListView(_savedMovies),
    );
  }

  Widget _buildResultListView(List<Movie> movies) {
    return ListView.separated(
        itemCount: movies.length,
        separatorBuilder: (context, index) => const SizedBox(height: 16),
        itemBuilder: (context, index) {
          final movie = movies[index];
          return GestureDetector(
            onTap: () => _moviePage(context, movie),
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
                                child: const Icon(Icons.movie_creation_outlined,
                                    size: 50, color: Colors.white70),
                              );
                            },
                          )
                        : Container(
                            width: 100,
                            height: 150,
                            color: Colors.grey[800],
                            child: const Icon(Icons.movie_creation_outlined,
                                size: 50, color: Colors.white70),
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
                              IconButton(
                                icon: const Icon(Icons.delete, color: Colors.red),
                                onPressed: () => _deleteStarMovie(movie),
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
        });
  }
}