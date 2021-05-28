import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fantasy_cricket/models/team.dart';

abstract class TeamRepo {
  static final CollectionReference _teamCollection =
      FirebaseFirestore.instance.collection('teams');
  static DocumentSnapshot lastDocument;

  static Future<Team> getTeamById(String id) async {
    DocumentSnapshot doc = await _teamCollection.doc(id).get();
    return Team.fromMap(doc.data(), doc.id);
  }

}
