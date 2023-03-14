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

  void _onEditingComplete() {
    searchController.text = searchController.text.trim();
    searchController.selection =
        TextSelection.collapsed(offset: searchController.text.length);
    currentQuery.value = qb.replace(wheres: {
      'swc':
          Where(field: field, isEqualTo: searchController.text.toUpperCase()),
    });
  }

  onSearchIconPressed() {
    widget.homeState.setState(() {
      widget.homeState.changeWidth();
    });

    Future.delayed(
      //For animation purposes
      const Duration(milliseconds: 500),
      () {
        if (widget.homeState.width != widget.homeState.minWidth) {
          widget1 = MySuffixPopUp(mySearchFieldState: this);
        } else {
          currentQuery.value = qb.removeClause(wheresKeys: ['swc']);
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
      onEditingComplete: _onEditingComplete,
      onTapOutside: (event) => FocusManager.instance.primaryFocus!.unfocus(),
      textAlignVertical: TextAlignVertical.center,
      decoration: InputDecoration(
        suffixIcon: widget1,
        prefixIcon: IconButton(
          icon: widget.homeState.width != widget.homeState.minWidth
              ? const Icon(Icons.restart_alt_rounded)
              : const Icon(Icons.search_rounded),
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
  const MySuffixPopUp({super.key,
   required this.mySearchFieldState,
  });

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
      onSelected: (value) {
        widget.mySearchFieldState.setField(value);
        
        

        if (value == 'normItemName') {
          changeIcon(Icons.abc_rounded);
        }

        if (value == 'normBorrowerName') {
          changeIcon(Icons.person_4_outlined);
        }

        if (value == 'roomNo') {
          changeIcon(Icons.meeting_room_rounded);
        }
      },
      child: Icon(icon),
      itemBuilder: (BuildContext context) => [
        const PopupMenuItem(child: Text('Search in Field:')),
        PopupMenuItem(
          value: 'normItemName',
          child: Wrap(
            children: const [
              Icon(Icons.abc_rounded),
              Text(' Item Name'),
            ],
          ),
        ),
        PopupMenuItem(
          value: 'normBorrowerName',
          child: Wrap(
            children: const [
              Icon(Icons.person_4_outlined),
              Text(' Borrower Name'),
            ],
          ),
        ),
        PopupMenuItem(
          value: 'roomNo',
          child: Wrap(
            children: const [
              Icon(Icons.meeting_room_rounded),
              Text(' Room No.'),
            ],
          ),
        ),
      ],
    );
  }
}
