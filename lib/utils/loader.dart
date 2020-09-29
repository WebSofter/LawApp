import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:path/path.dart';

class Loader{
  static void showLoader(var context, String type, Function(Context context) callback){
      showDialog(
        barrierDismissible: false,
        context: context, 
        child: 
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
                        SizedBox(
                          height: 30,
                        ),
                        SpinKitWave(
                            color: Colors.blueAccent,
                            size: 50.0,
                        ),
        ],)
      );
      //
      callback(context);
  }
}