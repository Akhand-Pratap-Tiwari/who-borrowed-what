import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_ui_firestore/firebase_ui_firestore.dart';
import 'package:flutter/material.dart';
import 'package:who_borrowed_what/home/sort.dart';
import 'list_tile/my_list_tile.dart';
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
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: AnimatedContainer(
            height: 46,
            // color: Colors.red,
            curve: Curves.elasticInOut,
            width: width,
            duration: const Duration(seconds: 1),
            child: Row(
              children: [
                Flexible(child: MySearchField(homeState: this)),
                const SizedBox(width: 10),
                const MySort(),
                // MyDropDownTitle(showResolved: showResolved)
              ],
            ),
          ),
          centerTitle: true,
          bottom: TabBar(
          labelColor: Colors.blueGrey.shade300,
            indicatorColor: Colors.blueGrey.shade300,
            onTap: (value) {
              if (value == 0) {
                showResolved.value = false;
                currentQuery.value = qb.replace(wheres: {
                  'rwc': Where(field: 'resolved', isEqualTo: false)
                });
              } else {
                showResolved.value = true;
                currentQuery.value = qb.replace(
                    wheres: {'rwc': Where(field: 'resolved', isEqualTo: true)});
              }
            },
            tabs:  const [
              Tab(
                icon: Icon(Icons.warning_rounded, color: Colors.orangeAccent,),
                text: 'Current',
              ),
              Tab(
                icon: Icon(Icons.done_all_rounded, color: Colors.green,),
                text: 'History',
              )
            ],
          ),
        ),
        body: SafeArea(
          child: ValueListenableBuilder(
            valueListenable: currentQuery,
            builder: (BuildContext context, Query<Headache> currentQueryValue,
                Widget? child) {
              return FirestoreListView(
                findChildIndexCallback: (key, snapshot) {
                  final valueKey = key as ValueKey;
                  final index = snapshot.docs
                      .indexWhere((element) => element.id == valueKey.value);
                  if (index == -1) return null;
                  return index;
                },
                padding: const EdgeInsets.all(16),
                query: currentQueryValue,
                errorBuilder: (context, error, stackTrace) => Center(
                  child: Text(
                    'Operation failed with $error',
                    style: const TextStyle(color: Colors.red),
                  ),
                ),
                emptyBuilder: (context) => SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(32),
                          child: Image.asset('assets/error.gif'),
                        ),
                        const SizedBox(height: 20),
                        const Text(
                          'We Found Nothing. Reset the search.',
                          style: TextStyle(color: Colors.red),
                        ),
                      ],
                    ),
                  ),
                ),
                itemBuilder: (context, doc) {
                  Headache headache = doc.data();
                  return Padding(
                    key: ValueKey(doc.id),
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: showResolved.value
                        ? MyListTile.resolved(
                            headache: headache,
                            docId: doc.id,
                          )
                        : MyListTile.unResolved(
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
      ),
    );
  }
}
