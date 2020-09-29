//Статья https://flutter.dev/docs/cookbook/networking/background-parsing

import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:cppapp/configs/config.dart';
import 'package:cppapp/models/agreement.dart';
import 'package:cppapp/models/document.dart';
import 'package:cppapp/models/user.dart';
import 'package:cppapp/utils/loader.dart';
import 'package:dio/dio.dart';
//import 'package:cppapp/pages/document.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:http/http.dart' as http; 
import 'package:folder_picker/folder_picker.dart';
//
import 'package:directory_picker/directory_picker.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
//
import 'package:flutter_spinkit/flutter_spinkit.dart';
//

/*
Future<List<Document>> fetchDocuments(http.Client client) async {
  String url = "${Config.baseUrl}/${Config.mobileDir}/?module=agreement&function=fileList&id=9628";
  final response = await client.get(url);
  var data = json.decode(response.body)['data'];
  return compute(parseDocuments, json.encode(data));
}
List<Document> parseDocuments(String responseBody) {
  final parsed = json.decode(responseBody).cast<Map<String, dynamic>>();
  return parsed.map<Document>((json) => Document.fromJson(json)).toList();
}
*/
//
class DocumentsList extends StatelessWidget {
  final Agreement agreement;
  final List<Document> documents;
  DocumentsList({Key key, this.documents, @required this.agreement}) : super(key: key);

  static Future<List<Document>> fetchDocuments(http.Client client, agreementId) async {
    String url = "${Config.baseUrl}/${Config.mobileDir}/?module=agreement&function=fileList&id="+agreementId;
    final response = await client.get(url);
    var data = json.decode(response.body)['data'];
    return compute(parseDocuments, json.encode(data));
  }
  static List<Document> parseDocuments(String responseBody) {
    final parsed = json.decode(responseBody).cast<Map<String, dynamic>>();
    return parsed.map<Document>((json) => Document.fromJson(json)).toList();
  }

