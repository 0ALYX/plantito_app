import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
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

  String plantName = 'Plant Name';
  bool isEditing = false;
  TextEditingController plantNameController = TextEditingController();

  // Leaf icon properties
  double leafIconSize = 40.0;
  double leafIconXPosition = 20.0;
  double leafIconYPosition = 10.0;

  // Define a list of hours, minutes, and seconds
  List<int> hours = List.generate(24, (index) => index);
  List<int> minutes = List.generate(60, (index) => index);
  List<int> seconds = List.generate(60, (index) => index);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Padding(
          padding: const EdgeInsets.only(top: 35.0),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Container(
                  width: 348,
                  height: 121,
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
                              size: 110,
                            ),
                          ),
                        ),
                        Align(
                          alignment: Alignment(moistureXAlignment, moistureYAlignment),
                          child: Column(
                            //crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                'Moisture Content',
                                style: TextStyle(
                                  fontFamily: 'Lato',
                                  fontSize: 16,
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
                                'MOIST',
                                style: TextStyle(
                                  fontFamily: 'Lato',
                                  fontSize: 38,
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
                        Positioned(
                          left: 2,
                          bottom: 10,
                          child: GestureDetector(
                            onTap: () {
                              setState(() {
                                isEditing = !isEditing;
                                if (!isEditing) {
                                  plantName = plantNameController.text;
                                }
                              });
                            },
                            child: Row(
                              children: [
                                Icon(
                                  Icons.edit,
                                  color: Color.fromARGB(255, 80, 133, 31),
                                  size: 20,
                                ),
                                SizedBox(width: 8),
                                isEditing
                                    ? Container(
                                        width: 200,
                                        child: TextField(
                                          controller: plantNameController,
                                          decoration: InputDecoration(
                                            hintText: 'Name your Plant :)',
                                          ),
                                        ),
                                      )
                                    : Text(
                                        plantName,
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
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 15),
                Container(
                  width: 348,
                  height: 120,
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
                                    fontSize: 16,
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
                                SizedBox(height: 8),
                                Text(
                                  'LOW LEVEL',
                                  style: TextStyle(
                                    fontFamily: 'Lato',
                                    fontSize: 30,
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
                          left: 20,
                          top: 20,
                          child: GestureDetector(
                            // You can add onTap handler for interaction with the icon
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
                Container(
                  width: 348,
                  height: 51,
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
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF000000),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Switch(
                        value: isSwitched,
                        onChanged: (value) {
                          setState(() {
                            isSwitched = value;
                          });
                        },
                      ),
                    ],
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
                          height: 200,
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
                                child: Text(
                                  'TIMER',
                                  style: TextStyle(
                                    fontFamily: 'Lato',
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                  ),
                                ),
                              ),
                              SizedBox(height: 8),
                              Padding(
                                padding: const EdgeInsets.only(left: 10, right: 10),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      'Start Time: ',
                                      style: TextStyle(
                                        fontFamily: 'Lato',
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black,
                                      ),
                                    ),
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
                                          child: Text(hour.toString().padLeft(2, '0')),
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
                                          child: Text(minute.toString().padLeft(2, '0')),
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
                                          child: Text(second.toString().padLeft(2, '0')),
                                        );
                                      }).toList(),
                                    ),
                                  ],
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(left: 10, right: 10),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      'End Time: ',
                                      style: TextStyle(
                                        fontFamily: 'Lato',
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black,
                                      ),
                                    ),
                                    DropdownButton<int>(
                                      value: selectedHour2,
                                      onChanged: (int? newValue) {
                                        setState(() {
                                          selectedHour2 = newValue!;
                                        });
                                      },
                                      items: hours.map((int hour) {
                                        return DropdownMenuItem<int>(
                                          value: hour,
                                          child: Text(hour.toString().padLeft(2, '0')),
                                        );
                                      }).toList(),
                                    ),
                                    DropdownButton<int>(
                                      value: selectedMinute2,
                                      onChanged: (int? newValue) {
                                        setState(() {
                                          selectedMinute2 = newValue!;
                                        });
                                      },
                                      items: minutes.map((int minute) {
                                        return DropdownMenuItem<int>(
                                          value: minute,
                                          child: Text(minute.toString().padLeft(2, '0')),
                                        );
                                      }).toList(),
                                    ),
                                    DropdownButton<int>(
                                      value: selectedSecond2,
                                      onChanged: (int? newValue) {
                                        setState(() {
                                          selectedSecond2 = newValue!;
                                        });
                                      },
                                      items: seconds.map((int second) {
                                        return DropdownMenuItem<int>(
                                          value: second,
                                          child: Text(second.toString().padLeft(2, '0')),
                                        );
                                      }).toList(),
                                    ),
                                  ],
                                ),
                              ),
                            ],
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
