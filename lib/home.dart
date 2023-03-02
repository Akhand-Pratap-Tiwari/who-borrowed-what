import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_ui_firestore/firebase_ui_firestore.dart';
import 'package:flutter/material.dart';

import 'input_headache.dart';

class Headache {
  String itemName, borrowerName, roomNo;
  String? regNo, phoneNo;
  DateTime dateTime;
  String _formattedDate() {
    return '${dateTime.day < 10 ? '0' : ''}${dateTime.day}-${dateTime.month < 10 ? '0' : ''}${dateTime.month}-${dateTime.year}';
  }

  String _formattedTime(context) {
    var timeOfDay = TimeOfDay(hour: dateTime.hour, minute: dateTime.minute);
    return timeOfDay.format(context);
  }

  Headache({
    required this.itemName,
    required this.borrowerName,
    required this.roomNo,
    required this.dateTime,
    this.regNo,
    this.phoneNo,
  });

  factory Headache.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> snapshot,
    SnapshotOptions? options,
  ) {
    final data = snapshot.data();
    Timestamp timestamp = data?['dateTime'];
    return Headache(
      itemName: data?['itemName'],
      borrowerName: data?['borrowerName'],
      dateTime: timestamp.toDate(),
      roomNo: data?['roomNo'],
      phoneNo: data?['phoneNo'],
      regNo: data?['regNo'],
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      "itemName": itemName,
      "borrowerName": borrowerName,
      "dateTime": dateTime,
      "roomNo": roomNo,
      if (phoneNo != null) "phoneNo": phoneNo,
      if (regNo != null) "regNo": regNo,
    };
  }

  display() {
    debugPrint('Debug: $itemName $borrowerName $roomNo $dateTime');
    debugPrint(
        'Debug: ${regNo == '' || regNo == null ? 'null/empty' : regNo} ${phoneNo == '' || phoneNo == null ? 'null/empty' : phoneNo}');
  }
}

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  void _addHeadacheScreen() {
    Navigator.of(context).push(MaterialPageRoute(
      builder: (context) {
        return const InputScreen();
      },
    ));
  }

  final usersQuery =
      FirebaseFirestore.instance.collection('headaches').withConverter(
            fromFirestore: Headache.fromFirestore,
            toFirestore: (value, options) => value.toFirestore(),
          );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: const [
            InkWell(
              onTap: null,
              child: CircleAvatar(child: Icon(Icons.filter_alt_rounded)),
            ),
            Text('Current Headaches'),
            InkWell(
              onTap: null,
              child: CircleAvatar(child: Icon(Icons.sort)),
            ),
          ],
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: FirestoreListView(
            query: usersQuery,
            itemBuilder: (context, snapshot) {
              Headache headache = snapshot.data();
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: ListTile(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0)),
                  tileColor: Colors.deepPurple,
                  isThreeLine: true,
                  title: Text(headache.itemName),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text('${headache.borrowerName} • ${headache.roomNo}'),
                      Text('${headache._formattedDate()} • ${headache._formattedTime(context)}'),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addHeadacheScreen,
        child: const Icon(Icons.add_box_rounded),
      ),
    );
  }
}
