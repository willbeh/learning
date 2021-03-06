// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// FirebaseServiceGenerator
// **************************************************************************

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'answer.dart';

class AnswerFirebaseService {
  CollectionReference colRef = Firestore.instance.collection('answers');

  static final AnswerFirebaseService _singleton =
      AnswerFirebaseService._internal();

  factory AnswerFirebaseService() {
    return _singleton;
  }

  AnswerFirebaseService._internal();

  Stream<List<Answer>> find(
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
        return Answer.fromJson(data);
      }).toList();
    });
  }

  Stream<Answer> findOne(
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
        return Answer.fromJson(data);
      }).first;
    });
  }

  Stream<Answer> findById({@required String id}) {
    if (id == null) {
      return null;
    }
    return colRef.document(id).snapshots().map((doc) {
      final Map<String, dynamic> data = doc.data;
      data['id'] = doc.documentID;
      return Answer.fromJson(data);
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

AnswerFirebaseService answerFirebaseService = AnswerFirebaseService();
