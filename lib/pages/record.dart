import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:looper/helpers/recording.dart';
import 'package:looper/helpers/rec_card.dart';
import 'package:audio_recorder/audio_recorder.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:audioplayers/audio_cache.dart';
import 'package:path_provider/path_provider.dart';
import 'package:app_settings/app_settings.dart';

// TODO: bug: audio keeps playing after leaving recording page

class Recorder extends StatefulWidget {
  @override
  _RecorderState createState() => _RecorderState();
}

class _RecorderState extends State<Recorder> {
  static AudioCache assetPlayer = AudioCache();
  List<AudioPlayer> players = []; // list of audio players for each clip
  bool _isRecording = false;
  Stopwatch _stopwatch = Stopwatch();
  Timer _timer;

  List<Clip> clips = [
    Clip(
      recordingName: 'The Nights',
      artistName: 'Avicii',
      fileName: 'the-nights.mp3',
      length: 173000,
    ),
    Clip(
      recordingName: 'Here With Me',
      artistName: 'Marshmello',
      fileName: 'here-with-me-ft-chvrches.mp3',
      length: 154000,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: <Widget>[
          // make a new recording card
          Card(
            margin: EdgeInsets.fromLTRB(16.0, 12.0, 16.0, 12.0),
            color: Colors.blue[400],
            child: Padding(
              padding: const EdgeInsets.all(14.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  Text(
                    'Add New Recording',
                    style: TextStyle(
                      fontSize: 22.0,
                      color: Colors.grey[300],
                    ),
                  ),
                  SizedBox(
                    height: 8.0,
                  ),
                  Row(
                    children: <Widget>[
                      // record button
                      IconButton(
                        onPressed: _isRecording ? _stopRecording : _startRecording,
                        color: _isRecording ? Colors.red[900] : Colors.black,
                        icon: Icon(Icons.fiber_manual_record),
                        iconSize: 30.0,
                      ),
//                      Text(
//                        _printDuration(_stopwatch.elapsed),
//                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: clips.length,
              itemBuilder: (context, index) {
                return RecordingCard(
                  rec: clips[index],
                  play: () async {
                    print(clips[index].fileName);
                    if (clips[index].audioPlayerID == null) {
                      if (clips[index].isLocal) {
                        AudioPlayer ap = AudioPlayer();
                        ap.play(clips[index].fileName,
                            isLocal: clips[index].isLocal);
                        clips[index].setPlayerID(ap.playerId);
                      } else {
                        clips[index].setPlayerID(
                            (await assetPlayer.play(clips[index].fileName))
                                .playerId);
                      }
                    } else {
                      AudioPlayer(playerId: clips[index].audioPlayerID)
                          .resume();
                    }
                  },
                  pause: () {
                    AudioPlayer(playerId: clips[index].audioPlayerID).pause();
                  },
                  stop: () {
                    AudioPlayer(playerId: clips[index].audioPlayerID).stop();
                  },
                  delete: () {
                    setState(() {
                      clips.remove(clips[index]);
                    });
                  },
                  editName: () {
                    showDialog(
                      context: context,
                      builder: (context) {
                        TextEditingController controller =
                            TextEditingController(
                                text: clips[index].recordingName);
                        return AlertDialog(
                          title: Text('Enter name:'),
                          content: TextField(
                            controller: controller,
                            autofocus: true,
                          ),
                          actions: <Widget>[
                            IconButton(
                              icon: Icon(Icons.check),
                              onPressed: () {
                                setState(() {
                                  clips[index].recordingName = controller.text;
                                });
                                Navigator.of(context).pop();
                              },
                            ),
                          ],
                        );
                      },
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  _startRecording() async {
    try {
      if (await AudioRecorder.hasPermissions) {
        Directory appDoc = await getApplicationDocumentsDirectory();
        int tStart = DateTime.now().millisecondsSinceEpoch;
        String recordingPath = appDoc.path + '/custom_recording$tStart.m4a';
        await AudioRecorder.start(path: recordingPath);
        _stopwatch.start();
        bool startedRec = await AudioRecorder.isRecording;
        setState(() {
          _isRecording = startedRec;
        });
      } else {
        Scaffold.of(context).showSnackBar(SnackBar(
          content: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text("You must accept permissions"),
              FlatButton(
                onPressed: () {
                  AppSettings.openAppSettings();
                },
                child: Text(
                  'SETTINGS',
                  style: TextStyle(
                    color: Colors.blue[700],
                  ),
                ),
                materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
              )
            ],
          ),
        ));
      }
    } catch (e) {
      print(e);
    }
  }

  _stopRecording() async {
    Recording recording = await AudioRecorder.stop();
    _stopwatch.stop();
    int recordingLength = _stopwatch.elapsedMilliseconds;
    bool isRecording = await AudioRecorder.isRecording;
    setState(() {
      clips.insert(
          0, // position in list
          Clip(
            recordingName: 'Clip #${clips.length + 1}',
            fileName: recording.path,
            length: recordingLength,
            isLocal: true,
          ));
      _isRecording = isRecording;
      _stopwatch.reset();
    });
  }
}
