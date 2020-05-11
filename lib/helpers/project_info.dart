import 'package:looper/helpers/rec_info.dart';

class ProjectFile {
  String name = 'Untitled Project';
  String projectPath;
  List<Clip> clips = [];

  ProjectFile({
    this.name,
    this.projectPath,
    this.clips,
  });

  add(Clip newClip) {
    clips.add(newClip);
  }

  @override
  String toString() {
    return this.name;
  }
}
