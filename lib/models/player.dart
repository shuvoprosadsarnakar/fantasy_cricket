import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

class Player extends Equatable {
  String id;
  String name;
  String role;
  String nationality;
  String handed;
  String battingStyle;
  String bowlingStyle;
  String description;
  DateTime birthDay;

  Player({this.id, this.name, this.role, this.nationality, this.handed});

  Player.fromSnapshot(DocumentSnapshot snapshot, String documentId)
      : id = documentId ?? 'id',
        name = snapshot['name'] ?? '',
        role = snapshot['role'] ?? '',
        nationality = snapshot['nationality'] ?? '',
        handed = snapshot['handed'] ?? '';

  toJson() {
    return {
      "name": name,
      "role": role,
      "nationality": nationality,
      "handed": handed,
    };
  }

  @override
  
  List<Object> get props => [id,name,role,nationality,handed];
}
