import 'package:flutter/material.dart';
import 'package:location/location.dart';

import 'bottomSheet.dart';

class ContactCard extends StatelessWidget {
  ContactCard(
      {this.email, this.infection, this.contactTime, this.contactLocation});

  final String? email;
  final String? infection;
  final DateTime? contactTime;
  final Location? contactLocation;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3.0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
      child: ListTile(
        trailing: Icon(Icons.more_horiz),
        title: Text(
          email!,
          style: TextStyle(
            color: Colors.deepPurple[700],
            fontWeight: FontWeight.bold,
          ),
        ),
        subtitle: Text(infection!),
        onTap: () => showModalBottomSheet(
            context: context,
            builder: (builder) {
              return Padding(
                padding: EdgeInsets.symmetric(vertical: 50.0, horizontal: 10.0),
                child: Column(
                  children: <Widget>[
                    BottomSheetText(question: 'Email', result: email),
                    SizedBox(height: 5.0),
                    BottomSheetText(
                        question: 'Contact Time',
                        result: contactTime.toString()),
                    SizedBox(height: 5.0),
                    BottomSheetText(
                        question: 'Contact Location',
                        result: contactLocation.toString()),
                    SizedBox(height: 5.0),
                    BottomSheetText(question: 'Times Contacted', result: '3'),
                  ],
                ),
              );
            }),
      ),
    );
  }
}
