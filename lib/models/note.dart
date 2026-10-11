class Note {
  final String subject;
  final String unit;
  final String fileName;
  final String filePath;

  Note({
    required this.subject,
    required this.unit,
    required this.fileName,
    required this.filePath,
  });

  @override
  String toString() {
    return 'Note('
        'subject: $subject, '
        'unit: $unit, '
        'fileName: $fileName, '
        'filePath: $filePath'
        ')';
  }
}