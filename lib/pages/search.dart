import 'package:flutter/material.dart';
//Статья https://fidev.io/full-screen-dialog/
class SearchDialog extends StatefulWidget {
  @override
  SearchDialogState createState() => new SearchDialogState();
}

class SearchDialogState extends State<SearchDialog> {
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: const Text('Параметры поиска'),
        actions: [
          new FlatButton(
              onPressed: () {
                //TODO: Handle save
              },
              child: new Text('Найти',
                  style: Theme
                      .of(context)
                      .textTheme
                      .subhead
                      .copyWith(color: Colors.white))),
        ],
      ),
      body: new Text("Foo"),
    );
  }
}