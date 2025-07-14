import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shop/HomePage/searchPage/SearchPage.dart';
import 'package:shop/HomePage/starPage/StarPage.dart';
import 'package:shop/Movie/Movie.dart';
import 'package:shop/User/User.dart';
import 'package:shop/HomePage/accountPage/AccountPage.dart';
import 'package:shop/repository/MovieRepository.dart';

class HomePage extends StatefulWidget {

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  MovieRepository _repository = MovieRepository();

  TextEditingController _movieName = TextEditingController();

  int _selectedIndex = 0;
  Movie _randomFilm = Movie(id: 0, name: "", ratingKp: 0);
  String? _errorMessage;

  void _accountPage(BuildContext context){
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AccountPage(),
      )
    );
  }

  void _searchPage(context){
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => SearchPage(_movieName),
      )
    );
  }

  Future<void> _randomFilmLoad() async {
    try{
      while(true){
        _randomFilm = await _repository.getRandomMovieKP();
        print(_randomFilm.name);

        if(_randomFilm.name == "Без названия"){
          continue;
        } else {
          break;
        }
      }

      setState(() {
        _randomFilm = _randomFilm;
      });
    }
    catch(e){
      print("Произошла ошибка при загрузке: $e");
      if (!mounted) return;

      // Обновляем UI, чтобы ПОКАЗАТЬ СООБЩЕНИЕ ОБ ОШИБКЕ.
      setState(() {
        _errorMessage = e.toString();
      });
    }
  }

  void _toStarPage(BuildContext context){
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => StarPage(),)
    );
  }

  @override
  void initState() {
    _randomFilmLoad();
  }

  @override
  Widget build(BuildContext context) {
    return Builder(
      builder: (context) => Scaffold(
        appBar: AppBar(
          title: Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _movieName,
                  style: TextStyle(fontSize: 16),
                  onSubmitted: (value) => _searchPage(context),
                  decoration: InputDecoration(
                    hintText: "Найти...",
                    suffixIcon: Padding(
                      padding: EdgeInsets.only(right: 10),
                      child: IconButton(
                        onPressed: () => _searchPage(context),
                        icon: Icon(Icons.search),
                      ),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(left: 20),
                child: IconButton(
                  onPressed: () => _accountPage(context),
                  icon: Icon(Icons.account_circle, size: 40, color: Colors.blueGrey,),
                ),
              ),
            ],
          ),
        ),
        drawer: Drawer(
          backgroundColor: Colors.black26,
          child: Padding(
            padding: EdgeInsets.only(top: 50),
            child: Column(
              children: [
                TextButton.icon(
                  onPressed: () => _toStarPage(context),
                  icon: Icon(Icons.star, color: Colors.amber,),
                  label: Text("Избранное", style: TextStyle(color: Colors.white, fontSize: 20),),
                ),
                SizedBox(height: 10,),
                TextButton.icon(
                  onPressed: () {},
                  icon: Icon(Icons.stars, color: Colors.amber,),
                  label: Text("Оценки", style: TextStyle(color: Colors.white, fontSize: 20),),
                ),
              ],
            ),
          ),
        ),
        body: SingleChildScrollView(
          child: Center(
            child: Column(
                children: [
                  Padding(
                    padding: EdgeInsets.only(top: 50, bottom: 50),
                    child: Text("Случайный фильм", style: Theme.of(context).textTheme.titleMedium),
                  ),
                  
                  _randomFilm.posterUrl != null
                    ? Image.network(
                        _randomFilm.posterUrl!,
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
                    padding: EdgeInsets.only(top: 50, bottom: 5),
                    child: Text(_randomFilm.name),
                  ),
                  Padding(
                  padding: EdgeInsets.only(left: 50, right: 50),
                    child: Text(_randomFilm.description ?? "нет описания.", style: TextStyle(color: Colors.blueGrey, fontSize: 26),)
                  ),
                  Text("Оценка: ${_randomFilm.ratingKp}", style: TextStyle(color: Colors.blueGrey, fontSize: 26)),
                  Padding(
                    padding: EdgeInsets.only(top: 20),
                    child: CupertinoButton.filled(
                      child: Text("Обновить фильм"),
                      onPressed: () => _randomFilmLoad(),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
  }
}