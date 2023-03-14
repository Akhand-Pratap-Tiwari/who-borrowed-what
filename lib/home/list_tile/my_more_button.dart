import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class MyMoreButton extends StatefulWidget {
  final String docId;

  const MyMoreButton({
    super.key,
    required this.docId,
  });

  @override
  State<MyMoreButton> createState() => _MyMoreButtonState();
}

class _MyMoreButtonState extends State<MyMoreButton>
    with TickerProviderStateMixin {
  bool finalActionStarted = false;
  late AnimationController controller;
  double borderRadius = 8;
  ValueNotifier<String> loadingState = ValueNotifier('idle');
  Widget setFinalAndShowLoad() {
    finalActionStarted = true;
    return const Padding(
      padding: EdgeInsets.all(8.0),
      child: CircularProgressIndicator(),
    );
  }

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
        color: Colors.white,
      ),
      duration: const Duration(milliseconds: 250),
      child: ValueListenableBuilder(
        builder: (BuildContext context, state, Widget? child) {
          if (state == 'restoring') {
            if (!finalActionStarted) {
              FirebaseFirestore.instance
                  .collection('headaches')
                  .doc(widget.docId)
                  .update({'resolved': false});
            }
            return setFinalAndShowLoad();
          }
          if (state == 'deleting') {
            controller.forward(from: controller.value);
            return AnimatedBuilder(
              animation: controller,
              builder: (context, child) {
                if (controller.isCompleted || finalActionStarted) {
                  if (!finalActionStarted) {
                    FirebaseFirestore.instance
                        .collection('headaches')
                        .doc(widget.docId)
                        .delete();
                  }
                  return setFinalAndShowLoad();
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
                      controller
                        ..reset()
                        ..stop();
                      loadingState.value = 'idle';
                      borderRadius = 8;
                    });
                  },
                );
              },
            );
          } else {
            return PopupMenuButton(
              onSelected: (value) {
                if (value == 'restore') {
                  setState(() {
                    loadingState.value = 'restoring';
                    borderRadius = 32;
                  });
                } else {
                  setState(() {
                    loadingState.value = 'deleting';
                    borderRadius = 32;
                  });
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
            );
          }
        },
        valueListenable: loadingState,
      ),
    );
  }
}
