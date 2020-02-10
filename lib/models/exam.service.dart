// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// FirebaseServiceGenerator
// **************************************************************************

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'exam.dart';

class ExamFirebaseService {
  CollectionReference colRef = Firestore.instance.collection('exams');

  static final ExamFirebaseService _singleton = ExamFirebaseService._internal();

  factory ExamFirebaseService() {
    return _singleton;
  }

  ExamFirebaseService._internal();

  Stream<List<Exam>> find(
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
        return Exam.fromJson(data);
      }).toList();
    });
  }

  Stream<Exam> findOne(
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
        return Exam.fromJson(data);
      }).first;
    });
  }

  Stream<Exam> findById({@required String id}) {
    if (id != null) {
      return null;
    }
    return colRef.document(id).snapshots().map((doc) {
      Map data = doc.data;
      data['id'] = doc.documentID;
      return Exam.fromJson(data);
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

ExamFirebaseService examFirebaseService = ExamFirebaseService();
