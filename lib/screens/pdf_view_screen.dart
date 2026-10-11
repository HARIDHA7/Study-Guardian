import 'pdf_view_screen.dart';

import 'package:flutter/material.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';

class PdfViewScreen extends StatelessWidget {
  final String filePath;
  final String title;

  const PdfViewScreen({
    super.key,
    required this.filePath,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        backgroundColor: Colors.blue,
        centerTitle: true,
      ),

      body: PDFView(
        filePath: filePath,
      ),

      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: Colors.green,
        icon: const Icon(Icons.play_arrow),
        label: const Text("Start Study"),
        onPressed: () {
          Navigator.pushNamed(
            context,
            "/study",
          );
        },
      ),
    );
  }
}