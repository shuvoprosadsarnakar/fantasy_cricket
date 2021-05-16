import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fantasy_cricket/models/contest.dart';
import 'package:fantasy_cricket/models/fantasy.dart';
import 'package:fantasy_cricket/models/series.dart';
import 'package:fantasy_cricket/models/user.dart';

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

  static Future<void> addFantasy(Fantasy fantasy, User user, Contest contest,
    Series series) async {
    WriteBatch batch = _db.batch();

    batch.set(_fantasyCollection.doc(), fantasy.toMap());
    batch.update(_db.collection('users').doc(user.id), user.toMap());
    batch.update(_db.collection('contests').doc(contest.id), contest.toMap());
    batch.update(_db.collection('serieses').doc(series.id), series.toMap());
    
    await batch.commit();
  }

  static Future<void> updateFantasy(Fantasy fantasy) async {
    await _fantasyCollection.doc(fantasy.id).update(fantasy.toMap());
  }
}
