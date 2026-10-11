import 'package:flutter/material.dart';
import '../services/progress_service.dart';

class ProgressScreen extends StatelessWidget {
  const ProgressScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final progress = ProgressService.getProgress();

    return Scaffold(
      appBar: AppBar(
        title: const Text("Progress Dashboard"),
        backgroundColor: Colors.blue,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [

            Card(
              child: ListTile(
                leading: const Icon(Icons.timer),
                title: const Text("Study Hours"),
                trailing: Text("${progress.studyHours} hrs"),
              ),
            ),

            Card(
              child: ListTile(
                leading: const Icon(Icons.check_circle),
                title: const Text("Completed Topics"),
                trailing: Text("${progress.completedTopics}"),
              ),
            ),

            Card(
              child: ListTile(
                leading: const Icon(Icons.star),
                title: const Text("Focus Score"),
                trailing: Text("${progress.focusScore}%"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}