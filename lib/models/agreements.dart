//Статья https://flutter.dev/docs/cookbook/networking/background-parsing

import 'dart:async';
import 'dart:convert';
import 'dart:ui';

import 'package:cppapp/configs/config.dart';
import 'package:cppapp/models/agreement.dart';
import 'package:cppapp/pages/agreement.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

Future<List<Agreement>> fetchAgreements(http.Client client) async {
  String url = "${Config.baseUrl}/${Config.mobileDir}/index.php?token=_token_&module=agreement&function=loadAgreements";
  final response = await client.get(url);
  var rsp = json.decode(response.body)['data'];
  print("Line 16: fetchAgreements...");
  // Use the compute function to run parseAgreements in a separate isolate.
  return compute(parseAgreements, json.encode(rsp));
}

// A function that converts a response body into a List<Agreement>.
List<Agreement> parseAgreements(String responseBody) {
  final parsed = json.decode(responseBody).cast<Map<String, dynamic>>();
  return parsed.map<Agreement>((json) => Agreement.fromJson(json)).toList();
}
//
class AgreementsList extends StatelessWidget {
  final List<Agreement> agreements;
  
  AgreementsList({Key key, this.agreements}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
      ),
      itemCount: agreements.length,
      itemBuilder: (context, index) {
        //return Image.network(agreements[index].logo);
        return new Card(
                      child: new FlatButton(
                        child: new Column(
                          children: <Widget>[
                          Row(
                            children: <Widget>[
                              /*
                              new Padding(
                                padding: const EdgeInsets.only(top:0.0),
                                child: new CircleAvatar(
                                  radius: 10,
                                    child: ClipOval(
                                      child: Image.network(
                                      agreements[index].logo,
                                      width: 20,
                                      height: 20,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                              ),*/
                              Column(
                                children: <Widget>[
                                  Row(
                                    children: <Widget>[
                                      new CircleAvatar(
                                        radius: 10,
                                          child: ClipOval(
                                            child: Image.network(
                                            agreements[index].logo,
                                            width: 20,
                                            height: 20,
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                      ),
                                      new Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Text("Договор №" + agreements[index].nomerDogovora,
                                            style: new TextStyle(
                                                fontSize: 10.0,
                                                fontWeight: FontWeight.bold)),
                                      ),
                                    ],
                                  ),
                                  
                                  new Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text((agreements[index].ispolnitelPin.isEmpty ? "-":"${agreements[index].ispolnitelPin}"),
                                        style: new TextStyle(
                                          color: Colors.teal,
                                            fontSize: 16.0,
                                            fontWeight: FontWeight.bold)),
                                  ),
                                  
                                ],
                              ),
                            ],
                          ),
                          new Padding(
                                padding: const EdgeInsets.only(bottom: 5.0),
                                child: new Container( 
                                  height: 22.0,
                                  child: Text(
                                    agreements[index].fullNameClient,
                                    style: new TextStyle(
                                        fontSize: 10.0,
                                        fontWeight: FontWeight.bold)),
                          ),),
                          Column(children: <Widget>[
                            Row(children: <Widget>[
                              const Icon(Icons.date_range, size: 12,color: Colors.blueAccent,),
                              new Text(agreements[index].date,
                                        style: new TextStyle(
                                            fontSize: 10.0,
                                            fontWeight: FontWeight.normal,
                                            color: Colors.teal)),
                            ],),
                            Row(children: <Widget>[
                              const Icon(Icons.label, size: 12,color: Colors.blueAccent,),
                              new Text(agreements[index].tematika,
                                        style: new TextStyle(
                                            fontSize: 10.0,
                                            fontWeight: FontWeight.normal,
                                            color: Colors.teal)),
                            ],), 
                            Row(children: <Widget>[
                              const Icon(Icons.phone, size: 12,color: Colors.blueAccent,),
                              new Text(agreements[index].phone,
                                        style: new TextStyle(
                                            fontSize: 10.0,
                                            fontWeight: FontWeight.normal,
                                            color: Colors.teal)),
                            ],),
                            Row(children: <Widget>[
                              const Icon(Icons.call_made, size: 12,color: Colors.blueAccent,),
                              new Text(agreements[index].calling==0?"Не обзвонен":"Обзвонено ${agreements[index].calling}",
                                        style: new TextStyle(
                                            fontSize: 10.0,
                                            fontWeight: FontWeight.normal,
                                            color: Colors.teal)),
                            ],),
                            Row(children: <Widget>[
                              const Icon(Icons.supervised_user_circle, size: 12,color: Colors.blueAccent,),
                              new Text("ЭПОД " + (agreements[index].epodPin.isEmpty ? "Не назначен":"${agreements[index].epodPin}"),
                                        style: new TextStyle(
                                            fontSize: 10.0,
                                            fontWeight: FontWeight.normal,
                                            color: Colors.teal)),
                            ],),
                            Row(children: <Widget>[
                              const Icon(Icons.account_circle, size: 12,color: Colors.blueAccent,),
                              new Text(( agreements[index].ispolnitelPin.isEmpty ? "Нет исполнителя":"Исполнитель ${agreements[index].ispolnitelPin}"),
                                        style: new TextStyle(
                                            fontSize: 10.0,
                                            fontWeight: FontWeight.normal,
                                            color: Colors.teal)),
                            ],),
                          ],),
                        ]),
                        onPressed: () {
                          Navigator.of(context).push(new MaterialPageRoute<Null>(
                              builder: (BuildContext context) {
                                return new AgreementDetail(agreement: agreements[index]);
                              },
                            fullscreenDialog: false
                          ));
                        },
                      ),
                    );
      },
    );
  }
}