import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../headache_class.dart';

class MyListTile extends StatefulWidget {
  final String docId;
  final Headache headache;
  final bool? _resolved;

  const MyListTile.resolved({
    super.key,
    required this.headache,
    required this.docId,
  }) : _resolved = true;

  const MyListTile.unResolved({
    super.key,
    required this.headache,
    required this.docId,
  }) : _resolved = false;

  const MyListTile({
    super.key,
    required this.headache,
    required this.docId,
  }) : _resolved = null;

  @override
  State<MyListTile> createState() => _MyListTileState();
}

class _MyListTileState extends State<MyListTile> {
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
      trailing: widget._resolved == null
          ? null
          : Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                AnimatedContainer(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(borderRadius),
                      color: Colors.amber),
                  duration: const Duration(milliseconds: 250),
                  child: (isLoading)
                      ? const Padding(
                          padding: EdgeInsets.all(8.0),
                          child: CircularProgressIndicator(),
                        )
                      : widget._resolved!
                          ? PopupMenuButton(
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
                                    const Duration(seconds: 5),
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
                                await Future.delayed(const Duration(seconds: 5),() async => await FirebaseFirestore.instance
                                    .collection('headaches')
                                    .doc(widget.docId)
                                    .update({
                                  'resolved': true
                                }) 
                                );
                              }),
                ),
              ],
            ),
    );
  }
}
