import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fantasy_cricket/model/player.dart';

class DataBase {
  final CollectionReference _playerCollection =
      Firestore.instance.collection('player');

  List<Player> _playerListFromSnapshot(QuerySnapshot snapshot) {
    return snapshot.documents.map((e) => Player.fromMap(e.data,e.documentID)).toList();
  }

  Stream<List<Player>> get players {
    //print(_playerCollection.document().snapshots());
    return _playerCollection.snapshots().map(_playerListFromSnapshot);
  }

  Future addPlayers(Player player) {
    return _playerCollection.add({
      'name': player.name,
      'nationality': player.nationality,
      'handed': player.handed,
      'role': player.role
    });
  }

  Future deletePlayer(String documentID) async{
    await _playerCollection.document(documentID).delete().whenComplete(() => print("deleted"));
  }
}
