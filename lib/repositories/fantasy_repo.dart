import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fantasy_cricket/models/contest.dart';
import 'package:fantasy_cricket/models/fantasy.dart';
import 'package:fantasy_cricket/models/series.dart';
import 'package:fantasy_cricket/models/series_rank.dart';
import 'package:fantasy_cricket/models/user.dart';
import 'package:fantasy_cricket/repositories/series_repo.dart';

class FantasyRepo {
  static final CollectionReference _fantasies = FirebaseFirestore.instance
    .collection('fantasies');

  static Future<Fantasy> getFantasyById(String id) async {
    DocumentSnapshot snapshot = await _fantasies.doc(id).get();
    return Fantasy.fromMap(snapshot.data(), snapshot.id);
  }

  static Future<List<Fantasy>> getFantasiesByContestId(String contestId) async {
    QuerySnapshot snapshot = await _fantasies
      .where('contestId', isEqualTo: contestId)
      .orderBy('totalPoints')
      .get();

    return snapshot.docs.map((QueryDocumentSnapshot snapshot) {
      return Fantasy.fromMap(snapshot.data(), snapshot.id);
    }).toList();
  }

  static Future<void> addFantasy(Fantasy fantasy, User user) async {
    FirebaseFirestore db = FirebaseFirestore.instance;
    DocumentReference contestRef = db.collection('contests')
      .doc(user.contestIds.last);
    
    await db.runTransaction((transaction) {
      // This code may get re-run multiple times if there are conflicts.
      // 'Conflicts' means [contest] doc gets changed before transictions.
      return transaction.get(contestRef).then((snapshot) async {
        if(!snapshot.exists) throw "Document does not exist!";

        // set fantasy rank and increase contest total contestents by 1
        Contest contest = Contest.fromMap(snapshot.data(), snapshot.id);
        
        contest.totalContestents = contest.totalContestents + 1;
        fantasy.createdAt = Timestamp.fromDate(DateTime.now());
        fantasy.rank = contest.totalContestents;
        
        DocumentReference fantasyRef = _fantasies.doc(user.id +contest.id);
        DocumentReference userRef = db.collection('users').doc(user.id);

        if(user.seriesIds.contains(contest.seriesId) == false) {
          user.seriesIds.add(contest.seriesId);

          // get series for the latest series [totalContestents] property value
          // and increase the value by 1
          Series series = await SeriesRepo.getSeriesById(contest.seriesId);
          series.totalContestents = series.totalContestents + 1;

          // create and init a [SeriesRank] object
          SeriesRank seriesRank = SeriesRank(
            joinedAt: Timestamp.fromDate(DateTime.now()),
            rank: series.totalContestents,
            seriesId: series.id,
            totalPoints: 0,
            username: user.username,
          );

          DocumentReference seriesRef = 
            db.collection('serieses').doc(series.id);
          DocumentReference seriesRankRef = db.collection('seriesRanks').doc(
            user.id + series.id);

          transaction.set(seriesRankRef, seriesRank.toMap());
          transaction.update(seriesRef, series.toMap());
        }

        transaction.set(fantasyRef, fantasy.toMap());
        transaction.update(contestRef, contest.toMap());
        transaction.update(userRef, user.toMap());
      });
    });
  }

  static Future<void> updateFantasy(Fantasy fantasy) async {
    await _fantasies.doc(fantasy.id).update(fantasy.toMap());
  }
}
