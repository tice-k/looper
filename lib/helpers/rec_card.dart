import 'package:flutter/material.dart';
import 'package:looper/helpers/rec_info.dart';

class RecordingCard extends StatelessWidget {
  final Clip rec;
  final Function play;
  final Function pause;
  final Function stop;
  final Function delete;
  final Function editName;
  final Function volumeChange;
  final Function loopToggle;

  RecordingCard({
    this.rec,
    this.play,
    this.pause,
    this.stop,
    this.delete,
    this.editName,
    this.volumeChange,
    this.loopToggle,
  });

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
                  onPressed: editName,
                  icon: Icon(Icons.edit),
                  iconSize: 24.0,
                ),
              ],
            ),
            Row(
              children: <Widget>[
                Text(
                  _printDuration(Duration(milliseconds: rec.length)),
                  style: TextStyle(
                    fontSize: 14.0,
                    color: Colors.grey[400],
                  ),
                ),
              ],
            ),
            Row(
              children : <Widget>[
                Row(
                  children: <Widget>[
                    IconButton(
                      onPressed: () {
                        if(rec.isMuted) {
                          volumeChange(rec.volumeOnUnMute);
                        } else {
                          rec.volumeOnUnMute = rec.volume;
                          volumeChange(0.0);
                        }
                        rec.isMuted = !rec.isMuted;
                      },
                      icon: Icon(rec.isMuted ? Icons.volume_off : Icons.volume_up),
                    ),
                    Slider(
                      onChanged: volumeChange,
                      value: rec.volume,
                    ),
                  ],
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                IconButton(
                  onPressed: loopToggle,
                  icon: Icon(Icons.loop),
                  iconSize: 30.0,
                  color: rec.loop ? Colors.white : Colors.grey[900],
                ),
                IconButton(
                  onPressed: rec.isPlaying ? pause : play,
                  icon: Icon(rec.isPlaying ? Icons.pause : Icons.play_arrow),
                  iconSize: 30.0,
                  color: Colors.grey[900],
                ),
                IconButton(
                  onPressed: stop,
                  icon: Icon(Icons.stop),
                  iconSize: 30.0,
                  color: Colors.grey[900],
                ),
                IconButton(
                  onPressed: delete,
                  icon: Icon(Icons.delete),
                  iconSize: 30.0,
                  color: Colors.grey[900],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  String _printDuration(Duration duration) {
    String twoDigits(int n) => (n >= 10) ? "$n" : "0$n";
    String threeDigits(int n) => (n >= 100) ? "$n" : (n >= 10) ? "0$n" : "00$n";

    String twoDigitMinutes = twoDigits(duration.inMinutes);
    String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
    String threeDigitMilliseconds =
        twoDigits(duration.inMilliseconds.remainder(1000));
    return "$twoDigitMinutes:$twoDigitSeconds.$threeDigitMilliseconds";
  }
}
