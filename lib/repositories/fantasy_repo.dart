import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fantasy_cricket/models/contest.dart';
import 'package:fantasy_cricket/models/fantasy.dart';
import 'package:fantasy_cricket/models/rank.dart';
import 'package:fantasy_cricket/models/series.dart';
import 'package:fantasy_cricket/models/user.dart';
import 'package:fantasy_cricket/repositories/series_repo.dart';
import 'package:fantasy_cricket/repositories/user_repo.dart';

class FantasyRepo {
  static final FirebaseFirestore _db = FirebaseFirestore.instance;
  static final CollectionReference _fantasyCollection = _db
    .collection('fantasies');

  static Future<Fantasy> getFantasy(String username, String contestId) async {
    QuerySnapshot querySnapshot = await _fantasyCollection
      .where('username', isEqualTo: username)
      .where('contestId', isEqualTo: contestId)
      .get();

    QueryDocumentSnapshot documentSnapshot = querySnapshot.docs.first;

    return Fantasy.fromMap(documentSnapshot.data(), documentSnapshot.id);
  }

  static Future<List<Fantasy>> getFantasiesByContestId(String contestId) async {
    QuerySnapshot querySnapshot = await _fantasyCollection
      .where('contestId', isEqualTo: contestId)
      .get();

    return querySnapshot.docs.map((QueryDocumentSnapshot snapshot) {
      return Fantasy.fromMap(snapshot.data(), snapshot.id);
    }).toList();
  }

  static Future<void> addFantasy(Fantasy fantasy, String userId, 
    Contest contest) async 
  {
    // add the fantasy
    // update series's [ranks] property 
    // update contest's [ranks] property
    // update user's [contestIds] & [seriesIds] properties

    DocumentReference contestRef = _db.collection('contests').doc(contest.id);
    DocumentReference seriesRef 
      = _db.collection('serieses').doc(contest.seriesId);
    DocumentReference userRef = _db.collection('users').doc(userId);
    DocumentReference fantasyRef = _fantasyCollection.doc();

    await _db.runTransaction((Transaction transaction) {
      return transaction.get(contestRef).then((DocumentSnapshot snapshot) {
        Contest contest = Contest.fromMap(snapshot.data(), snapshot.id);
        
        return transaction.get(seriesRef).then((DocumentSnapshot snapshot) {
          Series series = Series.fromMap(snapshot.data(), snapshot.id);

          return transaction.get(userRef).then((DocumentSnapshot snapshot) {
            User user = User.fromMap(snapshot.data(), snapshot.id);
            
            if(user.contestIds.contains(contest.id)) {
              throw 'User already joined the contest by another device.';
            }
            
            Rank rank = Rank(
              username: user.username,
              totalPoints: 0,
              joinedAt: Timestamp.fromDate(DateTime.now()),
            );

            user.contestIds.add(contest.id);
            contest.ranks.add(rank);

            if(user.seriesIds.contains(contest.seriesId) == false) {
              user.seriesIds.add(contest.seriesId);
              series.ranks.add(rank);
              transaction.update(seriesRef, series.toMap());
            }

            transaction.set(fantasyRef, fantasy.toMap());
            transaction.update(userRef, user.toMap());
            transaction.update(contestRef, contest.toMap());
          });
        });
      });
    });
  }

  static Future<void> updateFantasy(Fantasy fantasy) async {
    await _fantasyCollection.doc(fantasy.id).update(fantasy.toMap());
  }
}
