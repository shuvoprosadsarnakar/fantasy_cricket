import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fantasy_cricket/models/user.dart';

class UserRepo {
  static final CollectionReference _users = FirebaseFirestore.instance
    .collection('users');

  static Future<bool> checkUsername(String username) async {
    QuerySnapshot snapshot = await _users.where('username', isEqualTo: username)
      .get();

    if(snapshot.docs.isEmpty) {
      return true;
    } else {
      return false;
    }
  }

  static Future<void> addUser(User user) async {
    await _users.doc(user.id).set(user.toMap());
  }
}
