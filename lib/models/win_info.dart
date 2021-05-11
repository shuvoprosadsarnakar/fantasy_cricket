import 'package:cloud_firestore/cloud_firestore.dart';

// keys
const String DATE_KEY = 'date';
const String DETAILS_KEY = 'details';
const String RANK_KEY = 'rank';
const String REWARDS_KEY = 'rewards';

class WinInfo {
  Timestamp date;
  String details;
  int rank;
  int rewards;

  WinInfo({
    this.date,
    this.details,
    this.rank,
    this.rewards,
  });

  WinInfo.fromMap(Map<String, dynamic> doc) {
    date = doc[DATE_KEY];
    details = doc[DETAILS_KEY];
    rank = doc[RANK_KEY];
    rewards = doc[REWARDS_KEY];
  }

  Map<String, dynamic> toMap() {
    return {
      DATE_KEY: date,
      DETAILS_KEY: details,
      RANK_KEY: rank,
      REWARDS_KEY: rewards,
    };
  }
}
