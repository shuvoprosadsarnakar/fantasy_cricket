import 'package:cloud_firestore/cloud_firestore.dart';

// keys
const String ID_KEY = 'id';
const String TYPE_KEY = 'type';
const String NO_KEY = 'no';
const String TEAM_IDS_KEY = 'teamIds';
const String START_TIME_KEY = 'startTime';

class MatchExcerpt {
  String id;
  String type;
  int no;
  List<String> teamIds;
  Timestamp startTime;

  MatchExcerpt({this.id, this.type, this.no, this.teamIds, this.startTime});

  MatchExcerpt.fromMap(Map<String, dynamic> map) {
    id = map[ID_KEY];
    type = map[TYPE_KEY];
    no = map[NO_KEY];
    teamIds = map[TEAM_IDS_KEY];
    startTime = map[START_TIME_KEY];
  }

  Map<String, dynamic> toMap() {
    return {
      ID_KEY: id,
      TYPE_KEY: type,
      NO_KEY: no,
      TEAM_IDS_KEY: teamIds,
      START_TIME_KEY: startTime,
    };
  }

  @override
  String toString() {
    return '{ id: $id, type: $type, no: $no, teamIds: $teamIds, ' + 
      'startTime: $startTime }';
  }
}
