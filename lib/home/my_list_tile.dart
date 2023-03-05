import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'headache_class.dart';

class MyListTile extends StatelessWidget {
  final Headache headache;
  final String docId;
  final bool resolved;
  const MyListTile({super.key, required this.headache, required this.docId, required this.resolved});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
      tileColor: Colors.deepPurple,
      isThreeLine: true,
      title: Text(headache.itemName),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text('${headache.borrowerName} • ${headache.roomNo}'),
          Text(
              '${headache.formattedDate()} • ${headache.formattedTime(context)}'),
        ],
      ),
      leading: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: const [
          InkWell(
            child: CircleAvatar(
              child: Icon(Icons.call),
            ),
          ),
        ],
      ),
      trailing: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          InkResponse(
            onTap: (){
            },
            child: Container(
              padding: EdgeInsets.all(8),
              decoration: BoxDecoration(borderRadius: BorderRadius.circular(8), color: Colors.amber),
              child: resolved ? Icon(
                Icons.repeat_sharp,
                color: Colors.teal,
              ) : Icon(
                Icons.done_rounded,
                color: Colors.teal,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
