import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fantasy_cricket/models/series_rank.dart';

class SeriesRankRepo {
  static final CollectionReference _seriesRanks = FirebaseFirestore.instance
    .collection('seriesRanks');

  static Future<SeriesRank> getSeriesRankById(String id) async {
    DocumentSnapshot snapshot = await _seriesRanks.doc(id).get();
    return SeriesRank.fromMap(snapshot.data(), snapshot.id);
  }

  static Future<List<SeriesRank>> getSeriesRanksBySeriesId(String id) async {
    QuerySnapshot snapshot = await _seriesRanks
      .where('seriesId', isEqualTo: id)
      .get();
    return snapshot.docs.map((doc) {
      return SeriesRank.fromMap(doc.data(), doc.id);
    }).toList();
  }
}
