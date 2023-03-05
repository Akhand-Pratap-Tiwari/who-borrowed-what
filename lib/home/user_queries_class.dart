import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'headache_class.dart';
import 'dart:core';

// MyQuery myQuery = MyQuery();
class OrderBy {
  bool descending;
  Object field;
  OrderBy({required this.field, this.descending = false});
}

class Where {
  Object field;
  Object? isEqualTo;
  Object? isNotEqualTo;
  Object? isLessThan;
  Object? isLessThanOrEqualTo;
  Object? isGreaterThan;
  Object? isGreaterThanOrEqualTo;
  Object? arrayContains;
  Iterable<Object?>? arrayContainsAny;
  Iterable<Object?>? whereIn;
  Iterable<Object?>? whereNotIn;
  bool? isNull;

  Where({
    required this.field,
    this.isEqualTo,
    this.isNotEqualTo,
    this.isLessThan,
    this.isLessThanOrEqualTo,
    this.isGreaterThan,
    this.isGreaterThanOrEqualTo,
    this.arrayContains,
    this.arrayContainsAny,
    this.whereIn,
    this.whereNotIn,
    this.isNull,
  });
}

class QueryBuilder {
  Query<Headache> baseQuery;
  late Query<Headache> currentQuery;
  OrderBy? orderBy;
  Map<String, Where>? wheres = {};

  QueryBuilder({
    required this.baseQuery,
    this.orderBy,
    this.wheres,
  }) {
    _buildCurrentQuery();
  }
  _buildCurrentQuery() {
    currentQuery = baseQuery;
    if (wheres != null) {
      wheres!.forEach((key, value) {
        currentQuery = currentQuery.where(
          value.field,
          isEqualTo: value.isEqualTo,
          isGreaterThan: value.isGreaterThan,
          isGreaterThanOrEqualTo: value.isGreaterThanOrEqualTo,
          isLessThan: value.isLessThan,
          isLessThanOrEqualTo: value.isLessThanOrEqualTo,
          isNotEqualTo: value.isNotEqualTo,
          isNull: value.isNull,
        );
      });
    }
    if (orderBy != null) {
      currentQuery =
          currentQuery.orderBy(orderBy!.field, descending: orderBy!.descending);
    }
  }

  Query<Headache> replace(
      {Query<Headache>? baseQuery,
      OrderBy? orderBy,
      Map<String, Where>? wheres}) {
    ///Can be used to add wheres
    if (baseQuery != null) {
      this.baseQuery = baseQuery;
    }
    if (orderBy != null) {
      this.orderBy = orderBy;
    }
    if (wheres != null) {
      this.wheres == null ? this.wheres = wheres : this.wheres!.addAll(wheres);
    }
    if (baseQuery != null || orderBy != null || wheres != null) {
      _buildCurrentQuery();
    }
    return currentQuery;
  }

  Query<Headache> removeClause({bool? orderBy, List<String>? wheresKeys}) {
    ///Supply The wheres to be removed
    if (this.orderBy != null && orderBy == true) {
      this.orderBy = null;
    }
    if (wheres != null && wheresKeys != null && wheresKeys.isNotEmpty) {
      wheres!.removeWhere((key, value) => wheresKeys.contains(key));
    }
    if (orderBy != null || (wheresKeys != null && wheresKeys.isNotEmpty)) {
      _buildCurrentQuery();
    }
    return currentQuery;
  }
}

QueryBuilder qb = QueryBuilder(
  baseQuery: FirebaseFirestore.instance.collection('headaches').withConverter(
        fromFirestore: Headache.fromFirestore,
        toFirestore: (value, options) => value.toFirestore(),
      ),
  orderBy: OrderBy(field: 'dateTime', descending: true),
)..replace(wheres: {
    'rwc': Where(field: 'resolved', isEqualTo: false),
  });

final ValueNotifier<Query<Headache>> currentQuery =
    ValueNotifier(qb.currentQuery);
//search where clause = swc
//resolved where clause = rwc