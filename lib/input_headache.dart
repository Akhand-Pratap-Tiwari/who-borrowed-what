import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'home/headache_class.dart';

class InputScreen extends StatefulWidget {
  const InputScreen({super.key});

  @override
  State<InputScreen> createState() => _InputScreenState();
}

class _InputScreenState extends State<InputScreen> {
  late Headache headache;
  String itemName = '', borrowerName = '', roomNo = '';
  String? regNo, phoneNo;
  DateTime date = DateTime.now();
  TimeOfDay time = TimeOfDay.now();
  final _dateController = TextEditingController(
      text:
          '${DateTime.now().day}-${DateTime.now().month}-${DateTime.now().year}');
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _pressed = false;
  String? _validator(String? value) {
    return (value == null || value.isEmpty) ? 'Invalid value' : null;
  }

  Future<DocumentReference<Headache>> _addData() async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return Dialog(
          child: SizedBox(
            height: 100,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                CircularProgressIndicator(),
              ],
            ),
          ),
        );
      },
    );
    return await FirebaseFirestore.instance
        .collection('headaches')
        .withConverter(
          fromFirestore: Headache.fromFirestore,
          toFirestore: (value, options) => value.toFirestore(),
        )
        .add(headache)
      ..update({
        'normBorrowerName': headache.borrowerName.toUpperCase(),
        'normItemName': headache.itemName.toUpperCase(),
      });
  }

  @override
  Widget build(BuildContext context) {
    final timeController =
        TextEditingController(text: TimeOfDay.now().format(context));
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(8, 8, 32, 8),
          child: SingleChildScrollView(
            child: SizedBox(
              height: MediaQuery.of(context).size.height - 50,
              // width: MediaQuery.of(context).size.width,
              child: Form(
                onChanged: () {},
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    TextFormField(
                      textInputAction: TextInputAction.next,
                      decoration: const InputDecoration(
                        icon: Icon(Icons.note_alt_sharp),
                        labelText: '*Item Name',
                      ),
                      onSaved: (newValue) {
                        itemName = newValue.toString();
                      },
                      validator: _validator,
                    ),

                    TextFormField(
                      textInputAction: TextInputAction.next,
                      decoration: const InputDecoration(
                        icon: Icon(Icons.person),
                        labelText: '*Borrower Name',
                      ),
                      onSaved: (newValue) {
                        borrowerName = newValue.toString();
                      },
                      validator: _validator,
                    ),

                    TextFormField(
                      textInputAction: TextInputAction.next,
                      decoration: const InputDecoration(
                        icon: Icon(Icons.meeting_room_rounded),
                        labelText: '*Room No.',
                      ),
                      onSaved: (newValue) {
                        roomNo = newValue.toString();
                      },
                      validator: _validator,
                    ),

                    TextFormField(
                      textInputAction: TextInputAction.next,
                      decoration: const InputDecoration(
                        icon: Icon(Icons.numbers_rounded),
                        labelText: 'Reg. No.',
                      ),
                      onSaved: (newValue) {
                        regNo = newValue;
                      },
                    ),

                    TextFormField(
                      textInputAction: TextInputAction.next,
                      keyboardType: TextInputType.phone,
                      decoration: const InputDecoration(
                        icon: Icon(Icons.phone),
                        labelText: 'Phone No.',
                      ),
                      onSaved: (newValue) {
                        phoneNo = newValue;
                      },
                    ),

                    IntrinsicHeight(
                      child: Row(
                        // mainAxisSize: MainAxisSize.min,
                        children: [
                          Flexible(
                            child: TextFormField(
                              textInputAction: TextInputAction.next,
                              readOnly: true,
                              controller: _dateController,
                              onTap: () {
                                showDatePicker(
                                  context: context,
                                  initialDate: DateTime.now(),
                                  firstDate: DateTime.utc(2021),
                                  lastDate: DateTime.utc(2025),
                                ).then((value) {
                                  date = value ?? DateTime.now();
                                  _dateController.text =
                                      '${date.day}-${date.month}-${date.year}';
                                });
                              },
                              decoration: const InputDecoration(
                                icon: Icon(Icons.date_range_rounded),
                                labelText: '*Date',
                              ),
                              validator: _validator,
                            ),
                          ),
                          const VerticalDivider(color: Colors.transparent),
                          const VerticalDivider(indent: 8, endIndent: 8),
                          const VerticalDivider(color: Colors.transparent),
                          Flexible(
                            child: TextFormField(
                              textInputAction: TextInputAction.done,
                              readOnly: true,
                              controller: timeController,
                              onTap: () {
                                showTimePicker(
                                  context: context,
                                  initialTime: TimeOfDay.now(),
                                ).then((value) {
                                  time = value ?? TimeOfDay.now();
                                  timeController.text = time.format(context);
                                });
                              },
                              decoration: const InputDecoration(
                                icon: Icon(Icons.av_timer_rounded),
                                labelText: '*Time',
                              ),
                              validator: _validator,
                            ),
                          ),
                        ],
                      ),
                    ),
                    // const Divider(color: Colors.transparent),
                    FloatingActionButton(
                      onPressed: () {
                        if (_formKey.currentState!.validate() && !_pressed) {
                          _pressed = true;
                          _formKey.currentState!.save();
                          headache = Headache(
                            itemName: itemName,
                            borrowerName: borrowerName,
                            roomNo: roomNo.toUpperCase(),
                            regNo: regNo!
                                .toUpperCase(), //won't be null its just empty
                            phoneNo: phoneNo,
                            dateTime: DateTime(date.year, date.month, date.day,
                                time.hour, time.minute),
                          );
                          headache.display();
                          _addData().then((value) {
                            debugPrint('Debug: ${value.id} added');
                            Navigator.of(context)
                                .popUntil((route) => route.isFirst);
                            ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('Data Added')));
                          });
                        }
                      },
                      child: const Icon(Icons.add),
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }//TODO:Remove debug prints
}
