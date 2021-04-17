// team document keys
const String ID_KEY = 'id';
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
    playerIds = doc[PLAYER_IDS_KEY];
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