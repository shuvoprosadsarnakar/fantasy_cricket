import 'package:cloud_firestore/cloud_firestore.dart';

// keys
const String ID_KEY = 'id';
const String TYPE_KEY = 'type';
const String NO_KEY = 'no';
const String TEAM_IDS_KEY = 'teamIds';
const String START_TIME_KEY = 'startTime';
const String STATUS_KEY = 'status';

class MatchExcerpt {
  String id;
  String type;
  int no;
  List<String> teamIds = [];
  Timestamp startTime;
  String status;

  MatchExcerpt({
    this.id,
    this.type,
    this.no,
    this.teamIds,
    this.startTime,
    this.status = 'Upcoming',
  });

  MatchExcerpt.fromMap(Map<String, dynamic> map) {
    id = map[ID_KEY];
    type = map[TYPE_KEY];
    no = map[NO_KEY];
    startTime = map[START_TIME_KEY];
    status = map[STATUS_KEY];

    map[TEAM_IDS_KEY].forEach((dynamic teamId) {
      teamIds.add(teamId.toString());
    });
  }

  Map<String, dynamic> toMap() {
    return {
      ID_KEY: id,
      TYPE_KEY: type,
      NO_KEY: no,
      TEAM_IDS_KEY: teamIds,
      START_TIME_KEY: startTime,
      STATUS_KEY: status,
    };
  }

  @override
  String toString() {
    return '{ id: $id, type: $type, no: $no, teamIds: $teamIds, ' + 
      'startTime: $startTime, status: $status }';
  }
}
