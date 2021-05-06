// keys
const String USERNAME_KEY = 'username';
const String CONTEST_IDS_KEY = 'contestIds';
const String SERIES_IDS_KEY = 'seriesIds';

class User {
  String id;
  String username;
  List<String> contestIds = <String>[];
  List<String> seriesIds = <String>[];

  User({
    this.id,
    this.username,
    this.contestIds,
    this.seriesIds,
  });

  User.fromMap(Map<String, dynamic> doc, String docId) {
    id = docId;
    username = doc[USERNAME_KEY];
    
    // list in firestore is dynamic typed
    doc[CONTEST_IDS_KEY].forEach((dynamic id) {
      contestIds.add(id);
    });

    doc[SERIES_IDS_KEY].forEach((dynamic id) {
      seriesIds.add(id);
    });
  }

  Map<String, dynamic> toMap() {
    return {
      USERNAME_KEY: username,
      CONTEST_IDS_KEY: contestIds,
      SERIES_IDS_KEY: seriesIds,
    };
  }

  @override
  String toString() {
    return '{ id: $id, username: $username, contestIds: $contestIds, ' + 
      'seriesIds: $seriesIds }';
  }
}
