// keys
const String NAME_KEY = 'name';
const String PLAYER_IDS_KEY = 'playerIds';

class Team {
  String id;
  String name;
  List<String> playerIds;

  Team({this.id, this.name, this.playerIds});

  Team.fromMap(Map<String, dynamic> doc, String docId) {
    id = docId;
    name = doc[NAME_KEY];
    playerIds = [];

    // list in firestore is always [dynamic] even if we insert a [String] typed 
    // array, that's why we can't do playerIds = dco[PLAYER_IDS_KY]
    doc[PLAYER_IDS_KEY].forEach((dynamic playerId) {
      playerIds.add(playerId);
    });
  }

  Map<String, dynamic> toMap() {
    return {
      NAME_KEY: name,
      PLAYER_IDS_KEY: playerIds,
    };
  }

  @override
  String toString() {
    return '{ id: $id, name: $name, playerIds: $playerIds }';
  }
}