import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fantasy_cricket/models/team.dart';

abstract class DbTeam {
  static final Firestore _db = Firestore.instance;
  static final CollectionReference _teamCollection = _db.collection('teams');

  // fetch a player document by id and returns it
  static Future<DocumentSnapshot> getPlayerById(String playerId) async {
    return await _db.collection('players').document(playerId).get();
  }
  
  // returns true if team's name is not taken already, false otherwise
  static Future<bool> checkTeamName(Team team) async {
    QuerySnapshot querySanpshot = await _teamCollection
      .where('name', isEqualTo: team.name).getDocuments();

    if(querySanpshot.documents.isEmpty || 
      // Name field is unique, so we can get only one document (even if team's 
      // name is changed to update) that matches. Now, if the matched document's 
      // id matches then there is no other team with the same name.
      (team.id != null && querySanpshot.documents[0].documentID == team.id)) 
      {
      return true;
    }
    
    return false;
  }

  static Future<void> addTeam(Team team) async {
    await _teamCollection.add(team.toMap());
  }

  static Future<void> updateTeam(Team team) async {
    await _teamCollection.document(team.id).updateData(team.toMap());
  }
}
