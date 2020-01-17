import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:learning/models/series.dart';

class SeriesService {
  static const String _col = 'series';

  static Stream<List<Series>> find({String status = 'publish'}) {
    return Firestore.instance.collection(_col).where('status', isEqualTo: status).snapshots().map((list) {
      return list.documents.map((doc) {
        Map data = doc.data;
        data['id'] = doc.documentID;
        return Series.fromJson(data);
      }).toList();
    });
  }

  static Future<DocumentReference> insert(String tid, Map<String, dynamic> data){
    return Firestore.instance.collection(_col).add(data);
  }

  static Future<void> update({String id, Map<String, dynamic> data}){
    return Firestore.instance.collection(_col).document(id).updateData(data);
  }
}