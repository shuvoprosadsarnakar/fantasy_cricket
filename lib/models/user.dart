// keys
const String USERNAME_KEY = 'username';

class User {
  String id;
  String username;

  User({
    this.id,
    this.username,
  });

  User.fromMap(Map<String, dynamic> doc, String docId) {
    id = docId;
    username = doc[USERNAME_KEY];
  }

  Map<String, dynamic> toMap() {
    return {
      USERNAME_KEY: username,
    };
  }

  @override
  String toString() {
    return '{ id: $id, username: $username }';
  }
}
