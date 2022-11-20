import 'package:entracer/services/auth.dart';
import 'package:entracer/view/widgets/designSet.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:velocity_x/velocity_x.dart';
import 'stats.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  Widget signOut() {
    return IconButton(
        onPressed: () async {
          try {
            await Auth().logout();
          } on FirebaseAuthException catch (e) {
            print(e.message);
          }
        },
        icon: const Icon(
          Icons.logout,
          color: Vx.green400,
          size: 30,
        ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: DesignSet.appName(),
        elevation: 0,
        actions: [
          signOut(),
        ],
      ),
      body: Stats(),
    );
  }
}
