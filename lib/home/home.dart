import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_ui_firestore/firebase_ui_firestore.dart';
import 'package:flutter/material.dart';
import 'package:who_borrowed_what/home/my_list_tile.dart';
import 'package:who_borrowed_what/home/sort.dart';

import '../input_headache.dart';
import 'headache_class.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  double _width = 135;

  void _addHeadacheScreen() {
    Navigator.of(context).push(MaterialPageRoute(
      builder: (context) {
        return const InputScreen();
      },
    ));
  }

  animateTrigger() {
    setState(() {
      _width = _width == 135 ? 300 : 135;
    });
  }

  final usersQuery =
      FirebaseFirestore.instance.collection('headaches').withConverter(
            fromFirestore: Headache.fromFirestore,
            toFirestore: (value, options) => value.toFirestore(),
          ).orderBy('dateTime', descending: true);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Current Headaches'),
        centerTitle: true,
        bottom: Tab(
          child: AnimatedContainer(
            curve: Curves.elasticInOut,
            width: _width,
            duration: const Duration(milliseconds: 1000),
            child: ListTile(
              trailing: const MySort(),
              title: TextField(
                maxLines: 1,
                onTapOutside: (event) => FocusManager.instance.primaryFocus!.unfocus(),
                textAlignVertical: TextAlignVertical.center,
                decoration: InputDecoration(
                  prefixIcon: IconButton(
                    icon: const Icon(Icons.search_rounded),
                    onPressed: () => animateTrigger(),
                  ),
                  contentPadding:
                      const EdgeInsets.symmetric(vertical: 8, horizontal: 15),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(40)),
                ),
              ),
            ),
          ),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
          child: FirestoreListView(
            query: usersQuery,
            itemBuilder: (context, snapshot) {
              Headache headache = snapshot.data();
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: MyListTile(headache: headache),
              );
            },
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addHeadacheScreen,
        child: const Icon(Icons.add_box_rounded),
      ),
    );
  }
}
