import 'package:fantasy_cricket/models/contest.dart';
import 'package:fantasy_cricket/models/excerpt.dart';
import 'package:fantasy_cricket/models/report.dart';
import 'package:fantasy_cricket/resources/match_types.dart';

class PlayerPointsDetailsCubit {
  final Contest contest;
  final int playerIndex;
  final Excerpt excerpt;
  
  Report report;
  int halfCenturies;
  int centuries;
  double strikeRate;
  int fourWickets;
  int fiveWickets;
  double economyRate;

  PlayerPointsDetailsCubit(this.contest, this.playerIndex, this.excerpt) {
    if(contest.playersReports.isNotEmpty) {
      report = contest.playersReports[playerIndex];
      halfCenturies = (report.runsTaken % 100 >= 50) ? 1 : 0;
      centuries = (report.runsTaken / 100).floor();
      strikeRate = report.runsTaken / report.ballsFaced * 100;
      fourWickets = (report.wicketsTaken % 5 == 4) ? 1 : 0;
      fiveWickets = (report.wicketsTaken / 5).floor();
      economyRate = report.runsGiven / (report.ballsBowled / 6);
    } else {
      report = Report();
      halfCenturies = 0;
      centuries = 0;
      strikeRate = 0;
      fourWickets = 0;
      fiveWickets = 0;
      economyRate = 0;
    }
  }

  // batting points getters
  
  double get runsTakenPoints {
    return report.runsTaken * 0.5;
  }

  double get foursHitPoints {
    return report.foursHit * 0.5;
  }

  double get sixesHitPoints {
    return report.sixesHit * 1.0;
  }

  double get halfCenturyPoints {
    if(excerpt.type == T20) {
      return halfCenturies * 4.0;
    } else {
      return halfCenturies * 2.0;
    }
  }

  double get centuryPoints {    
    if(excerpt.type == T20) {
      return centuries * 8.0;
    } else {
      return centuries * 4.0;
    }
  }

  double get strikeRatePoints {
    double point = 0;

    if(excerpt.type == T20 && report.ballsFaced >= 10) {
      if(strikeRate <= 50) {
        point = -3;
      } else if(strikeRate <= 60) {
        point = -2;
      } else if(strikeRate <= 70) {
        point = -1;
      }
    } else if(excerpt.type == ONE_DAY && report.ballsFaced >= 20) {
      if(strikeRate <= 40) {
        point = -3;
      } else if(strikeRate <= 50) {
        point = -2;
      } else if(strikeRate <= 60) {
        point = -1;
      }
    }

    return point;
  }

  // bowling points getters

  double get wicketsTakenPoints {
    if(excerpt.type == ONE_DAY) {
      return report.wicketsTaken * 12.0;
    } else {
      return report.wicketsTaken * 10.0;
    }
  }

  double get fourWicketsPoints {
    if(excerpt.type == T20) {
      return fourWickets * 4.0;
    } else {
      return fourWickets * 2.0;
    }
  }

  double get fiveWicketsPoints {
    if(excerpt.type == T20) {
      return fiveWickets * 8.0;
    } else {
      return fiveWickets * 4.0;
    }
  }

  double get maidenOversPoints {
    if(excerpt.type == T20) {
      return report.maidenOvers * 4.0;
    } else if(excerpt.type == ONE_DAY) {
      return report.maidenOvers * 2.0;
    } else {
      return 0;
    }
  }

  double get economyRatePoints {
    double point = 0;

    if(excerpt.type == T20 && report.ballsBowled >= 12) {
      if(economyRate <= 4) {
        point = 3;
      } else if(economyRate <= 5) {
        point = 2;
      } else if(economyRate <= 7) {
        point = 1;
      } else if(economyRate <= 9) {
        point = -1;
      } else if(economyRate <= 11) {
        point = -2;
      } else {
        point = -3;
      }
    } else if(excerpt.type == ONE_DAY && report.ballsBowled >= 30) {
      if(economyRate <= 2.5) {
        point = 3;
      } else if(economyRate <= 3.5) {
        point = 2;
      } else if(economyRate <= 4.5) {
        point = 1;
      } else if(economyRate >= 7 && economyRate <= 8) {
        point = -1;
      } else if(economyRate > 8 && economyRate <= 9) {
        point = -2;
      } else if(economyRate > 9) {
        point = -3;
      }
    }

    return point;
  }

  // fielding points getters

  double get catchesPoints {
    return report.catches * 4.0;
  }

  double get stumpingsPoints {
    return report.stumpings * 6.0;
  }

  double get runOutsPoints {
    return report.runOuts * 4.0;
  }

  // other points getters

  double get playerOfTheMatchPoints {
    if(contest.playersNames[playerIndex] == contest.playerOfTheMatch) {
      return 10.0;
    } else {
      return 0;
    }
  }

  double get isPlayingPoints {
    if(contest.isPlayings[playerIndex]) {
      return 2.0;
    } else {
      return 0;
    }
  }
}
