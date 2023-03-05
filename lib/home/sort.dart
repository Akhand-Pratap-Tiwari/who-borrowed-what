import 'package:flutter/material.dart';
import 'package:who_borrowed_what/home/user_queries_class.dart';

class MySort extends StatefulWidget {
  const MySort({super.key});

  @override
  State<MySort> createState() => _MySortState();
}

class _MySortState extends State<MySort> {
  String _dropValue = 'Newest First';
  dropDownCallBack(String? selectedValue) {
    setState(() {
      _dropValue = selectedValue ?? _dropValue;
      selectedValue == 'Newest First'
          ? currentQuery.value = qb.replace(orderBy: OrderBy(field: 'dateTime', descending: true))
          : currentQuery.value = qb.replace(orderBy: OrderBy(field: 'dateTime', descending: false));
    });
  }

  @override
  Widget build(BuildContext context) {
    return DropdownButton(
      borderRadius: BorderRadius.circular(16),
      alignment: AlignmentDirectional.bottomCenter,
      value: _dropValue,
      items: [
        DropdownMenuItem(
          value: 'Newest First',
          child: Wrap(
            children: const [
              Icon(Icons.arrow_upward_rounded),
              Text(' Newest First'),
            ],
          ),
        ),
        DropdownMenuItem(
          value: 'Oldest First',
          child: Wrap(
            children: const [
              Icon(Icons.arrow_downward_rounded),
              Text(' Oldest First'),
            ],
          ),
        )
      ],
      onChanged: dropDownCallBack,
    );
  }
}
