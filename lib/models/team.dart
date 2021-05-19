// keys
const String NAME_KEY = 'name';
const String PHOTO_KEY = 'photo';
const String PLAYERS_NAMES_KEY = 'playersNames';
const String PLAYERS_ROLES_KEY = 'playersRoles';
const String PLAYER_PHOTOS_KEY = 'playerPhotos';

class Team {
  String id;
  String name;
  String photo;
  List<String> playersNames;
  List<String> playersRoles;
  List<String> playerPhotos;

  Team({
    this.id,
    this.name,
    this.photo,
    this.playersNames,
    this.playersRoles,
    this.playerPhotos,
  }) {
    if(playersNames == null) playersNames = <String>[];
    if(playersRoles == null) playersRoles = <String>[];
    if(playerPhotos == null) playerPhotos = <String>[];
  }

  Team.fromMap(Map<String, dynamic> doc, String docId) {
    id = docId;
    name = doc[NAME_KEY];
    photo = doc[PHOTO_KEY];
    playersNames = <String>[];
    playersRoles = <String>[];
    playerPhotos = <String>[];

    // list in firestore is always [dynamic] even if we insert a [String] typed 
    // array, that's why we can't do playersNames = dco[PLAYERs_NAMES_KY]
    doc[PLAYERS_NAMES_KEY].forEach((dynamic playerName) {
      playersNames.add(playerName);
    });
    
    doc[PLAYERS_ROLES_KEY].forEach((dynamic playerRole) {
      playersRoles.add(playerRole);
    });

    doc[PLAYER_PHOTOS_KEY].forEach((dynamic playerPhoto) {
      playerPhotos.add(playerPhoto);
    });
  }

  Map<String, dynamic> toMap() {
    return {
      NAME_KEY: name,
      PHOTO_KEY: photo,
      PLAYERS_NAMES_KEY: playersNames,
      PLAYERS_ROLES_KEY: playersRoles,
      PLAYER_PHOTOS_KEY: playerPhotos,
    };
  }
}
