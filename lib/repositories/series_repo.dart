import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fantasy_cricket/models/series.dart';

class SeriesRepo {
  static final _seriesCollection = FirebaseFirestore.instance
    .collection('serieses');

    static DocumentSnapshot lastDocument;

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

  static Future<List<Series>> fetchSeries(int startIndex, int limit) async {
    if (startIndex == 0) {
      QuerySnapshot documentList = await _seriesCollection
          .orderBy("name")
          .limit(limit)
          .get(GetOptions(source: Source.cache));
      if (documentList.docs.isEmpty)
        await _seriesCollection
            .orderBy("name")
            .limit(limit)
            .get(GetOptions(source: Source.server));
      lastDocument = documentList.docs.last;

      return documentList.docs
          .map((doc) => Series.fromMap(doc.data(), doc.id))
          .toList();
    } else {
      QuerySnapshot documentList = await _seriesCollection
          .orderBy("name")
          .limit(limit)
          .startAfterDocument(lastDocument)
          .get();
      lastDocument = documentList.docs.last;
      return documentList.docs
          .map((doc) => Series.fromMap(doc.data(), doc.id))
          .toList();
    }
  }

  static Future<List<Series>> searchTeams(String searchKey, int limit) async {
    String endingSearchKey = incrementLastChar(searchKey);
    try {
      QuerySnapshot documentList = await _seriesCollection
          .where('name', isGreaterThanOrEqualTo: searchKey)
          .where('name', isLessThan: endingSearchKey)
          .get();
      print(documentList.docs.first.data());
      return documentList.docs
          .map((doc) => Series.fromMap(doc.data(), doc.id))
          .toList();
    } catch (error) {
      print(error);
    }
    return null;
  }

  static String incrementLastChar(String x) {
    String s = x;
    if (x != null && x.length > 0) {
      s = s.toLowerCase();
      String a = s.substring(s.length - 1);
      int lastChar = a.codeUnits[0];
      lastChar++;
      s = s.substring(0, s.length - 1) + String.fromCharCode(lastChar);
    }
    return (s);
  }
}
