import 'package:equatable/equatable.dart';

// player document key names
const String PLAYER_NAME_KEY = 'name';
const String PLAYER_ROLE_KEY = 'role';

class Player extends Equatable {
  String id;
  String name;
  String role;

  Player({this.id, this.name, this.role});

  Player.fromMap(Map<String, dynamic> doc, String docId) {
    id = docId;
    name = doc[PLAYER_NAME_KEY];
    role = doc[PLAYER_ROLE_KEY];
  }

  Map<String, dynamic> toMap() {
    return {
      PLAYER_NAME_KEY: name,
      PLAYER_ROLE_KEY: role,
    };
  }

  @override  
  List<Object> get props => [id, name, role];

  @override
  String toString() {
    print('{ id: $id, name: $name, role: $role }');
    return super.toString();
  }
}
