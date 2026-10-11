import 'package:flutter/material.dart';
import '../models/topic.dart';
import 'study_timer_screen.dart';

class TopicDetailsScreen extends StatelessWidget {

  final Topic topic;

  const TopicDetailsScreen({
    super.key,
    required this.topic,
  });


  @override
  Widget build(BuildContext context) {

    return Scaffold(

      appBar: AppBar(
        title: const Text("Topic Details"),
        backgroundColor: Colors.blue,
      ),


      body: Padding(

        padding: const EdgeInsets.all(20),

        child: Column(

          crossAxisAlignment: CrossAxisAlignment.start,

          children: [


            Text(

              topic.name,

              style: const TextStyle(

                fontSize: 28,

                fontWeight: FontWeight.bold,

              ),

            ),



            const SizedBox(height: 20),



            Text(

              "Duration : ${topic.studyDuration} Minutes",

              style: const TextStyle(

                fontSize: 18,

              ),

            ),



            const SizedBox(height: 10),



            Text(

              "Status : ${topic.status}",

              style: const TextStyle(

                fontSize: 18,

              ),

            ),



            const SizedBox(height: 40),




            SizedBox(

              width: double.infinity,


              child: ElevatedButton.icon(


                icon: const Icon(Icons.play_arrow),



                label: const Text(

                  "Start Study",

                ),



                onPressed: () {


                  Navigator.push(

                    context,

                    MaterialPageRoute(

                      builder: (context) => StudyTimerScreen(

                        topic: topic,

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