  @override
  Widget build(BuildContext context) { 
    print("START:!!!!!!!!!!!!!!!!!!!!!&&&&!!!!!!!!!!!!!!!!!!!");
    print(this.agreement.id);
    print("END:!!!!!!!!!!!!!!!!!!!!!&&&&!!!!!!!!!!!!!!!!!!!");
    return GridView.builder(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
      ),
      itemCount: documents.length,
      itemBuilder: (context, index) {
        String dFileSrc = "assets/icon/icon-file-file.png";
        switch(documents[index].type.toLowerCase()){
          case 'pdf': dFileSrc = "assets/icon/icon-file-pdf.png";
            break;
          case 'doc':
          case 'docx': 
              dFileSrc = "assets/icon/icon-file-doc.png";
            break;
          case 'txt': dFileSrc = "assets/icon/icon-file-txt";
            break;
          case 'xsl': 
          case 'xslx':
              dFileSrc = "assets/icon/icon-file-xsl.png";
            break;
          case 'csv': dFileSrc = "assets/icon/icon-file-csv.png";
            break;
          case 'zip': dFileSrc = "assets/icon/icon-file-zip.png";
            break;
          case 'mp3': 
          case 'wav': 
          case 'ogg': 
          case 'midi': 
              dFileSrc = "assets/icon/icon-file-audio.png";
            break;
          case 'jpg': 
          case 'jpeg': 
          case 'png': 
          case 'tiff': 
          case 'gif': 
              dFileSrc = "assets/icon/icon-file-image.png";
            break;
          default: dFileSrc = "assets/icon/icon-file-file.png";
        }
        //
        return new Card(
                      child: new FlatButton(
                        child: new Column(
                          children: <Widget>[
                          /*
                          Row(
                            children: <Widget>[
                              new SpinKitWave(
                                color: Colors.red,
                                size: 50.0,
                                
                              ),
                            ]
                          ),
                          */
                          Row(
                            children: <Widget>[
                              Column(
                                children: <Widget>[
                                  Row(
                                    children:<Widget>[
                                  new Padding(
                                    padding: const EdgeInsets.only(top:5.0),
                                      child: new CircleAvatar(
                                        backgroundColor: Colors.transparent,
                                        radius: 12,
                                        child: ClipOval(
                                          child: new Container(
                                            width: 24.0,
                                            height: 24.0,
                                            decoration: new BoxDecoration(
                                              shape: BoxShape.circle,
                                              image: new DecorationImage(
                                                fit: BoxFit.fill,
                                                image: AssetImage(dFileSrc),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),),
                                      SizedBox(
                                        width: 90,
                                        child: new Padding(
                                                            padding: const EdgeInsets.only(left:5.0),
                                                            child: Text(documents[index].name,
                                                            textAlign: TextAlign.center,
                                                            style: new TextStyle(
                                                                fontSize: 8.0,
                                                                fontWeight: FontWeight.bold),
                                                            ),
                                                          ),
                                      )
                                    ]
                                  ),
                                  new Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text((documents[index].type.isEmpty ? "-":"${documents[index].type}"),
                                        style: new TextStyle(
                                          color: Colors.teal,
                                            fontSize: 16.0,
                                            fontWeight: FontWeight.bold)),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          Column(children: <Widget>[
                            Row(children: <Widget>[
                              const Icon(Icons.date_range, size: 12,color: Colors.blueAccent,),
                              new Text(documents[index].date,
                                        style: new TextStyle(
                                            fontSize: 10.0,
                                            fontWeight: FontWeight.normal,
                                            color: Colors.teal)),
                            ],),
                            Row(children: <Widget>[
                              const Icon(Icons.save, size: 12,color: Colors.blueAccent,),
                              new Text("Размер " + (documents[index].size.isEmpty ? "не указан":"${documents[index].size}"),
                                        style: new TextStyle(
                                            fontSize: 10.0,
                                            fontWeight: FontWeight.normal,
                                            color: Colors.teal)),
                            ],),
                            Row(children: <Widget>[
                              const Icon(Icons.category, size: 12,color: Colors.blueAccent,),
                              new Text((documents[index].type.isEmpty ? "Нет формата":"Тип ${documents[index].type.toUpperCase()}"),
                                        style: new TextStyle(
                                            fontSize: 10.0,
                                            fontWeight: FontWeight.normal,
                                            color: Colors.teal)),
                            ],),
                          ],),

                          Column(children: <Widget>[
                            Row(children: <Widget>[
                              new Text(("Скачать"),
                                        style: new TextStyle(
                                            fontSize: 10.0,
                                            fontWeight: FontWeight.normal,
                                            color: Colors.teal)),
                            ],),
                          ],),
                        ]),
                        onPressed: () async {

                          /*
                          Directory appDocDir = await getLibraryDirectory();
                          String appDocPath = appDocDir.path;
                          var directory = new Directory(appDocPath);
                          */
                          ///storage/emulated/0
                          ///
                          ////*
                          
                          Directory directory;
                          if (Platform.isAndroid) {
                            directory = new Directory('/storage/emulated/0');
                            print('Android platform');
                          } else if (Platform.isIOS) {
                            directory = new Directory('/storage/emulated/0');
                            print('iOS platform');
                          }
                          var rootContext = context;
                          Navigator.of(rootContext).push<FolderPickerPage>(
                            MaterialPageRoute(
                                builder: (BuildContext context) {
                                  return FolderPickerPage(
                                      rootDirectory: directory, /// a [Directory] object
                                      action: (BuildContext context, Directory folder) async {
                                        //Downloading file ...
                                        print('Download file' + documents[index].link + ' to ' + folder.path);
                                        Dio dio = new Dio();
                                        Response response = await dio.download(documents[index].link, folder.path + '/downloaded.pdf');
                                        print(response);
                                        print('File downloaded...!');
                                        //Show loader...
                                        /*
                                        Loader.showLoader(context, "Wave", (context) async {
                                          Future.delayed(Duration(seconds: 10), (){
                                            Navigator.of(rootContext).pop(true);
                                            print("Navigator.popUntil");
                                            Navigator.pop(rootContext);
                                          });
                                        });
                                        */
                                        //
                                      });
                          }));
                        },
                      ),
                    );
      },
    );
  }
}