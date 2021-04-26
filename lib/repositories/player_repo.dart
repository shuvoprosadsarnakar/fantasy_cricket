import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fantasy_cricket/models/player.dart';

abstract class PlayerRepo {
  static final CollectionReference _playerCollection =
      FirebaseFirestore.instance.collection('players');
  static DocumentSnapshot lastDocument;

  // returns true if player's name is not taken already, false otherwise
  static Future<bool> checkPlayerName(Player player) async {
    QuerySnapshot querySanpshot =
        await _playerCollection.where('name', isEqualTo: player.name).get();

    if (querySanpshot.docs.isEmpty ||
        // Name field is unique, so we can get only one document (even if
        // player's name is changed to update) that matches. Now, if the matched
        // document's id matches then there is no other player with the same
        // name.
        (player.id != null && querySanpshot.docs[0].id == player.id)) {
      return true;
    } else {
      return false;
    }
  }

  static Future<void> addPlayer(Player player) async {
    await _playerCollection.add(player.toMap());
  }

  static Future<void> updatePlayer(Player player) async {
    await _playerCollection.doc(player.id).update(player.toMap());
  }

  static Future<void> deletePlayer(Player player) async {
    await _playerCollection.doc(player.id).delete().whenComplete(() {
      print("player deleted");
      return true;
    }).onError((error, stackTrace) {
      print(error);
      return false;
    });
  }

  static Future<List<Player>> fetchPlayers(int startIndex, int limit) async {
    if (startIndex == 0) {
      QuerySnapshot documentList =
          await _playerCollection.orderBy("name").limit(limit).get();
      lastDocument = documentList.docs.last;

      return documentList.docs
          .map((doc) => Player.fromMap(doc.data(), doc.id))
          .toList();
    } else {
      QuerySnapshot documentList = await _playerCollection
          .orderBy("name")
          .limit(limit)
          .startAfterDocument(lastDocument)
          .get();
      lastDocument = documentList.docs.last;
      return documentList.docs
          .map((doc) => Player.fromMap(doc.data(), doc.id))
          .toList();
    }
  }

  static Future<List<Player>> searchPlayers(String searchKey, int limit) async {
    try {
      QuerySnapshot documentList = await _playerCollection
          .where('name', isGreaterThanOrEqualTo:"wa")
          .where('name', isLessThan:"wb")
          .get();
      print(documentList.docs.first.data());
      return documentList.docs
          .map((doc) => Player.fromMap(doc.data(), doc.id))
          .toList();
    } catch (error) {
      print(error);
    }
  }

  static Future<void> assignAllPlayers(List<Player> allPlayers) async {
    QuerySnapshot snapshot =  await _playerCollection.get();

    snapshot.docs.forEach((DocumentSnapshot snapshot) {
      allPlayers.add(Player.fromMap(snapshot.data(), snapshot.id));
    });
  }
}
