// keys
const String CHIPS_KEY = 'chips';
const String FROM_KEY = 'from';
const String TO_KEY = 'to';

class ChipsDistribute {
  int chips;
  int from;
  int to;

  ChipsDistribute({this.chips, this.from, this.to});

  ChipsDistribute.fromMap(Map<String, dynamic> map) {
    chips = map[CHIPS_KEY];
    from = map[FROM_KEY];
    to = map[TO_KEY];
  }

  Map<String, dynamic> toMap() {
    return {
      CHIPS_KEY: chips,
      FROM_KEY: from,
      TO_KEY: to,
    };
  }

  @override
  String toString() {
    return '{ chips: $chips, from: $from, to: $to }';
  }
}