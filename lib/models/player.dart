import 'package:equatable/equatable.dart';

// player document keys
const String NAME_KEY = 'name';
const String ROLE_KEY = 'role';

class Player extends Equatable {
  String id;
  String name;
  String role;

  Player({this.id, this.name, this.role});

  Player.fromMap(Map<String, dynamic> doc, String docId) {
    id = docId;
    name = doc[NAME_KEY];
    role = doc[ROLE_KEY];
  }

  Map<String, dynamic> toMap() {
    return {
      NAME_KEY: name,
      ROLE_KEY: role,
    };
  }

  @override  
  List<Object> get props => [id, name, role];

  @override
  String toString() {
    return '{ id: $id, name: $name, role: $role }';
  }
}
