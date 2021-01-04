class Player {
  String name;
  String role;
  String nationality;
  String handed;

  Player({this.name, this.role, this.nationality,this.handed});

  Player.fromMap(Map snapshot) :
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
}