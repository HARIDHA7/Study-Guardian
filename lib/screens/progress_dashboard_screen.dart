import 'package:flutter/material.dart';

import '../services/distraction_history_service.dart';
import '../services/focus_score_service.dart';
import '../services/study_session_service.dart';



class ProgressDashboardScreen extends StatelessWidget {


  const ProgressDashboardScreen({
    super.key,
  });




  @override
  Widget build(BuildContext context) {



    double focusScore =
        FocusScoreService.calculateScore();




    int distractions =
        DistractionHistoryService
            .getHistory()
            .length;




    int totalMinutes =
        StudySessionService.totalMinutes;




    double studyHours =
        totalMinutes / 60;





    return Scaffold(


      appBar:
      AppBar(

        title:
        const Text(
          "Progress Dashboard",
        ),

        backgroundColor:
        Colors.blue,

        centerTitle:
        true,

      ),






      body:
      SingleChildScrollView(


        padding:
        const EdgeInsets.all(20),



        child:
        Column(


          children: [



            Card(


              elevation:
              8,



              shape:
              RoundedRectangleBorder(

                borderRadius:
                BorderRadius.circular(20),

              ),



              child:
              Padding(


                padding:
                const EdgeInsets.all(20),



                child:
                Column(


                  children: [



                    const Icon(

                      Icons.track_changes,

                      size:
                      50,

                      color:
                      Colors.blue,

                    ),




                    const SizedBox(
                      height:10,
                    ),




                    const Text(

                      "Focus Score",

                      style:
                      TextStyle(

                        fontSize:
                        22,

                        fontWeight:
                        FontWeight.bold,

                      ),

                    ),




                    const SizedBox(
                      height:10,
                    ),




                    Text(

                      "${focusScore.toStringAsFixed(1)}%",


                      style:
                      const TextStyle(

                        fontSize:
                        35,

                        fontWeight:
                        FontWeight.bold,

                      ),

                    ),



                  ],


                ),

              ),

            ),






            const SizedBox(
              height:20,
            ),






            dashboardCard(

              Icons.timer,

              "Study Hours",

              "${studyHours.toStringAsFixed(1)} Hours",

            ),






            dashboardCard(

              Icons.warning,

              "Distractions",

              "$distractions Times",

            ),






            dashboardCard(

              Icons.menu_book,

              "Study Status",

              "Completed Sessions",

            ),





            const SizedBox(
              height:20,
            ),






            const Card(


              child:
              ListTile(


                leading:
                Icon(

                  Icons.emoji_events,

                  size:
                  40,

                  color:
                  Colors.orange,

                ),



                title:
                Text(

                  "Today's Challenge",

                  style:
                  TextStyle(

                    fontWeight:
                    FontWeight.bold,

                    fontSize:
                    18,

                  ),

                ),



                subtitle:
                Text(

                  "Stay focused for 30 minutes without distraction 🔥",

                ),


              ),


            ),



          ],


        ),


      ),


    );

  }






  Widget dashboardCard(

      IconData icon,

      String title,

      String value,

      ){



    return Card(


      elevation:
      5,



      margin:
      const EdgeInsets.only(
        bottom:15,
      ),




      child:
      ListTile(


        leading:
        CircleAvatar(

          child:
          Icon(icon),

        ),




        title:
        Text(

          title,

          style:
          const TextStyle(

            fontWeight:
            FontWeight.bold,

          ),

        ),




        trailing:
        Text(

          value,

          style:
          const TextStyle(

            fontSize:
            18,

            fontWeight:
            FontWeight.bold,

          ),

        ),



      ),


    );


  }



}