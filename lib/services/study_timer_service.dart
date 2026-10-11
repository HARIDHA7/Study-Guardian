import 'dart:async';

class StudyTimerService {

  static Timer? timer;

  static int remainingSeconds = 0;

  static bool isRunning = false;


  static void startTimer(int minutes) {

    if(isRunning) return;


    remainingSeconds = minutes * 60;

    isRunning = true;


    timer = Timer.periodic(
      const Duration(seconds: 1),
      (t){

        if(remainingSeconds > 0){

          remainingSeconds--;

        }
        else{

          t.cancel();

          isRunning = false;

        }

      },
    );

  }



  static String getTime(){

    int minutes = remainingSeconds ~/ 60;

    int seconds = remainingSeconds % 60;


    return "$minutes:${seconds.toString().padLeft(2,'0')}";

  }



  static void stopTimer(){

    timer?.cancel();

    isRunning = false;

  }

}