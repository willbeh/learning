import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:learning/models/answer.dart';
import 'package:learning/utils/logger.dart';

class AnswerService {
  static const String _col = 'answers';
  static var log = getLogger('AnswerService');
  static CollectionReference colRef = Firestore.instance.collection('answers');

  static Stream<List<Answer>> find() {
    return Firestore.instance.collection(_col).orderBy('order').snapshots().map((list) {
      return list.documents.map((doc) {
        Map data = doc.data;
        data['id'] = doc.documentID;
        return Answer.fromJson(data);
      }).toList();
    });
  }

  static Stream<Answer> findByUId({String vid, String uid}) {
    return Firestore.instance.collection(_col).where('vid', isEqualTo: vid).where('uid', isEqualTo: uid).snapshots().map((list) {
      return list.documents.map((doc) {
        Map data = doc.data;
        data['id'] = doc.documentID;
        return Answer.fromJson(data);
      }).first;
    });
  }

  static Stream<List<Answer>> findBy({List<Query> queries, dynamic orderField, bool descending = false}){
    CollectionReference inColRef = colRef;
    if(queries != null){
      queries.forEach((query) => inColRef.where(query));
    }
    if(orderField != null){
      inColRef.orderBy(orderField, descending: descending);
    }
    return inColRef.snapshots().map((list) {
      return list.documents.map((doc) {
        Map data = doc.data;
        data['id'] = doc.documentID;
        return Answer.fromJson(data);
      }).toList();
    });
  }

  static Stream<List<Answer>> findById({@required String id, dynamic orderField, bool descending = false}) {
    CollectionReference inColRef = colRef;
    inColRef.where('id', isEqualTo: id);
    if(orderField != null){
      inColRef.orderBy(orderField, descending: descending);
    }
    return inColRef.snapshots().map((list) {
      return list.documents.map((doc) {
        Map data = doc.data;
        data['id'] = doc.documentID;
        return Answer.fromJson(data);
      }).toList();
    });
  }

  static Future<DocumentReference> insert({@required Map<String, dynamic> data}){
    return Firestore.instance.collection(_col).add(data);
  }

  static Future<void> update({@required String id, @required Map<String, dynamic> data}){
    return Firestore.instance.collection(_col).document(id).updateData(data);
  }
}