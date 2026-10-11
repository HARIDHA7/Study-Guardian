import '../models/subject.dart';

class SubjectService {
  static final List<Subject> _subjects = [];

  static void addSubject(String name) {
    if (name.trim().isEmpty) return;

    bool exists = _subjects.any(
      (subject) =>
          subject.name.toLowerCase() ==
          name.trim().toLowerCase(),
    );

    if (!exists) {
      _subjects.add(
        Subject(
          name: name.trim(),
        ),
      );
    }
  }

  static List<Subject> getSubjects() {
    return _subjects;
  }

  static int getSubjectCount() {
    return _subjects.length;
  }

  static void deleteSubject(int index) {
    _subjects.removeAt(index);
  }

  static Subject getSubject(int index) {
    return _subjects[index];
  }

  static void clearSubjects() {
    _subjects.clear();
  }
}