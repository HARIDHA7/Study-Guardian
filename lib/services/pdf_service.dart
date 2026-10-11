import 'dart:io';
import 'package:syncfusion_flutter_pdf/pdf.dart';

class PDFService {

  static Future<String> extractText(String path) async {

    final File file = File(path);

    final List<int> bytes = await file.readAsBytes();

    final PdfDocument document =
        PdfDocument(inputBytes: bytes);


    String text =
        PdfTextExtractor(document).extractText();


    document.dispose();


    return text;
  }
}