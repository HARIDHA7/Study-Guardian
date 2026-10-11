import 'package:flutter/material.dart';
import 'package:open_file/open_file.dart';

import '../models/note.dart';
import '../services/note_service.dart';
import 'study_session_screen.dart';

class MyNotesScreen extends StatefulWidget {
  const MyNotesScreen({super.key});

  @override
  State<MyNotesScreen> createState() => _MyNotesScreenState();
}

class _MyNotesScreenState extends State<MyNotesScreen> {
  List<Note> notes = [];

  @override
  void initState() {
    super.initState();
    loadNotes();
  }

  void loadNotes() {
    setState(() {
      notes = NoteService.getNotes();
    });
  }

  // Group by Subject -> Unit
  Map<String, Map<String, List<Note>>> groupNotes() {
    Map<String, Map<String, List<Note>>> grouped = {};

    for (var note in notes) {
      grouped.putIfAbsent(note.subject, () => {});
      grouped[note.subject]!.putIfAbsent(note.unit, () => []);
      grouped[note.subject]![note.unit]!.add(note);
    }

    return grouped;
  }

  void deleteNote(Note note) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Delete Note"),
          content: const Text(
              "Are you sure you want to delete this note?"),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text("Cancel"),
            ),
            TextButton(
              onPressed: () {
                NoteService.deleteNote(note);
                Navigator.pop(context);
                loadNotes();
              },
              child: const Text(
                "Delete",
                style: TextStyle(color: Colors.red),
              ),
            ),
          ],
        );
      },
    );
  }

  IconData getFileIcon(String fileName) {
    final name = fileName.toLowerCase();

    if (name.endsWith(".pdf")) {
      return Icons.picture_as_pdf;
    } else if (name.endsWith(".ppt") ||
        name.endsWith(".pptx")) {
      return Icons.slideshow;
    } else if (name.endsWith(".png") ||
        name.endsWith(".jpg") ||
        name.endsWith(".jpeg")) {
      return Icons.image;
    }

    return Icons.insert_drive_file;
  }

  @override
  Widget build(BuildContext context) {
    final groupedNotes = groupNotes();

    return Scaffold(
      appBar: AppBar(
        title: const Text("My Notes"),
        centerTitle: true,
        backgroundColor: Colors.blue,
      ),
      body: notes.isEmpty
          ? const Center(
              child: Text(
                "No Notes Uploaded Yet",
                style: TextStyle(fontSize: 18),
              ),
            )
          : ListView(
              padding: const EdgeInsets.all(12),
              children: groupedNotes.entries.map((subjectEntry) {
                return Card(
                  margin: const EdgeInsets.only(bottom: 12),
                  child: ExpansionTile(
                    leading: const Icon(
                      Icons.menu_book,
                      color: Colors.blue,
                    ),
                    title: Text(
                      subjectEntry.key,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    children: subjectEntry.value.entries.map((unitEntry) {
                      return ExpansionTile(
                        leading: const Icon(
                          Icons.folder,
                          color: Colors.orange,
                        ),
                        title: Text(
                          unitEntry.key,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        children: unitEntry.value.map((note) {
                          return Card(
                            margin: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 5,
                            ),
                            child: ListTile(
                              leading: Icon(
                                getFileIcon(note.fileName),
                                color: Colors.blue,
                              ),
                              title: Text(note.fileName),
                              subtitle: Text(note.unit),
                              trailing: PopupMenuButton<String>(
                                onSelected: (value) {
                                  if (value == "study") {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (_) =>
                                            StudySessionScreen(
                                          note: note,
                                        ),
                                      ),
                                    );
                                  } else if (value == "view") {
                                    OpenFile.open(note.filePath);
                                  } else if (value == "delete") {
                                    deleteNote(note);
                                  }
                                },
                                itemBuilder: (context) => [
                                  const PopupMenuItem(
                                    value: "study",
                                    child: Text("▶ Start Study"),
                                  ),
                                  const PopupMenuItem(
                                    value: "view",
                                    child: Text("📖 View File"),
                                  ),
                                  const PopupMenuItem(
                                    value: "delete",
                                    child: Text("🗑 Delete"),
                                  ),
                                ],
                              ),
                            ),
                          );
                        }).toList(),
                      );
                    }).toList(),
                  ),
                );
              }).toList(),
            ),
    );
  }
}
