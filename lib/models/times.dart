import 'package:cloud_firestore/cloud_firestore.dart';

// keys
const String START_KEY = 'start';
const String END_KEY = 'end';

class Times {
  Timestamp start;
  Timestamp end;

  Times({this.start, this.end});

  Times.fromMap(Map<String, dynamic> map) {
    start = map[START_KEY];
    end = map[END_KEY];
  }

  Map<String, dynamic> toMap() {
    return {
      START_KEY: start,
      END_KEY: end,
    };
  }

  @override
  String toString() {
    return '{ start: $start, end: $end }';
  }
}