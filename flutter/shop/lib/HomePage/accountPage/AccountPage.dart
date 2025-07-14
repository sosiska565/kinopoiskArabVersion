import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop/User/User.dart';
import 'package:shop/User/UserData.dart';
import 'package:shop/loginPage/LoginPage.dart';
import 'package:shop/repository/UserRepository.dart';

class AccountPage extends StatefulWidget {
  @override
  State<AccountPage> createState() => _AccountPageState();
}

class _AccountPageState extends State<AccountPage> {
  RegistrationPageService _repository = RegistrationPageService();

  void _deleteUser(BuildContext context, User? user){
    _repository.deleteUser(user?.id);

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => LoginPage(),
      )
    );
  }

  void _showConfirmationDialog(BuildContext context, User? user) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Уведомление'),
          content: Text('Вы уверены что хотите удалить данного пользователя?', style: Theme.of(context).textTheme.bodySmall,),
          actions: <Widget>[
            TextButton(
              child: Text('Отмена'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text(
                'Удалить',
                style: TextStyle(color: Colors.red),
              ),
              onPressed: () {
                _deleteUser(context, user);
              },
            ),
          ],
        );
      },
    );
  }
  
  @override
  Widget build(BuildContext context) {
    final user = context.watch<UserData>().user;

    return Builder(
      builder: (context) => Scaffold(
        appBar: AppBar(),
        body: Center(
          child: Column(
            children: [
              Icon(Icons.account_circle, color: Colors.blueGrey, size: 150),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: EdgeInsets.only(bottom: 10),
                    child: Text(
                      user?.name ?? "гость"
                    ),
                  ),
                  IconButton(onPressed: () {}, icon: Icon(Icons.edit), iconSize: 20,)
                ],
              ),
              Text(user?.email ?? ""),
              CupertinoButton.filled(
                color: Colors.red,
                onPressed: () => _showConfirmationDialog(context, user),
                child: Text("Удалить пользователя"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}