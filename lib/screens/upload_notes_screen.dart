import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';

import '../models/note.dart';
import '../services/note_service.dart';
import '../services/distraction_service.dart';

class UploadNotesScreen extends StatefulWidget {
  final String subject;

  const UploadNotesScreen({
    super.key,
    required this.subject,
  });

  @override
  State<UploadNotesScreen> createState() =>
      _UploadNotesScreenState();
}

class _UploadNotesScreenState extends State<UploadNotesScreen> {
  final TextEditingController unitController =
      TextEditingController();

  String fileName = "No File Selected";
  String filePath = "";

  // ============================================================
  // PICK FILE
  // ============================================================

  Future<void> pickFile() async {
    // ----------------------------------------------------------
    // IMPORTANT:
    // Suspend distraction monitoring BEFORE opening Android
    // File Picker so the picker is NOT treated as leaving the app.
    // ----------------------------------------------------------

    await DistractionService.suspendMonitoring();

    FilePickerResult? result;

    try {
      result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: [
          'pdf',
          'ppt',
          'pptx',
          'png',
          'jpg',
          'jpeg',
        ],
      );
    } catch (e) {
      print("FILE PICKER ERROR: $e");
    } finally {
      // --------------------------------------------------------
      // Resume monitoring after File Picker is completely closed.
      // --------------------------------------------------------

      DistractionService.resumeMonitoring();
    }

    // ----------------------------------------------------------
    // User cancelled the picker.
    // ----------------------------------------------------------

    if (result == null) {
      return;
    }

    // ----------------------------------------------------------
    // File selected successfully.
    // ----------------------------------------------------------

    setState(() {
      fileName = result!.files.single.name;
      filePath = result.files.single.path ?? "";
    });

    if (!mounted) {
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text("✅ $fileName Selected"),
      ),
    );
  }

  // ============================================================
  // SAVE NOTES
  // ============================================================

  void saveNotes() {
    if (unitController.text.trim().isEmpty) {
      showMessage("Enter Unit Name");
      return;
    }

    if (filePath.isEmpty) {
      showMessage("Select File First");
      return;
    }

    final Note note = Note(
      subject: widget.subject,
      unit: unitController.text.trim(),
      fileName: fileName,
      filePath: filePath,
    );

    NoteService.addNote(note);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("🎉 Notes Uploaded Successfully"),
      ),
    );

    Navigator.pop(context);
  }

  // ============================================================
  // SHOW MESSAGE
  // ============================================================

  void showMessage(String text) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(text),
      ),
    );
  }

  // ============================================================
  // FILE ICON
  // ============================================================

  IconData getFileIcon() {
    if (fileName.endsWith(".pdf")) {
      return Icons.picture_as_pdf;
    } else if (fileName.endsWith(".png") ||
        fileName.endsWith(".jpg") ||
        fileName.endsWith(".jpeg")) {
      return Icons.image;
    } else {
      return Icons.insert_drive_file;
    }
  }

  // ============================================================
  // DISPOSE
  // ============================================================

  @override
  void dispose() {
    unitController.dispose();
    super.dispose();
  }

  // ============================================================
  // BUILD
  // ============================================================

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Upload Notes"),
        centerTitle: true,
        backgroundColor: Colors.blue,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Icon(
              getFileIcon(),
              size: 90,
              color: Colors.blue,
            ),

            const SizedBox(height: 20),

            Text(
              widget.subject,
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 25),

            TextField(
              controller: unitController,
              decoration: InputDecoration(
                labelText: "Unit Name",
                hintText: "Example: Unit 3",
                prefixIcon: const Icon(
                  Icons.menu_book,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),

            const SizedBox(height: 20),

            Card(
              child: ListTile(
                leading: Icon(
                  getFileIcon(),
                  color: Colors.blue,
                ),
                title: const Text(
                  "Selected File",
                ),
                subtitle: Text(
                  fileName,
                ),
              ),
            ),

            const SizedBox(height: 20),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: pickFile,
                icon: const Icon(
                  Icons.upload_file,
                ),
                label: const Text(
                  "Choose File",
                ),
              ),
            ),

            const SizedBox(height: 15),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: saveNotes,
                icon: const Icon(
                  Icons.save,
                ),
                label: const Text(
                  "Save Notes",
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  foregroundColor: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}