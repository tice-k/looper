class Clip {
  String recordingName;
  String artistName;
  String fileName; // path name
  String audioPlayerID;
  int length; // in milliseconds
  bool isLocal;

  Clip(
      {this.recordingName = 'Untitled',
      this.artistName = 'Unknown',
      this.fileName,
      this.length = 0,
      this.isLocal = false});

  void setPlayerID(playerID) {
    this.audioPlayerID = playerID;
  }
}
