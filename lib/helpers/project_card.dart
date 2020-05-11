import 'package:flutter/material.dart';
import 'package:looper/helpers/project_info.dart';

class ProjectCard extends StatelessWidget {

  final ProjectFile projectFile;
  final Function openProject;

  ProjectCard({
    this.projectFile,
    this.openProject,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: openProject,
      child: Card(
        margin: EdgeInsets.fromLTRB(16.0, 0, 16.0, 12.0),
        color: Colors.blue,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16.0, 4.0, 16.0, 8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Row(
                children: <Widget>[
                  Expanded(
                    child: Text(
                      projectFile.name,
                      style: TextStyle(
                        fontSize: 20.0,
                        color: Colors.grey[300],
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: null,
                    icon: Icon(Icons.edit),
                    iconSize: 24.0,
                  ),
                ],
              ),
              SizedBox(
                height: 4.0,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                    '${projectFile.clips.length} recorded clips',
                    style: TextStyle(
                      fontSize: 16.0,
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
