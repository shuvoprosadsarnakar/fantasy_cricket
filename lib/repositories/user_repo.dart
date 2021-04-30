import 'package:cloud_firestore/cloud_firestore.dart';

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
}
