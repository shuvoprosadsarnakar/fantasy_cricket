import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fantasy_cricket/models/series.dart';

class SeriesRepo {
  static final _seriesCollection = FirebaseFirestore.instance
    .collection('serieses');

    static DocumentSnapshot lastDocument;

  static Future<void> updateSeries(Series series) async {
    await _seriesCollection.doc(series.id).update(series.toMap());
  }

  static Future<void> assignNotEndedSerieses(List<Series> notEndedSerieses) 
    async 
  {
    DateTime dateTime = DateTime.now();
    int year = dateTime.year;
    int month = dateTime.month - 1;
    int day = dateTime.day;

    if(month == 0) {
      year--;
      month = 12;
    }

    // series ended after this time will be fetched
    DateTime minTime = DateTime.utc(year, month, day);

    QuerySnapshot collection = await _seriesCollection
      .where('times.end', isGreaterThan: Timestamp.fromDate(minTime))
      .get();

    collection.docs.forEach((QueryDocumentSnapshot doc) {
      notEndedSerieses.add(Series.fromMap(doc.data(), doc.id));
    });
  }

  static Future<Series> getSeriesById(String id) async {
    DocumentSnapshot snapshot = await _seriesCollection.doc(id).get();
    return Series.fromMap(snapshot.data(), snapshot.id);
  }

}
