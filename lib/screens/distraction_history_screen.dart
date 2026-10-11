import 'package:flutter/material.dart';

import '../services/distraction_history_service.dart';


class DistractionHistoryScreen extends StatelessWidget {


  const DistractionHistoryScreen({
    super.key,
  });



  String formatDuration(int seconds){

    int minutes = seconds ~/ 60;

    int remainingSeconds = seconds % 60;


    if(minutes > 0){

      return "$minutes min $remainingSeconds sec";

    }


    return "$seconds sec";

  }





  @override
  Widget build(BuildContext context) {


    final history =
        DistractionHistoryService.history;



    final totalSeconds =
        DistractionHistoryService.getTotalSeconds();




    return Scaffold(


      appBar: AppBar(

        title:
        const Text(
          "Distraction History",
        ),

        backgroundColor:
        Colors.red,

      ),






      body:


      history.isEmpty


          ?

      const Center(

        child:

        Text(

          "No distractions recorded 🎯",

          style:
          TextStyle(

            fontSize:18,

          ),

        ),

      )



          :


      Column(

        children: [



          Padding(

            padding:
            const EdgeInsets.all(20),


            child:

            Text(

              "Total Distraction Time: ${formatDuration(totalSeconds)}",

              style:

              const TextStyle(

                fontSize:20,

                fontWeight:
                FontWeight.bold,

              ),

            ),

          ),





          Expanded(

            child:

            ListView.builder(


              itemCount:
              history.length,


              itemBuilder:
                  (context,index){


                final item =
                history[index];



                return Card(


                  margin:
                  const EdgeInsets.all(10),


                  child:

                  ListTile(


                    leading:

                    const Icon(
                        Icons.warning,
                        color: Colors.red
                    ),



                    title:

                    Text(
                        item.topic
                    ),



                    subtitle:

                    Text(

                      "Duration: ${formatDuration(item.duration)}",

                    ),



                  ),


                );


              },


            ),

          ),



        ],

      ),



    );

  }


}