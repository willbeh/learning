import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:learning/models/video.dart';

class VideoService {
  static const String _col = 'videos';

  static Stream<List<Video>> find({String status = 'publish'}) {
    print('VideoService find');
    return Firestore.instance.collection(_col).where('status', isEqualTo: status).orderBy('date', descending: true).snapshots().map((list) {
      return list.documents.map((doc) {
        Map data = doc.data;
//        print(data);
        return Video.fromJson(data);
      }).toList();
    });
  }

  static Stream<List<Video>> findBySeries({@required String id, String status = 'publish'}) {
    return Firestore.instance.collection(_col).where('sid', isEqualTo: id).where('status', isEqualTo: status).orderBy('order').snapshots().map((list) {
      return list.documents.map((doc) {
        Map data = doc.data;
//        print(data);
        return Video.fromJson(data);
      }).toList();
    });
  }

//  static Stream<Answer> findById(String tid, String qid, String uid) {
//    return Firestore.instance.collection(_col).document(tid).collection(_colPhoto).where('qid', isEqualTo: qid).where('uid', isEqualTo: uid).snapshots().map((list) {
//      return list.documents.map((doc) {
//        Map data = doc.data;
//        data['id'] = doc.documentID;
//        return Answer.fromJson(data);
//      }).first;
//    });
//  }

  static Future<DocumentReference> insert(String tid, Map<String, dynamic> data){
    return Firestore.instance.collection(_col).add(data);
  }

  static Future<void> update({String id, Map<String, dynamic> data}){
    return Firestore.instance.collection(_col).document(id).updateData(data);
  }
}