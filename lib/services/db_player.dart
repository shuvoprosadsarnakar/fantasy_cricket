import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fantasy_cricket/models/player.dart';

abstract class DbPlayer {
  static final CollectionReference _playerCollection = Firestore.instance
    .collection('players');

  // returns true if player's name is not taken already, false otherwise
  static Future<bool> checkPlayerName(Player player) async {
    QuerySnapshot querySanpshot = await _playerCollection
      .where('name', isEqualTo: player.name).getDocuments();
    
    if(querySanpshot.documents.isEmpty || 
      // Name field is unique, so we can get only one document (even if player's 
      // name is changed to update) that matches. Now, if the matched document's 
      // id matches then there is no other player with the same name.
      (player.id != null && querySanpshot.documents[0].documentID == player.id)) 
      {
      return true;
    }
    
    return false;
  }

  static Future<void> addPlayer(Player player) async {
    await _playerCollection.add(player.toMap());
  }

  static Future<void> updatePlayer(Player player) async {
    await _playerCollection.document(player.id).updateData(player.toMap());
  }
}