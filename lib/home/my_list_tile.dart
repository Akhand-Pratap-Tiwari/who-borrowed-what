import 'package:flutter/material.dart';

import 'headache_class.dart';

class MyListTile extends StatelessWidget {
  final Headache headache;
  const MyListTile({super.key, required this.headache});

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
        children: const [
          InkWell(
              child: IconButton(
            icon: Icon(Icons.done_outline_rounded),
            onPressed: null,
          )),
        ],
      ),
    );
  }
}
