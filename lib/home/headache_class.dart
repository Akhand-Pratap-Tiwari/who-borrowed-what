import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Headache {
  String itemName, borrowerName, roomNo;
  String? regNo, phoneNo;
  DateTime dateTime;
  String formattedDate() {
    return '${dateTime.day < 10 ? '0' : ''}${dateTime.day}-${dateTime.month < 10 ? '0' : ''}${dateTime.month}-${dateTime.year}';
  }

  String formattedTime(context) {
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

  // display() {
  //   debugPrint('Debug: $itemName $borrowerName $roomNo $dateTime');
  //   debugPrint(
  //       'Debug: ${regNo == '' || regNo == null ? 'null/empty' : regNo} ${phoneNo == '' || phoneNo == null ? 'null/empty' : phoneNo}');
  // }
}
