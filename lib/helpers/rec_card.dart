import 'package:flutter/material.dart';
import 'package:looper/helpers/recording.dart';

class RecordingCard extends StatelessWidget {
  final Clip rec;
  final Function play;
  final Function pause;
  final Function stop;
  final Function delete;

  RecordingCard({this.rec, this.play, this.pause, this.stop, this.delete});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.fromLTRB(16.0, 0, 16.0, 12.0),
      color: Colors.blue[800],
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16.0, 8.0, 16.0, 8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Row(
              children: <Widget>[
                Expanded(
                  child: Text(
                    rec.recordingName,
                    style: TextStyle(
                      fontSize: 20.0,
                      color: Colors.grey[300],
                    ),
                  ),
                ),
                IconButton(
                  onPressed: () {},
                  icon: Icon(Icons.edit),
                  iconSize: 24.0,
                ),
              ],
            ),
//            SizedBox(
//              height: 8.0,
//            ),
//            Text(
//              'by ${rec.artistName}',
//              style: TextStyle(
//                fontSize: 18.0,
//                color: Colors.grey[500],
//              ),
//            ),
            SizedBox(
              height: 8.0,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                IconButton(
                  onPressed: play,
                  icon: Icon(Icons.play_arrow),
                  iconSize: 30.0,
                ),
                IconButton(
                  onPressed: pause,
                  icon: Icon(Icons.pause),
                  iconSize: 30.0,
                ),
                IconButton(
                  onPressed: stop,
                  icon: Icon(Icons.stop),
                  iconSize: 30.0,
                ),
                IconButton(
                  onPressed: delete,
                  icon: Icon(Icons.delete),
                  iconSize: 30.0,
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
