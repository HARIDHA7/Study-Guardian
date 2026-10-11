import '../models/note.dart';

class NoteService {
  static final List<Note> _notes = [];

  /// Add a note
  static void addNote(Note note) {
    _notes.add(note);
  }

  /// Get all notes
  static List<Note> getNotes() {
    return List<Note>.from(_notes);
  }

  /// Get notes for a specific subject
  static List<Note> getNotesBySubject(String subject) {
    return _notes
        .where((note) => note.subject == subject)
        .toList();
  }

  /// Delete a note
  static void deleteNote(Note note) {
    _notes.remove(note);
  }

  /// Remove all notes
  static void clearNotes() {
    _notes.clear();
  }
}