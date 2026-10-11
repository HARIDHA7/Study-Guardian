import 'package:flutter/material.dart';


class DistractionScreen extends StatelessWidget {


  final int seconds;

  final String topic;



  const DistractionScreen({

    super.key,

    required this.seconds,

    required this.topic,

  });





  @override
  Widget build(BuildContext context){



    return Scaffold(



      backgroundColor:
      Colors.grey.shade100,




      appBar: AppBar(



        title:
        const Text(
            "Distraction Alert"
        ),



        centerTitle:true,



        backgroundColor:
        Colors.orange,



      ),






      body:Center(



        child:
        Padding(



          padding:
          const EdgeInsets.all(20),





          child:
          Card(



            elevation:8,



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





                children:[






                  const Icon(



                    Icons.warning_amber_rounded,



                    size:60,



                    color:Colors.orange,



                  ),






                  const SizedBox(height:15),






                  const Text(



                    "⚠️ Focus Interrupted",



                    style:
                    TextStyle(



                      fontSize:26,



                      fontWeight:
                      FontWeight.bold,



                    ),



                  ),






                  const SizedBox(height:25),






                  const Text(



                    "📚 Current Topic",



                    style:
                    TextStyle(



                      fontSize:18,



                      color:Colors.grey,



                    ),



                  ),






                  const SizedBox(height:5),






                  Text(



                    topic,



                    textAlign:
                    TextAlign.center,



                    style:
                    const TextStyle(



                      fontSize:22,



                      fontWeight:
                      FontWeight.bold,



                    ),



                  ),







                  const SizedBox(height:20),







                  const Text(



                    "⏱ Distraction Time",



                    style:
                    TextStyle(



                      fontSize:18,



                      color:Colors.grey,



                    ),



                  ),






                  const SizedBox(height:5),






                  Text(



                    "$seconds seconds",



                    style:
                    const TextStyle(



                      fontSize:22,



                      fontWeight:
                      FontWeight.bold,



                    ),



                  ),







                  const SizedBox(height:25),






                  const Text(



                    "Your study session is active.\nCome back and continue learning 📚",



                    textAlign:
                    TextAlign.center,



                    style:
                    TextStyle(



                      fontSize:16,



                    ),



                  ),







                  const SizedBox(height:30),








                  SizedBox(



                    width:
                    double.infinity,





                    child:
                    ElevatedButton(



                      style:
                      ElevatedButton.styleFrom(



                        padding:
                        const EdgeInsets.all(15),



                      ),





                      onPressed:(){



                        Navigator.pop(context);



                      },





                      child:
                      const Text(



                        "Resume Study",



                        style:
                        TextStyle(



                          fontSize:18,



                        ),



                      ),



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