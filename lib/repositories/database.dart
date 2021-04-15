import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fantasy_cricket/models/player.dart';

class DataBase {
  final CollectionReference _playerCollection =
      Firestore.instance.collection('player');

  Stream<List<Player>> get players {
    return _playerCollection.snapshots().map((snapshot) {
      return snapshot.documents
          .map((doc) => Player.fromMap(doc.data, doc.documentID))
          .toList();
    });
  }

  Future addPlayer(Player player) {
    return _playerCollection.add({
      'name': player.name,
      'role': player.role
    }).whenComplete(() => print("added"));
  }

  Future updatePlayer(Player player) {
    return _playerCollection.document(player.id).updateData({
      'name': player.name,
      'role': player.role
    }).whenComplete(() => print("updated"));
  }

  Future deletePlayer(String documentID) async {
    await _playerCollection
        .document(documentID)
        .delete()
        .whenComplete(() => print("deleted"));
  }
}
