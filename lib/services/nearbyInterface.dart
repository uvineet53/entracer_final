// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';
// import 'package:nearby_connections/nearby_connections.dart';

// import 'auth.dart';

// class NearbyInterface extends StatefulWidget {
//   static const String id = 'nearby_interface';

//   @override
//   _NearbyInterfaceState createState() => _NearbyInterfaceState();
// }

// class _NearbyInterfaceState extends State<NearbyInterface> {
//   // Location location = Location();
//   FirebaseFirestore _firestore = FirebaseFirestore.instance;
//   final Strategy strategy = Strategy.P2P_STAR;

//   String testText = '';

//   List<dynamic> contactTraces = [];
//   List<dynamic> contactTimes = [];
//   List<dynamic> contactLocations = [];

//   void addContactsToList() async {
//     _firestore
//         .collection('users')
//         .doc(Auth().currentUser?.email)
//         .collection('met_with')
//         .snapshots()
//         .listen((snapshot) {
//       for (var doc in snapshot.docs) {
//         String currUsername = doc.data()['username'];
//         DateTime? currTime = doc.data().containsKey('contact time')
//             ? (doc.data()['contact time'] as Timestamp).toDate()
//             : null;
//         String currLocation = doc.data().containsKey('contact location')
//             ? doc.data()['contact location']
//             : null;

//         if (!contactTraces.contains(currUsername)) {
//           contactTraces.add(currUsername);
//           contactTimes.add(currTime);
//           contactLocations.add(currLocation);
//         }
//       }
//       setState(() {});
//     });
//   }

//   void deleteOldContacts(int threshold) async {
//     DateTime timeNow = DateTime.now(); //get today's time

//     _firestore
//         .collection('users')
//         .doc(Auth().currentUser?.email)
//         .collection('met_with')
//         .snapshots()
//         .listen((snapshot) {
//       for (var doc in snapshot.docs) {
//         if (doc.data().containsKey('contact time')) {
//           DateTime contactTime =
//               (doc.data()['contact time'] as Timestamp).toDate();
//           if (timeNow.difference(contactTime).inDays > threshold) {
//             doc.reference.delete();
//           }
//         }
//       }
//     });

//     setState(() {});
//   }

//   void discovery() async {
//     try {
//       bool a = await Nearby()
//           .startDiscovery(Auth().currentUser!.email!, strategy,
//               onEndpointFound: (id, name, serviceId) async {
//         var docRef =
//             _firestore.collection('users').doc(Auth().currentUser!.email!);
//         docRef.collection('met_with').doc(name).set({
//           'email': name,
//           'contact time': DateTime.now(),
//           'contact location': "location",
//         });
//       }, onEndpointLost: (id) {
//         print(id);
//       });
//       print('DISCOVERING: ${a.toString()}');
//     } catch (e) {
//       print(e);
//     }
//   }

//   void getPermissions() {
//     Nearby().askLocationAndExternalStoragePermission();
//   }

//   @override
//   void initState() {
//     super.initState();
//     deleteOldContacts(14);
//     addContactsToList();
//     getPermissions();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         leading: Icon(
//           Icons.menu,
//           color: Colors.deepPurple[800],
//         ),
//         centerTitle: true,
//         title: Text(
//           'TracerX',
//           style: TextStyle(
//             color: Colors.deepPurple[800],
//             fontWeight: FontWeight.bold,
//             fontSize: 28.0,
//           ),
//         ),
//         backgroundColor: Colors.white,
//       ),
//       body: Column(
//         children: <Widget>[
//           Padding(
//             padding: EdgeInsets.only(bottom: 30.0),
//             child: MaterialButton(
//               shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(20.0)),
//               elevation: 5.0,
//               color: Colors.deepPurple[400],
//               onPressed: () async {
//                 try {
//                   bool a = await Nearby().startAdvertising(
//                     Auth().currentUser!.email!,
//                     strategy,
//                     onConnectionInitiated: (id, info) {
//                       print(id);
//                     },
//                     onConnectionResult: (id, status) {
//                       print(status);
//                     },
//                     onDisconnected: (id) {
//                       print('Disconnected $id');
//                     },
//                   );

//                   print('ADVERTISING ${a.toString()}');
//                 } catch (e) {
//                   print(e);
//                 }

//                 discovery();
//               },
//               child: Text(
//                 'Start Tracing',
//               ),
//             ),
//           ),
//           Expanded(
//             flex: 2,
//             child: Padding(
//               padding: EdgeInsets.symmetric(horizontal: 25.0),
//               child: ListView.builder(
//                 itemBuilder: (context, index) {
//                   return ContactCard(
//                     imagePath: 'images/profile1.jpg',
//                     email: contactTraces[index],
//                     infection: 'Not-Infected',
//                     contactUsername: contactTraces[index],
//                     contactTime: contactTimes[index],
//                     contactLocation: contactLocations[index],
//                   );
//                 },
//                 itemCount: contactTraces.length,
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

// // TODO: Take mobile number instead of email

// // TODO: Delete contacts older than 14 days from database