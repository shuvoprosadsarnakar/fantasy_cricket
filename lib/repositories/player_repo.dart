/*
  Author: Rangan Roy
  Purpose: Testing
*/

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fantasy_cricket/models/player.dart';

abstract class PlayerRepo {
  static final CollectionReference _playerCollection =
      Firestore.instance.collection('player');
  static DocumentSnapshot lastDocument;
  // returns true if player's name is not taken already, false otherwise
  static Future<bool> checkPlayerName(Player player) async {
    QuerySnapshot querySanpshot = await _playerCollection
        .where('name', isEqualTo: player.name)
        .getDocuments();

    if (querySanpshot.documents.isEmpty ||
        // Name field is unique, so we can get only one document (even if player's
        // name is changed to update) that matches. Now, if the matched document's
        // id matches then there is no other player with the same name.
        (player.id != null &&
            querySanpshot.documents[0].documentID == player.id)) {
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

  static Future<bool> deletePlayer(Player player) async {
    await _playerCollection.document(player.id).delete().whenComplete(() {
      print("deleted");
      return true;
    }).onError((error, stackTrace) {
      print(error);
      return false;
    });
  }

  static Future<List<Player>> fetchPlayers(int startIndex, int limit) async {
    if (startIndex == 0) {
      QuerySnapshot documentList =
          await _playerCollection.orderBy("name").limit(limit).getDocuments();
      lastDocument = documentList.documents.last;

      return documentList.documents
          .map((doc) => Player.fromMap(doc.data, doc.documentID))
          .toList();
    } else {
      QuerySnapshot documentList = await _playerCollection
          .orderBy("name")
          .limit(limit)
          .startAfterDocument(lastDocument)
          .getDocuments();
      lastDocument = documentList.documents.last;
      return documentList.documents
          .map((doc) => Player.fromMap(doc.data, doc.documentID))
          .toList();
    }
  }
}
