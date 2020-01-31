// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// FirebaseServiceGenerator
// **************************************************************************

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'profile.dart';

class ProfileFirebaseService {
  CollectionReference colRef = Firestore.instance.collection('profiles');

  static final ProfileFirebaseService _singleton =
      ProfileFirebaseService._internal();

  factory ProfileFirebaseService() {
    return _singleton;
  }

  ProfileFirebaseService._internal();

  Stream<List<Profile>> find(
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
        return Profile.fromJson(data);
      }).toList();
    });
  }

  Stream<Profile> findOne(
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
        return Profile.fromJson(data);
      }).first;
    });
  }

  Stream<Profile> findById({String id = ''}) {
    return colRef.document(id).snapshots().map((doc) {
      Map data = doc.data;
      data['id'] = doc.documentID;
      return Profile.fromJson(data);
    })..handleError((error) {
      print('ProfileFirebaseService findById error $error');
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

ProfileFirebaseService profileFirebaseService = ProfileFirebaseService();
