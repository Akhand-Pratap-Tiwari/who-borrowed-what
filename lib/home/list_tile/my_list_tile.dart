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
                widget._resolved!
                    ? MyMoreButton(docId: widget.docId)
                    : MyTickButton(docId: widget.docId),
              ],
            ),
    );
  }
}

class MyMoreButton extends StatefulWidget {
  final String docId;

  const MyMoreButton({
    super.key,
    required this.docId,
  });

  @override
  State<MyMoreButton> createState() => _MyMoreButtonState();
}

class _MyMoreButtonState extends State<MyMoreButton> with TickerProviderStateMixin {
  bool finalActionStarted = false;
  late AnimationController controller;
  double borderRadius = 8;
  ValueNotifier<String> loadingState = ValueNotifier('idle');
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
        builder: (BuildContext context, state, Widget? child) {
          if (state == 'restoring') {
            if(!finalActionStarted) {
              Future.delayed(
              const Duration(seconds: 5),
              () async {
                await FirebaseFirestore.instance
                    .collection('headaches')
                    .doc(widget.docId)
                    .update({'resolved': false});
              },
            );
            }
            finalActionStarted = true;
            return const Padding(
              padding: EdgeInsets.all(8.0),
              child: CircularProgressIndicator(),
            );
          }
          if (state == 'deleting') {
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
                        .delete(),
                  );
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
                      loadingState.value = 'idle';
                      borderRadius = 8;
                    });
                  },
                );
              },
            );
          } else {
            return PopupMenuButton(
              onSelected: (value) async {
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
