import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:learning/models/watch.dart';

class WatchService {
  static const String _col = 'watch';

  static Stream<List<Watch>> find() {
    return Firestore.instance.collection(_col).snapshots().map((list) {
      return list.documents.map((doc) {
        Map data = doc.data;
        data['id'] = doc.documentID;
        return Watch.fromJson(data);
      }).toList();
    });
  }

  static Stream<Watch> findById({String id, String uid}) {
    return Firestore.instance.collection(_col).where('uid', isEqualTo: uid).where('vid', isEqualTo: id).snapshots().map((list) {
      return list.documents.map((doc) {
        Map data = doc.data;
        data['id'] = doc.documentID;
        return Watch.fromJson(data);
      }).first;
    });
  }

  static Future<Watch> getById({String id, String uid}) {
    return Firestore.instance.collection(_col).where('uid', isEqualTo: uid).where('vid', isEqualTo: id).snapshots().map((list) {
      if(list.documents.length == 0){
        return null;
      }
      return list.documents.map((doc) {
        Map data = doc.data;
        data['id'] = doc.documentID;
        return Watch.fromJson(data);
      }).first;
    }).first;
  }

  static Future<DocumentReference> insert(Map<String, dynamic> data){
    return Firestore.instance.collection(_col).add(data);
  }

  static Future<void> update({String id, Map<String, dynamic> data}){
    return Firestore.instance.collection(_col).document(id).updateData(data);
  }
}