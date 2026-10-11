import 'topic.dart';
import 'note.dart';

class Subject {
  String name;

  List<Topic> topics;

  List<Note> notes;

  Subject({
    required this.name,
    List<Topic>? topics,
    List<Note>? notes,
  })  : topics = topics ?? [],
        notes = notes ?? [];
}