import 'package:flutter/material.dart';

import '../models/note.dart';
import '../services/notification_service.dart';

import 'study_timer_screen.dart';
import 'study_reader_screen.dart';



class StudySessionScreen extends StatelessWidget {


  final Note? note;


  const StudySessionScreen({

    super.key,

    this.note,

  });






  Future<void> startStudy(BuildContext context) async {



    final bool enabled =
        await NotificationService.isNotificationEnabled();




    if (!enabled) {



      showDialog(


        context: context,


        barrierDismissible: false,



        builder: (context) {


          return AlertDialog(



            title:
            const Text(
              "Enable Notifications",
            ),




            content:
            const Text(

              "Study Guardian needs notification permission "
              "to send distraction alerts. Please enable notifications."

            ),




            actions: [



              TextButton(



                onPressed: () async {



                  Navigator.pop(context);



                  await NotificationService
                      .openNotificationSettings();



                },



                child:
                const Text(
                  "Enable",
                ),



              ),




            ],




          );


        },


      );



      return;


    }







    Navigator.push(


      context,


      MaterialPageRoute(


        builder: (_) => StudyTimerScreen(

          note: note,

        ),


      ),


    );


  }









  @override
  Widget build(BuildContext context) {



    return Scaffold(



      appBar: AppBar(


        title:
        const Text(
          "Start Study",
        ),



        backgroundColor:
        Colors.blue,



        centerTitle:
        true,


      ),








      body:
      Center(



        child:
        Padding(



          padding:
          const EdgeInsets.all(20),





          child:
          Card(



            elevation:
            6,



            shape:
            RoundedRectangleBorder(


              borderRadius:
              BorderRadius.circular(20),


            ),





            child:
            Padding(



              padding:
              const EdgeInsets.all(25),





              child:
              Column(



                mainAxisSize:
                MainAxisSize.min,






                children: [





                  const Icon(


                    Icons.menu_book,


                    size:
                    90,


                    color:
                    Colors.blue,


                  ),






                  const SizedBox(
                    height:20,
                  ),






                  const Text(


                    "Ready to Study?",




                    style:
                    TextStyle(



                      fontSize:
                      24,



                      fontWeight:
                      FontWeight.bold,



                    ),


                  ),






                  const SizedBox(
                    height:10,
                  ),






                  Text(



                    note != null

                        ? "Start studying ${note!.unit}"

                        : "Press Start to begin your focused study session.",




                    textAlign:
                    TextAlign.center,



                  ),






                  const SizedBox(
                    height:30,
                  ),






                  SizedBox(



                    width:
                    double.infinity,





                    child:
                    ElevatedButton.icon(



                      icon:
                      const Icon(
                        Icons.play_arrow,
                      ),




                      label:
                      const Text(
                        "Start Study",
                      ),






                      style:
                      ElevatedButton.styleFrom(


                        padding:
                        const EdgeInsets.symmetric(

                          vertical:
                          15,

                        ),


                      ),






                      onPressed: () {


                        startStudy(context);



                      },





                    ),




                  ),







                  const SizedBox(
                    height:15,
                  ),







                  SizedBox(



                    width:
                    double.infinity,





                    child:
                    ElevatedButton.icon(



                      icon:
                      const Icon(
                        Icons.insert_drive_file,
                      ),





                      label:
                      const Text(
                        "Open File",
                      ),







                      style:
                      ElevatedButton.styleFrom(



                        padding:
                        const EdgeInsets.symmetric(


                          vertical:
                          15,


                        ),


                      ),






                      onPressed:

                      note == null

                          ? null

                          : () {



                        Navigator.push(



                          context,



                          MaterialPageRoute(



                            builder: (_) =>

                                StudyReaderScreen(



                                  note:
                                  note!,



                                ),



                          ),



                        );



                      },





                    ),





                  ),





                ],





              ),



            ),



          ),



        ),



      ),



    );


  }


}