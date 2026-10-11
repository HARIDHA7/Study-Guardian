import 'package:flutter/material.dart';

import 'greeting_screen.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {

  final TextEditingController nameController =
      TextEditingController();

  final TextEditingController emailController =
      TextEditingController();

  final TextEditingController passwordController =
      TextEditingController();

  bool hidePassword = true;


  void register() {

    if (nameController.text.isEmpty ||
        emailController.text.isEmpty ||
        passwordController.text.isEmpty) {

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            "Please fill all details",
          ),
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
                backgroundColor: Colors.green.shade100,
                child: const Icon(
                  Icons.person_add,
                  size: 60,
                  color: Colors.green,
                ),
              ),


              const SizedBox(height: 25),


              const Text(
                "Create Account 🚀",
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                ),
              ),


              const SizedBox(height: 8),


              const Text(
                "Start your smart study journey",
                style: TextStyle(
                  color: Colors.grey,
                  fontSize: 16,
                ),
              ),


              const SizedBox(height: 40),


              TextField(
                controller: nameController,
                decoration: InputDecoration(

                  labelText: "Name",

                  prefixIcon:
                      const Icon(Icons.person),

                  border: OutlineInputBorder(
                    borderRadius:
                        BorderRadius.circular(15),
                  ),
                ),
              ),


              const SizedBox(height: 20),


              TextField(
                controller: emailController,

                keyboardType:
                    TextInputType.emailAddress,

                decoration: InputDecoration(

                  labelText: "Email",

                  prefixIcon:
                      const Icon(Icons.email),

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

                  onPressed: register,

                  style:
                      ElevatedButton.styleFrom(

                    backgroundColor:
                        Colors.green,

                    shape:
                        RoundedRectangleBorder(

                      borderRadius:
                          BorderRadius.circular(15),

                    ),

                  ),


                  child: const Text(

                    "REGISTER",

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
                    "Already have an account?",
                  ),


                  TextButton(

                    onPressed: () {

                      Navigator.pop(context);

                    },

                    child: const Text(
                      "Login",
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