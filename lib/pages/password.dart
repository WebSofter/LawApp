import 'package:cppapp/configs/Auth.dart';
import 'package:cppapp/utils/alert.dart';
import 'package:flutter/material.dart';
//Статья https://fidev.io/full-screen-dialog/
class PasswordDialog extends StatefulWidget {
  @override
  PasswordDialogState createState() => new PasswordDialogState();
}

class PasswordDialogState extends State<PasswordDialog> {
  var _loginController = new TextEditingController();
  var _passwordController = new TextEditingController();
  var _codeController = new TextEditingController();
    //Выделение полей
    bool _isSecuredPassword = true;
    //Кнопки
    bool _visibleBtnSendCode = true;
    bool _visibleBtnPrev = false;
    bool _visibleBtnChangePass = false;
    //Активность на ввод
    bool _enabledTextFieldLogin = true;
    bool _enabledTextFieldCode = false;
    bool _enabledTextFieldPassword = false;
    //Видимость
    bool _visibleTextFieldLogin = true;
    bool _visibleTextFieldCode = false;
    bool _visibleTextFieldPassword = false;
  //
  void setFldsStateDefault(){
    //Кнопки
    _visibleBtnSendCode = true;
    _visibleBtnPrev = false;
    _visibleBtnChangePass = false;
    //Активность на ввод
    _enabledTextFieldLogin = true;
    _enabledTextFieldCode = false;
    _enabledTextFieldPassword = false;
    //Видимость
    _visibleTextFieldLogin = true;
    _visibleTextFieldCode = false;
    _visibleTextFieldPassword = false;
  }
  //
  void setFldsStateChangePass(){
    //Кнопки
    _visibleBtnSendCode = false;
    _visibleBtnPrev = true;
    _visibleBtnChangePass = true;
    //Активность на ввод
    _enabledTextFieldLogin = false;
    _enabledTextFieldCode = true;
    _enabledTextFieldPassword = true;
    //Видимость
    _visibleTextFieldLogin = false;
    _visibleTextFieldCode = true;
    _visibleTextFieldPassword = true;
  }
  //
  @override
  Widget build(BuildContext context) {
    //
    var logo = new Center(
                  child: new Container(
                    width: 50.0,
                    height: 50.0,
                    decoration: new BoxDecoration(
                      shape: BoxShape.circle,
                      image: new DecorationImage(
                        fit: BoxFit.fill,
                        image: AssetImage("assets/icon/reset_password.png"),//new NetworkImage("https://vignette.wikia.nocookie.net/flutter-butterfly-sanctuary/images/7/7f/FlutterLogo.PNG/revision/latest?cb=20131017172902")
                      ),
                    ),
                  ),
    );
  //

  var fldCode = new Visibility(
      visible: _visibleTextFieldCode,
      child: new ListTile(
      leading: const Icon(Icons.fiber_pin),
      title: TextField(
          enabled: _enabledTextFieldCode,
          decoration: InputDecoration(
              filled: true,
              labelText: "код из Telegram",
              hintText: "Напишите код из Telegram",
              border: InputBorder.none),
          //obscureText: _isSecured,
          controller: _codeController,
      ),
    )
  );
    //
  var fldLogin = new Visibility(
        visible: _visibleTextFieldLogin,
        child:    new ListTile(
        leading: const Icon(Icons.near_me),
        title: TextField(
          decoration: InputDecoration(
              filled: _enabledTextFieldLogin,
              labelText: "ваш номер Telegram",
              hintText: "Напишите номер Telegram",
              border: InputBorder.none),
          //obscureText: _isSecured,
          controller: _loginController,
        ),
      ),
  );

  var fldNewPassword = new Visibility(
      visible: _visibleTextFieldPassword,
      child: new ListTile(
      leading: const Icon(Icons.remove_red_eye),
      title: TextField(
        decoration: InputDecoration(
            filled: _enabledTextFieldPassword,
            labelText: "новый пароль",
            hintText: "Придумайте пароль",
            border: InputBorder.none),
        obscureText: _isSecuredPassword,
        controller: _passwordController,
      ),
    ),
  );
    //
  var btnSendCode = new Visibility(
    visible: _visibleBtnSendCode,
    child: new Container(
      child: RaisedButton(
        child: const Text('Отправить код проверки'),
        onPressed: () {
          Auth.sendResetCode(_loginController.text, (data){
            if(data["status"] == "success") {
              setState(() {
                setFldsStateChangePass();
              });
            }else{
              setState(() {
                setFldsStateDefault();
              });
              Alert.showError(context, "Не удалось отправить", data["message"]);
            }
          });
        },
      ),
    ),
  );
  var btnPrev = new Visibility(
    visible: _visibleBtnPrev,
    child: new Container(
      child: FlatButton(
        child: const Text('Назад'),
        onPressed: () {
          setState(() {
            setFldsStateDefault();
          });
        },
      ),
    ),
  );
  var btnChangePass = new Visibility(
    visible: _visibleBtnChangePass,
    child: new Container(
      child: RaisedButton(
          child: const Text('Изменить пароль'),
          onPressed: () {
            if(_passwordController.text?.isEmpty?? true){
              Alert.showError(context, "Неправильный ввод", "Пустой пароль");
            }else{
              if(_passwordController.text.length < 6){
                Alert.showError(context, "Неправильный ввод", "Пароль должен состоять не менее из 6 символов!");
              }else{
                Auth.sendChangePass(_loginController.text, _codeController.text, _passwordController.text, (data){
                  print(data);
                  if(data["status"] == "success") {
                    Alert.showSuccess(context, "Пароль изменен", data["message"], (){
                      Navigator.pop(context);
                      return Future.value(false);
                    });
                    
                  }else{
                    Alert.showError(context, "Не удалось изменить", data["message"]);
                  }
                });
              }
            }
          },
        ),
      ),
    );
    return new Scaffold(
      appBar: new AppBar(
        title: const Text('Сброс пароля'),
        actions: [
          /*
          new FlatButton(
              onPressed: () {
              },
              child: new Text('Найти',
                  style: Theme
                      .of(context)
                      .textTheme
                      .subhead
                      .copyWith(color: Colors.white))),
          */
        ],
      ),
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
                    fldLogin, 
                    fldCode,
                    fldNewPassword,
                    SizedBox(
                      height: 18.0,
                    ),
                    btnSendCode,
                    Row(
                      children: <Widget>[
                      btnPrev,
                      btnChangePass
                    ],),
                  ],
                ),
              ),
            ),
          ),
          SizedBox(height: 5.0,),
          //createaccount
        ],
      ),
    );
  }
}