import '../models/distraction.dart';



class DistractionHistoryService {


  static final List<Distraction> history = [];




  static void addDistraction({


    required String topic,

    required int duration,


  }) {



    history.add(


      Distraction(


        topic:

        topic,



        duration:

        duration,



        time:

        DateTime.now(),


      ),


    );



  }






  static List<Distraction> getHistory(){


    return history;


  }







  static int getTotalSeconds(){


    int total = 0;



    for(var item in history){


      total += item.duration;


    }



    return total;


  }





}