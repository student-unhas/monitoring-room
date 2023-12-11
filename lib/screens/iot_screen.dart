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
      theme: ThemeData(
        brightness: Brightness.dark,
      ),
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        key: _scaffoldKey,
        drawer: Drawer(
            child: ListView(
          children: <Widget>[
            const DrawerHeader(
              decoration: BoxDecoration(color: Colors.orange),
              child: Text("DRAWER HEADER.."),
            ),
            ListTile(
              title: const Text("Room 1"),
              onTap: () {},
            ),
            ListTile(
              title: const Text("Room 2"),
              onTap: () {},
            ),
          ],
        )),
        body: SafeArea(
          child: StreamBuilder(
              builder: (context, snapshot) {
                if (snapshot.hasData &&
                    !snapshot.hasError &&
                    snapshot.data?.snapshot != null) {
                  // Create a SensorData object from the map

                  final jsonData = jsonEncode(snapshot.data!.snapshot.value);

                  var sensorData = SensorData.fromJson(jsonDecode(jsonData));

                  return Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(18.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            GestureDetector(
                              onTap: () {
                                _scaffoldKey.currentState?.openDrawer();
                              },

                              child: Icon(
                                Icons.clear_all,
                                color: !value ? Colors.white : Colors.yellow,
                              ),
                              // ),
                            ),
                            const Text("MY ROOM",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold)),

                            Icon(
                              Icons.settings,
                              color: !value ? Colors.white : Colors.yellow,
                            ),
                            // ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text("Temperature",
                                    style: TextStyle(
                                        color: !value
                                            ? Colors.white
                                            : Colors.yellow,
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold)),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text("${sensorData.temperature}°C",
                                    style: const TextStyle(
                                        color: Colors.white, fontSize: 20)),
                              ),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text("Humidity",
                                style: TextStyle(
                                    color:
                                        !value ? Colors.white : Colors.yellow,
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold)),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text("${sensorData.humidity}%",
                                style: const TextStyle(
                                    color: Colors.white, fontSize: 20)),
                          ),
                        ],
                      ),
                      const SizedBox(height: 80),
                      Padding(
                        padding: const EdgeInsets.all(18.0),
                        child: FloatingActionButton.extended(
                          icon: value
                              ? const Icon(Icons.visibility)
                              : const Icon(Icons.visibility_off),
                          backgroundColor: value ? Colors.yellow : Colors.white,
                          label: value ? const Text("ON") : const Text("OFF"),
                          elevation: 20.00,
                          onPressed: () {
                            onUpdate();
                            writeData();
                          },
                        ),
                      ),
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