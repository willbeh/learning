// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// FirebaseServiceGenerator
// **************************************************************************

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'series_watch.dart';

class SeriesWatchFirebaseService {
  CollectionReference colRef = Firestore.instance.collection('seriesWatch');

  static final SeriesWatchFirebaseService _singleton =
      SeriesWatchFirebaseService._internal();

  factory SeriesWatchFirebaseService() {
    return _singleton;
  }

  SeriesWatchFirebaseService._internal();

  Stream<List<SeriesWatch>> find(
      {Query query, dynamic orderField, bool descending = false, int limit}) {
    Query inColRef = colRef;
    if (query != null) {
      inColRef = query;
    }
    if (orderField != null) {
      inColRef = inColRef.orderBy(orderField, descending: descending);
    }
    if (limit != null) {
      inColRef = inColRef.limit(limit);
    }
    return inColRef.snapshots().map((list) {
      return list.documents.map((doc) {
        Map data = doc.data;
        data['id'] = doc.documentID;
        return SeriesWatch.fromJson(data);
      }).toList();
    });
  }

  Stream<SeriesWatch> findOne(
      {Query query, dynamic orderField, bool descending = false}) {
    Query inColRef = colRef;
    if (query != null) {
      inColRef = query;
    }
    if (orderField != null) {
      inColRef = inColRef.orderBy(orderField, descending: descending);
    }
    return inColRef.limit(1).snapshots().map((list) {
      return list.documents.map((doc) {
        Map data = doc.data;
        data['id'] = doc.documentID;
        return SeriesWatch.fromJson(data);
      }).first;
    });
  }

  Stream<SeriesWatch> findById({@required String id}) {
    if (id == null) {
      return null;
    }
    return colRef.document(id).snapshots().map((doc) {
      Map data = doc.data;
      data['id'] = doc.documentID;
      return SeriesWatch.fromJson(data);
    });
  }

  Future<DocumentReference> insert({@required Map<String, dynamic> data}) {
    return colRef.add(data);
  }

  Future<void> update(
      {@required String id, @required Map<String, dynamic> data}) {
    return colRef.document(id).updateData(data);
  }
}

SeriesWatchFirebaseService series_watchFirebaseService =
    SeriesWatchFirebaseService();
