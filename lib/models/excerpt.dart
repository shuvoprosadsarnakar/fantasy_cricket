import 'package:cloud_firestore/cloud_firestore.dart';

// keys
const String ID_KEY = 'id';
const String TYPE_KEY = 'type';
const String NO_KEY = 'no';
const String TEAMS_IDS_KEY = 'teamsIds';
const String TEAMS_NAMES_KEY = 'teamsNames';
const String TEAM_IMAGES_KEY = 'teamImages';
const String START_TIME_KEY = 'startTime';
const String STATUS_KEY = 'status';
const String TOTAL_CHIPS_KEY = 'totalChips';
const String TOTAL_WINNERS_KEY = 'totalWinners';

class Excerpt {
  String id;
  String type;
  int no;
  List<String> teamsIds; // to get team players for contest
  List<String> teamsNames;
  List<String> teamImages;
  Timestamp startTime;
  String status;
  int totalChips;
  int totalWinners;

  Excerpt({
    this.id,
    this.type,
    this.no,
    this.teamsIds,
    this.teamsNames,
    this.teamImages,
    this.startTime,
    this.status = 'Upcoming',
    this.totalChips,
    this.totalWinners,
  }) {
    if(teamsIds == null) teamsIds = <String>[];
    if(teamsNames == null) teamsNames = <String>[];
    if(teamImages == null) teamsNames = <String>[];
  }

  Excerpt.fromMap(Map<String, dynamic> map) {
    id = map[ID_KEY];
    type = map[TYPE_KEY];
    no = map[NO_KEY];
    teamsIds = <String>[];
    teamsNames = <String>[];
    teamImages = <String>[];
    startTime = map[START_TIME_KEY];
    status = map[STATUS_KEY];
    totalChips = map[TOTAL_CHIPS_KEY];
    totalWinners = map[TOTAL_WINNERS_KEY];

    // the type of array in firestore is always dynamic
    map[TEAMS_IDS_KEY].forEach((dynamic teamId) {
      teamsIds.add(teamId);
    });

    map[TEAMS_NAMES_KEY].forEach((dynamic teamName) {
      teamsNames.add(teamName);
    });

    map[TEAM_IMAGES_KEY].forEach((dynamic teamImage) {
      teamImages.add(teamImage);
    });
  }

  Map<String, dynamic> toMap() {
    return {
      ID_KEY: id,
      TYPE_KEY: type,
      NO_KEY: no,
      TEAMS_IDS_KEY: teamsIds,
      TEAMS_NAMES_KEY: teamsNames,
      TEAM_IMAGES_KEY: teamImages,
      START_TIME_KEY: startTime,
      STATUS_KEY: status,
      TOTAL_CHIPS_KEY: totalChips,
      TOTAL_WINNERS_KEY: totalWinners,
    };
  }
}
