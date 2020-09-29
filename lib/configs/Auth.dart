import 'dart:convert';
import 'package:http/http.dart' as http;

import 'config.dart';

class Auth{
  //Функция получает данные для входа пользователя
  static Future getLoginData(String login, String password, Function(Map) callback) async {
    //Получаем базовые данные авторизации
    String urlAuth = "${Config.baseUrl}/${Config.mobileDir}/?module=authorization&function=authorization&username=$login&password=$password";
    var responseAuth = await http.get(Uri.encodeFull(urlAuth), headers: {"Accept": "application/json"});
    var jsonAuth = json.decode(responseAuth.body);
    if(jsonAuth['status'] == "success"){
      //Получаем базовые персональные данные, чтобы получить юзерпик
      String urlPerson = "${Config.baseUrl}/${Config.mobileDir}/?module=general&function=infoPersonal&pin=${jsonAuth['data']['pin']}";
      var responsePerson = await http.get(Uri.encodeFull(urlPerson), headers: {"Accept": "application/json"});
      var jsonPerson = json.decode(responsePerson.body);
      //
      jsonAuth['data']['userpic'] = jsonPerson['data']['path'];
    }
    var jsonResult = jsonAuth;
    callback(jsonResult);
  }
  //Функция отправляет код сброса пароля на телеграм
  static Future sendResetCode(String login, Function(Map) callback) async {
    String url = "${Config.baseUrl}/${Config.mobileDir}/index.php?module=authorization&function=sendRecCode&user=$login";
    var response = await http.get(Uri.encodeFull(url), headers: {"Accept": "application/json"});
    var result = json.decode(response.body);
    callback(result);
  }
  //Функция принимает код сброса пароля из телеграм и новый пароль
  static Future sendChangePass(String login, String code, String password, Function(Map) callback) async {
    String url = "${Config.baseUrl}/${Config.mobileDir}/index.php?module=authorization&function=changePass&user=$login&code=$code&pass=$password";
    var response = await http.get(Uri.encodeFull(url), headers: {"Accept": "application/json"});
    var result = json.decode(response.body);
    callback(result);
  }
}