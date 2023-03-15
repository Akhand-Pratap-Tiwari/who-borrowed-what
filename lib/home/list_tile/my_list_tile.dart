import 'dart:math';

import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

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

class _MyListTileState extends State<MyListTile> {
  _makeCall(Uri uri) async {
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    } else {
      throw 'Could not launch $uri';
    }
  }

  @override
  Widget build(BuildContext context) {
    bool isDark = MediaQuery.of(context).platformBrightness == Brightness.dark
        ? true
        : false;
    return Ink(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16.0),
          gradient: LinearGradient(
            colors: (widget._resolved ?? true)
                ? [Colors.indigoAccent, Colors.blue]
                : [Colors.pinkAccent, Colors.purple],
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
          )
          // color: Colors.black
          ),
      child: GestureDetector(
        onLongPressStart: (details) {
          var l = details.globalPosition.dx;
          var r = MediaQuery.of(context).size.width - l;
          var t = details.globalPosition.dy;

          var info = [];
          if (widget.headache.regNo != '' && 
              widget.headache.regNo != null) {
            info.add('Reg. No: ${widget.headache.regNo!}');
          }
          if (widget.headache.phoneNo != '' &&
              widget.headache.phoneNo != null) {
            info.add('Phone: ${widget.headache.phoneNo!}');
          }
          showMenu(
            constraints: BoxConstraints.loose(Size.fromWidth(125)),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16)),
              useRootNavigator: true,
              context: context,
              position: RelativeRect.fromLTRB(l, t, r, 0),
              items: info.isEmpty
                  ? [
                      const PopupMenuItem(
                          child: Center(
                        child: Text(
                          'Nothing Here',
                          style: TextStyle(color: Colors.red),
                        ),
                      ))
                    ]
                  : List.generate(info.length,
                      (index) => PopupMenuItem(child: Text(info[index]))));
        },
        child: ListTile(
          textColor: Colors.white,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.0)),
          tileColor: Colors.transparent,
          isThreeLine: true,
          title: Text(widget.headache.itemName),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                  '${widget.headache.borrowerName} • ${widget.headache.roomNo}'),
              Text(
                  '${widget.headache.formattedDate()} • ${widget.headache.formattedTime(context)}'),
            ],
          ),
          leading: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              InkResponse(
                onTap: () {
                  widget.headache.phoneNo != null &&
                          widget.headache.phoneNo != ''
                      ? _makeCall(
                          Uri(scheme: 'tel', path: widget.headache.phoneNo))
                      : null;
                },
                child: CircleAvatar(
                  backgroundColor: isDark ? Colors.black : Colors.white,
                  child: widget.headache.phoneNo == null ||
                          widget.headache.phoneNo == ''
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
        ),
      ),
    );
  }
}
