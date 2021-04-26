import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fantasy_cricket/models/chips_distribute.dart';

// keys
const String ID_KEY = 'id';
const String SERIES_NAME_KEY = 'seriesName';
const String TEAMS_NAMES_KEY = 'teamsNames';
const String MATCH_TYPE_KEY = 'matchType';
const String NO_BY_TYPE_KEY = 'noByType';
const String START_TIME_KEY = 'startTime';
const String CHIPS_DISTRIBUTES_KEY = 'chipsDistributes';
const String TEAM_1_TOTAL_PLAYERS_KEY = 'team1TotalPlayers';
const String PLAYERS_NAMES_KEY = 'playersNames';
const String PLAYERS_ROLES_KEY = 'playersRoles';
const String PLAYERS_CREDITS_KEY = 'playersCredits';
const String PLAYERS_POINTS_KEY = 'playersPoints';
const String PLAYERS_REPORTS_KEY = 'playersReports';
const String IS_PLAYINGS_KEY = 'isPlaying';
const String SERIES_ID_KEY = 'seriesId';
const String EXCERPT_INDEX_KEY = 'excerptIndex';

class Contest {
  // contest id and excerpt id
  String id;

  // to create contests list ui item except upcoming contests list
  String seriesName;
  List<String> teamsNames;
  String matchType;
  int noByType;
  Timestamp startTime;

  // to show match details
  List<ChipsDistribute> chipsDistributes;
  int team1TotalPlayers;
  List<String> playersNames;
  List<String> playersRoles;
  List<double> playersCredits;
  List<double> playersPoints;
  List<Report> playersReports;
  List<bool> isPlayings;
  
  // to update excerpt match status and set excerpt id
  String seriesId;
  int excerptIndex;

  Contest();

  Contest.fromMap(Map<String, dynamic> doc, String docId) {
    id = docId;
    seriesName = doc[SERIES_NAME_KEY];
    matchType = doc[MATCH_TYPE_KEY];
    noByType = doc[NO_BY_TYPE_KEY];
    startTime = doc[START_TIME_KEY];
    team1TotalPlayers = doc[TEAM_1_TOTAL_PLAYERS_KEY];
    seriesId = doc[SERIES_ID_KEY];
    excerptIndex = doc[EXCERPT_INDEX_KEY];
    teamsNames = [];
    chipsDistributes = [];
    playersNames = [];
    playersRoles = [];
    playersCredits = [];
    isPlayings = [];

    doc[TEAMS_NAMES_KEY].forEach((dynamic name) => teamsNames.add(name));
    
    doc[CHIPS_DISTRIBUTES_KEY].forEach((dynamic distributeMap) => 
      chipsDistributes.add(ChipsDistribute.fromMap(distributeMap)));
    
    doc[PLAYERS_NAMES_KEY].forEach((dynamic name) => playersNames.add(name));
    
    doc[PLAYERS_ROLES_KEY].forEach((dynamic role) => playersRoles.add(role));
    
    doc[PLAYERS_CREDITS_KEY].forEach((dynamic credits) => 
      playersCredits.add(credits));
    
    if(doc[PLAYERS_POINTS_KEY] != null) {
      playersPoints = [];

      doc[PLAYERS_POINTS_KEY].forEach((dynamic points) => 
        playersPoints.add(points));
    }
    
    if(doc[PLAYERS_REPORTS_KEY] != null) {
      playersReports = [];

      doc[PLAYERS_REPORTS_KEY].forEach((dynamic reportMap) 
        => playersReports.add(Report.fromMap(reportMap)));
    }
    
    doc[IS_PLAYINGS_KEY].forEach((dynamic isPlaying) => 
      isPlayings.add(isPlaying));
  }

  Map<String, dynamic> toMap() {
    return {
      SERIES_NAME_KEY: seriesName,
      TEAMS_NAMES_KEY: teamsNames,
      MATCH_TYPE_KEY: matchType,
      NO_BY_TYPE_KEY: noByType,
      START_TIME_KEY: startTime,
      
      CHIPS_DISTRIBUTES_KEY: chipsDistributes.map((ChipsDistribute distribute) {
        return distribute.toMap();
      }).toList(),
      
      TEAM_1_TOTAL_PLAYERS_KEY: team1TotalPlayers,
      PLAYERS_NAMES_KEY: playersNames,
      PLAYERS_ROLES_KEY: playersRoles,
      PLAYERS_CREDITS_KEY: playersCredits,
      PLAYERS_POINTS_KEY: playersPoints,
      
      PLAYERS_REPORTS_KEY: playersReports != null ? 
        playersReports.map((Report report) {
          return report.toMap();
        }).toList() : null,
      
      IS_PLAYINGS_KEY: isPlayings,
      SERIES_ID_KEY: seriesId,
      EXCERPT_INDEX_KEY: excerptIndex,
    };
  }
}

class Report {
  Report.fromMap(Map<String, dynamic> map) {}
  Map<String, dynamic> toMap() {
    return {};
  }
}
