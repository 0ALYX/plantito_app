import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_core/firebase_core.dart';
import 'dart:async';

Future<void> main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    home: MyApp(

    ),
  ));
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

//for timer
class Timer {
  late int hours;
  late int minutes;
  late int seconds;

  Timer({required this.hours, required this.minutes, required this.seconds});

  int getTotalSeconds() {
    return hours * 3600 + minutes * 60 + seconds;
  }
}

class _MyAppState extends State<MyApp> {
  final DatabaseReference _plantito1  = FirebaseDatabase.instance.ref().child('waterstatus');
  final DatabaseReference _plantito2  = FirebaseDatabase.instance.ref().child('moistcontent');
  final DatabaseReference _plantito3  = FirebaseDatabase.instance.ref().child('light');

  double moistureXAlignment = 250 / 348;
  double moistureYAlignment = 16 / 191;
  double moistureZAlignment = 0.0;

  double reservoirXAlignment = 0.65;
  double reservoirYAlignment = -1.0;
  double reservoirZAlignment = 0.0;

  double lowLevelXAlignment = 0.0;
  double lowLevelYAlignment = 0.0;
  double lowLevelZAlignment = 0.0;

  bool isSwitched = false;

  double timerXAlignment = 0.0;
  double timerYAlignment = 0.0;

  int selectedHour = 0;
  int selectedMinute = 0;
  int selectedSecond = 0;

  int selectedHour2 = 0;
  int selectedMinute2 = 0;
  int selectedSecond2 = 0;
  

//water reservoir status
int status = 1;
 String getStatusString(int status) {
  String result = "";
  switch (status) {
    case 1:
      result = "EMPTY";
      break;
    case 2:
      result = "LOW";
      break;
    case 3:
      result = "HALF";
      break;
    case 4:
      result = "FULL";
      break;
    default:
      result = "UNKNOWN";
  }
  return result;
}

//moisture content status
int content = 2;
String getcontentString(int sta) {
  String result = "";
  switch (sta) {
    case 1:
      result = "DRY";
      break;
    case 2:
      result = "MOIST";
      break;
  }
  return result;
}

  String plantName = 'Plant Name';
 // bool isEditing = false;
 // TextEditingController plantNameController = TextEditingController();

  // Leaf icon properties
  double leafIconSize = 40.0;
  double leafIconXPosition = 20.0;
  double leafIconYPosition = 18.0;

  // Define a list of hours, minutes, and seconds
  List<int> hours = List.generate(24, (index) => index);
  List<int> minutes = List.generate(60, (index) => index);
  List<int> seconds = List.generate(60, (index) => index);

  double startButtonAlignment = 0.1;
  double stopButtonAlignment = 0.6;
  int remainingSeconds = 0;

  
  //Timer Logic
  //initialaized class
  Timer selectedTimer = Timer(hours: 0, minutes: 0, seconds: 0);
  bool isTimerRunning = false; //bool var to track id running or not

void startTimer() { //start timer
  recalculateTotalSeconds();  // Recalculate totalSeconds before starting the timer

  // Send signal to Arduino to turn on LED
    FirebaseDatabase.instance.ref().child('light').set(true);

  const oneSecond = Duration(seconds: 1); 

  void updateTimer() { //implement recursive function, w/ 1 sec delay between updates
    if (remainingSeconds <= 0) { 
      // Timer reached zero, stop the timer
      stopTimer();

      // Send signal to Arduino to turn off LED
        FirebaseDatabase.instance.ref().child('light').set(false);
    } else {
      setState(() {
        //remainingSeconds = currentSeconds;
        remainingSeconds -= 1;
      });

      // Send signal to Arduino to turn on/off LED immediately
    FirebaseDatabase.instance.ref().child('signalLED').set(remainingSeconds > 0);
      // Schedule the next update after one second
      Future.delayed(oneSecond, updateTimer);
    }
  }

  // Ensure that the timer is not already running
  if (!isTimerRunning) {
    // Start the initial update without subtracting 1
    updateTimer();

    setState(() {
      isTimerRunning = true;
    });
  }
}
void recalculateTotalSeconds() { //recal total num of sec based on selected hr,min,sec
  selectedTimer = Timer(hours: selectedHour, minutes: selectedMinute, seconds: selectedSecond);
  remainingSeconds = selectedTimer.getTotalSeconds();
}

  void stopTimer() {
    // Stop the timer by setting isTimerRunning to false
    setState(() {
      isTimerRunning = false;
    });
  }


  String convertSecondsToTime(int seconds) { //takes duration in secs & conerts into formatted string
  int hours = seconds ~/ 3600;
  int minutes = (seconds % 3600) ~/ 60;
  int remainingSeconds = seconds % 60;
  return '${hours.toString().padLeft(2,'0')}hrs ${minutes.toString().padLeft(2,'0')}mins ${remainingSeconds.toString().padLeft(2,'0')}secs';
}


