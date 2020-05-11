import 'dart:io';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

// home screen, create new project, look at old projects

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue[900],
        centerTitle: true,
        elevation: 0,
      ),
      body: Container(
        decoration: BoxDecoration(
          color: Colors.grey,
        ),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(0.0, 100.0, 0.0, 100.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(
                  'Looper',
                  style: TextStyle(
                    fontSize: 50.0,
                    letterSpacing: 3.0,
                  ),
                ),
                RaisedButton.icon(
                  icon: Icon(
                    Icons.add,
                    color: Colors.blue,
                  ),
                  disabledColor: Colors.white,
                  label: Text('Create New Project'),
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (context) {
                        TextEditingController controller =
                            TextEditingController();
                        return AlertDialog(
                          title: Text('Enter name:'),
                          content: TextField(
                            controller: controller,
                            autofocus: true,
                          ),
                          actions: <Widget>[
                            IconButton(
                              icon: Icon(Icons.check),
                              onPressed: () async {
                                String projectName = controller.text;
                                Directory appDir =
                                    await getApplicationDocumentsDirectory();
                                Directory projectDir = await Directory(
                                        appDir.path + '/$projectName')
                                    .create();
                                await File(projectDir.path + '/info.txt').create();
                                Navigator.of(context).pop();
                              },
                            ),
                          ],
                        );
                      },
                    );
                  },
                ),
                RaisedButton.icon(
                  onPressed: () async {
                    Directory appDir = await getApplicationDocumentsDirectory();
                    appDir.delete(recursive: true);
                  },
                  icon: Icon(
                    Icons.delete,
                    color: Colors.blue,
                  ),
                  label: Text('Clear data'),
                  disabledColor: Colors.white,
                ),
                RaisedButton.icon(
                  onPressed: () {},
                  icon: Icon(
                    Icons.person,
                    color: Colors.blue,
                  ),
                  label: Text(
                    'About',
                  ),
                  disabledColor: Colors.white,
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
