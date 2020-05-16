import 'dart:io';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

// home screen, create new project, look at old projects

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {

  _createProject() {
    showDialog(
      context: context,
      builder: (context) {
        TextEditingController controller = TextEditingController();
        return AlertDialog(
          title: Text('Enter name:'),
          content: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: TextField(
              controller: controller,
              autofocus: true,
            ),
          ),
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.check),
              onPressed: () async {
                String projectName = controller.text;
                controller.dispose();
                Directory appDir = await getApplicationDocumentsDirectory();
                Directory projectDir = await Directory(appDir.path + '/$projectName').create();
                File info = await File(projectDir.path + '/info.txt').create();
                info.writeAsString('$projectName\n0');
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

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
                  onPressed: _createProject,
                ),
                RaisedButton.icon(
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          title: Text('Are you sure?'),
                          content: Text('Deleting your data is permanent.'),
                          actions: <Widget>[
                            FlatButton(
                              child: Text('No'),
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                            ),
                            FlatButton(
                              child: Text('Yes'),
                              onPressed: () async {
                                Directory appDir = await getApplicationDocumentsDirectory();
                                appDir.delete(recursive: true);
                                Navigator.of(context).pop();
                              },
                            ),
                          ],
                        );
                      }
                    );
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
