import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fantasy_cricket/models/series.dart';

class SeriesRepo {
  static final _seriesCollection = FirebaseFirestore.instance
    .collection('serieses');

  // returns true if player's name is not taken already, false otherwise
  static Future<bool> checkSeriesName(Series series) async {
    QuerySnapshot querySanpshot = await _seriesCollection
      .where('name', isEqualTo: series.name).get();

    if(querySanpshot.docs.isEmpty ||
      // Name field is unique, so we can get only one document even if name is
      // changed to update. Now, if the matched document's id matches then there
      // is no other doc with the same name.
      (series.id != null && querySanpshot.docs[0].id == series.id)) {
      return true;
    } else {
      return false;
    }
  }

  static Future<void> addSeries(Series series) async {
    await _seriesCollection.add(series.toMap());
  }

  static Future<void> updateSeries(Series series) async {
    await _seriesCollection.doc(series.id).update(series.toMap());
  }

  static Future<void> assignNotEndedSerieses(List<Series> notEndedSerieses) 
    async {
    QuerySnapshot collection = await _seriesCollection
      .where('times.end', isGreaterThan: Timestamp.fromDate(DateTime.now()))
      .get();

    collection.docs.forEach((QueryDocumentSnapshot doc) {
      notEndedSerieses.add(Series.fromMap(doc.data(), doc.id));
    });
  }
}
