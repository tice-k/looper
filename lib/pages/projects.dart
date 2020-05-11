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

  initialize() async {
    // get all projects
    Directory appDir = await getApplicationDocumentsDirectory();
    List<ProjectFile> projects = [];
    List<FileSystemEntity> projectDirectories = appDir.listSync();
    for(FileSystemEntity projectDir in projectDirectories) {
      print(projectDir.toString());
      if(projectDir is Directory) {
        List<Clip> projectClips = [];
        List<FileSystemEntity> clipFolders = projectDir.listSync();
        for (FileSystemEntity clipFolder in clipFolders) {
          print(projectDir.toString());
          if(clipFolder is Directory) {
            File clipInfo = File('$clipFolder.path/info.txt');
            List<String> clipData = clipInfo.readAsLinesSync();
            Clip c = Clip(
              recordingName: clipData[0],
              artistName: clipData[1],
              fileName: clipData[2],
              length: int.parse(clipData[3]),
              isLocal: clipData[4] == 'true',
            );
            projectClips.add(c);
          }
        }
        ProjectFile p = ProjectFile(
          name: basename(projectDir.path),
          projectPath: basename(projectDir.path),
          clips: projectClips,
        );
        projects.add(p);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey,
      ),
      child: Column(
        children: <Widget>[
          SizedBox(
            height: 12.0,
          ),
          RaisedButton(
            onPressed: initialize,
            child: Text('Show directories'),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: 1,
              itemBuilder: (context, index) {
                return ProjectCard(
                  openProject: () {
                    // TODO: open recordings page
                  },
                  projectName: 'project',
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
