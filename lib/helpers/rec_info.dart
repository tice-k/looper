class Clip {
  String recordingName;
  String artistName;
  String recordingPath; // path name to .m4a file
  String folderPath;
  String audioPlayerID;
  int length; // in milliseconds
  bool isLocal;
  double volume = 1.0;
  double volumeOnUnMute = 1.0;
  bool isMuted = false;
  bool isPlaying = false;
  bool loop = true;

//  Clip({
//    this.recordingName = 'Untitled',
//    this.artistName = 'Unknown',
//    this.recordingPath, // directly to .m4a file, inside of clip directory with info.txt file
//    this.length = 0,
//    this.isLocal = true,
//  });

  Clip(
      {String recordingName = 'Untitled',
      String artistName,
      String recordingPath,
      int length = 0,
      bool isLocal = true}) {
    this.recordingName = recordingName;
    this.artistName = artistName;
    this.recordingPath = recordingPath;
    this.length = length;
    this.isLocal = isLocal;
    this.folderPath = recordingPath.substring(0, recordingPath.lastIndexOf('/'));
  }

  void setPlayerID(playerID) {
    this.audioPlayerID = playerID;
  }
}
