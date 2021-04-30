import 'package:cloud_firestore/cloud_firestore.dart';

// keys
const String ID_KEY = 'id';
const String TYPE_KEY = 'type';
const String NO_KEY = 'no';
const String TEAMS_IDS_KEY = 'teamsIds';
const String TEAMS_NAMES_KEY = 'teamsNames';
const String START_TIME_KEY = 'startTime';
const String STATUS_KEY = 'status';

class Excerpt {
  String id;
  String type;
  int no;
  List<String> teamsIds = [];
  List<String> teamsNames = [];
  Timestamp startTime;
  String status;

  Excerpt({
    this.id,
    this.type,
    this.no,
    this.teamsIds,
    this.teamsNames,
    this.startTime,
    this.status = 'Upcoming',
  });

  Excerpt.fromMap(Map<String, dynamic> map) {
    id = map[ID_KEY];
    type = map[TYPE_KEY];
    no = map[NO_KEY];
    teamsIds = [];
    teamsNames = [];
    startTime = map[START_TIME_KEY];
    status = map[STATUS_KEY];

    // the type of array in firestore is always dynamic
    map[TEAMS_IDS_KEY].forEach((dynamic teamId) {
      teamsIds.add(teamId);
    });

    map[TEAMS_NAMES_KEY].forEach((dynamic teamName) {
      teamsNames.add(teamName);
    });
  }

  Map<String, dynamic> toMap() {
    return {
      ID_KEY: id,
      TYPE_KEY: type,
      NO_KEY: no,
      TEAMS_IDS_KEY: teamsIds,
      TEAMS_NAMES_KEY: teamsNames,
      START_TIME_KEY: startTime,
      STATUS_KEY: status,
    };
  }

  @override
  String toString() {
    return '{ id: $id, type: $type, no: $no, teamsIds: $teamsIds, ' + 
      'teamsNames: $teamsNames, startTime: $startTime, status: $status }';
  }
}