  Widget buildTimerDisplay() { //disp current timer value
  // No need to subtract 1 here, as it's already handled in the timer logic
    return Text(
      '${convertSecondsToTime(remainingSeconds)}',
      style: TextStyle(
        fontFamily: 'Lato',
        fontSize: 16,
        fontWeight: FontWeight.bold,
        color: Colors.black,
      ),
    );
}//Timer Logic End

  @override
  Widget build(BuildContext context) {
    //firebase connect
_plantito1.onValue.listen(( event) { //set listener for changes
      DataSnapshot snapshot = event.snapshot; //provides an event
      dynamic data = snapshot.value;
//checks the type of data received from databse if data is int it updates the status
//if double it converts double to int before updating stats
      if (data is int) {
        setState(() {
          status = data;
        });
      } else if (data is double) {
        setState(() {
          status = data.toInt();
        });
      } else {
        // Handle other data types or errors
        print('Value is not numeric');
      }
    });

    _plantito2.onValue.listen(( event) {
      DataSnapshot snapshot = event.snapshot;
      dynamic data = snapshot.value;

      if (data is int) {
        setState(() {
          content = data;
        });
      } else if (data is double) {
        setState(() {
          content = data.toInt();
        });
      } else {
        // Handle other data types or errors
        print('Value is not numeric');
      }
    });

    return MaterialApp(
      home: Scaffold(
        body: Padding(
          padding: const EdgeInsets.only(top: 40.0),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Container(
                  width: 348,
                  height: 160,
                  decoration: BoxDecoration(
                    color: Color(0xFFC5D38B),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Padding(
                    padding: EdgeInsets.all(18.0),
                    child: Stack(
                      children: [
                        // Leaf icon
                        Positioned(
                          top: leafIconYPosition,
                          left: leafIconXPosition,
                          child: GestureDetector( 
                            // You can add onTap handler for interaction with the icon
                            child: Icon(
                              Icons.eco_outlined,
                              color: Color.fromARGB(255, 95, 146, 47),
                              size: 100,
                            ),
                          ),
                        ),
                        Align(
                          alignment: Alignment(moistureXAlignment, moistureYAlignment),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                'Moisture Content',
                                style: TextStyle(
                                  fontFamily: 'Lato',
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFFFFFFFF),
                                  shadows: [
                                    Shadow(
                                      color: Color(0xFF726F6C),
                                      offset: Offset(0, 0),
                                      blurRadius: 1,
                                    ),
                                  ],
                                ),
                              ),
                              
                              Text(
                                getcontentString(content),
                                style: TextStyle(
                                  fontFamily: 'Lato',
                                  fontSize: 44,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFFFFFFFF),
                                  shadows: [
                                    Shadow(
                                      color: Color(0xFF696969),
                                      offset: Offset(0, 0),
                                      blurRadius: 1,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                                 Text(
                                'My Plant',
                                style: TextStyle(
                                  fontFamily: 'Lato',
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Color.fromARGB(255, 35, 87, 0),
                                ),
                              )
                            ],
                          ),
                    ),
                  ),
                
                SizedBox(height: 15),
                Container(
                  width: 348,
                  height: 160,
                  decoration: BoxDecoration(
                    color: Color(0xFFA5DEEB),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Padding(
                    padding: EdgeInsets.all(20.0),
                    child: Stack(
                      children: [
                        Align(
                          alignment: Alignment(reservoirXAlignment, reservoirYAlignment),
                          child: Transform.translate(
                            offset: Offset(0, reservoirZAlignment),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(
                                  'Water Reservoir',
                                  style: TextStyle(
                                    fontFamily: 'Lato',
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFFFFFFFF),
                                    shadows: [
                                      Shadow(
                                        color: Color(0xFF726F6C),
                                        offset: Offset(0, 0),
                                        blurRadius: 1,
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(height: 8),// way sure
                                Text(
                                  getStatusString(status),
                                  style: TextStyle(
                                    fontFamily: 'Lato',
                                    fontSize:40,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFFFFFFFF),
                                    shadows: [
                                      Shadow(
                                        color: Color(0xFF696969),
                                        offset: Offset(0, 0),
                                        blurRadius: 1,
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        // Cartoon water drop icon
                        Positioned(
                          left: 10,
                          top: 10,
                          child: GestureDetector(
                            child: Icon(
                              Icons.water_drop_outlined,
                              color: Color.fromARGB(255, 67, 141, 202),
                              size: 100,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 16),
                Expanded(
                  child: Container(
                    width: 348,
                    height: 20,
                    decoration: BoxDecoration(
                      color: Color(0xFFFFED8C),
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        color: Color(0xFF8F8F8F),
                        width: 1,
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 16.0),
                          child: Row(
                            children: [
                              Icon(
                                Icons.wb_sunny,
                                color: Color.fromARGB(255, 255, 196, 0),
                              ),
                              SizedBox(width: 8),
                              Text(
                                'LIGHT',
                                style: TextStyle(
                                  fontFamily: 'Lato',
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF000000),
                                ),
                              ),
                            ],
                          ),
                        ),
                        //LED toggle switch
                        Switch(
                          value: isSwitched,
                          onChanged: (value) {
                            setState(() {
                              isSwitched = value;
                              _plantito3.set(value ? true : false);
                            });
                          },
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 10),
                Container(
                  width: 348,
                  height: 300,
                  decoration: BoxDecoration(
                    color: Colors.transparent,
                  ),
                  child: Stack(
                    children: [
                      Positioned(
                        top: timerYAlignment,
                        left: timerXAlignment,
                        child: Container(
                          width: 348,
                          height: 270,
                          decoration: BoxDecoration(
                            color: Colors.transparent,
                            borderRadius: BorderRadius.circular(5),
                            border: Border.all(
                              color: Color(0xFFA9A9A9),
                              width: 3,
                            ),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(left: 10, right: 10),
                                child: Row(
                                  children: [
                                    Icon(
                                      Icons.hourglass_bottom_rounded,
                                      color: Colors.black,
                                      size: 20,
                                    ),
                                    SizedBox(width: 1),
                                    Text(
                                      'TIMER',
                                      style: TextStyle(
                                        fontFamily: 'Lato',
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(height: 8),

                              Padding(
                                padding: const EdgeInsets.only(left: 10, right: 10),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      'Start Time:',
                                      style: TextStyle(
                                        fontFamily: 'Lato',
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black,
                                      ),
                                    ),
                                    isTimerRunning
                                    ? buildTimerDisplay()
                                    : Row(children: [
                                      // Dropdown list for hours, minutes, and seconds
                                    DropdownButton<int>(
                                      value: selectedHour,
                                      onChanged: (int? newValue) {
                                        setState(() {
                                          selectedHour = newValue!;
                                        });
                                      },
                                      items: hours.map((int hour) {
                                        return DropdownMenuItem<int>(
                                          value: hour,
                                          child: Text(hour.toString().padLeft(2, '0') + ' hrs'),
                                        );
                                      }).toList(),
                                    ),
                                    DropdownButton<int>(
                                      value: selectedMinute,
                                      onChanged: (int? newValue) {
                                        setState(() {
                                          selectedMinute = newValue!;
                                        });
                                      },
                                      items: minutes.map((int minute) {
                                        return DropdownMenuItem<int>(
                                          value: minute,
                                          child: Text(minute.toString().padLeft(2, '0') + ' mins'),
                                        );
                                      }).toList(),
                                    ),
                                    DropdownButton<int>(
                                      value: selectedSecond,
                                      onChanged: (int? newValue) {
                                        setState(() {
                                          selectedSecond = newValue!;
                                        });
                                      },
                                      items: seconds.map((int second) {
                                        return DropdownMenuItem<int>(
                                          value: second,
                                          child: Text(second.toString().padLeft(2, '0') + ' secs'),
                                        );
                                      }).toList(),
                                    ),
                                    ],)
                                    
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),

                      // Start and Stop buttons
                      AnimatedAlign(
                        duration: Duration(milliseconds: 500),
                        curve: Curves.easeInOut,
                        alignment: Alignment(-0.6, 0.3),
                        child: ElevatedButton(
                          onPressed: () {
                            // Handle Start button press
                            // Add your logic for starting the timer
                            if (!isTimerRunning) {
                              startTimer();
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            primary: Colors.green,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                            child: Text(
                              'Start',
                              style: TextStyle(
                                fontFamily: 'Lato',
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: const Color.fromARGB(255, 255, 255, 255),
                              ),
                            ),
                          ),
                        ),
                      ),
                      AnimatedAlign(
                        duration: Duration(milliseconds: 500),
                        curve: Curves.easeInOut,
                        alignment: Alignment(stopButtonAlignment, 0.3),
                        child: ElevatedButton(
                          onPressed: () {
                            // Handle Stop button press
                            // Add your logic for stopping the timer
                             if (isTimerRunning) {
                                stopTimer();
                                FirebaseDatabase.instance.ref().child('light').set(false);
                              }
                          },
                          style: ElevatedButton.styleFrom(
                            primary: Colors.red,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                            child: Text(
                              'Stop',
                              style: TextStyle(
                                fontFamily: 'Lato',
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: const Color.fromARGB(255, 255, 255, 255),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}