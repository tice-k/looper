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
  List<AudioPlayer> players = [];
  Recording _recording = Recording();
  bool _isRecording = false;
  int _tStart;

  List<Clip> clips = [
    Clip(
      recordingName: 'The Nights',
      artistName: 'Avicii',
      fileName: 'the-nights.mp3',
    ),
    Clip(
      recordingName: 'Here With Me',
      artistName: 'Marshmello',
      fileName: 'here-with-me-ft-chvrches.mp3',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: <Widget>[
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
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: <Widget>[
                      IconButton(
                        onPressed: _isRecording ? null : _startRecording,
                        icon: Icon(Icons.fiber_manual_record),
                        iconSize: 30.0,
                        color: _isRecording ? Colors.red[900] : Colors.black,
                        disabledColor: Colors.red,
                      ),
                      IconButton(
                        onPressed: _isRecording ? _stopRecording : null,
                        icon: Icon(Icons.stop),
                        iconSize: 30.0,
                        color: _isRecording ? Colors.black : Colors.grey[700],
                      ),
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
        _tStart = DateTime.now().millisecondsSinceEpoch; // start time
        String recordingPath = appDoc.path + '/custom_recording$_tStart.m4a';
        await AudioRecorder.start(path: recordingPath);
        bool startedRec = await AudioRecorder.isRecording;
        setState(() {
          _recording = Recording(duration: Duration(), path: '');
//          _isRecording = true;
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
    bool isRecording = await AudioRecorder.isRecording;
    setState(() {
      clips.insert(
          0,
          Clip(
            recordingName: 'Clip #${clips.length + 1}',
            fileName: recording.path,
            isLocal: true,
          ));
      _recording = recording;
      _isRecording = isRecording;
//      _isRecording = false;
    });
  }
}
