import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fantasy_cricket/models/exchange.dart';
import 'package:fantasy_cricket/models/user.dart';
import 'package:fantasy_cricket/repositories/user_repo.dart';

class ExchangeRepo {
  static final FirebaseFirestore _db = FirebaseFirestore.instance;
  static final CollectionReference exchangesCollection = 
    _db.collection('exchanges');

  static Future<void> addExchange(Exchange exchange, User user) async {
    WriteBatch batch = _db.batch();
    
    batch.set(exchangesCollection.doc(), exchange.toMap());
    batch.update(UserRepo.usersCollection.doc(user.id), user.toMap());
    await batch.commit();
  }

  static Future<List<Exchange>> getExchangesByUserId(String userId) async {
    QuerySnapshot snapshot = await exchangesCollection
      .where('userId', isEqualTo: userId)
      .orderBy('dateTime', descending: true)
      .get();

    return snapshot.docs.map((QueryDocumentSnapshot snapshot) {
      return Exchange.fromMap(snapshot.data(), snapshot.id);
    }).toList();
  }

  static Future<List<Exchange>> getAllExchanges() async {
    QuerySnapshot snapshot = await exchangesCollection
      .orderBy('dateTime', descending: true)
      .get();

    return snapshot.docs.map((QueryDocumentSnapshot snapshot) {
      return Exchange.fromMap(snapshot.data(), snapshot.id);
    }).toList();
  }

  static Future<void> updateExchange(Exchange exchange,
    void Function(User) updateUserAndExchange) async {
    await _db.runTransaction((transaction) {
      return transaction.get(_db.collection('users').doc(exchange.userId))
        .then((value) {
          final User user = User.fromMap(value.data(), value.id);
          updateUserAndExchange(user);

          transaction.update(exchangesCollection.doc(exchange.id),
            exchange.toMap());
          transaction.update(_db.collection('users').doc(user.id), 
            user.toMap());
        });
    });
  }
}
