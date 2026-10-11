import 'package:flutter/material.dart';

import 'home_screen.dart';


class GreetingScreen extends StatelessWidget {

  const GreetingScreen({super.key});


  @override
  Widget build(BuildContext context) {

    return Scaffold(

      backgroundColor: Colors.white,


      body: SafeArea(

        child: Padding(

          padding: const EdgeInsets.all(25),

          child: Column(

            mainAxisAlignment:
                MainAxisAlignment.center,

            children: [


              CircleAvatar(

                radius: 70,

                backgroundColor:
                    Colors.blue.shade100,

                child: const Icon(

                  Icons.school,

                  size: 80,

                  color: Colors.blue,

                ),

              ),


              const SizedBox(height: 35),


              const Text(

                "Welcome to Study Guardian 🎓",

                textAlign: TextAlign.center,

                style: TextStyle(

                  fontSize: 28,

                  fontWeight: FontWeight.bold,

                ),

              ),


              const SizedBox(height: 15),


              const Text(

                "Your AI powered study companion.\n"
                "Manage subjects, track progress,\n"
                "and improve your focus.",

                textAlign: TextAlign.center,

                style: TextStyle(

                  fontSize: 16,

                  color: Colors.grey,

                ),

              ),


              const SizedBox(height: 50),


              SizedBox(

                width: double.infinity,

                height: 55,

                child: ElevatedButton(

                  onPressed: () {


                    Navigator.pushReplacement(

                      context,

                      MaterialPageRoute(

                        builder: (_) =>
                            const HomeScreen(),

                      ),

                    );


                  },


                  style:
                      ElevatedButton.styleFrom(

                    backgroundColor:
                        Colors.blue,

                    shape:
                        RoundedRectangleBorder(

                      borderRadius:
                          BorderRadius.circular(15),

                    ),

                  ),


                  child: const Text(

                    "START STUDY 🚀",

                    style: TextStyle(

                      fontSize: 18,

                      color: Colors.white,

                    ),

                  ),

                ),

              ),

            ],

          ),

        ),

      ),

    );

  }

}