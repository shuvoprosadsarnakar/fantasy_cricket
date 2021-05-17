abstract class PointsCalculator {

  // batting points calculators
  
  static double getRunsTakenPoints(int runsTaken) {
    return runsTaken * 0.5;
  }

  static double getFoursHitPoints(int foursHit) {
    return foursHit * 0.5;
  }

  static double getSixesHitPoints(int sixesHit) {
    return sixesHit * 1.0;
  }

  static double getHalfCenturyPoints(int halfCenturies, String matchType) {
    if(matchType == 'T20') {
      return halfCenturies * 4.0;
    } else {
      return halfCenturies * 2.0;
    }
  }

  static double getCenturyPoints(int centuries, String matchType) {
    if(matchType == 'T20') {
      return centuries * 8.0;
    } else {
      return centuries * 4.0;
    }
  }

  static double getStrikeRatePoints(int ballsFaced, double strikeRate,
    String matchType) 
  {
    double point = 0;

    if(matchType == 'T20' && ballsFaced >= 10) {
      if(strikeRate <= 50) {
        point = -3;
      } else if(strikeRate <= 60) {
        point = -2;
      } else if(strikeRate <= 70) {
        point = -1;
      }
    } else if(matchType == 'One Day' && ballsFaced >= 20) {
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

  // bowling points calculators

  static double getWicketsTakenPoints(int wicketsTaken, String matchType) {
    if(matchType == 'One Day') {
      return wicketsTaken * 12.0;
    } else {
      return wicketsTaken * 10.0;
    }
  }

  static double getFourWicketsPoints(int fourWickets, String matchType) {
    if(matchType == 'T20') {
      return fourWickets * 4.0;
    } else {
      return fourWickets * 2.0;
    }
  }

  static double getFiveWicketsPoints(int fiveWickets, String matchType) {
    if(matchType == 'T20') {
      return fiveWickets * 8.0;
    } else {
      return fiveWickets * 4.0;
    }
  }

  static double getMaidenOversPoints(int maidenOvers, String matchType) {
    if(matchType == 'T20') {
      return maidenOvers * 4.0;
    } else if(matchType == 'One Day') {
      return maidenOvers * 4.0;
    } else {
      return 0;
    }
  }

  static double getEconomyRatePoints(int ballsBowled, double economyRate, 
    String matchType) 
  {
    double point = 0;

    if(matchType == 'T20' && ballsBowled >= 12) {
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
    } else if(matchType == 'One Day' && ballsBowled >= 12) {
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

  // fielding points calculator

  static double getCatchesPoints(int catches) {
    return catches * 4.0;
  }

  static double getStumpingsPoints(int stumpings) {
    return stumpings * 6.0;
  }

  static double getRunOutsPoints(int runOuts) {
    return runOuts * 4.0;
  }

  // other points calculator

  static double getPlayerOfTheMatchPoints(bool isPlayerOfTheMatch) {
    if(isPlayerOfTheMatch) {
      return 10.0;
    } else {
      return 0;
    }
  }

  static double getIsPlayingPoints(bool isPlaying) {
    if(isPlaying) {
      return 2.0;
    } else {
      return 0;
    }
  }
}
