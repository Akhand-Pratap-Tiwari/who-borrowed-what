import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class MyTickButton extends StatefulWidget {
  final String docId;
  const MyTickButton({super.key, required this.docId});

  @override
  State<MyTickButton> createState() => _MyTickButtonState();
}

class _MyTickButtonState extends State<MyTickButton>
    with TickerProviderStateMixin {
  bool finalActionStarted = false;
  late AnimationController controller;
  double borderRadius = 8;
  ValueNotifier isLoading = ValueNotifier(false);

  @override
  void initState() {
    controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 5),
    );
    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(borderRadius),
          color: Colors.amber),
      duration: const Duration(milliseconds: 250),
      child: ValueListenableBuilder(
        valueListenable: isLoading,
        builder: (context, loading, child) {
          if (!loading) {
            return IconButton(
                icon: const Icon(
                  Icons.done_rounded,
                  color: Colors.teal,
                ),
                onPressed: () {
                  setState(() {
                    isLoading.value = true;
                    borderRadius = 32;
                  });
                });
          } else {
            controller.forward(from: controller.value);
            return AnimatedBuilder(
              animation: controller,
              builder: (context, child) {
                if (controller.isCompleted || finalActionStarted) {
                  if(!finalActionStarted) {
                    Future.delayed(
                      const Duration(seconds: 5),
                      () async => await FirebaseFirestore.instance
                          .collection('headaches')
                          .doc(widget.docId)
                          .update({'resolved': true}));
                  }
                  finalActionStarted = true;
                  return const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: CircularProgressIndicator(),
                  );
                }

                return IconButton(
                  icon: Stack(
                    alignment: Alignment.center,
                    children: [
                      const Icon(
                        Icons.cancel_rounded,
                        color: Colors.red,
                      ),
                      CircularProgressIndicator(
                        value: 1 - controller.value,
                        color: Colors.red,
                      )
                    ],
                  ),
                  onPressed: () {
                    setState(() {
                      controller..reset()..stop();
                      isLoading.value = false;
                      borderRadius = 8;
                    });
                  },
                );
              },
            );
          }
        },
      ),
    );
  }
}
