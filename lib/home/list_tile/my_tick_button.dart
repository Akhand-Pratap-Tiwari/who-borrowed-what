import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class MyTickButton extends StatefulWidget {
  final String docId;
  const MyTickButton({super.key, required this.docId});

  @override
  State<MyTickButton> createState() => _MyTickButtonState();
}

class _MyTickButtonState extends State<MyTickButton> {
  double borderRadius = 8;
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(borderRadius),
        color: Colors.white,
      ),
      duration: const Duration(milliseconds: 250),
      child: isLoading
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
                await Future.delayed(
                    const Duration(seconds: 5),
                    () async => await FirebaseFirestore.instance
                        .collection('headaches')
                        .doc(widget.docId)
                        .update({'resolved': true}));
              }),
    );
  }
}
