import 'package:flutter/material.dart';

import 'user_queries_class.dart';

class MySearchField extends StatefulWidget {
  final homeState;

  const MySearchField({super.key, required this.homeState});

  @override
  State<MySearchField> createState() => _MySearchFieldState();
}

class _MySearchFieldState extends State<MySearchField> {
  TextEditingController searchController = TextEditingController();
  Widget? widget1;
  String field = 'normItemName';

  onSearchIconPressed() {
    widget.homeState.setState(() {
      widget.homeState.changeWidth();
    });

    Future.delayed(
      const Duration(milliseconds: 500),
      () {
        if (widget.homeState.width != widget.homeState.minWidth) {
          widget1 = MySuffixPopUp(mySearchFieldState: this);
        } else {
          currentQuery.value = qb.removeClause(where: true);
          searchController.text = '';
          widget1 = null;
        }

        setState(() {});
      },
    );
  }

  setField(String fl) {
    field = fl;
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      maxLines: 1,
      controller: searchController,
      textInputAction: TextInputAction.search,
      onEditingComplete: () {
        currentQuery.value = qb.replace(
            where: Where(
                field: field, isEqualTo: searchController.text.toUpperCase()));
      },
      onTapOutside: (event) => FocusManager.instance.primaryFocus!.unfocus(),
      textAlignVertical: TextAlignVertical.center,
      decoration: InputDecoration(
        suffixIcon: widget1,
        prefixIcon: IconButton(
          icon: const Icon(Icons.search_rounded),
          onPressed: onSearchIconPressed,
        ),
        contentPadding: const EdgeInsets.symmetric(vertical: 8, horizontal: 15),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(40)),
      ),
    );
  }
}

class MySuffixPopUp extends StatefulWidget {
  final mySearchFieldState;
  const MySuffixPopUp({super.key, required this.mySearchFieldState});

  @override
  State<MySuffixPopUp> createState() => _MySuffixPopUpState();
}

class _MySuffixPopUpState extends State<MySuffixPopUp> {
  IconData icon = Icons.abc_rounded;
  changeIcon(IconData ico) {
    setState(() {
      icon = ico;
    });
  }

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton(
      child: Icon(icon),
      itemBuilder: (BuildContext context) => [
        const PopupMenuItem(child: Text('Search in Field:')),
        PopupMenuItem(
          onTap: () {
            changeIcon(Icons.abc_rounded);
            widget.mySearchFieldState.setField('normItemName');
          },
          child: Wrap(
            children: const [Icon(Icons.abc_rounded), Text(' Item Name')],
          ),
        ),
        PopupMenuItem(
          onTap: () {
            changeIcon(Icons.person_4_outlined);
            widget.mySearchFieldState.setField('normBorrowerName');
          },
          child: Wrap(
            children: const [
              Icon(Icons.person_4_outlined),
              Text(' Borrower Name')
            ],
          ),
        ),
        PopupMenuItem(
          onTap: () {
            changeIcon(Icons.date_range_outlined);
            widget.mySearchFieldState.setField('dateTime');
          },
          child: Wrap(
            children: const [
              Icon(Icons.date_range_outlined),
              Text(' Date Time')
            ],
          ),
        ),
      ],
    );
  }
}
