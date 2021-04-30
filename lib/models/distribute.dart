// keys
const String CHIPS_KEY = 'chips';
const String FROM_KEY = 'from';
const String TO_KEY = 'to';

class Distribute {
  int chips;
  int from;
  int to;

  Distribute({this.chips, this.from, this.to});

  Distribute.fromMap(Map<String, dynamic> map) {
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