import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fantasy_cricket/models/distribute.dart';
import 'package:fantasy_cricket/models/rank.dart';
import 'package:fantasy_cricket/models/report.dart';

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
const String TEAMS_SCORES_KEY = 'teamsScores';
const String RESULT_KEY = 'result';
const String PLAYER_OF_THE_MATCH_KEY = 'playerOfTheMatch';
const String RANKS_KEY = 'ranks';
const String PLAYER_PHOTOS_KEY = 'playerPhotos';
const String PLAYER_PICKED_COUNTS_KEY = 'playerPickedCounts';
const String FULL_SCORE_URL_KEY = 'fullScoreUrl';

class Contest {
  // contest info
  String id;
  String seriesName;
  List<String> teamsNames;
  String matchType;
  int noByType;
  Timestamp startTime;
  List<Distribute> chipsDistributes;
  
  // players info
  int team1TotalPlayers;
  List<String> playersNames;
  List<String> playersRoles;
  List<String> playerPhotos;
  List<double> playersCredits;
  List<bool> isPlayings;

  // match result info
  List<Report> playersReports;
  List<double> playersPoints;
  List<String> teamsScores;
  String result;
  String playerOfTheMatch;
  String fullScoreUrl;

  // needed to update match excerpt's status
  String seriesId;

  // users info
  List<Rank> ranks;
  List<int> playerPickedCounts;

  Contest({
    this.id,
    this.seriesName,
    this.teamsNames,
    this.matchType,
    this.noByType,
    this.startTime,
    this.chipsDistributes,
    this.team1TotalPlayers,
    this.playersNames,
    this.playersRoles,
    this.playersCredits,
    this.playersPoints,
    this.playersReports,
    this.isPlayings,
    this.teamsScores,
    this.result,
    this.playerOfTheMatch,
    this.seriesId,
    this.ranks,
    this.playerPhotos,
    this.playerPickedCounts,
    this.fullScoreUrl,
  }) {
    if(teamsNames == null) teamsNames = <String>[];
    if(chipsDistributes == null) chipsDistributes = <Distribute>[];
    if(playersNames == null) playersNames = <String>[];
    if(playersRoles == null) playersRoles = <String>[];
    if(playersCredits == null) playersCredits = <double>[];
    if(isPlayings == null) isPlayings = <bool>[];
    if(ranks == null) ranks = <Rank>[];
    if(playersPoints == null) playersPoints = <double>[];
    if(playersReports == null) playersReports = <Report>[];
    if(teamsScores == null) teamsScores = <String>[];
    if(playerPhotos == null) playerPhotos = <String>[];
    if(playerPickedCounts == null) playerPickedCounts = <int>[];
  }

  Contest.fromMap(Map<String, dynamic> doc, String docId) {
    id = docId;
    seriesName = doc[SERIES_NAME_KEY];
    matchType = doc[MATCH_TYPE_KEY];
    noByType = doc[NO_BY_TYPE_KEY];
    startTime = doc[START_TIME_KEY];
    team1TotalPlayers = doc[TEAM_1_TOTAL_PLAYERS_KEY];
    seriesId = doc[SERIES_ID_KEY];
    result = doc[RESULT_KEY];
    playerOfTheMatch = doc[PLAYER_OF_THE_MATCH_KEY];
    fullScoreUrl = doc[FULL_SCORE_URL_KEY];
    teamsNames = <String>[];
    chipsDistributes = <Distribute>[];
    playersNames = <String>[];
    playersRoles = <String>[];
    playersCredits = <double>[];
    isPlayings = <bool>[];
    ranks = <Rank>[];
    playersPoints = <double>[];
    playersReports = <Report>[];
    teamsScores = <String>[];
    playerPhotos = <String>[];
    playerPickedCounts = <int>[];

    doc[TEAMS_NAMES_KEY].forEach((dynamic name) 
      => teamsNames.add(name));
    
    doc[PLAYERS_NAMES_KEY].forEach((dynamic name) 
      => playersNames.add(name));
    
    doc[PLAYERS_ROLES_KEY].forEach((dynamic role) 
      => playersRoles.add(role));

    doc[PLAYER_PHOTOS_KEY].forEach((dynamic photo) 
      => playerPhotos.add(photo));
    
    doc[PLAYERS_CREDITS_KEY].forEach((dynamic credits) 
      => playersCredits.add(credits));

    doc[PLAYERS_POINTS_KEY].forEach((dynamic points) 
      => playersPoints.add(points));
      
    doc[TEAMS_SCORES_KEY].forEach((dynamic score) 
      => teamsScores.add(score));
    
    doc[IS_PLAYINGS_KEY].forEach((dynamic isPlaying) 
      => isPlayings.add(isPlaying));

    doc[PLAYER_PICKED_COUNTS_KEY].forEach((dynamic count) 
      => playerPickedCounts.add(count));

    doc[CHIPS_DISTRIBUTES_KEY].forEach((dynamic distributeMap) 
      => chipsDistributes.add(Distribute.fromMap(distributeMap)));

    doc[PLAYERS_REPORTS_KEY].forEach((dynamic reportMap) 
      => playersReports.add(Report.fromMap(reportMap)));

    doc[RANKS_KEY].forEach((dynamic rankMap) 
      => ranks.add(Rank.fromMap(rankMap)));
  }

  Map<String, dynamic> toMap() {
    return {
      SERIES_NAME_KEY: seriesName,
      TEAMS_NAMES_KEY: teamsNames,
      MATCH_TYPE_KEY: matchType,
      NO_BY_TYPE_KEY: noByType,
      START_TIME_KEY: startTime,
      TEAM_1_TOTAL_PLAYERS_KEY: team1TotalPlayers,
      PLAYERS_NAMES_KEY: playersNames,
      PLAYERS_ROLES_KEY: playersRoles,
      PLAYERS_CREDITS_KEY: playersCredits,
      PLAYERS_POINTS_KEY: playersPoints,
      IS_PLAYINGS_KEY: isPlayings,
      SERIES_ID_KEY: seriesId,
      TEAMS_SCORES_KEY: teamsScores,
      RESULT_KEY: result,
      PLAYER_OF_THE_MATCH_KEY: playerOfTheMatch,
      PLAYER_PHOTOS_KEY: playerPhotos,
      PLAYER_PICKED_COUNTS_KEY: playerPickedCounts,
      FULL_SCORE_URL_KEY: fullScoreUrl,
      
      RANKS_KEY: ranks.map((Rank rank) {
        return rank.toMap();
      }).toList(),

      CHIPS_DISTRIBUTES_KEY: chipsDistributes.map((Distribute distribute) {
        return distribute.toMap();
      }).toList(),
      
      PLAYERS_REPORTS_KEY: playersReports.map((Report report) {
        return report.toMap();
      }).toList(),
    };
  }
}
