import 'package:flutter/cupertino.dart';
import 'package:shop/Movie/Movie.dart';

class StarsMoviesData extends ChangeNotifier {
  List<Movie> _movies = [];

  List<Movie> get movies => List.from(_movies);

  void addMovie(Movie newMovie) {
    _movies.add(newMovie);
    notifyListeners();
  }

  void popMovie(Movie movie){
    _movies.remove(movie);
    notifyListeners();
  }

  void setMovies(List<Movie> newMovies) {
    _movies = List.from(newMovies);
    notifyListeners();
  }

  void clearMovies() {
    _movies.clear();
    notifyListeners();
  }
}