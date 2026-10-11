import 'package:flutter/material.dart';

import 'register_screen.dart';
import 'greeting_screen.dart';


class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}


class _LoginScreenState extends State<LoginScreen> {

  final TextEditingController emailController =
      TextEditingController();

  final TextEditingController passwordController =
      TextEditingController();

  bool hidePassword = true;


  void login() {

    if (emailController.text.isEmpty ||
        passwordController.text.isEmpty) {

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Please enter Email and Password"),
        ),
      );

      return;
    }


    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => const GreetingScreen(),
      ),
    );

  }



  @override
  Widget build(BuildContext context) {

    return Scaffold(

      backgroundColor: Colors.grey.shade100,


      body: SafeArea(

        child: SingleChildScrollView(

          padding: const EdgeInsets.all(25),


          child: Column(

            children: [


              const SizedBox(height: 40),



              CircleAvatar(

                radius: 55,

                backgroundColor: Colors.blue.shade100,

                child: const Icon(

                  Icons.menu_book,

                  size: 60,

                  color: Colors.blue,

                ),

              ),



              const SizedBox(height: 25),



              const Text(

                "Welcome Back 👋",

                style: TextStyle(

                  fontSize: 30,

                  fontWeight: FontWeight.bold,

                ),

              ),



              const SizedBox(height: 8),



              const Text(

                "Login to continue your study",

                style: TextStyle(

                  color: Colors.grey,

                  fontSize: 16,

                ),

              ),



              const SizedBox(height: 40),



              TextField(

                controller: emailController,

                keyboardType: TextInputType.emailAddress,


                decoration: InputDecoration(

                  labelText: "Email",

                  prefixIcon: const Icon(Icons.email),


                  border: OutlineInputBorder(

                    borderRadius:
                        BorderRadius.circular(15),

                  ),

                ),

              ),



              const SizedBox(height: 20),



              TextField(

                controller: passwordController,

                obscureText: hidePassword,


                decoration: InputDecoration(

                  labelText: "Password",


                  prefixIcon:
                      const Icon(Icons.lock),


                  suffixIcon: IconButton(

                    icon: Icon(

                      hidePassword

                          ? Icons.visibility

                          : Icons.visibility_off,

                    ),


                    onPressed: () {

                      setState(() {

                        hidePassword =
                            !hidePassword;

                      });

                    },

                  ),


                  border: OutlineInputBorder(

                    borderRadius:
                        BorderRadius.circular(15),

                  ),

                ),

              ),



              const SizedBox(height: 30),



              SizedBox(

                width: double.infinity,

                height: 55,


                child: ElevatedButton(


                  onPressed: login,


                  style: ElevatedButton.styleFrom(

                    backgroundColor: Colors.blue,


                    shape: RoundedRectangleBorder(

                      borderRadius:
                          BorderRadius.circular(15),

                    ),

                  ),


                  child: const Text(

                    "LOGIN",


                    style: TextStyle(

                      fontSize: 18,

                      color: Colors.white,

                    ),

                  ),

                ),

              ),



              const SizedBox(height: 20),



              Row(

                mainAxisAlignment:
                    MainAxisAlignment.center,


                children: [


                  const Text(
                    "Don't have an account?",
                  ),



                  TextButton(


                    onPressed: () {


                      Navigator.push(

                        context,

                        MaterialPageRoute(

                          builder: (_) =>
                              const RegisterScreen(),

                        ),

                      );


                    },


                    child: const Text(

                      "Register",

                    ),

                  ),


                ],

              ),


            ],

          ),

        ),

      ),

    );

  }

}