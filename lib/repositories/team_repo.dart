import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fantasy_cricket/models/team.dart';

abstract class TeamRepo {
  static final CollectionReference _teamCollection = FirebaseFirestore.instance
    .collection('teams');
  
  // returns true if team's name is not taken already, false otherwise
  static Future<bool> checkTeamName(Team team) async {
    QuerySnapshot querySanpshot = await _teamCollection
      .where('name', isEqualTo: team.name).get();

    if(querySanpshot.docs.isEmpty || 
      // Name field is unique, so we can get only one document (even if team's 
      // name is changed to update) that matches. Now, if the matched document's 
      // id matches then there is no other team with the same name.
      (team.id != null && querySanpshot.docs[0].id == team.id)) {
      return true;
    } else {
      return false;
    }
  }

  static Future<void> addTeam(Team team) async {
    await _teamCollection.add(team.toMap());
  }

  static Future<void> updateTeam(Team team) async {
    await _teamCollection.doc(team.id).update(team.toMap());
  }

  static Future<void> fetchAllTeams(List<Team> allTeams) async {
    QuerySnapshot snapshot = await _teamCollection.get();

    snapshot.docs.forEach((QueryDocumentSnapshot snapshot) {
      allTeams.add(Team.fromMap(snapshot.data(), snapshot.id));
    });
  }

  static Future<Team> getTeamById(String id) async {
    DocumentSnapshot doc = await _teamCollection.doc(id).get();
    return Team.fromMap(doc.data(), doc.id);
  }
}
