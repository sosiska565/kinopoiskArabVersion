import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shop/Movie/Movie.dart';

class MoviePage extends StatefulWidget {
  Movie movie = Movie(id: 0, name: "", ratingKp: 0);

  MoviePage(Movie movie){
    this.movie = movie;
  }

  @override
  State<MoviePage> createState() => _MoviePageState(movie);
}

class _MoviePageState extends State<MoviePage> {
  Movie movie = Movie(id: 0, name: "", ratingKp: 0);

  _MoviePageState(Movie movie){
    this.movie = movie;
  }

  @override
  Widget build(BuildContext context) {
    return Builder(
      builder: (context) => Scaffold(
        appBar: AppBar(),
        body: Center(
          child: SingleChildScrollView(
            child: Column(
              children: [
                movie.posterUrl != null
                ? Image.network(
                    movie.posterUrl!,
                    scale: 1,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        width: 200,
                        height: 250,
                        color: Colors.grey[800],
                        child: const Icon(Icons.movie_creation_outlined, size: 50, color: Colors.white70),
                      );
                    },
                  )
                : Container(
                    width: 300,
                    height: 400,
                    color: Colors.grey[800],
                    child: const Icon(Icons.movie_creation_outlined, size: 50, color: Colors.white70),
                  ),
                Padding(
                  padding: EdgeInsets.only(top: 20),
                  child: Text(movie.name, style: Theme.of(context).textTheme.titleMedium,),
                ),
                Text("${movie.year}г"),
                Padding(
                  padding: EdgeInsets.only(left: 50, right: 50),
                  child: Text(movie.description!, style: TextStyle(color: Colors.blueGrey, fontSize: 26),)
                ),
                Text("Оценка: ${movie.ratingKp}"),
                Text("ID: ${movie.id}", style: TextStyle(color: Colors.grey, fontSize: 20),)
              ],
            ),
          )
        ),
      ),
    );
  }
}