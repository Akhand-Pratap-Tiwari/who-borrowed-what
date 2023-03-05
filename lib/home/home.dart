import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_ui_firestore/firebase_ui_firestore.dart';
import 'package:flutter/material.dart';
import 'package:who_borrowed_what/home/my_list_tile.dart';
import 'package:who_borrowed_what/home/sort.dart';

import '../input_headache.dart';
import 'headache_class.dart';
import 'search_field.dart';
import 'user_queries_class.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  bool showResolved = false;
  void _addHeadacheScreen() {
    Navigator.of(context).push(MaterialPageRoute(
      builder: (context) {
        return const InputScreen();
      },
    ));
  }

  final usersQuery = FirebaseFirestore.instance
      .collection('headaches')
      .withConverter(
        fromFirestore: Headache.fromFirestore,
        toFirestore: (value, options) => value.toFirestore(),
      )
      .orderBy('dateTime', descending: true);

  double width = 200;
  double minWidth = 200;
  changeWidth() {
    width =
        width == minWidth ? MediaQuery.of(context).size.width - 16 : minWidth;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: PopupMenuButton(
              child: Icon(Icons.more_vert),
              itemBuilder: (context) => [
                PopupMenuItem(
                  onTap: (){
                    showResolved = showResolved ? false : true; 
                    if(showResolved){
                      currentQuery.value = qb.replace(wheres: {'rwc':Where(field: 'resolved', isEqualTo: true)});
                    }
                    else{
                      currentQuery.value = qb.replace(wheres: {'rwc':Where(field: 'resolved', isEqualTo: false)});
                    }
                  },
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: !showResolved
                        ? [Icon(Icons.done_all_rounded), Text('  Show Resolved')]
                        : [Icon(Icons.flag_rounded), Text('  Show UnResolved')],
                  ),
                )
              ],
            ),
          )
        ],
        title: const Text('Current Headaches'),
        centerTitle: true,
        bottom: Tab(
          child: AnimatedContainer(
            // color: Colors.red,
            curve: Curves.elasticInOut,
            width: width,
            duration: const Duration(milliseconds: 1000),
            child: Row(
              children: [
                Flexible(child: MySearchField(homeState: this)),
                const SizedBox(
                  width: 10,
                ),
                const MySort(),
              ],
            ),
          ),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
          child: ValueListenableBuilder(
            valueListenable: currentQuery,
            builder: (BuildContext context, Query<Headache> currentQueryValue,
                Widget? child) {
              return FirestoreListView(
                query: currentQueryValue,
                errorBuilder: (context, error, stackTrace) => Center(
                  child: Text(
                    'Operation failed with $error',
                    style: TextStyle(color: Colors.red),
                  ),
                ),
                emptyBuilder: (context) => Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: Image.asset('assets/error.gif'),
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      'We Found Nothing',
                      style: TextStyle(color: Colors.red),
                    ),
                  ],
                ),
                itemBuilder: (context, snapshot) {
                  Headache headache = snapshot.data();
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: MyListTile(
                      resolved: snapshot.get('resolved'),
                      headache: headache,
                      docId: snapshot.id,
                    ),
                  );
                },
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
