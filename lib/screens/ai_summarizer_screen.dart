import 'dart:io';
import 'dart:typed_data';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:syncfusion_flutter_pdf/pdf.dart';

import '../services/gemini_service.dart';
import 'summary_screen.dart';

class AISummarizerScreen extends StatefulWidget {
  const AISummarizerScreen({
    super.key,
  });

  @override
  State<AISummarizerScreen> createState() =>
      _AISummarizerScreenState();
}

class _AISummarizerScreenState
    extends State<AISummarizerScreen> {
  bool _isLoading = false;

  bool _isLeavingScreen = false;

  final GeminiService _gemini = GeminiService();

  // ============================================================
  // HANDLE BACK
  //
  // IMPORTANT:
  //
  // Leaving the AI Summarizer selection/upload screen is NOT
  // considered a distraction.
  //
  // Distraction monitoring starts only inside SummaryScreen,
  // when the generated summary is actually being studied.
  // ============================================================

  Future<void> _leaveSummarizer() async {
    if (_isLeavingScreen) {
      return;
    }

    _isLeavingScreen = true;

    print('========================================');
    print('AI SUMMARIZER EXIT');
    print('USER PRESSED BACK');
    print('NO DISTRACTION NOTIFICATION');
    print('========================================');

    if (mounted) {
      Navigator.of(context).pop();
    }
  }

  // ============================================================
  // FILE UPLOAD HANDLER
  // ============================================================

  Future<void> _handleFileUpload(
    String type,
  ) async {
    if (_isLoading) {
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      String summary = '';

      // ========================================================
      // IMAGE
      // ========================================================

      if (type == 'image') {
        XFile? photo;

        try {
          photo = await ImagePicker().pickImage(
            source: ImageSource.gallery,
          );
        } catch (e) {
          rethrow;
        }

        if (photo == null) {
          return;
        }

        summary = await _gemini.summarizeImage(
          File(photo.path),
        );
      }

      // ========================================================
      // PDF
      // ========================================================

      else if (type == 'pdf') {
        FilePickerResult? result;

        try {
          result = await FilePicker.platform.pickFiles(
            type: FileType.custom,
            allowedExtensions: ['pdf'],
          );
        } catch (e) {
          rethrow;
        }

        if (result == null) {
          return;
        }

        final String? filePath =
            result.files.single.path;

        if (filePath == null) {
          throw Exception(
            'Unable to access the selected PDF.',
          );
        }

        final File pdfFile = File(filePath);

        final Uint8List bytes =
            await pdfFile.readAsBytes();

        final PdfDocument document =
            PdfDocument(
          inputBytes: bytes,
        );

        try {
          final PdfTextExtractor extractor =
              PdfTextExtractor(document);

          final String extractedText =
              extractor.extractText();

          if (extractedText.trim().isEmpty) {
            throw Exception(
              'No readable text was found in this PDF. '
              'For scanned PDFs, upload the pages as photos.',
            );
          }

          summary = await _gemini.summarizeText(
            extractedText,
          );
        } finally {
          document.dispose();
        }
      }

      // ========================================================
      // POWERPOINT
      // ========================================================

      else if (type == 'pptx') {
        FilePickerResult? result;

        try {
          result = await FilePicker.platform.pickFiles(
            type: FileType.custom,
            allowedExtensions: ['pptx'],
          );
        } catch (e) {
          rethrow;
        }

        if (result == null) {
          return;
        }

        final String? filePath =
            result.files.single.path;

        if (filePath == null) {
          throw Exception(
            'Unable to access the selected PowerPoint file.',
          );
        }

        final File pptFile = File(filePath);

        summary = await _gemini.summarizePpt(
          pptFile,
        );
      }

      // ========================================================
      // SHOW SUMMARY
      // ========================================================

      if (!mounted) {
        return;
      }

      if (summary.trim().isNotEmpty) {
        print('========================================');
        print('AI SUMMARY GENERATED');
        print('OPENING SUMMARY SCREEN');
        print('DISTRACTION MONITORING WILL START');
        print('WHEN USER IS READING SUMMARY');
        print('========================================');

        await Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => SummaryScreen(
              summary: summary,
            ),
          ),
        );

        if (!mounted) {
          return;
        }

        print('========================================');
        print('RETURNED FROM SUMMARY SCREEN');
        print('========================================');
      }
    } catch (e) {
      if (!mounted) {
        return;
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Error: $e',
          ),
          duration: const Duration(
            seconds: 5,
          ),
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  // ============================================================
  // BUILD
  // ============================================================

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,

      onPopInvokedWithResult: (
        bool didPop,
        dynamic result,
      ) async {
        if (didPop) {
          return;
        }

        await _leaveSummarizer();
      },

      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            'AI Summarizer',
          ),
          centerTitle: true,
          backgroundColor: Colors.blue,
          foregroundColor: Colors.white,
        ),

        body: _isLoading
            ? const Center(
                child: Column(
                  mainAxisAlignment:
                      MainAxisAlignment.center,
                  children: [
                    CircularProgressIndicator(),

                    SizedBox(height: 20),

                    Text(
                      'Analyzing study material...',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight:
                            FontWeight.w500,
                      ),
                    ),

                    SizedBox(height: 8),

                    Text(
                      'Please wait',
                      style: TextStyle(
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
              )
            : SingleChildScrollView(
                padding:
                    const EdgeInsets.all(20),

                child: Column(
                  children: [
                    const SizedBox(height: 10),

                    const Icon(
                      Icons.auto_awesome,
                      size: 70,
                      color: Colors.blue,
                    ),

                    const SizedBox(height: 15),

                    const Text(
                      'AI Study Summarizer',
                      style: TextStyle(
                        fontSize: 25,
                        fontWeight:
                            FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 8),

                    const Text(
                      'Upload your study material '
                      'and let AI create an '
                      'easy-to-study summary.',
                      textAlign:
                          TextAlign.center,
                      style: TextStyle(
                        fontSize: 15,
                        color: Colors.grey,
                      ),
                    ),

                    const SizedBox(height: 30),

                    _uploadCard(
                      title: 'Upload PDF',
                      subtitle:
                          'Extract text and generate summary',
                      icon: Icons.picture_as_pdf,
                      color: Colors.red,
                      onTap: () =>
                          _handleFileUpload(
                        'pdf',
                      ),
                    ),

                    _uploadCard(
                      title: 'Upload PPT',
                      subtitle:
                          'Analyze PowerPoint study material',
                      icon: Icons.slideshow,
                      color: Colors.orange,
                      onTap: () =>
                          _handleFileUpload(
                        'pptx',
                      ),
                    ),

                    _uploadCard(
                      title: 'Upload Photo',
                      subtitle:
                          'Analyze handwritten or printed notes',
                      icon: Icons.image,
                      color: Colors.green,
                      onTap: () =>
                          _handleFileUpload(
                        'image',
                      ),
                    ),

                    const SizedBox(height: 20),

                    Container(
                      padding:
                          const EdgeInsets.all(15),

                      decoration:
                          BoxDecoration(
                        color:
                            Colors.blue.shade50,
                        borderRadius:
                            BorderRadius.circular(
                          12,
                        ),
                      ),

                      child: const Row(
                        crossAxisAlignment:
                            CrossAxisAlignment.start,

                        children: [
                          Icon(
                            Icons.info_outline,
                            color: Colors.blue,
                          ),

                          SizedBox(width: 10),

                          Expanded(
                            child: Text(
                              'The AI creates summaries, '
                              'key points, definitions, '
                              'important concepts and '
                              'exam preparation questions.',
                              style: TextStyle(
                                fontSize: 14,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
      ),
    );
  }

  // ============================================================
  // UPLOAD CARD
  // ============================================================

  Widget _uploadCard({
    required String title,
    required String subtitle,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Card(
      elevation: 5,

      margin:
          const EdgeInsets.only(
        bottom: 15,
      ),

      shape:
          RoundedRectangleBorder(
        borderRadius:
            BorderRadius.circular(14),
      ),

      child: ListTile(
        contentPadding:
            const EdgeInsets.symmetric(
          horizontal: 18,
          vertical: 10,
        ),

        leading: CircleAvatar(
          radius: 25,

          backgroundColor:
              color.withValues(
            alpha: 0.15,
          ),

          child: Icon(
            icon,
            color: color,
            size: 28,
          ),
        ),

        title: Text(
          title,
          style: const TextStyle(
            fontWeight:
                FontWeight.bold,
            fontSize: 17,
          ),
        ),

        subtitle: Text(
          subtitle,
        ),

        trailing: const Icon(
          Icons.arrow_forward_ios,
          size: 18,
        ),

        onTap: onTap,
      ),
    );
  }
}