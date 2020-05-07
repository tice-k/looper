import 'package:flutter/material.dart';

class ProjectCard extends StatelessWidget {

  ProjectCard();

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.fromLTRB(16.0, 0, 16.0, 12.0),
      color: Colors.blue,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16.0, 8.0, 16.0, 8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Row(
              children: <Widget>[
                Expanded(
                  child: Text(
                    'Project Name',
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
//            SizedBox(
//              height: 8.0,
//            ),
//            Text(
//              _printDuration(Duration(milliseconds: rec.length)),
//              style: TextStyle(
//                fontSize: 14.0,
//                color: Colors.grey[400],
//              ),
//            ),
            SizedBox(
              height: 8.0,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(
                  '0 recorded clips',
                  style: TextStyle(
                    fontSize: 16.0,
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
