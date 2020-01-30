//import 'package:cloud_firestore/cloud_firestore.dart';
//import 'package:learning/models/question.dart';
//import 'package:learning/utils/logger.dart';
//
//class QuestionService {
//  static const String _col = 'questions';
//  static var log = getLogger('QuestionService');
//
//  static Stream<List<Question>> find() {
//    return Firestore.instance.collection(_col).orderBy('order').snapshots().map((list) {
//      return list.documents.map((doc) {
//        Map data = doc.data;
//        data['id'] = doc.documentID;
//        return Question.fromJson(data);
//      }).toList();
//    });
//  }
//
//  static Stream<List<Question>> findByVId({String id}) {
//    return Firestore.instance.collection(_col).where('vid', isEqualTo: id).orderBy('order').snapshots().map((list) {
//      return list.documents.map((doc) {
//        Map data = doc.data;
//        data['id'] = doc.documentID;
//        return Question.fromJson(data);
//      }).toList();
//    });
//  }
//
//  static Future<DocumentReference> insert(Map<String, dynamic> data){
//    return Firestore.instance.collection(_col).add(data);
//  }
//
//  static Future<void> update({String id, Map<String, dynamic> data}){
//    return Firestore.instance.collection(_col).document(id).updateData(data);
//  }
//}