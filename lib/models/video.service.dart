// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// FirebaseServiceGenerator
// **************************************************************************

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'video.dart';

class VideoFirebaseService {
  CollectionReference colRef = Firestore.instance.collection('videos');

  static final VideoFirebaseService _singleton =
      VideoFirebaseService._internal();

  factory VideoFirebaseService() {
    return _singleton;
  }

  VideoFirebaseService._internal();

  Stream<List<Video>> find(
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
        return Video.fromJson(data);
      }).toList();
    });
  }

  Stream<Video> findOne(
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
        return Video.fromJson(data);
      }).first;
    });
  }

  Stream<Video> findById({@required String id}) {
    return colRef.document(id).snapshots().map((doc) {
      Map data = doc.data;
      data['id'] = doc.documentID;
      return Video.fromJson(data);
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

VideoFirebaseService videoFirebaseService = VideoFirebaseService();
