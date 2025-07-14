import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop/HomePage/HomePage.dart';
import 'package:shop/User/User.dart';
import 'package:shop/User/UserData.dart';
import 'package:shop/registrationPage/RegistrationPage.dart';
import 'package:shop/repository/UserRepository.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController _textPassword = TextEditingController();
  TextEditingController _textEmail = TextEditingController();

  RegistrationPageService _service = RegistrationPageService();

  void _handleSubmit(BuildContext context) async {
    try{
      User user = await _service.findByEmail(_textEmail.text);

      context.read<UserData>().login(user);

      if(mounted){
        if(user.password == _textPassword.text){
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => HomePage(),
            )
          );
        }
        else{
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text("Password is not correct"), behavior: SnackBarBehavior.floating,
          ));
        }
      }
    }
    catch(e){
      if(mounted){
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(e.toString().replaceFirst('Exception: ', '')), behavior: SnackBarBehavior.floating,
        ));
      }
    }
  }

  void _registrationPage(context){
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => RegistrationPage(),
      )
    );
  }

  @override
  Widget build(BuildContext context) {
    return Builder(
      builder: (context) => Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
        ),
        bottomNavigationBar: Padding(
          padding: EdgeInsets.only(bottom: 30, left: 30, right: 30),
          child: SizedBox(
            width: double.infinity,
            child: CupertinoButton.filled(
              child: Text("Войти"),
              onPressed: () => _handleSubmit(context),
            ),
          ),
        ),
        body: Padding(
          padding: EdgeInsets.symmetric(horizontal: 50),
          child: Column(
            children: [
              Text(
                "Вход",
                style: Theme.of(context).textTheme.titleMedium,
              ),
              SizedBox(height: 100),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      TextField(
                        style: TextStyle(fontSize: 26),
                        controller: _textEmail,
                        decoration: InputDecoration(hintText: "Почта"),
                      ),
                      SizedBox(height: 20),
                      Divider(color: const Color.fromARGB(255, 60, 60, 60), indent: 20, endIndent: 20),
                      SizedBox(height: 20),
                      TextField(
                        style: TextStyle(fontSize: 26),
                        obscureText: true,
                        controller: _textPassword,
                        decoration: InputDecoration(hintText: "Пароль"),
                      ),
                      SizedBox(height: 30),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            "нет аккаунта?",
                            style: TextStyle(
                              fontSize: 16, // Уменьшил шрифт для лучшего вида
                            ),
                          ),
                          CupertinoButton(
                            onPressed: () => _registrationPage(context),
                            child: Text(
                              "Зарегистрируйтесь",
                              style: TextStyle(
                                fontSize: 16, // Уменьшил шрифт для лучшего вида
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  )
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}