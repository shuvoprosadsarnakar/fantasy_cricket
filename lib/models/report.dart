// keys
const String RUNS_TAKEN_KEY = 'runsTaken';
const String FOURS_HIT_KEY = 'foursHit';
const String SIXES_HIT_KEY = 'sixesHit';
const String BALLS_FACED_KEY = 'ballsFaced';
const String WICKETS_TAKEN_KEY = 'wicketsTaken';
const String MAIDEN_OVERS_KEY = 'maidenOvers';
const String BALLS_BOWLED_KEY = 'ballsBowled';
const String RUNS_GIVEN_KEY = 'runsGiven';
const String CATCHES_KEY = 'catches';
const String STUMPINGS_KEY = 'stumpings';
const String RUN_OUTS_KEY = 'runOuts';

class Report {
  // batting report
  int runsTaken;
  int foursHit;
  int sixesHit;
  int ballsFaced;

  // bowling report
  int wicketsTaken;
  int maidenOvers;
  int ballsBowled;
  int runsGiven;

  // fielding report
  int catches;
  int stumpings;
  int runOuts;

  Report();

  Report.fromMap(Map<String, dynamic> map) {
    runsTaken = map[RUNS_TAKEN_KEY];
    foursHit = map[FOURS_HIT_KEY];
    sixesHit = map[SIXES_HIT_KEY];
    ballsFaced = map[BALLS_FACED_KEY];
    wicketsTaken = map[WICKETS_TAKEN_KEY];
    maidenOvers = map[MAIDEN_OVERS_KEY];
    ballsBowled = map[BALLS_BOWLED_KEY];
    runsGiven = map[RUNS_GIVEN_KEY];
    catches = map[CATCHES_KEY];
    stumpings = map[STUMPINGS_KEY];
    runOuts = map[RUN_OUTS_KEY];
  }
  
  Map<String, dynamic> toMap() {
    return {
      RUNS_TAKEN_KEY: runsTaken,
      FOURS_HIT_KEY: foursHit,
      SIXES_HIT_KEY: sixesHit,
      BALLS_FACED_KEY: ballsFaced,
      WICKETS_TAKEN_KEY: wicketsTaken,
      MAIDEN_OVERS_KEY: maidenOvers,
      BALLS_BOWLED_KEY: ballsBowled,
      RUNS_GIVEN_KEY: runsGiven,
      CATCHES_KEY: catches,
      STUMPINGS_KEY: stumpings,
      RUN_OUTS_KEY: runOuts,
    };
  }
}
