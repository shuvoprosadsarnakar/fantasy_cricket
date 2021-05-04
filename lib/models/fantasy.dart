import 'package:cloud_firestore/cloud_firestore.dart';

// keys
const String CONTEST_ID_KEY = 'contestId';
const String CREATED_AT_KEY = 'createdAt';
const String USERNAME_KEY = 'username';
const String TOTAL_POINTS_KEY = 'totalPoints';
const String PLAYERS_NAMES_KEY = 'playersNames';
const String CAPTAIN_KEY = 'captain';
const String VICE_CAPTAIN_KEY = 'viceCaptain';

class Fantasy {
  String id;
  String contestId;
  String username;
  List<String> playersNames = [];
  double totalPoints;
  Timestamp createdAt;
  String captain;
  String viceCaptain;

  Fantasy();

  Fantasy.fromMap(Map<String, dynamic> doc, String docId) {
    id = docId;
    contestId = doc[CONTEST_ID_KEY];
    username = doc[USERNAME_KEY];
    totalPoints = doc[TOTAL_POINTS_KEY];
    createdAt = doc[CREATED_AT_KEY];
    captain = doc[CAPTAIN_KEY];
    viceCaptain = doc[VICE_CAPTAIN_KEY];

    doc[PLAYERS_NAMES_KEY].forEach((dynamic playerName) {
      playersNames.add(playerName);
    });
  }

  Map<String, dynamic> toMap() {
    return {
      CONTEST_ID_KEY: contestId,
      USERNAME_KEY: username,
      PLAYERS_NAMES_KEY: playersNames,
      TOTAL_POINTS_KEY: totalPoints,
      CREATED_AT_KEY: createdAt,
      CAPTAIN_KEY: captain,
      VICE_CAPTAIN_KEY: viceCaptain,
    };
  }
}
