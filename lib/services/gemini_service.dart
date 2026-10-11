import 'dart:convert';
import 'dart:io';

import 'package:archive/archive.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:xml/xml.dart';
import '../config/api_keys.dart';

class GeminiService {
  // ============================================================
  // GEMINI API KEY
  // ============================================================

     static const String apiKey = String.fromEnvironment('GEMINI_API_KEY');

  // ============================================================
  // GEMINI MODEL
  // ============================================================

  late final GenerativeModel _model;

  GeminiService() {
    _model = GenerativeModel(
      model: 'gemini-3.6-flash',
      apiKey: apiKey,
    );
  }

  // ============================================================
  // TEXT / PDF SUMMARIZATION
  // ============================================================

  Future<String> summarizeText(String text) async {
    if (text.trim().isEmpty) {
      return 'No readable text was found in the uploaded file.';
    }

    final prompt = '''
You are an AI study assistant for college students.

Analyze ONLY the study material provided below.

Create a clear study-friendly summary containing:

1. Short Summary
2. Important Key Points
3. Important Definitions
4. Important Concepts
5. Exam Preparation Questions

Rules:
- Use only information present in the study material.
- Do not invent facts.
- Keep the explanation simple and easy to study.
- Preserve important technical terms.
- Organize the output clearly.

STUDY MATERIAL:

$text
''';

    try {
      final response = await _model.generateContent([
        Content.text(prompt),
      ]);

      return response.text?.trim() ??
          'Unable to generate summary.';
    } catch (e) {
      return 'Failed to generate AI summary: $e';
    }
  }

  // ============================================================
  // IMAGE SUMMARIZATION
  // ============================================================

  Future<String> summarizeImage(File imageFile) async {
    try {
      final imageBytes = await imageFile.readAsBytes();

      final extension =
          imageFile.path.toLowerCase().split('.').last;

      String mimeType;

      switch (extension) {
        case 'png':
          mimeType = 'image/png';
          break;

        case 'webp':
          mimeType = 'image/webp';
          break;

        case 'jpg':
        case 'jpeg':
        default:
          mimeType = 'image/jpeg';
          break;
      }

      final prompt = '''
You are an AI study assistant.

Analyze the uploaded study material image.

Create:

1. Short Summary
2. Important Key Points
3. Important Definitions
4. Important Concepts
5. Exam Preparation Questions

Rules:
- Use ONLY information visible in the image.
- Do not invent information.
- Do not guess unreadable text.
- Preserve technical terms.
- Make the result easy to study.
''';

      final response = await _model.generateContent([
        Content.multi([
          TextPart(prompt),
          DataPart(
            mimeType,
            imageBytes,
          ),
        ]),
      ]);

      return response.text?.trim() ??
          'Unable to generate image summary.';
    } catch (e) {
      return 'Failed to analyze image: $e';
    }
  }

  // ============================================================
  // POWERPOINT PPTX SUMMARIZATION
  // ============================================================

  Future<String> summarizePpt(File pptFile) async {
    try {
      final extension =
          pptFile.path.toLowerCase().split('.').last;

      if (extension != 'pptx') {
        return 'Please select a PPTX PowerPoint file.';
      }

      // Extract text from all slides.
      final String presentationText =
          await _extractPptxText(pptFile);

      if (presentationText.trim().isEmpty) {
        return '''
No readable text was found in this PowerPoint.

Please make sure the PPTX contains readable/selectable text.
''';
      }

      final prompt = '''
You are an AI study assistant for college students.

Analyze ONLY the PowerPoint presentation content provided below.

The content contains multiple slides.

Create a clear study-friendly summary containing:

1. Short Summary
2. Important Key Points
3. Important Definitions
4. Important Concepts
5. Exam Preparation Questions

Rules:
- Use ONLY information present in the PowerPoint.
- Do not invent facts.
- Do not add outside information.
- Consider ALL slides.
- Preserve important technical terms.
- Keep the explanation simple and easy to study.
- Organize the output clearly.
- If formulas are present, preserve them accurately.
- If examples are present, include important examples.
- Make the final result useful for exam preparation.

POWERPOINT PRESENTATION:

$presentationText
''';

      final response = await _model.generateContent([
        Content.text(prompt),
      ]);

      return response.text?.trim() ??
          'Unable to generate PowerPoint summary.';
    } catch (e) {
      return 'Failed to generate AI summary from PowerPoint: $e';
    }
  }

  // ============================================================
  // EXTRACT TEXT FROM PPTX
  // ============================================================

  Future<String> _extractPptxText(File pptFile) async {
    final bytes = await pptFile.readAsBytes();

    final Archive archive =
        ZipDecoder().decodeBytes(bytes);

    final List<ArchiveFile> slideFiles = archive.files
        .where(
          (file) =>
              file.name.startsWith('ppt/slides/slide') &&
              file.name.endsWith('.xml'),
        )
        .toList();

    // Sort slides in correct numerical order.
    slideFiles.sort(
      (a, b) {
        final int slideA =
            _getSlideNumber(a.name);

        final int slideB =
            _getSlideNumber(b.name);

        return slideA.compareTo(slideB);
      },
    );

    final StringBuffer result =
        StringBuffer();

    for (final slideFile in slideFiles) {
      try {
        final dynamic content =
            slideFile.content;

        final List<int> contentBytes =
            content is List<int>
                ? content
                : List<int>.from(content);

        final String xmlText =
            utf8.decode(
          contentBytes,
          allowMalformed: true,
        );

        final XmlDocument document =
            XmlDocument.parse(xmlText);

        final List<String> textParts = document
            .findAllElements('t')
            .map(
              (node) => node.innerText.trim(),
            )
            .where(
              (text) => text.isNotEmpty,
            )
            .toList();

        if (textParts.isEmpty) {
          continue;
        }

        final int slideNumber =
            _getSlideNumber(slideFile.name);

        result.writeln(
          '========================================',
        );

        result.writeln(
          'SLIDE $slideNumber',
        );

        result.writeln(
          '========================================',
        );

        for (final text in textParts) {
          result.writeln(text);
        }

        result.writeln();
      } catch (_) {
        // If one slide cannot be read,
        // continue with the remaining slides.
        continue;
      }
    }

    return result.toString();
  }

  // ============================================================
  // GET SLIDE NUMBER
  // ============================================================

  int _getSlideNumber(String fileName) {
    final RegExpMatch? match =
        RegExp(
          r'slide(\d+)\.xml$',
        ).firstMatch(fileName);

    if (match == null) {
      return 0;
    }

    return int.tryParse(
          match.group(1) ?? '0',
        ) ??
        0;
  }
}