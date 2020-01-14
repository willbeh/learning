import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:learning/models/answer.dart';
import 'package:learning/utils/logger.dart';

class AnswerService {
  static const String _col = 'answers';
  static var log = getLogger('AnswerService');

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

  static Future<DocumentReference> insert(Map<String, dynamic> data){
    return Firestore.instance.collection(_col).add(data);
  }

  static Future<void> update({String id, Map<String, dynamic> data}){
    return Firestore.instance.collection(_col).document(id).updateData(data);
  }
}