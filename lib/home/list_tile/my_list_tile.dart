import 'dart:math';

import 'package:flutter/material.dart';

import '../headache_class.dart';
import 'my_more_button.dart';
import 'my_tick_button.dart';

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

class _MyListTileState extends State<MyListTile> with TickerProviderStateMixin {
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
        children: [
          InkResponse(
            onTap: () {
              
            },
            child: CircleAvatar(
              child:
                  widget.headache.phoneNo == null || widget.headache.phoneNo == ''
                      ? Transform.rotate(
                          angle: -1.5 * pi,
                          child: const Icon(Icons.phone_disabled))
                      : const Icon(Icons.phone),
            ),
          ),
        ],
      ),
      trailing: widget._resolved == null
          ? null
          : Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                widget._resolved!
                    ? MyMoreButton(docId: widget.docId)
                    : MyTickButton(docId: widget.docId),
              ],
            ),
    );
  }
}
