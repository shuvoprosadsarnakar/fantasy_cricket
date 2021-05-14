import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fantasy_cricket/models/user.dart';

class UserRepo {
  static final FirebaseFirestore _db = FirebaseFirestore.instance;
  static final CollectionReference usersCollection = _db.collection('users');

  static Future<bool> checkUsername(String username) async {
    QuerySnapshot snapshot = await usersCollection
      .where('username', isEqualTo: username)
      .get();

    if(snapshot.docs.isEmpty) {
      return true;
    } else {
      return false;
    }
  }

  static Future<void> addUser(User user) async {
    await usersCollection.doc(user.id).set(user.toMap());
  }

  static Future<User> getUserById(String id) async {
    DocumentSnapshot snapshot = await usersCollection.doc(id).get();
    return User.fromMap(snapshot.data(), id);
  }

  static Future<User> getUserByUsername(String username) async {
    QuerySnapshot snapshot = await usersCollection
      .where('username', isEqualTo: username)
      .get();
    QueryDocumentSnapshot doc = snapshot.docs.first;

    return User.fromMap(doc.data(), doc.id);
  }
}
