import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'input_headache.dart';

class Headache {
  String itemName, borrowerName, roomNo;
  String? regNo, phoneNo;
  DateTime dateTime;

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
    return Headache(
      itemName: data?['itemName'],
      borrowerName: data?['borrowerName'],
      dateTime: data?['dateTime'],
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

  display(){
    debugPrint('Debug: $itemName $borrowerName $roomNo $dateTime');
    debugPrint('Debug: ${regNo == '' || regNo == null ? 'null/empty' : regNo} ${phoneNo == '' || phoneNo == null ? 'null/empty' : phoneNo}');
  }
}

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  void _addHeadacheScreen() {
    Navigator.of(context).push(MaterialPageRoute(builder: (context) {
      return const InputScreen();
    },));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Current Headaches'),
        centerTitle: true,
      ),
      body: const Text('Test Text'),
      floatingActionButton: FloatingActionButton(
        onPressed: _addHeadacheScreen,
        child: const Icon(Icons.add_box_rounded),
      ),
    );
  }
}
