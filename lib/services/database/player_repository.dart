import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fantasy_cricket/model/player_nr.dart';

abstract class PlayerRepository {
  Future<void> addPlayer(Playernr player);
}

class FsPlayerRepository implements PlayerRepository {
  final CollectionReference _playerCollection =
      Firestore.instance.collection('players');

  @override
  Future<void> addPlayer(Playernr player) async {
    Timer(Duration(seconds: 3), () {print("Yeah, this line is printed after 3 seconds");});
    _playerCollection
        .add({'name': player.name, 'role': player.role}).catchError((error) {
      print(error);
    }).whenComplete(() => print("Player added"));
  }
}

class NetworkException implements Exception {}
