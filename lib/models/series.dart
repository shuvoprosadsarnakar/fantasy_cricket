import 'package:fantasy_cricket/models/distribute.dart';
import 'package:fantasy_cricket/models/excerpt.dart';
import 'package:fantasy_cricket/models/rank.dart';
import 'package:fantasy_cricket/models/times.dart';

// keys
const String NAME_KEY = 'name';
const String PHOTO_KEY = 'photo';
const String TIMES_KEY = 'times';
const String CHIPS_DISTRIBUTES_KEY = 'chipsDistributes';
const String MATCH_EXCERPTS_KEY = 'matchExcerpts';
const String RANKS_KEY = 'ranks';
const String PLAYER_NAMES_KEY = 'playerNames';
const String PLAYER_POINTS_KEY = 'playerPoints';

class Series {
  String id;
  String name;
  String photo;
  Times times;
  List<Distribute> chipsDistributes;
  List<Excerpt> matchExcerpts;
  List<Rank> ranks;
  List<String> playerNames;
  List<double> playerPoints;

  Series({
    this.id,
    this.name,
    this.photo,
    this.times,
    this.chipsDistributes,
    this.matchExcerpts,
    this.ranks,
  }) {
    if(chipsDistributes == null) chipsDistributes = <Distribute>[];
    if(matchExcerpts == null) matchExcerpts = <Excerpt>[];
    if(ranks == null) ranks = <Rank>[];
    if(playerNames == null) playerNames = <String>[];
    if(playerPoints == null) playerPoints = <double>[];
  }

  Series.fromMap(Map<String, dynamic> doc, String docId) {
    id = docId;
    name = doc[NAME_KEY];
    photo = doc[PHOTO_KEY];
    times = Times.fromMap(doc[TIMES_KEY]);
    chipsDistributes = <Distribute>[];
    matchExcerpts = <Excerpt>[];
    ranks = <Rank>[];
    playerNames = <String>[];
    playerPoints = <double>[];

    doc[CHIPS_DISTRIBUTES_KEY].forEach((dynamic map) {
      chipsDistributes.add(Distribute.fromMap(map));
    });
    
    doc[MATCH_EXCERPTS_KEY].forEach((dynamic map) {
      matchExcerpts.add(Excerpt.fromMap(map));
    });

    doc[RANKS_KEY].forEach((dynamic map) {
      ranks.add(Rank.fromMap(map));
    });

    doc[PLAYER_NAMES_KEY].forEach((dynamic name) {
      playerNames.add(name);
    });

    doc[PLAYER_POINTS_KEY].forEach((dynamic points) {
      playerPoints.add(points);
    });
  }

  Map<String, dynamic> toMap() {
    return {
      NAME_KEY: name,
      PHOTO_KEY: photo,
      TIMES_KEY: times.toMap(),
      CHIPS_DISTRIBUTES_KEY: chipsDistributes.map((Distribute distribute) {
        return distribute.toMap();
      }).toList(),
      MATCH_EXCERPTS_KEY: matchExcerpts.map((Excerpt excerpt) {
        return excerpt.toMap();
      }).toList(),
      RANKS_KEY: ranks.map((Rank rank) {
        return rank.toMap();
      }).toList(),
      PLAYER_NAMES_KEY: playerNames,
      PLAYER_POINTS_KEY: playerPoints,
    };
  }
}
