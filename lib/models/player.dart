
// keys
const String NAME_KEY = 'name';
const String ROLE_KEY = 'role';
const String PHOTO_KEY = 'photo';

// ignore: must_be_immutable
class Player {
  String id;
  String name;
  String role;
  String photo;

  Player({
    this.id,
    this.name,
    this.role,
    this.photo,
  });

  Player.fromMap(Map<String, dynamic> doc, String docId) {
    id = docId;
    name = doc[NAME_KEY];
    role = doc[ROLE_KEY];
    photo = doc[PHOTO_KEY];
  }

  Map<String, dynamic> toMap() {
    return {
      NAME_KEY: name,
      ROLE_KEY: role,
      PHOTO_KEY: photo,
    };
  }

}
