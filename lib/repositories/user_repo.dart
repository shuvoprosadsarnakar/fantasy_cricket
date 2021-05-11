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

  static Future<User> getUserById(String id) async {
    DocumentSnapshot snapshot = await _users.doc(id).get();
    return User.fromMap(snapshot.data(), id);
  }

  static Future<User> getUserByUsername(String username) async {
    QuerySnapshot snapshot = await _users
      .where('username', isEqualTo: username)
      .get();
    QueryDocumentSnapshot doc = snapshot.docs.first;

    return User.fromMap(doc.data(), doc.id);
  }
}
