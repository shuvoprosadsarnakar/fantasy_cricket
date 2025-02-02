import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fantasy_cricket/models/contest.dart';
import 'package:fantasy_cricket/models/distribute.dart';
import 'package:fantasy_cricket/models/series.dart' as seriesModel;
import 'package:fantasy_cricket/models/user.dart';

class ContestRepo {
  static final _db = FirebaseFirestore.instance;
  static final _contestCollection = _db.collection('contests');

  static Future<void> addContest(Contest contest, seriesModel.Series series, 
    int excerptIndex) async {
    WriteBatch batch = _db.batch();
    DocumentReference docRef = _contestCollection.doc();

    // insert contest into db
    batch.set(docRef, contest.toMap());
    
    // edit series excerpt
    series.matchExcerpts[excerptIndex].id = docRef.id;
    series.matchExcerpts[excerptIndex].status = 'Running';
    series.matchExcerpts[excerptIndex].totalChips = 0;
    series.matchExcerpts[excerptIndex].totalWinners = contest
      .chipsDistributes[contest.chipsDistributes.length - 1].to;

    contest.chipsDistributes.forEach((Distribute distribute) {
      series.matchExcerpts[excerptIndex].totalChips 
        += distribute.chips * (distribute.to - distribute.from + 1);
    });

    // update series excerpt
    docRef = _db.collection('serieses').doc(series.id);
    batch.update(docRef, series.toMap());

    await batch.commit();
  }

  static Future<Contest> getContestById(String id) async {
    DocumentSnapshot snapshot = await _contestCollection.doc(id).get();
    return Contest.fromMap(snapshot.data(), snapshot.id);
  }

  static Future<void> updateContest(Contest contest) async {
    final DocumentReference contestRef = _contestCollection.doc(contest.id);
    
    await _db.runTransaction((Transaction transaction) {
      return transaction.get(contestRef).then((DocumentSnapshot doc) {
        // get new rank if any
        contest.ranks = Contest.fromMap(doc.data(), doc.id).ranks;
        transaction.update(contestRef, contest.toMap());
      });
    });
  }

  static Future<void> endContest(Contest contest, seriesModel.Series series,
    List<User> contestWinners, List<User> seriesWinners) async {
    WriteBatch batch = _db.batch();
    DocumentReference docRef;
    
    docRef = _contestCollection.doc(contest.id);
    batch.update(docRef, contest.toMap());

    docRef = _db.collection('serieses').doc(series.id);
    batch.update(docRef, series.toMap());

    contestWinners.forEach((User user) {
      docRef = _db.collection('users').doc(user.id);
      batch.update(docRef, user.toMap());
    });

    if(seriesWinners != null) seriesWinners.forEach((User user) {
      if(user != null) {
        docRef = _db.collection('users').doc(user.id);
        batch.update(docRef, user.toMap());
      }
    });

    await batch.commit();
  }

  static Future<void> updateIsContestEnding(bool isContestEnding) async {
    await _contestCollection
      .doc('info')
      .update({'isContestEnding': isContestEnding});
  }
}
