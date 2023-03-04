import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'headache_class.dart';

class UserQueries {
  late final  Query<Headache> orderByOldest;
  late final Query<Headache> orderByNewest;

  UserQueries() {
    orderByOldest = _userQuery(descending: false);
    orderByNewest  = _userQuery();
  }

  Query<Headache> _userQuery({bool descending = true}) {
    return FirebaseFirestore.instance
        .collection('headaches')
        .withConverter(
          fromFirestore: Headache.fromFirestore,
          toFirestore: (value, options) => value.toFirestore(),
        )
        .orderBy(
          'dateTime',
          descending: descending,
        );
  } 
}

UserQueries userQueries = UserQueries();

final ValueNotifier<Query<Headache>> currentQuery = ValueNotifier(userQueries.orderByNewest);

