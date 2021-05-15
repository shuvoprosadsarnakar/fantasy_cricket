import 'package:cloud_firestore/cloud_firestore.dart';

// keys
const String USERNAME_KEY = 'username';
const String TOTAL_POINTS_KEY = 'totalPoints';
const String JOINED_AT_KEY = 'joinedAt';

class Rank {
  String username;
  double totalPoints;
  Timestamp joinedAt;

  Rank({
    this.username,
    this.totalPoints,
    this.joinedAt,
  });

  Rank.fromMap(Map<String, dynamic> doc) {
    username = doc[USERNAME_KEY];
    totalPoints = doc[TOTAL_POINTS_KEY];
    joinedAt = doc[JOINED_AT_KEY];
  }

  Map<String, dynamic> toMap() {
    return {
      USERNAME_KEY: username,
      TOTAL_POINTS_KEY: totalPoints,
      JOINED_AT_KEY: joinedAt,
    };
  }
}
