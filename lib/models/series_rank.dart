import 'package:cloud_firestore/cloud_firestore.dart';

// keys
const String JOINED_AT_KEY = 'joinedAt';
const String RANK_KEY = 'rank';
const String SERIES_ID_KEY = 'seriesId';
const String TOTAL_POINTS_KEY = 'totalPoints';
const String USERNAME_KEY = 'username';

class SeriesRank {
  String id;
  Timestamp joinedAt;
  int rank;
  String seriesId;
  double totalPoints;
  String username;

  SeriesRank({
    this.id,
    this.joinedAt,
    this.rank,
    this.seriesId,
    this.totalPoints,
    this.username,
  });

  SeriesRank.fromMap(Map<String, dynamic> doc, String docId) {
    id = docId;
    joinedAt = doc[JOINED_AT_KEY];
    rank = doc[RANK_KEY];
    seriesId = doc[SERIES_ID_KEY];
    totalPoints = doc[TOTAL_POINTS_KEY];
    username = doc[USERNAME_KEY];
  }

  Map<String, dynamic> toMap() {
    return {
      JOINED_AT_KEY: joinedAt,
      RANK_KEY: rank,
      SERIES_ID_KEY: seriesId,
      TOTAL_POINTS_KEY: totalPoints,
      USERNAME_KEY: username,
    };
  }
}
