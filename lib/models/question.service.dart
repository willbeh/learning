// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// FirebaseServiceGenerator
// **************************************************************************

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'question.dart';

class QuestionFirebaseService {
  CollectionReference colRef = Firestore.instance.collection('questions');

  static final QuestionFirebaseService _singleton =
      QuestionFirebaseService._internal();

  factory QuestionFirebaseService() {
    return _singleton;
  }

  QuestionFirebaseService._internal();

  Stream<List<Question>> find(
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
        return Question.fromJson(data);
      }).toList();
    });
  }

  Stream<Question> findOne(
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
        return Question.fromJson(data);
      }).first;
    });
  }

  Stream<Question> findById({@required String id}) {
    return colRef.document(id).snapshots().map((doc) {
      Map data = doc.data;
      data['id'] = doc.documentID;
      return Question.fromJson(data);
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

QuestionFirebaseService questionFirebaseService = QuestionFirebaseService();
