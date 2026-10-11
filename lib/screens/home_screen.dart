import 'package:flutter/material.dart';

import '../services/subject_service.dart';

import 'add_subject_screen.dart';
import 'subject_details_screen.dart';
import 'progress_dashboard_screen.dart';
import 'my_notes_screen.dart';
import 'distraction_history_screen.dart';
import 'ai_summarizer_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Future<void> _openAddSubjectScreen() async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => const AddSubjectScreen(),
      ),
    );

    setState(() {});
  }

  String greeting() {
    final hour = DateTime.now().hour;

    if (hour < 12) {
      return "Good Morning 👋";
    } else if (hour < 17) {
      return "Good Afternoon ☀";
    } else {
      return "Good Evening 🌙";
    }
  }

  @override
  Widget build(BuildContext context) {
    final subjects = SubjectService.getSubjects();

    return Scaffold(
      backgroundColor: Colors.grey.shade100,

      appBar: AppBar(
        title: const Text(
          "Study Guardian",
        ),
        centerTitle: true,
        backgroundColor: Colors.blue,
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,

          children: [
            Text(
              greeting(),
              style: const TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 5),

            const Text(
              "Stay focused and achieve your study goals.",
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey,
              ),
            ),

            const SizedBox(height: 25),

            Row(
              children: [
                Expanded(
                  child: summaryCard(
                    Icons.timer,
                    "Daily Goal",
                    "3 Hours",
                  ),
                ),

                const SizedBox(width: 12),

                Expanded(
                  child: summaryCard(
                    Icons.book,
                    "Subjects",
                    "${subjects.length}",
                  ),
                ),
              ],
            ),

            const SizedBox(height: 25),

            const Card(
              elevation: 5,
              child: ListTile(
                leading: Icon(
                  Icons.emoji_events,
                  color: Colors.orange,
                  size: 40,
                ),

                title: Text(
                  "Today's Challenge",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),

                subtitle: Text(
                  "Study continuously for 30 minutes without leaving the app.",
                ),
              ),
            ),

            const SizedBox(height: 25),

            const Text(
              "Quick Actions",
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 15),

            // ADD SUBJECT
            buttonWidget(
              Icons.add,
              "Add Subject",
              _openAddSubjectScreen,
            ),

            // START STUDY
            buttonWidget(
              Icons.play_circle,
              "Start Study",
              () {
                if (subjects.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text(
                        "Please add a subject first",
                      ),
                    ),
                  );

                  return;
                }

                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => SubjectDetailsScreen(
                      subject: subjects.first,
                    ),
                  ),
                );
              },
            ),

            // AI SUMMARIZER
            Card(
              elevation: 5,
              margin: const EdgeInsets.only(bottom: 12),

              child: ListTile(
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),

                leading: const CircleAvatar(
                  backgroundColor: Colors.blueAccent,

                  child: Icon(
                    Icons.summarize,
                    color: Colors.white,
                  ),
                ),

                title: const Text(
                  "AI Summarizer",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),

                subtitle: const Text(
                  "Summarize PDF, PPT, or Photos",
                ),

                trailing: const Icon(
                  Icons.arrow_forward_ios,
                  size: 18,
                ),

                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const AISummarizerScreen(),
                    ),
                  );
                },
              ),
            ),

            // PROGRESS DASHBOARD
            buttonWidget(
              Icons.bar_chart,
              "Progress Dashboard",
              () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) =>
                        const ProgressDashboardScreen(),
                  ),
                );
              },
            ),

            // MY NOTES
            buttonWidget(
              Icons.folder,
              "My Notes",
              () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const MyNotesScreen(),
                  ),
                );
              },
            ),

            // DISTRACTION HISTORY
            buttonWidget(
              Icons.warning,
              "Distraction History",
              () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) =>
                        const DistractionHistoryScreen(),
                  ),
                );
              },
            ),

            const SizedBox(height: 25),

            const Text(
              "Your Subjects",
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 10),

            subjects.isEmpty
                ? const Center(
                    child: Padding(
                      padding: EdgeInsets.all(30),
                      child: Text(
                        "No subjects added yet.",
                        style: TextStyle(
                          fontSize: 18,
                        ),
                      ),
                    ),
                  )
                : ListView.builder(
                    shrinkWrap: true,
                    physics:
                        const NeverScrollableScrollPhysics(),

                    itemCount: subjects.length,

                    itemBuilder: (context, index) {
                      final subject = subjects[index];

                      return Card(
                        elevation: 4,

                        margin: const EdgeInsets.only(
                          bottom: 12,
                        ),

                        child: ListTile(
                          leading: const CircleAvatar(
                            backgroundColor: Colors.blue,

                            child: Icon(
                              Icons.book,
                              color: Colors.white,
                            ),
                          ),

                          title: Text(
                            subject.name,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),

                          subtitle: const Text(
                            "Tap to view notes and start studying",
                          ),

                          trailing: const Icon(
                            Icons.arrow_forward_ios,
                          ),

                          onTap: () async {
                            await Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) =>
                                    SubjectDetailsScreen(
                                  subject: subject,
                                ),
                              ),
                            );

                            setState(() {});
                          },
                        ),
                      );
                    },
                  ),
          ],
        ),
      ),
    );
  }

  Widget summaryCard(
    IconData icon,
    String title,
    String value,
  ) {
    return Card(
      elevation: 5,

      child: Padding(
        padding: const EdgeInsets.all(15),

        child: Column(
          children: [
            Icon(
              icon,
              size: 35,
              color: Colors.blue,
            ),

            const SizedBox(height: 10),

            Text(
              title,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 5),

            Text(
              value,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buttonWidget(
    IconData icon,
    String title,
    VoidCallback onPressed,
  ) {
    return Padding(
      padding: const EdgeInsets.only(
        bottom: 12,
      ),

      child: SizedBox(
        width: double.infinity,
        height: 55,

        child: ElevatedButton.icon(
          onPressed: onPressed,

          icon: Icon(icon),

          label: Text(
            title,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),

          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.blue,
            foregroundColor: Colors.white,

            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        ),
      ),
    );
  }
}
        