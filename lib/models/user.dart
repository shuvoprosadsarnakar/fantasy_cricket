// keys
const String USERNAME_KEY = 'username';
const String CONTESTS_IDS_KEYS = 'contestsIds';

class User {
  String id;
  String username;
  List<String> contestsIds = <String>[];

  User({
    this.id,
    this.username,
    this.contestsIds,
  });

  User.fromMap(Map<String, dynamic> doc, String docId) {
    id = docId;
    username = doc[USERNAME_KEY];
    
    // list in firestore is dynamic typed
    doc[CONTESTS_IDS_KEYS].forEach((dynamic id) {
      contestsIds.add(id);
    });
  }

  Map<String, dynamic> toMap() {
    return {
      USERNAME_KEY: username,
      CONTESTS_IDS_KEYS: contestsIds,
    };
  }

  @override
  String toString() {
    return '{ id: $id, username: $username, contestsIds: $contestsIds }';
  }
}
