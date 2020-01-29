// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// FirebaseServiceGenerator
// **************************************************************************

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'watch.dart';

class WatchFirebaseService {
  static CollectionReference colRef = Firestore.instance.collection('watch');

  static Stream<List<Watch>> find(
      {Query query, dynamic orderField, bool descending = false}) {
    Query inColRef = colRef;
    if (query != null) {
      inColRef = query;
    }
    if (orderField != null) {
      inColRef = inColRef.orderBy(orderField, descending: descending);
    }
    return inColRef.snapshots().map((list) {
      return list.documents.map((doc) {
        Map data = doc.data;
        data['id'] = doc.documentID;
        return Watch.fromJson(data);
      }).toList();
    });
  }

  static Stream<List<Watch>> findById(
      {@required String id, dynamic orderField, bool descending = false}) {
    Query inColRef = colRef;
    inColRef.where('id', isEqualTo: id);
    if (orderField != null) {
      inColRef = inColRef.orderBy(orderField, descending: descending);
    }
    return inColRef.snapshots().map((list) {
      return list.documents.map((doc) {
        Map data = doc.data;
        data['id'] = doc.documentID;
        return Watch.fromJson(data);
      }).toList();
    });
  }

  static Future<DocumentReference> insert(
      {@required Map<String, dynamic> data}) {
    return colRef.add(data);
  }

  static Future<void> update(
      {@required String id, @required Map<String, dynamic> data}) {
    return colRef.document(id).updateData(data);
  }
}
