import 'package:cppapp/configs/Auth.dart';
import 'package:cppapp/models/user.dart';
import 'package:cppapp/pages/password.dart';
import 'package:flutter/material.dart';
//import 'package:cppapp/pages/new_account.dart';
import 'package:cppapp/pages/index.dart';
import 'package:cppapp/configs/config.dart';
import 'package:cppapp/utils/alert.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:async';

void main() => runApp(new MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => new _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Базовый список',
      home: new HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => new _HomePageState();
}

class _HomePageState extends State<HomePage> {
  var _loginController = new TextEditingController();
  var _passwordController = new TextEditingController();
  var data;
  var _isSecured = true;
  //
  _readAuth() async {
    final prefs = await SharedPreferences.getInstance();
    final keyLogin = 'login';
    final keyPassword = 'password';
    //
    final valueLogin = prefs.getString(keyLogin) ?? "";
    final valuePassword = prefs.getString(keyPassword) ?? "";
    //
    _loginController.text = valueLogin;
    _passwordController.text = valuePassword;
  }

  _saveAuth() async {
    final prefs = await SharedPreferences.getInstance();
    //
    final keyLogin = 'login';
    final keyPassword = 'password';
    //
    final valueLogin = _loginController.text;
    final valuePassword = _passwordController.text;
    prefs.setString(keyLogin, valueLogin);
    prefs.setString(keyPassword, valuePassword);
  }

  _clearAuth() async {
    final prefs = await SharedPreferences.getInstance();
    //
    final keyLogin = 'login';
    final keyPassword = 'password';
    //
    final valueLogin = "";
    final valuePassword = "";
    prefs.setString(keyLogin, valueLogin);
    prefs.setString(keyPassword, valuePassword);
  }

  @override
  Widget build(BuildContext context) {
    verifyData(String login, String password) {
      if (login?.isEmpty ?? true) {
        Alert.showError(context, "Неправильный ввод", "Пустой логин");
      } else {
        if (password?.isEmpty ?? true) {
          Alert.showError(context, "Неправильный ввод", "Пустой пароль");
        } else {
          Auth.getLoginData(login, password, (data) {
            print("WWWWWWWWWWWWWWWWWWWWWW");
            //if(data["status"] == "success") {
            _saveAuth();
            User user = new User(
                '89266542365', 'Иванов И.И.', '', '440', 'it', '1', null);
            /*
            User user = new User(
                data['data']['username'],
                data['data']['fio'],
                data['data']['userpic'],
                data['data']['pin'],
                data['data']['rights'],
                data['data']['token'],
                data['data']['access']);
            */
            var route = new MaterialPageRoute(
              builder: (BuildContext context) => new IndexPage(user: user),
            );
            Navigator.of(context).push(route);
            //}else{
            //Alert.showError(context, "Неу удалось войти", data["message"]);
            //}
          });
        }
      }
    }

    var logo = new Center(
      child: new Container(
        width: 120.0,
        height: 120.0,
        decoration: new BoxDecoration(
          shape: BoxShape.circle,
          image: new DecorationImage(
            fit: BoxFit.fill,
            image: AssetImage(
                "assets/icon/icon.png"), //new NetworkImage("https://vignette.wikia.nocookie.net/flutter-butterfly-sanctuary/images/7/7f/FlutterLogo.PNG/revision/latest?cb=20131017172902")
          ),
        ),
      ),
    );

    /****************** TextField Login*******************************/
    var login = new ListTile(
      leading: const Icon(Icons.person),
      title: TextFormField(
        decoration: InputDecoration(
            labelText: "ваш логин",
            filled: true,
            hintText: "Напишите ваш логин",
            border: InputBorder.none),
        controller: _loginController,
      ),
    );

    /******************** TextField Password ******************************/
    var password = new ListTile(
      leading: const Icon(Icons.remove_red_eye),
      title: TextField(
        decoration: InputDecoration(
            filled: true,
            labelText: "ваш пароль",
            hintText: "Напишите ваш пароль",
            border: InputBorder.none),
        obscureText: _isSecured,
        controller: _passwordController,
      ),
    );

    /********************* Button Login****************************************/
    /*
    var createaccount = new Container(
      child: FlatButton(
        child: const Text('Регистрация'),
        onPressed: () {
          var route = new MaterialPageRoute(
            builder: (BuildContext context) => new Register(),
          );
          Navigator.of(context).push(route);
        },
      ),
    );
    */
/*************************************************/

    /********************* Button Login****************************************/
    var loginButton = new Container(
      child: RaisedButton(
        child: const Text('Вход'),
        elevation: 8.0,
        onPressed: () {
          //getLogin(_loginController.text);
          verifyData(_loginController.text, _passwordController.text);
        },
      ),
    );
    /********************* Button Reset****************************************/
    var resetButton = new Container(
      child: FlatButton.icon(
        icon: Icon(Icons.restore), //`Icon` to display
        label: Text('Забыли пароль?'), //`Text` to display
        onPressed: () {
          Navigator.of(context).push(new MaterialPageRoute<Null>(
              builder: (BuildContext context) {
                return new PasswordDialog();
              },
              fullscreenDialog: false));
        },
      ),
    );
/*************************************************/

    /********************Button Cancel ***********************/
    var cancelButton = new Container(
      child: FlatButton(
        child: const Text('Очистить'),
        onPressed: () {
          _passwordController.clear();
          _loginController.clear();
          _clearAuth();
        },
      ),
    );

/***********************************************/
    _readAuth();
    return new Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: new ListView(
        children: <Widget>[
          SizedBox(
            height: 50.0,
          ),
          logo,
          SizedBox(
            height: 50.0,
          ),
          new Padding(
            padding: const EdgeInsets.all(18.0),
            child: new Card(
              elevation: 8.0,
              color: Colors.white,
              child: new Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: <Widget>[
                    login,
                    password,
                    SizedBox(
                      height: 18.0,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: <Widget>[cancelButton, loginButton],
                    ),
                    resetButton,
                  ],
                ),
              ),
            ),
          ),
          SizedBox(
            height: 5.0,
          ),
          //createaccount
        ],
      ),
    );
  }
}
