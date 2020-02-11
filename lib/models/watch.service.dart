// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// FirebaseServiceGenerator
// **************************************************************************

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'watch.dart';

class WatchFirebaseService {
  CollectionReference colRef = Firestore.instance.collection('watch');

  static final WatchFirebaseService _singleton =
      WatchFirebaseService._internal();

  factory WatchFirebaseService() {
    return _singleton;
  }

  WatchFirebaseService._internal();

  Stream<List<Watch>> find(
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
        final Map<String, dynamic> data = doc.data;
        data['id'] = doc.documentID;
        return Watch.fromJson(data);
      }).toList();
    });
  }

  Stream<Watch> findOne(
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
        final Map<String, dynamic> data = doc.data;
        data['id'] = doc.documentID;
        return Watch.fromJson(data);
      }).first;
    });
  }

  Stream<Watch> findById({@required String id}) {
    if (id == null) {
      return null;
    }
    return colRef.document(id).snapshots().map((doc) {
      final Map<String, dynamic> data = doc.data;
      data['id'] = doc.documentID;
      return Watch.fromJson(data);
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

WatchFirebaseService watchFirebaseService = WatchFirebaseService();
