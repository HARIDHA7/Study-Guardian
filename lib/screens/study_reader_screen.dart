import 'dart:io';

import 'package:flutter/material.dart';
import 'package:open_file/open_file.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

import '../models/note.dart';

class StudyReaderScreen extends StatefulWidget {
  final Note note;

  const StudyReaderScreen({
    super.key,
    required this.note,
  });

  @override
  State<StudyReaderScreen> createState() =>
      _StudyReaderScreenState();
}

class _StudyReaderScreenState extends State<StudyReaderScreen> {
  // ============================================================
  // FILE TYPE
  // ============================================================

  bool get isPdf {
    return widget.note.fileName
        .toLowerCase()
        .endsWith('.pdf');
  }

  bool get isImage {
    final String name =
        widget.note.fileName.toLowerCase();

    return name.endsWith('.png') ||
        name.endsWith('.jpg') ||
        name.endsWith('.jpeg');
  }

  // ============================================================
  // BUILD
  // ============================================================

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: true,
      onPopInvokedWithResult: (
        bool didPop,
        dynamic result,
      ) {
        if (!didPop) {
          return;
        }

        print('========================================');
        print('STUDY READER CLOSED');
        print('RETURNING TO STUDY TIMER');
        print('STUDY SESSION CONTINUES');
        print('========================================');
      },
      child: _buildReader(),
    );
  }

  // ============================================================
  // READER UI
  // ============================================================

  Widget _buildReader() {
    // ----------------------------------------------------------
    // PDF
    // ----------------------------------------------------------

    if (isPdf) {
      return Scaffold(
        appBar: AppBar(
          title: Text(
            widget.note.unit,
          ),
          backgroundColor: Colors.blue,
          foregroundColor: Colors.white,
        ),
        body: SfPdfViewer.file(
          File(
            widget.note.filePath,
          ),
        ),
      );
    }

    // ----------------------------------------------------------
    // IMAGE
    // ----------------------------------------------------------

    if (isImage) {
      return Scaffold(
        appBar: AppBar(
          title: Text(
            widget.note.unit,
          ),
          backgroundColor: Colors.blue,
          foregroundColor: Colors.white,
        ),
        body: InteractiveViewer(
          child: Center(
            child: Image.file(
              File(
                widget.note.filePath,
              ),
            ),
          ),
        ),
      );
    }

    // ----------------------------------------------------------
    // OTHER FILES
    // ----------------------------------------------------------

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Study Reader',
        ),
      ),
      body: Center(
        child: ElevatedButton.icon(
          icon: const Icon(
            Icons.open_in_new,
          ),
          label: const Text(
            'Open File',
          ),
          onPressed: () async {
            await OpenFile.open(
              widget.note.filePath,
            );
          },
        ),
      ),
    );
  }
}