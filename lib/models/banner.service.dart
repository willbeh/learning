// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// FirebaseServiceGenerator
// **************************************************************************

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'banner.dart';

class AppBannerFirebaseService {
  CollectionReference colRef = Firestore.instance.collection('banners');

  static final AppBannerFirebaseService _singleton =
      AppBannerFirebaseService._internal();

  factory AppBannerFirebaseService() {
    return _singleton;
  }

  AppBannerFirebaseService._internal();

  Stream<List<AppBanner>> find(
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
        return AppBanner.fromJson(data);
      }).toList();
    });
  }

  Stream<AppBanner> findOne(
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
        return AppBanner.fromJson(data);
      }).first;
    });
  }

  Stream<AppBanner> findById({@required String id}) {
    if (id == null) {
      return null;
    }
    return colRef.document(id).snapshots().map((doc) {
      final Map<String, dynamic> data = doc.data;
      data['id'] = doc.documentID;
      return AppBanner.fromJson(data);
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

AppBannerFirebaseService bannerFirebaseService = AppBannerFirebaseService();
