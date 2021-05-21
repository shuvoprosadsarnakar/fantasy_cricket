const String BATSMAN = 'Batsman';
const String WICKET_KEEPER = 'Wicket Keeper';
const String ALL_ROUNDER = 'All Rounder';
const String BOWLER = 'Bowler';

abstract class PlayerRoles {
  static final String batsman = BATSMAN;
  static final String wicketKeeper = WICKET_KEEPER;
  static final String allRounder = ALL_ROUNDER;
  static final String bowler = BOWLER;

  static List<String> get list {
    return [
      BATSMAN,
      WICKET_KEEPER,
      ALL_ROUNDER,
      BOWLER,
    ];
  }
}
