import 'dart:convert';
import 'dart:developer';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class IotScreen extends StatefulWidget {
  const IotScreen({super.key});

  @override
  State<IotScreen> createState() => _IotScreenState();
}

class _IotScreenState extends State<IotScreen> {
  final dbRef = FirebaseDatabase.instance.ref();
  bool value = false;
  Color color = Colors.grey;

  onUpdate() {
    setState(() {
      value = !value;
    });
  }

  static final GlobalKey<ScaffoldState> _scaffoldKey =
      GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    readData();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: SafeArea(
          child: StreamBuilder(
              builder: (context, snapshot) {
                if (snapshot.hasData &&
                    !snapshot.hasError &&
                    snapshot.data?.snapshot != null) {
                  final jsonData = jsonEncode(snapshot.data!.snapshot.value);
                  var sensorData = SensorData.fromJson(jsonDecode(jsonData));
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const Padding(
                        padding: EdgeInsets.all(18.0),
                        child: Text("Smart Temperature Room",
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 20,
                                fontWeight: FontWeight.bold)),
                      ),
                      const Spacer(),
                      Center(
                        child: Container(
                          width: 300,
                          height: 300,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                            image: DecorationImage(
                              image: AssetImage(value == true
                                  ? "assets/on.png"
                                  : "assets/off.png"),
                              fit: BoxFit.cover,
                            ),
                            // border: Border.all(
                            //     width: 3, color: const Color(0xff33bac0))
                          ),
                          child: Center(
                              child: RichText(
                            textAlign: TextAlign.center,
                            text: TextSpan(
                              text: sensorData.temperature,
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 80,
                                  color: Color(0xff0d123f)),
                              children: const <TextSpan>[
                                TextSpan(
                                    text: '°C',
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 30)),
                                TextSpan(
                                    text: '\nRoom Temperature',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 17,
                                    )),
                              ],
                            ),
                          )
                              //  Text(
                              //   "${sensorData.temperature}°C",
                              //   style: const TextStyle(
                              //       fontSize: 70, color: Color(0xff33bac0)),
                              // ),
                              ),
                        ),
                      ),
                      // Row(
                      //   mainAxisAlignment: MainAxisAlignment.center,
                      //   children: [
                      //     Column(
                      //       children: [
                      //         Padding(
                      //           padding: const EdgeInsets.all(8.0),
                      //           child: Text("Temperature",
                      //               style: TextStyle(
                      //                   color: !value
                      //                       ? Colors.white
                      //                       : Colors.yellow,
                      //                   fontSize: 20,
                      //                   fontWeight: FontWeight.bold)),
                      //         ),
                      //         Padding(
                      //           padding: const EdgeInsets.all(8.0),
                      //           child: Text("${sensorData.temperature}°C",
                      //               style: const TextStyle(
                      //                   color: Colors.black, fontSize: 20)),
                      //         ),
                      //       ],
                      //     ),
                      //   ],
                      // ),
                      const Spacer(),
                      Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Row(
                          children: [
                            Expanded(
                                child: Container(
                              height: 110,
                              padding: const EdgeInsets.all(15),
                              decoration: BoxDecoration(
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.1),
                                      spreadRadius: 3,
                                      blurRadius: 3,
                                      offset: const Offset(0, 0),
                                    ),
                                  ],
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(15)),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text("Humadity Room"),
                                  Text(
                                    "${sensorData.humidity}%",
                                    style: const TextStyle(
                                        fontSize: 40, color: Color(0xff0d123f)),
                                  ),
                                ],
                              ),
                            )),
                            const SizedBox(
                              width: 15,
                            ),
                            Expanded(
                                child: Container(
                              height: 110,
                              padding: const EdgeInsets.all(15),
                              decoration: BoxDecoration(
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.1),
                                      spreadRadius: 3,
                                      blurRadius: 3,
                                      offset: const Offset(0, 0),
                                    ),
                                  ],
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(15)),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    "Turn On/Off Air Conditioner",
                                    style: TextStyle(fontSize: 12),
                                  ),
                                  const Spacer(),
                                  InkWell(
                                    onTap: () {
                                      onUpdate();
                                      writeData();
                                    },
                                    child: Container(
                                      width: double.infinity,
                                      padding: const EdgeInsets.all(8),
                                      decoration: BoxDecoration(
                                          boxShadow: [
                                            BoxShadow(
                                              color:
                                                  Colors.black.withOpacity(0.1),
                                              spreadRadius: 1,
                                              blurRadius: 1,
                                              offset: const Offset(0, 0),
                                            ),
                                          ],
                                          color: value == true
                                              ? const Color(0xff71CBDC)
                                              : Colors.grey.withOpacity(.4),
                                          borderRadius:
                                              BorderRadius.circular(10)),
                                      child: Center(
                                          child: Text(
                                        value == true ? "On" : "Off",
                                        style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: Color(0xff0d123f)),
                                      )),
                                    ),
                                  )
                                ],
                              ),
                            ))
                          ],
                        ),
                      ),
                      // Column(
                      //   children: [
                      //     Padding(
                      //       padding: const EdgeInsets.all(8.0),
                      //       child: Text("Humidity",
                      //           style: TextStyle(
                      //               color:
                      //                   !value ? Colors.black : Colors.yellow,
                      //               fontSize: 20,
                      //               fontWeight: FontWeight.bold)),
                      //     ),
                      //     Padding(
                      //       padding: const EdgeInsets.all(8.0),
                      //       child: Text("${sensorData.humidity}%",
                      //           style: const TextStyle(
                      //               color: Colors.white, fontSize: 60)),
                      //     ),
                      //   ],
                      // ),
                      //   const SizedBox(height: 80),
                      //   Padding(
                      //     padding: const EdgeInsets.all(18.0),
                      //     child: FloatingActionButton.extended(
                      //       icon: value
                      //           ? const Icon(Icons.visibility)
                      //           : const Icon(Icons.visibility_off),
                      //       backgroundColor: value ? Colors.yellow : Colors.white,
                      //       label: value ? const Text("ON") : const Text("OFF"),
                      //       elevation: 20.00,
                      //       onPressed: () {
                      //         onUpdate();
                      //         writeData();
                      //       },
                      //     ),
                      //   ),
                    ],
                  );
                } else {}
                return Container();
              },
              stream: dbRef.child("data").onValue),
        ),
      ),
    );
  }

  Future<void> writeData() async {
    dbRef.child("lightState").set({"switch": !value});
  }

  Future<void> readData() async {
    dbRef.child("data").once().then((DatabaseEvent value) {
      print(value.snapshot.value);
    });
  }
}

class SensorData {
  final String temperature;
  final String humidity;

  SensorData({required this.temperature, required this.humidity});

  factory SensorData.fromJson(Map<String, dynamic> json) {
    return SensorData(
      temperature: json['temperature'].toString(),
      humidity: json['humidity'].toString(),
    );
  }

  @override
  String toString() {
    return 'SensorData{temperature: $temperature, humidity: $humidity}';
  }
}



//**
// Relay
// sensor suhu
// esp32
// */