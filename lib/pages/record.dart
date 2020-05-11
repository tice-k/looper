import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:looper/helpers/rec_info.dart';
import 'package:looper/helpers/rec_card.dart';
import 'package:looper/helpers/project_info.dart';
import 'package:audio_recorder/audio_recorder.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:audioplayers/audio_cache.dart';
import 'package:path_provider/path_provider.dart';
import 'package:app_settings/app_settings.dart';

// TODO: bug: audio keeps playing after leaving recording page
// TODO: pause button doesn't turn back after clip finishes playing (low priority)

class Recorder extends StatefulWidget {

  final ProjectFile project;
  const Recorder(this.project);

  @override
  _RecorderState createState() => _RecorderState();
}

class _RecorderState extends State<Recorder> {
  static AudioCache assetPlayer = AudioCache();
  List<AudioPlayer> players = []; // list of audio players for each clip
  bool _isRecording = false;
  Stopwatch _stopwatch = Stopwatch();
  Timer _timer;
  String savePath = '';

  List<Clip> clips = [];

  @override
  Widget build(BuildContext context) {
//    print(ModalRoute.of(context).settings.arguments);
//    final ProjectFile project = ModalRoute.of(context).settings.arguments;
    if(widget.project != null) {
      savePath = widget.project.projectPath;
      clips = widget.project.clips;
    } else {
      return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.blue[900],
        title: Text(widget.project.name),
          centerTitle: true,
          elevation: 0,
        ),
        body: Container(
          decoration: BoxDecoration(
            color: Colors.grey,
          ),
          child: Center(
            child: Text('Please select a project'),
          ),
        ),
      );
    }
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue[900],
//        title: Text(project.name),
        title: Text('Record'),
        centerTitle: true,
        elevation: 0,
      ),
      body: Container(
        decoration: BoxDecoration(
          color: Colors.grey,
        ),
        child: Column(
          children: <Widget>[
            // card: make a new recording
            Card(
              margin: EdgeInsets.fromLTRB(16.0, 12.0, 16.0, 12.0),
              color: Colors.blue,
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
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        // record button
                        IconButton(
                          onPressed:
                              _isRecording ? _stopRecording : _startRecording,
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
                      if (clips[index].audioPlayerID == null) {
                        if (clips[index].isLocal) {
                          AudioPlayer ap = AudioPlayer();
                          ap.setReleaseMode(ReleaseMode.LOOP);
                          ap.onPlayerCompletion.listen((event) {
                            ap.release();
                            setState(() {
                              clips[index].isPlaying = false;
                            });
                          });
                          ap.play(
                            clips[index].filePath,
                            isLocal: clips[index].isLocal,
                            volume: clips[index].volume,
                          );
                          clips[index].setPlayerID(ap.playerId);
                        } else {
                          AudioPlayer ap = await assetPlayer.play(
                            clips[index].filePath,
                            volume: clips[index].volume,
                          );
                          clips[index].setPlayerID(ap.playerId);
                          ap.setReleaseMode(ReleaseMode.LOOP);
                          ap.onPlayerCompletion.listen((event) {
                            setState(() {
                              clips[index].isPlaying = false;
                            });
                          });
                        }
                      } else {
                        AudioPlayer(playerId: clips[index].audioPlayerID)
                            .resume();
                      }
                      setState(() {
                        clips[index].isPlaying = !clips[index].isPlaying;
                      });
                    },
                    pause: () {
                      AudioPlayer(playerId: clips[index].audioPlayerID).pause();
                      setState(() {
                        clips[index].isPlaying = !clips[index].isPlaying;
                      });
                    },
                    stop: () {
                      AudioPlayer(playerId: clips[index].audioPlayerID).stop();
                      AudioPlayer(playerId: clips[index].audioPlayerID).release();
                      setState(() {
                        clips[index].isPlaying = false;
                      });
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
                    volumeChange: (value) {
                      setState(() {
                        clips[index].volume = value;
                        AudioPlayer currentPlayer =
                            AudioPlayer(playerId: clips[index].audioPlayerID);
                        if (currentPlayer != null) {
                          currentPlayer.setVolume(value);
                        }
                      });
                    },
                    loopToggle: () {
                      if(clips[index].loop)
                        AudioPlayer(playerId: clips[index].audioPlayerID).setReleaseMode(ReleaseMode.RELEASE);
                      else
                        AudioPlayer(playerId: clips[index].audioPlayerID).setReleaseMode(ReleaseMode.LOOP);
                      setState(() {
                        clips[index].loop = !clips[index].loop;
                      });
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

  _startRecording() async {
    try {
      if (await AudioRecorder.hasPermissions) {
        String recordingPath;
        if(savePath.isEmpty) {
          Directory appDoc = await getApplicationDocumentsDirectory();
          int tStart = DateTime.now().millisecondsSinceEpoch;
          recordingPath = appDoc.path + '/REC$tStart.m4a';
        } else {
          await Directory(savePath + '/clip${clips.length + 1}').create();
          File infoFile = await File(savePath + '/clip${clips.length + 1}/info.txt').create();
          infoFile.writeAsString('Clip #${clips.length + 1}\n' +
              'unkown artist\n' +
              'savePath' + '/clip${clips.length + 1}\n'+
              '0\n' +
              'true');
          int tStart = DateTime.now().millisecondsSinceEpoch;
          recordingPath = savePath + '/clip${clips.length + 1}/REC$tStart.m4a';
        }
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
            filePath: recording.path,
            length: recordingLength,
            isLocal: true,
          ));
      _isRecording = isRecording;
      _stopwatch.reset();
    });
  }
}
