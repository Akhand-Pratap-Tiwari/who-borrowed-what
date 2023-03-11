import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';

import 'user_queries_class.dart';

class MyDropDownTitle extends StatefulWidget {
  final ValueNotifier<bool> showResolved;

  const MyDropDownTitle({
    super.key,
    required ValueNotifier<bool> this.showResolved,
  });

  @override
  State<MyDropDownTitle> createState() => _MyDropDownTitleState();
}

class _MyDropDownTitleState extends State<MyDropDownTitle> {
  String _dropValue = 'Show UnResolved';
  dropDownCallBack(String? selectedValue) {
    setState(() {
      _dropValue = selectedValue ?? _dropValue;
      if (selectedValue == 'Show UnResolved') {
        widget.showResolved.value = false;
        currentQuery.value = qb.replace(
            wheres: {'rwc': Where(field: 'resolved', isEqualTo: false)});
      } else {
        currentQuery.value = qb.replace(
            wheres: {'rwc': Where(field: 'resolved', isEqualTo: true)});
      }
    });
  }


  @override
  Widget build(BuildContext context) {
   var pltBright = MediaQuery.of(context).platformBrightness;
   bool isDark = (pltBright == Brightness.dark) ? true : false;
  TextStyle txtStyle = TextStyle(fontSize: 24);
    return Container(
      padding: EdgeInsets.fromLTRB(16, 0 , 8, 0),
      decoration: BoxDecoration(color: Colors.teal, borderRadius: BorderRadius.circular(20),),
      child: DropdownButtonHideUnderline(
        child: DropdownButton(
          dropdownColor: isDark ? Colors.white.withOpacity(0.7) : Colors.black.withOpacity(0.7),
          style: txtStyle,
          borderRadius: BorderRadius.circular(16),
          value: _dropValue,
          items: [
            DropdownMenuItem(
              alignment: Alignment.center,
              value: 'Show UnResolved',
              child:  Text('Current Headaches'),
            ),
            DropdownMenuItem(
                          alignment: Alignment.center,
              value: 'Show Resolved',
              child:  Text('Resolved Headaches'),
            ),
          ],
          onChanged: dropDownCallBack,
        ),
      ),
    );
  }
}
