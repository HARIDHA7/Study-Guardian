class Topic {
  String name;
  int studyDuration;
  String status;
  String reflection;
  bool revisionNoteUploaded;

  Topic({
    required this.name,
    required this.studyDuration,
    this.status = "Pending",
    this.reflection = "",
    this.revisionNoteUploaded = false,
  });
}