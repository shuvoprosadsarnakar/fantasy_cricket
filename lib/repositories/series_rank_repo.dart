import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fantasy_cricket/models/series_rank.dart';

class SeriesRankRepo {
  static final CollectionReference _seriesRanks = FirebaseFirestore.instance
    .collection('seriesRanks');

  static Future<SeriesRank> getSeriesRankById(String id) async {
    DocumentSnapshot snapshot = await _seriesRanks.doc(id).get();
    return SeriesRank.fromMap(snapshot.data(), snapshot.id);
  } 
}
