import 'package:cppapp/models/agreement.dart';
import 'package:cppapp/models/agreements.dart';
import 'package:cppapp/models/user.dart';
import 'package:cppapp/pages/search.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:http/http.dart' as http;

class IndexScreen extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Панель управления",
      debugShowCheckedModeBanner: false,
      home: IndexPage(),
    );
  }
}

class IndexPage extends StatelessWidget {
  User user;
  IndexPage({Key key, this.user}) : super(key: key){
    print(key);
    print(this.user.fio);
  }
  
  _launchURL() async {
    const url = 'Тел:89253826214';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Невозможно вызвать';
    }
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text(this.user.fio),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.search),
            tooltip: 'Поиск',
            onPressed: () {
              Navigator.of(context).push(new MaterialPageRoute<Null>(
                  builder: (BuildContext context) {
                    return new SearchDialog();
                  },
                fullscreenDialog: true
              ));
            },
          ),
          IconButton(
            icon: const Icon(Icons.exit_to_app),
            tooltip: 'Выход',
            onPressed: () {
              Navigator.pop(context);
              return Future.value(false);
            },
          ),
        ],
      ),
      drawer: new Drawer(
        child: new ListView(
        children: <Widget>[
          new DrawerHeader(
            padding: const EdgeInsets.all(10.0),
            child: new Row(
              children: <Widget>[
                new Expanded(
                  child: Row(
                    children: <Widget>[
                      new Container(
                        width: 80.0,
                        height: 80.0,
                        decoration: new BoxDecoration(
                          shape: BoxShape.circle,
                          image: new DecorationImage(
                              fit: BoxFit.cover,
                              image: new NetworkImage(this.user.userpic)),
                        ),
                      ),
                      new Container(
                        width: MediaQuery.of(context).size.width/2,
                        padding: const EdgeInsets.only(top:50.0, left:20.0),
                        child: new Column(
                          mainAxisSize: MainAxisSize.max,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text("@${this.user.username}"),
                            Text("${this.user.fio}",
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              softWrap: false,
                              style: new TextStyle(
                                fontSize: 14.0,
                                fontFamily: 'Roboto',
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
          new ListTile(
            title: new Text('Мои договора'),
            onTap: () {},
          ),
          new Divider(),
          new ListTile(
            title: new Text('О приложении'),
            onTap: () {

            },
          ),
        ],
      )),
      body: FutureBuilder<List<Agreement>>(
                  future: fetchAgreements(http.Client()), 
                  builder: (context, snapshot) {
                    if (snapshot.hasError) print(snapshot.error);
                    return snapshot.hasData ? AgreementsList(agreements: snapshot.data) : Center(child: CircularProgressIndicator());
                  },
                ),
    );
  }
}
