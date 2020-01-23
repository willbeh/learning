// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// FirebaseServiceGenerator
// **************************************************************************

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'category.dart';

class CategoryFirebaseService {
  static CollectionReference colRef =
      Firestore.instance.collection('categories');

  static Stream<List<Category>> find(
      {List<Query> queries, dynamic orderField, bool descending = false}) {
    CollectionReference inColRef = colRef;
    if (queries != null) {
      queries.forEach((query) => inColRef.where(query));
    }
    if (orderField != null) {
      inColRef.orderBy(orderField, descending: descending);
    }
    return inColRef.snapshots().map((list) {
      return list.documents.map((doc) {
        Map data = doc.data;
        data['id'] = doc.documentID;
        return Category.fromJson(data);
      }).toList();
    });
  }

  static Stream<List<Category>> findById(
      {@required String id, dynamic orderField, bool descending = false}) {
    CollectionReference inColRef = colRef;
    inColRef.where('id', isEqualTo: id);
    if (orderField != null) {
      inColRef.orderBy(orderField, descending: descending);
    }
    return inColRef.snapshots().map((list) {
      return list.documents.map((doc) {
        Map data = doc.data;
        data['id'] = doc.documentID;
        return Category.fromJson(data);
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
