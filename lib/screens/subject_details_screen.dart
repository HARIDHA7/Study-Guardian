import 'package:flutter/material.dart';

import '../models/subject.dart';
import '../services/note_service.dart';

import 'upload_notes_screen.dart';
import 'study_session_screen.dart';
import 'progress_dashboard_screen.dart';
import 'my_notes_screen.dart';

class SubjectDetailsScreen extends StatefulWidget {
  final Subject subject;

  const SubjectDetailsScreen({
    super.key,
    required this.subject,
  });

  @override
  State<SubjectDetailsScreen> createState() =>
      _SubjectDetailsScreenState();
}

class _SubjectDetailsScreenState
    extends State<SubjectDetailsScreen> {
  @override
  Widget build(BuildContext context) {
    final notes = NoteService.getNotesBySubject(
      widget.subject.name,
    );

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.subject.name),
        backgroundColor: Colors.blue,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Card(
              elevation: 5,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              child: ListTile(
                leading: const CircleAvatar(
                  radius: 28,
                  backgroundColor: Colors.blue,
                  child: Icon(
                    Icons.book,
                    color: Colors.white,
                  ),
                ),
                title: Text(
                  widget.subject.name,
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                subtitle: Text(
                  "${notes.length} Notes Uploaded",
                ),
              ),
            ),

            const SizedBox(height: 25),

            const Text(
              "Uploaded Notes",
              style: TextStyle(
                fontSize: 21,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 10),

            notes.isEmpty
                ? Card(
                    child: ListTile(
                      leading: const Icon(
                        Icons.insert_drive_file,
                        color: Colors.blue,
                      ),
                      title: const Text(
                        "No Notes Uploaded",
                      ),
                      subtitle: const Text(
                        "Upload PDF / PPT / Image",
                      ),
                    ),
                  )
                : ListView.builder(
                    shrinkWrap: true,
                    physics:
                        const NeverScrollableScrollPhysics(),
                    itemCount: notes.length,
                    itemBuilder: (context, index) {
                      final note = notes[index];

                      return Card(
                        elevation: 4,
                        margin:
                            const EdgeInsets.only(bottom: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.circular(15),
                        ),
                        child: ListTile(
                          leading: const CircleAvatar(
                            backgroundColor: Colors.blue,
                            child: Icon(
                              Icons.insert_drive_file,
                              color: Colors.white,
                            ),
                          ),
                          title: Text(
                            note.unit,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          subtitle: Text(note.fileName),
                          trailing: ElevatedButton(
                            child: const Text("Study"),
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) =>
                                      StudySessionScreen(
                                    note: note,
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      );
                    },
                  ),

            const SizedBox(height: 30),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                icon: const Icon(Icons.upload_file),
                label: const Text("Upload Notes"),
                onPressed: () async {
                  await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => UploadNotesScreen(
                        subject: widget.subject.name,
                      ),
                    ),
                  );

                  setState(() {});
                },
              ),
            ),

            const SizedBox(height: 15),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                icon: const Icon(Icons.folder),
                label: const Text("My Notes"),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) =>
                          const MyNotesScreen(),
                    ),
                  );
                },
              ),
            ),

            const SizedBox(height: 15),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                icon: const Icon(Icons.bar_chart),
                label: const Text("Progress"),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) =>
                          const ProgressDashboardScreen(),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}