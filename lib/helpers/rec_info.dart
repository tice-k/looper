class Clip {
  String recordingName;
  String artistName;
  String filePath; // path name
  String audioPlayerID;
  int length; // in milliseconds
  bool isLocal;
  double volume = 1.0;
  double volumeOnUnMute = 1.0;
  bool isMuted = false;
  bool isPlaying = false;
  bool loop = true;

  Clip({
    this.recordingName = 'Untitled',
    this.artistName = 'Unknown',
    this.filePath, // directly to .m4a file, inside of clip directory with info.txt file
    this.length = 0,
    this.isLocal = true,
  });

  void setPlayerID(playerID) {
    this.audioPlayerID = playerID;
  }
}
