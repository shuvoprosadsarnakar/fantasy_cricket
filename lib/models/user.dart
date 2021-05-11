// keys
import 'package:fantasy_cricket/models/win_info.dart';

const String USERNAME_KEY = 'username';
const String CONTEST_IDS_KEY = 'contestIds';
const String SERIES_IDS_KEY = 'seriesIds';
const String EARNED_CHIPS_KEY = 'earnedChips';
const String REMAINING_CHIPS_KEY = 'remainingChips';
const String EARNING_HISTORY_KEY = 'earningHistory';

class User {
  String id;
  String username;
  int earnedChips = 0;
  int remainingChips = 0;
  List<String> contestIds = <String>[];
  List<String> seriesIds = <String>[];
  List<WinInfo> earningHistory = <WinInfo>[];

  User({
    this.id,
    this.username,
    this.earnedChips,
    this.remainingChips,
    this.contestIds,
    this.seriesIds,
    this.earningHistory,
  });

  User.fromMap(Map<String, dynamic> doc, String docId) {
    id = docId;
    username = doc[USERNAME_KEY];
    earnedChips = doc[EARNED_CHIPS_KEY];
    remainingChips = doc[REMAINING_CHIPS_KEY];
    
    if(doc[EARNING_HISTORY_KEY] != null) {
      doc[EARNING_HISTORY_KEY].forEach((dynamic map) {
        earningHistory.add(WinInfo.fromMap(map));
      });
    }
    
    // list in firestore is dynamic typed
    doc[CONTEST_IDS_KEY].forEach((dynamic id) {
      contestIds.add(id);
    });

    doc[SERIES_IDS_KEY].forEach((dynamic id) {
      seriesIds.add(id);
    });
  }

  Map<String, dynamic> toMap() {
    return {
      USERNAME_KEY: username,
      CONTEST_IDS_KEY: contestIds,
      SERIES_IDS_KEY: seriesIds,
      EARNED_CHIPS_KEY: earnedChips,
      REMAINING_CHIPS_KEY: remainingChips,
      EARNING_HISTORY_KEY: earningHistory.map((WinInfo winInfo) {
        return winInfo.toMap();
      }).toList(),
    };
  }
}
