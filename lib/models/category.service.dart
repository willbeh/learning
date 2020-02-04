// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// FirebaseServiceGenerator
// **************************************************************************

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'category.dart';

class CategoryFirebaseService {
  CollectionReference colRef = Firestore.instance.collection('categories');

  static final CategoryFirebaseService _singleton =
      CategoryFirebaseService._internal();

  factory CategoryFirebaseService() {
    return _singleton;
  }

  CategoryFirebaseService._internal();

  Stream<List<Category>> find(
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
        return Category.fromJson(data);
      }).toList();
    });
  }

  Stream<Category> findOne(
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
        return Category.fromJson(data);
      }).first;
    });
  }

  Stream<Category> findById({@required String id}) {
    return colRef.document(id).snapshots().map((doc) {
      Map data = doc.data;
      data['id'] = doc.documentID;
      return Category.fromJson(data);
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

CategoryFirebaseService categoryFirebaseService = CategoryFirebaseService();
