import 'package:flutter/material.dart';

class Alert{
  static void showError(var context, String title, String message){
      var alert = new AlertDialog(
        title: new Text(title),
        content: new Text(message),
      );
      showDialog(context: context, child: alert);
  }
  static void showSuccess(var context, String title, String message, Function() callback){
      var alert = new AlertDialog(
        title: new Text(title),
        content: new Text(message),
      );
      showDialog(context: context, child: alert);
      Future.delayed(Duration(seconds: 2), () {
        Navigator.of(context).pop(true);
        callback();
      });
  }
}