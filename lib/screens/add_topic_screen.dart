import 'package:flutter/material.dart';
import '../services/topic_service.dart';
import 'topic_details_screen.dart';

class AddTopicScreen extends StatefulWidget {
  final dynamic subject;

  const AddTopicScreen({
    super.key,
    required this.subject,
  });

  @override
  State<AddTopicScreen> createState() => _AddTopicScreenState();
}

class _AddTopicScreenState extends State<AddTopicScreen> {
  final TextEditingController topicController = TextEditingController();
  final TextEditingController durationController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    int completed =
        TopicService.completedCount(widget.subject.name);

    int total =
        TopicService.getTopics(widget.subject.name).length;

    return Scaffold(
      appBar: AppBar(
        title: Text("${widget.subject.name} Topics"),
        backgroundColor: Colors.blue,
      ),

      body: Padding(
        padding: const EdgeInsets.all(20),

        child: Column(
          children: [

            TextField(
              controller: topicController,
              decoration: const InputDecoration(
                labelText: "Topic Name",
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 15),

            TextField(
              controller: durationController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: "Study Duration (Minutes)",
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 15),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {

                  if (topicController.text.trim().isEmpty ||
                      durationController.text.trim().isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text(
                          "Enter Topic Name and Duration",
                        ),
                      ),
                    );
                    return;
                  }

                  TopicService.addTopic(
                    widget.subject.name,
                    topicController.text.trim(),
                    int.parse(durationController.text.trim()),
                  );

                  topicController.clear();
                  durationController.clear();

                  setState(() {});
                },

                child: const Text("Add Topic"),
              ),
            ),

            const SizedBox(height: 20),

            Card(
              child: ListTile(
                leading: const Icon(Icons.analytics),
                title: const Text("Progress"),
                subtitle: Text(
                  "$completed / $total Topics Completed",
                ),
              ),
            ),

            const SizedBox(height: 15),

            Expanded(
              child: ListView.builder(
                itemCount:
                    TopicService.getTopics(widget.subject.name).length,

                itemBuilder: (context, index) {

                  final topic =
                      TopicService.getTopics(widget.subject.name)[index];

                  return Card(
                    child: ListTile(
                      title: Text(topic.name),

                      subtitle: Text(
                        "Duration : ${topic.studyDuration} Minutes\n"
                        "Status : ${topic.status}",
                      ),

                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                TopicDetailsScreen(
                              topic: topic,
                            ),
                          ),
                        ).then((value) {
                          setState(() {});
                        });
                      },

                      trailing: IconButton(
                        icon: const Icon(
                          Icons.delete,
                          color: Colors.red,
                        ),
                        onPressed: () {

                          setState(() {

                            TopicService.deleteTopic(
                              widget.subject.name,
                              index,
                            );

                          });

                        },
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}