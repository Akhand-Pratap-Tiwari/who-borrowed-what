import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../headache_class.dart';

class MyListTileRes extends StatefulWidget {
  final Headache headache;
  final String docId;

  const MyListTileRes({
    super.key,
    required this.headache,
    required this.docId,
  });

  @override
  State<MyListTileRes> createState() => _MyListTileResState();
}

class _MyListTileResState extends State<MyListTileRes> {
  bool isLoading = false;

  double borderRadius = 8;

  @override
  Widget build(BuildContext context) {
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
            child: isLoading
                ? const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: CircularProgressIndicator())
                : PopupMenuButton(
                    onSelected: (value) async {
                      setState(() {
                        isLoading = true;
                        borderRadius = 32;
                      });
                      if (value == 'restore') {
                        await FirebaseFirestore.instance
                            .collection('headaches')
                            .doc(widget.docId)
                            .update({'resolved': false});
                      } else {
                        await Future.delayed(
                          Duration(seconds: 5),
                          () async => await FirebaseFirestore.instance
                              .collection('headaches')
                              .doc(widget.docId)
                              .delete(),
                        );
                      }
                    },
                    itemBuilder: (BuildContext popUpContext) => [
                      const PopupMenuItem(
                        value: 'restore',
                        child: Text('Restore'),
                      ),
                      const PopupMenuItem(
                        value: 'delete',
                        child: Text(
                          'Delete',
                          style: TextStyle(color: Colors.red),
                        ),
                      )
                    ],
                    icon: const Icon(
                      Icons.more_vert_rounded,
                      color: Colors.teal,
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}
