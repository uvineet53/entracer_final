import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:entracer/view/widgets/statsWidget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:location/location.dart';
import 'package:lottie/lottie.dart';
import 'package:nearby_connections/nearby_connections.dart';
import 'package:velocity_x/velocity_x.dart';

import '../../services/auth.dart';
import '../widgets/contactCards.dart';

class Stats extends StatefulWidget {
  Stats({Key? key}) : super(key: key);

  @override
  State<Stats> createState() => _StatsState();
}

class _StatsState extends State<Stats> {
  bool animate = false;
  final Strategy strategy = Strategy.P2P_STAR;
  Location location = Location();

  bool? _serviceEnabled;
  PermissionStatus? _permissionGranted;
  LocationData? _locationData;

  void enableLocation() async {
    _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled!) {
      _serviceEnabled = await location.requestService();
      if (!_serviceEnabled!) {
        return;
      }
    }

    _permissionGranted = await location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await location.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        return;
      }
    }
  }

  List<dynamic> contactTraces = [];
  List<dynamic> contactTimes = [];
  List<dynamic> contactLocations = [];
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  void addContactsToList() async {
    _firestore
        .collection('users')
        .doc(Auth().currentUser?.email)
        .collection('met_with')
        .snapshots()
        .listen((snapshot) {
      for (var doc in snapshot.docs) {
        String email = doc.data()['email'];
        DateTime? currTime = doc.data().containsKey('contact time')
            ? (doc.data()['contact time'] as Timestamp).toDate()
            : null;
        String currLocation = doc.data().containsKey('contact location')
            ? doc.data()['contact location']
            : null;

        if (!contactTraces.contains(email)) {
          contactTraces.add(email);
          contactTimes.add(currTime);
          contactLocations.add(currLocation);
        }
      }
      setState(() {});
    });
  }

  void deleteOldContacts(int threshold) async {
    DateTime timeNow = DateTime.now();

    _firestore
        .collection('users')
        .doc(Auth().currentUser?.email)
        .collection('met_with')
        .snapshots()
        .listen((snapshot) {
      for (var doc in snapshot.docs) {
        if (doc.data().containsKey('contact time')) {
          DateTime contactTime =
              (doc.data()['contact time'] as Timestamp).toDate();
          if (timeNow.difference(contactTime).inDays > threshold) {
            doc.reference.delete();
          }
        }
      }
    });

    setState(() {});
  }

  void discovery() async {
    try {
      bool a = await Nearby()
          .startDiscovery(Auth().currentUser!.email!, strategy,
              onEndpointFound: (id, name, serviceId) async {
        var docRef =
            _firestore.collection('users').doc(Auth().currentUser!.email!);
        _locationData = await location.getLocation();

        docRef.collection('met_with').doc(name).set({
          'email': name,
          'contact time': DateTime.now(),
          'contact location':
              "${_locationData!.latitude},${_locationData!.longitude}",
        });
      }, onEndpointLost: (id) {
        print(id);
      });
      print('DISCOVERING: ${a.toString()}');
    } catch (e) {
      print(e);
    }
  }

  void getPermissions() {
    Nearby().askLocationAndExternalStoragePermission();
  }

  @override
  void initState() {
    super.initState();
    enableLocation();
    deleteOldContacts(14);
    addContactsToList();
    getPermissions();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: VStack(
          [
            statsWidget(
              email: "uvineet53@gmail.com",
              location: "Patiala",
              temp: "98 C",
              oxygen: "98%",
              risk: "Low",
            ).p12(),
            Transform.scale(
              scale: 2,
              child: Lottie.asset(
                "assets/loading.json",
                animate: animate,
                fit: BoxFit.cover,
                width: Get.width * .6,
              ),
            ).marginOnly(top: 10),
            GestureDetector(
                onTap: () async {
                  setState(() {
                    animate = !animate;
                  });
                  try {
                    bool a = await Nearby().startAdvertising(
                      Auth().currentUser!.email!,
                      strategy,
                      onConnectionInitiated: (id, info) {
                        print(id);
                      },
                      onConnectionResult: (id, status) {
                        print(status);
                      },
                      onDisconnected: (id) {
                        print('Disconnected $id');
                      },
                    );

                    print('ADVERTISING ${a.toString()}');
                  } catch (e) {
                    print(e);
                  }
                  discovery();
                },
                child: (animate ? "Stop Scan" : "Start Scan")
                    .text
                    .align(TextAlign.center)
                    .semiBold
                    .xl
                    .green700
                    .make()
                    .box
                    .width(Get.width * .7)
                    .green400
                    .p16
                    .rounded
                    .make()),
            SizedBox(
              height: Get.height * .5,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25.0),
                child: ListView.builder(
                  itemBuilder: (context, index) {
                    return ContactCard(
                      email: contactTraces[index],
                      infection: 'Not-Infected',
                      contactTime: contactTimes[index],
                      contactLocation: contactLocations[index],
                    );
                  },
                  itemCount: contactTraces.length,
                ),
              ),
            )
          ],
          crossAlignment: CrossAxisAlignment.center,
        ),
      ),
    );
  }
}
