import 'dart:io';
import 'package:flutter/material.dart';
import 'package:looper/helpers/project_info.dart';
import 'package:looper/helpers/project_card.dart';
import 'package:looper/helpers/rec_info.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';

class ProjectView extends StatefulWidget {
  @override
  _ProjectViewState createState() => _ProjectViewState();
}

class _ProjectViewState extends State<ProjectView> {
  List<ProjectFile> projects = [];

  @override
  void initState() {
    super.initState();
    initialize();
  }

  /*
  sample project info.txt file:
    [name]
    [int - totalClipsEver]
  sample clip info.txt file:
    [name]
    [artistName]
    [int - length in ms]
   */

  initialize() async {
    // get all projects
    projects.clear();
    Directory appDir = await getApplicationDocumentsDirectory();
    List<FileSystemEntity> projectDirectories = appDir.listSync();
    for (FileSystemEntity projectDir in projectDirectories) {
//      print(projectDir);
      if (projectDir is Directory) {
        if (await File(projectDir.path + '/info.txt').exists()) {
//          print('Project ${basename(projectDir.path)}');
          List<Clip> projectClips = [];
          List<FileSystemEntity> clipFolders = projectDir.listSync();
          for (FileSystemEntity clipFolder in clipFolders) {
//            print(clipFolder.toString());
            if (clipFolder is Directory) {
//              print('clip folder: ' + clipFolder.toString());
              if (clipFolder is Directory) {
                File clipInfo = File('${clipFolder.path}/info.txt');
                List<String> clipData = clipInfo.readAsLinesSync();
                Clip c = Clip(
                  recordingName: clipData[0],
                  artistName: clipData[1],
                  recordingPath: clipData[2],
                  length: int.parse(clipData[3]),
                );
                projectClips.add(c);
              }
            }
          }
          ProjectFile p = ProjectFile(
            name: basename(projectDir.path),
            projectPath: projectDir.path,
            clips: projectClips,
          );
          projects.add(p);
        }
      }
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue[900],
        title: Text('Projects'),
        centerTitle: true,
        elevation: 0,
      ),
      resizeToAvoidBottomInset: false,
      body: Container(
        decoration: BoxDecoration(
          color: Colors.grey,
        ),
        child: Column(
          children: <Widget>[
            SizedBox(
              height: 8.0,
            ),
            RaisedButton(
              onPressed: () async {
                print(projects);
                await initialize();
                setState(() {
                  print(projects);
                });
              },
              child: Text('Refresh'),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: projects.length,
                itemBuilder: (context, index) {
                  return ProjectCard(
                    projectFile: projects[index],
                    openProject: () {
                      Navigator.pushNamed(
                        context,
                        '/record',
                        arguments: projects[index],
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
