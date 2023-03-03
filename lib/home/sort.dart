import 'package:flutter/material.dart';

class MySort extends StatelessWidget {
  const MySort({super.key});

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton(
      offset: Offset(100, 0),
        itemBuilder: (context) => [
              PopupMenuItem(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextButton.icon(onPressed: (){print('');}, icon: Icon(Icons.arrow_upward_rounded), label: Text('Sort By New')),
                    TextButton.icon(onPressed: null, icon: Icon(Icons.arrow_downward_rounded), label: Text('Sort By Old')),
                  ],
                ),
              )
            ],
        child: CircleAvatar(child: Icon(Icons.sort)));
  }
}
