import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_ui_firestore/firebase_ui_firestore.dart';
import 'package:flutter/material.dart';
import 'package:who_borrowed_what/home/list_tile/my_list_tile_unres.dart';
import 'package:who_borrowed_what/home/sort.dart';

import '../input_headache.dart';
import 'headache_class.dart';
import 'list_tile/my_list_tile_res.dart';
import 'my_drop_down_title.dart';
import 'search_field.dart';
import 'user_queries_class.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  ValueNotifier<bool> showResolved = ValueNotifier(false);
  void _inputHeadacheScreen() {
    Navigator.of(context).push(MaterialPageRoute(
      builder: (context) {
        return const InputScreen();
      },
    ));
  }

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
        title:  MyDropDownTitle(showResolved: showResolved),
        centerTitle: true,
        bottom: Tab(
          // height: 48,
          child: AnimatedContainer(
            // color: Colors.red,
            curve: Curves.elasticInOut,
            width: width,
            duration: const Duration(milliseconds: 1000),
            child: Row(
              children: [
                Flexible(child: MySearchField(homeState: this)),
                const SizedBox(width: 10),
                const MySort(),
                // MyDropDownTitle(showResolved: showResolved)
              ],
            ),
          ),
        ),
      ),
      body: SafeArea(
        child: ValueListenableBuilder(
          valueListenable: currentQuery,
          builder: (BuildContext context, Query<Headache> currentQueryValue,
              Widget? child) {
            // debugPrint('Debug1: Rebiult');
            return FirestoreListView(
              findChildIndexCallback: (key, snapshot) {
                final valueKey = key as ValueKey;
                final index = snapshot.docs.indexWhere((element) => element.id == valueKey.value);
                if (index == -1) return null;
                debugPrint('Debug1:'+index.toString());
                return index;
              },
              padding: EdgeInsets.all(16),
              query: currentQueryValue,
              errorBuilder: (context, error, stackTrace) => Center(
                child: Text(
                  'Operation failed with $error',
                  style: const TextStyle(color: Colors.red),
                ),
              ),
              emptyBuilder: (context) => Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(32),
                    child: Image.asset('assets/error.gif'),
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    'We Found Nothing',
                    style: TextStyle(color: Colors.red),
                  ),
                ],
              ),
              itemBuilder: (context, doc) {
                Headache headache = doc.data();
                return Padding(
                  key: ValueKey(doc.id),
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: showResolved.value
                      ? MyListTileRes(
                          headache: headache,
                          docId: doc.id,
                        )
                      : MyListTileUnres(
                          headache: headache,
                          docId: doc.id,
                        ),
                );
              },
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _inputHeadacheScreen,
        child: const Icon(Icons.add_box_rounded),
      ),
    );
  }
}
