import 'dart:convert';
import 'dart:io';

import 'package:cppapp/models/agreement.dart';
import 'package:cppapp/models/document.dart';
import 'package:cppapp/models/documents.dart'; 
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'package:flutter/services.dart';
import 'package:flutter_share/flutter_share.dart';
import 'package:image_picker/image_picker.dart';
import 'package:documents_picker/documents_picker.dart';

//Статья https://fidev.io/full-screen-dialog/
class AgreementDetail extends StatefulWidget {
  final Agreement agreement; 
  AgreementDetail({Key key, @required this.agreement}): super(key: key){
    print(this.agreement.nomerDogovora);
  }
  @override
  AgreementDetailState createState() => new AgreementDetailState(this.agreement);
}

class AgreementDetailState extends State<AgreementDetail> {
  final Agreement agreement;
  AgreementDetailState(this.agreement);

  //**************File Uploade */
  // My IPv4 : 192.168.43.171 
  final String phpEndPoint = '4cpp.ru/android/file/upload.php';
  //final String nodeEndPoint = 'http://192.168.43.171:3000/image';
  File file;
  List<String> docPaths;

  void _chooseDocuments() async {
    docPaths = await DocumentsPicker.pickDocuments;
    print('______________upload()__________|'+docPaths.toString());
    //if (!mounted) return;
    //setState(() {});
  }
  void _chooseCamera() async {
    file = await ImagePicker.pickImage(source: ImageSource.camera);
    _upload();
  }
  void _chooseImage() async {
    file = await ImagePicker.pickImage(source: ImageSource.gallery);
    _upload();
  }
  void _upload() {
    //if (file == null) return;
    String base64Image = base64Encode(file.readAsBytesSync());
    String fileName = file.path.split("/").last;
    print('______________upload()_________|'+fileName); 
    http.post(phpEndPoint, body: { 
      "image": base64Image,
      "name": fileName,
    }).then((res) {
      print(res.statusCode);
    }).catchError((err) {
      print(err);
    });
  }
  //**************File Uploade */

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: Text("Договор №${this.agreement.nomerDogovora}"),
        actions: [
          file == null ? Text('No Image Selected') : Image.file(file),
          IconButton(
            icon: const Icon(Icons.add_a_photo),
            tooltip: 'Сделать фото из камеры',
            onPressed: _chooseCamera,
          ),
          IconButton(
            icon: const Icon(Icons.image),
            tooltip: 'Прикрепить фото',
            onPressed: _chooseImage,
          ),
          IconButton(
            icon: const Icon(Icons.insert_drive_file),
            tooltip: 'Прикрепить документ',
            onPressed: _chooseDocuments,
          ),
        ],
      ),
      body: Column(
                children: <Widget>[
        new Card(
              child: new FlatButton(
                child: new Column(
                  children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      new CircleAvatar(
                        radius: 30,
                        child: ClipOval(
                          child: Image.network(
                            agreement.logo,
                            width: 60,
                            height: 60,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      Column(
                        children: <Widget>[
                          new Padding(
                            padding: const EdgeInsets.all(20.0),
                            child: Text("Договор №" + agreement.nomerDogovora,
                                style: new TextStyle(
                                    fontSize: 14.0,
                                    fontWeight: FontWeight.bold)),
                          ),
                          new Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text((agreement.ispolnitelPin.isEmpty ? "-":"${agreement.ispolnitelPin}"),
                                style: new TextStyle(
                                  color: Colors.teal,
                                    fontSize: 25.0,
                                    fontWeight: FontWeight.bold)),
                          ),
                        ],
                      ),
                    ],
                  ),
                  new Padding(
                        padding: const EdgeInsets.only(bottom: 10.0),
                        child: new Container( 
                          alignment: Alignment.topCenter,
                          height: 30.0,
                          child: Text(
                            agreement.fullNameClient,
                            style: new TextStyle(
                                fontSize: 14.0,
                                fontWeight: FontWeight.bold)),
                    ),
                  ),
                  new Padding(
                    padding: const EdgeInsets.only(bottom: 20.0),
                    child:Column(children: <Widget>[
                                      Row(children: <Widget>[
                                        const Icon(Icons.date_range, size: 20,color: Colors.blueAccent,),
                                        new Text(agreement.date,
                                                  style: new TextStyle(
                                                      fontSize: 14.0,
                                                      fontWeight: FontWeight.normal,
                                                      color: Colors.teal)),
                                      ],),
                                      Row(children: <Widget>[
                                        const Icon(Icons.label, size: 20,color: Colors.blueAccent,),
                                        new Text(agreement.tematika,
                                                  style: new TextStyle(
                                                      fontSize: 14.0,
                                                      fontWeight: FontWeight.normal,
                                                      color: Colors.teal)),
                                      ],), 
                                      Row(children: <Widget>[
                                        const Icon(Icons.phone, size: 20,color: Colors.blueAccent,),
                                        new Text(agreement.phone,
                                                  style: new TextStyle(
                                                      fontSize: 14.0,
                                                      fontWeight: FontWeight.normal,
                                                      color: Colors.teal)),
                                      ],),
                                      Row(children: <Widget>[
                                        const Icon(Icons.call_made, size: 20,color: Colors.blueAccent,),
                                        new Text(agreement.calling==0 ? "Не обзвонен" : "Обзвонено ${agreement.calling}",
                                                  style: new TextStyle(
                                                      fontSize: 14.0,
                                                      fontWeight: FontWeight.normal,
                                                      color: Colors.teal)),
                                      ],),
                                      Row(children: <Widget>[
                                        const Icon(Icons.supervised_user_circle, size: 20,color: Colors.blueAccent,),
                                        new Text("ЭПОД " + (agreement.epodPin.isEmpty ? "не назначен":"${agreement.epodPin}"),
                                                  style: new TextStyle(
                                                      fontSize: 14.0,
                                                      fontWeight: FontWeight.normal,
                                                      color: Colors.teal)),
                                      ],),
                                      Row(children: <Widget>[
                                        const Icon(Icons.account_circle, size: 20,color: Colors.blueAccent,),
                                        new Text((agreement.ispolnitelPin.isEmpty ? "Нет исполнителя":"Исполнитель ${agreement.ispolnitelPin}"),
                                                  style: new TextStyle(
                                                      fontSize: 14.0,
                                                      fontWeight: FontWeight.normal,
                                                      color: Colors.teal)),
                                      ],),
                  ],),),
                ]),
                onPressed: () {},
              ),
        ),
        Padding(
          padding: const EdgeInsets.only(bottom: 10.0, top: 10.0),
          child: Center(child: Text("Документы к договору", style: new TextStyle(
            fontSize: 14,
            ),
          ),
        ),
      ),
        Expanded(
          child: FutureBuilder<List<Document>>(
                    future: DocumentsList.fetchDocuments(http.Client(), this.agreement.id), 
                    builder: (context, snapshot) {
                      if (snapshot.hasError) print(snapshot.error);
                      return snapshot.hasData ? DocumentsList(documents: snapshot.data, agreement: this.agreement) : Center(child: CircularProgressIndicator());
                    },
                  ),
        ),
      ],)
    );
  }
}