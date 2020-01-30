// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// FirebaseServiceGenerator
// **************************************************************************

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'answer.dart';

class AnswerFirebaseService {
  static CollectionReference colRef = Firestore.instance.collection('answers');

  static Stream<List<Answer>> find(
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
        return Answer.fromJson(data);
      }).toList();
    });
  }

  static Stream<Answer> findOne(
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
        return Answer.fromJson(data);
      }).first;
    });
  }

  static Stream<List<Answer>> findById(
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
        return Answer.fromJson(data);
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
