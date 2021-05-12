import 'package:fantasy_cricket/models/distribute.dart';
import 'package:fantasy_cricket/models/excerpt.dart';
import 'package:fantasy_cricket/models/times.dart';

// keys
const String NAME_KEY = 'name';
const String CHIPS_DISTRIBUTES_KEY = 'chipsDistributes';
const String TIMES_KEY = 'times';
const String MATCH_EXCERPTS_KEY = 'matchExcerpts';
const String TOTAL_CONTESTENTS_KEY = 'totalContestents';
const String PHOTO_KEY = 'photo';

class Series {
  String id;
  String name;
  String photo;
  List<Distribute> chipsDistributes = [];
  Times times;
  List<Excerpt> matchExcerpts = [];
  int totalContestents = 0;

  Series({
    this.id,
    this.name,
    this.photo,
    this.chipsDistributes,
    this.times,
    this.matchExcerpts,
    this.totalContestents,
  });

  Series.fromMap(Map<String, dynamic> doc, String docId) {
    id = docId;
    name = doc[NAME_KEY];
    totalContestents = doc[TOTAL_CONTESTENTS_KEY];
    photo = doc[PHOTO_KEY];

    doc[CHIPS_DISTRIBUTES_KEY].forEach((dynamic map) {
      chipsDistributes.add(Distribute.fromMap(map));
    });
    
    times = Times.fromMap(doc[TIMES_KEY]);
    
    doc[MATCH_EXCERPTS_KEY].forEach((dynamic map) {
      matchExcerpts.add(Excerpt.fromMap(map));
    });
  }

  Map<String, dynamic> toMap() {
    return {
      NAME_KEY: name,
      TOTAL_CONTESTENTS_KEY: totalContestents,
      PHOTO_KEY: photo,
      
      CHIPS_DISTRIBUTES_KEY: chipsDistributes
        .map((Distribute chipsDistribute) {
          return chipsDistribute.toMap();
        }).toList(),
      
      TIMES_KEY: times.toMap(),

      MATCH_EXCERPTS_KEY: matchExcerpts.map((Excerpt matchExcerpt) {
          return matchExcerpt.toMap();
        }).toList(),
    };
  }
}
