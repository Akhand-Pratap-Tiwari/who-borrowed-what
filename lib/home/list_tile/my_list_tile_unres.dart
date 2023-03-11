import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../headache_class.dart';

class MyListTileUnres extends StatefulWidget {
  final Headache headache;
  final String docId;

  const MyListTileUnres({
    super.key,
    required this.headache,
    required this.docId,
  });

  @override
  State<MyListTileUnres> createState() => _MyListTileUnresState();
}

class _MyListTileUnresState extends State<MyListTileUnres> {
  bool isLoading = false;
  double borderRadius = 8;

  @override
  Widget build(BuildContext context) {
    debugPrint('Debug1: ${widget.key}');
    return ListTile(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
      tileColor: Colors.deepPurple,
      isThreeLine: true,
      title: Text(widget.headache.itemName),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text('${widget.headache.borrowerName} • ${widget.headache.roomNo}'),
          Text(
              '${widget.headache.formattedDate()} • ${widget.headache.formattedTime(context)}'),
        ],
      ),
      leading: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: const [
          CircleAvatar(
            child: Icon(Icons.call),
          ),
        ],
      ),
      trailing: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          AnimatedContainer(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(borderRadius),
                color: Colors.amber),
            duration: Duration(milliseconds: 250),
            child: (isLoading)
                ? const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: CircularProgressIndicator(),
                  )
                : IconButton(
                    icon: const Icon(
                      Icons.done_rounded,
                      color: Colors.teal,
                    ),
                    onPressed: () async {
                      setState(() {
                        isLoading = true;
                        borderRadius = 32;
                      });
                      await FirebaseFirestore.instance
                          .collection('headaches')
                          .doc(widget.docId)
                          .update({
                        'resolved': true
                      }); //TODO:Remove Future delayed at the end and set anim durations
                      //TODO: Add collapsible button and option to calcel operations
                    }),
          ),
        ],
      ),
    );
  }
}
