import 'package:email_validator/email_validator.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop/Movie/MovieData.dart';
import 'package:shop/User/UserData.dart';
import 'package:shop/loginPage/LoginPage.dart';
import 'package:shop/repository/UserRepository.dart';
import 'package:shop/theme/Theme.dart';

class RegistrationPage extends StatefulWidget {
  @override
  State<RegistrationPage> createState() => _RegistrationPageState();
}

class _RegistrationPageState extends State<RegistrationPage> {
  TextEditingController _textName = TextEditingController();
  TextEditingController _textNickname = TextEditingController();
  TextEditingController _textPassword = TextEditingController();
  TextEditingController _textEmail = TextEditingController();

  RegistrationPageService _service = RegistrationPageService();

  void _loginPage(BuildContext context){
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => LoginPage(),
      )
    );
  }

  void _handleSubmit(BuildContext context) async{

    try{
      if(_textName.text.trim().isEmpty ||
          _textNickname.text.trim().isEmpty ||
          _textPassword.text.trim().isEmpty ||
          _textEmail.text.trim().isEmpty
      ){
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text("Fill all fields"),
              behavior: SnackBarBehavior.floating,
          ));
          return;
      }

      if(!EmailValidator.validate(_textEmail.text)){
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text("Email is not valid"), behavior: SnackBarBehavior.floating,
        ));
        return;
      }

      await _service.saveUser(
        _textName.text,
        _textNickname.text,
        _textPassword.text,
        _textEmail.text
      );

      if(mounted){
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => LoginPage(),
          )
        );
      }
    }
    catch(e){
      if(mounted){
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text("${e.toString()}".replaceFirst("Exception: ", "")), behavior: SnackBarBehavior.floating,
        ));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => UserData(),),
        ChangeNotifierProvider(create: (context) => StarsMoviesData(),),
      ],
      child: MaterialApp(
        theme: AppTheme.lightTheme,
        darkTheme: AppTheme.darkTheme,
        themeMode: ThemeMode.system,
        debugShowCheckedModeBanner: false,
        home: Builder(
          builder: (context) => Scaffold(
            appBar: AppBar(),
            bottomNavigationBar: Padding(
              padding: EdgeInsets.only(bottom: 30, left: 30, right: 30),
              child: SizedBox(
                width: double.infinity,
                child: CupertinoButton.filled(
                  child: Text("Зарегистрироваться"),
                  onPressed: () => _handleSubmit(context),
                ),
              ),
            ),
            body: Padding(
              padding: EdgeInsets.symmetric(horizontal: 50),
              child: Column(
                children: [
                  Text(
                    "Регистрация",
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  SizedBox(height: 100),
                  Expanded(
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          TextField(
                            style: TextStyle(fontSize: 26),
                            controller: _textName,
                            decoration: InputDecoration(
                              hintText: "Имя",
                            ),
                          ),
                          SizedBox(height: 20),
                          Divider(color: const Color.fromARGB(255, 60, 60, 60), indent: 20, endIndent: 20),
                          SizedBox(height: 20),
                          TextField(
                            style: TextStyle(fontSize: 26),
                            controller: _textNickname,
                            decoration: InputDecoration(hintText: "Никнейм"),
                          ),
                          SizedBox(height: 20),
                          Divider(color: const Color.fromARGB(255, 60, 60, 60), indent: 20, endIndent: 20),
                          SizedBox(height: 20),
                          TextField(
                            style: TextStyle(fontSize: 26),
                            controller: _textPassword,
                            obscureText: true,
                            decoration: InputDecoration(hintText: "Пароль"),
                          ),
                          SizedBox(height: 20),
                          Divider(color: const Color.fromARGB(255, 60, 60, 60), indent: 20, endIndent: 20),
                          SizedBox(height: 20),
                          TextField(
                            style: TextStyle(fontSize: 26),
                            controller: _textEmail,
                            decoration: InputDecoration(hintText: "Почта"),
                          ),
                          SizedBox(height: 30),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                "уже есть аккаунт?",
                                style: TextStyle(
                                  fontSize: 16,
                                ),
                              ),
                              CupertinoButton(
                                onPressed: () => _loginPage(context),
                                child: Text(
                                  "Войти",
                                  style: TextStyle(
                                    fontSize: 16,
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
        ),
      ),
    );
  }
}