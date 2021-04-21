import 'package:fantasy_cricket/models/chips_distribute.dart';
import 'package:fantasy_cricket/models/match_excerpt.dart';
import 'package:fantasy_cricket/models/times.dart';

// keys
const String NAME_KEY = 'name';
const String CHIPS_DISTRIBUTES_KEY = 'chipsDistributes';
const String TIMES_KEY = 'times';
const String MATCH_EXCERPTS_KEY = 'matchExcerpts';

class Series {
  String id;
  String name;
  List<ChipsDistribute> chipsDistributes;
  Times times;
  List<MatchExcerpt> matchExcerpts;

  Series({
    this.id,
    this.name,
    this.chipsDistributes,
    this.times,
    this.matchExcerpts,
  });

  Series.fromMap(Map<String, dynamic> doc, String docId) {
    id = docId;
    name = doc[NAME_KEY];

    chipsDistributes = doc[CHIPS_DISTRIBUTES_KEY]
      .map((Map<String, dynamic> map) {
        return ChipsDistribute.fromMap(map);
      }).toList();
    
    times = Times.fromMap(doc[TIMES_KEY]);
    
    matchExcerpts = doc[MATCH_EXCERPTS_KEY].map((Map<String, dynamic> map) {
        return MatchExcerpt.fromMap(map);
      }).toList();
  }

  Map<String, dynamic> toMap() {
    return {
      NAME_KEY: name,
      
      CHIPS_DISTRIBUTES_KEY: chipsDistributes
        .map((ChipsDistribute chipsDistribute) {
          return chipsDistribute.toMap();
        }).toList(),
      
      TIMES_KEY: times.toMap(),

      MATCH_EXCERPTS_KEY: matchExcerpts.map((MatchExcerpt matchExcerpt) {
          return matchExcerpt.toMap();
        }).toList(),
    };
  }

  @override
  String toString() {
    return '{ id: $id, name: $name, chipsDistributes: $chipsDistributes, ' + 
      'times: $times, matchExcerpts: $matchExcerpts }';
  }
}
