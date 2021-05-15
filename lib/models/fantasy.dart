// keys
const String CONTEST_ID_KEY = 'contestId';
const String USERNAME_KEY = 'username';
const String PLAYER_NAMES_KEY = 'playerNames';
const String CAPTAIN_KEY = 'captain';
const String VICE_CAPTAIN_KEY = 'viceCaptain';

class Fantasy {
  String id;
  String contestId;
  String username;
  List<String> playerNames;
  String captain;
  String viceCaptain;

  Fantasy({
    this.id,
    this.contestId,
    this.username,
    this.playerNames,
    this.captain,
    this.viceCaptain,
  }) {
    if(playerNames == null) playerNames = <String>[];
  }

  Fantasy.fromMap(Map<String, dynamic> doc, String docId) {
    id = docId;
    contestId = doc[CONTEST_ID_KEY];
    username = doc[USERNAME_KEY];
    playerNames = <String>[];
    captain = doc[CAPTAIN_KEY];
    viceCaptain = doc[VICE_CAPTAIN_KEY];

    doc[PLAYER_NAMES_KEY].forEach((dynamic playerName) {
      playerNames.add(playerName);
    });
  }

  Map<String, dynamic> toMap() {
    return {
      CONTEST_ID_KEY: contestId,
      USERNAME_KEY: username,
      PLAYER_NAMES_KEY: playerNames,
      CAPTAIN_KEY: captain,
      VICE_CAPTAIN_KEY: viceCaptain,
    };
  }
}
