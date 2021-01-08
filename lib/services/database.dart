import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fantasy_cricket/model/player.dart';

class DataBase {
  final CollectionReference _playerCollection =
      Firestore.instance.collection('player');

  List<Player> _playerListFromSnapshot(QuerySnapshot snapshot) {
    return snapshot.documents.map((e) => 
      Player.fromMap(e.data)
    ).toList();
  }

  Stream<List<Player>> get Players {
    return _playerCollection.snapshots().map(_playerListFromSnapshot);
  }

  Future addPlayers(Player player){

  }
}
