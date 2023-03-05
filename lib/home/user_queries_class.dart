import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'headache_class.dart';

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
  Where? where;

  QueryBuilder({
    required this.baseQuery,
    this.orderBy,
    this.where,
  }) {
    _buildCurrentQuery();
  }
  _buildCurrentQuery() {
    currentQuery = baseQuery;
    if (where != null) {
      currentQuery = currentQuery.where(where!.field,
          isEqualTo: where!.isEqualTo,
          isGreaterThan: where!.isGreaterThan,
          isGreaterThanOrEqualTo: where!.isGreaterThanOrEqualTo,
          isLessThan: where!.isLessThan,
          isLessThanOrEqualTo: where!.isLessThanOrEqualTo,
          isNotEqualTo: where!.isNotEqualTo,
          isNull: where!.isNull);
    }
    if (orderBy != null) {
      currentQuery =
          currentQuery.orderBy(orderBy!.field, descending: orderBy!.descending);
    }
  }

  Query<Headache> replace({Query<Headache>? baseQuery, OrderBy? orderBy, Where? where}) {
    if (baseQuery != null) {
      this.baseQuery = baseQuery;
    }
    if (orderBy != null) {
      this.orderBy = orderBy;
    }
    if (where != null) {
      this.where = where;
    }
    if (baseQuery != null || orderBy != null || where != null) {
      _buildCurrentQuery();
    }
    return currentQuery;
  }

  Query<Headache> removeClause({bool? orderBy, bool? where}){
    if(orderBy!=null && orderBy == true){
      this.orderBy = null;
    }
    if(where!= null && where == true){
      this.where = null;
    }
    if(orderBy != null || where != null){
      _buildCurrentQuery();
    }
    return currentQuery;
  }

}


QueryBuilder qb = QueryBuilder(baseQuery: FirebaseFirestore.instance.collection('headaches').withConverter(
          fromFirestore: Headache.fromFirestore,
          toFirestore: (value, options) => value.toFirestore(),
        ), orderBy: OrderBy(field: 'dateTime', descending: true),);

final ValueNotifier<Query<Headache>> currentQuery = ValueNotifier(qb.currentQuery);
