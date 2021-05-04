import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fantasy_cricket/models/fantasy.dart';
import 'package:fantasy_cricket/models/user.dart';

class FantasyRepo {
  static final CollectionReference _fantasies = FirebaseFirestore.instance
    .collection('fantasies');

  static Future<Fantasy> getFantasyById(String id) async {
    DocumentSnapshot snapshot = await _fantasies.doc(id).get();
    return Fantasy.fromMap(snapshot.data(), snapshot.id);
  }

  static Future<void> addFantasy(Fantasy fantasy, User user, String contestId) 
    async {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    WriteBatch batch = firestore.batch();
    DocumentReference userDocRef = firestore.collection('users').doc(user.id);
    DocumentReference fantasyDocRef = _fantasies.doc(user.id + contestId);

    batch.update(userDocRef, user.toMap());
    batch.set(fantasyDocRef, fantasy.toMap());
    batch.commit();
  }

  static Future<void> updateFantasy(Fantasy fantasy) async {
    await _fantasies.doc(fantasy.id).update(fantasy.toMap());
  }
}
