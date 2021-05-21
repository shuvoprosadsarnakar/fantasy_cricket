const String T20 = 'T20';
const String ONE_DAY = 'One Day';
const String TEST = 'Test';

abstract class MatchTypes {
  static final String t20 = T20;
  static final String oneDay = ONE_DAY;
  static final String test = TEST;

  static List<String> get list {
    return [
      T20,
      ONE_DAY,
      TEST,
    ];
  }
}
