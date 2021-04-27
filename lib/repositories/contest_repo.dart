import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fantasy_cricket/models/contest.dart';
import 'package:fantasy_cricket/models/series.dart';

class ContestRepo {
  static final _db = FirebaseFirestore.instance;
  static final _contests = _db.collection('contests');

  static Future<void> addContest(Contest contest, Series series, 
    int excerptIndex) async {
    WriteBatch batch = _db.batch();
    DocumentReference docRef = _contests.doc();

    // insert contest into db
    batch.set(docRef, contest.toMap());
    
    // edit series excerpt
    series.matchExcerpts[excerptIndex].id = docRef.id;
    series.matchExcerpts[excerptIndex].status = 'Running';

    // update series excerpt
    docRef = _db.collection('serieses').doc(series.id);
    batch.update(docRef, series.toMap());

    await batch.commit();
  }

  static Future<Contest> getContestById(String id) async {
    DocumentSnapshot doc = await _contests.doc(id).get();
    return Contest.fromMap(doc.data(), doc.id);
  }

  static Future<void> updateContest(Contest contest) async {
    await _contests.doc(contest.id).update(contest.toMap());
  }

  static Future<void> updateSeriesAndContest(Series series, Contest contest) 
    async {
    WriteBatch batch = _db.batch();
    DocumentReference seriesRef = _db.collection('serieses').doc(series.id);
    DocumentReference contestRef = _contests.doc(contest.id);

    batch.update(seriesRef, series.toMap());
    batch.update(contestRef, contest.toMap());
    await batch.commit();
  }
}
