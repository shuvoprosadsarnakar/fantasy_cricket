import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fantasy_cricket/models/team.dart';

abstract class TeamRepo {
  static final CollectionReference _teamCollection =
      FirebaseFirestore.instance.collection('teams');
  static DocumentSnapshot lastDocument;

  // returns true if team's name is not taken already, false otherwise
  static Future<bool> checkTeamName(Team team) async {
    QuerySnapshot querySanpshot =
        await _teamCollection.where('name', isEqualTo: team.name).get();

    if (querySanpshot.docs.isEmpty ||
        // Name field is unique, so we can get only one document (even if team's
        // name is changed to update) that matches. Now, if the matched document's
        // id matches then there is no other team with the same name.
        (team.id != null && querySanpshot.docs[0].id == team.id)) {
      return true;
    } else {
      return false;
    }
  }

  static Future<void> addTeam(Team team) async {
    await _teamCollection.add(team.toMap());
  }

  static Future<void> updateTeam(Team team) async {
    await _teamCollection.doc(team.id).update(team.toMap());
  }

    static Future<void> deleteTeam(Team team) async {
    await _teamCollection.doc(team.id).delete().whenComplete(() {
      print("team deleted");
      return true;
    }).onError((error, stackTrace) {
      print(error);
      return false;
    });
  }

  static Future<void> fetchAllTeams(List<Team> allTeams) async {
    QuerySnapshot snapshot = await _teamCollection.get();

    snapshot.docs.forEach((QueryDocumentSnapshot snapshot) {
      allTeams.add(Team.fromMap(snapshot.data(), snapshot.id));
    });
  }

  static Future<Team> getTeamById(String id) async {
    DocumentSnapshot doc = await _teamCollection.doc(id).get();
    return Team.fromMap(doc.data(), doc.id);
  }

  static Future<List<Team>> fetchTeams(int startIndex, int limit) async {
    if (startIndex == 0) {
      QuerySnapshot documentList = await _teamCollection
          .orderBy("name")
          .limit(limit)
          .get(GetOptions(source: Source.cache));
      if (documentList.docs.isEmpty)
        await _teamCollection
            .orderBy("name")
            .limit(limit)
            .get(GetOptions(source: Source.server));
      lastDocument = documentList.docs.last;

      return documentList.docs
          .map((doc) => Team.fromMap(doc.data(), doc.id))
          .toList();
    } else {
      QuerySnapshot documentList = await _teamCollection
          .orderBy("name")
          .limit(limit)
          .startAfterDocument(lastDocument)
          .get();
      lastDocument = documentList.docs.last;
      return documentList.docs
          .map((doc) => Team.fromMap(doc.data(), doc.id))
          .toList();
    }
  }

  static Future<List<Team>> searchTeams(String searchKey, int limit) async {
    String endingSearchKey = incrementLastChar(searchKey);
    try {
      QuerySnapshot documentList = await _teamCollection
          .where('name', isGreaterThanOrEqualTo: searchKey)
          .where('name', isLessThan: endingSearchKey)
          .get();
      print(documentList.docs.first.data());
      return documentList.docs
          .map((doc) => Team.fromMap(doc.data(), doc.id))
          .toList();
    } catch (error) {
      print(error);
    }
    return null;
  }

  static String incrementLastChar(String x) {
    String s = x;
    if (x != null && x.length > 0) {
      s = s.toLowerCase();
      String a = s.substring(s.length - 1);
      int lastChar = a.codeUnits[0];
      lastChar++;
      s = s.substring(0, s.length - 1) + String.fromCharCode(lastChar);
    }
    return (s);
  }
}
