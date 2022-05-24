import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:givnotes/models/models.dart';

class FireDBHelper {
  static final CollectionReference _reference = FirebaseFirestore.instance.collection("users");

  static Future<bool> checkUserExists(String userID) async {
    final DocumentSnapshot snapshot = await _reference.doc(userID).get();

    if ((snapshot.data() as Map<String, dynamic>)['uid'] != null) {
      return true;
    } else {
      return false;
    }
  }

  static Future<void> addUserToDB(UserModel user) async {
    // final DatabaseReference db = FirebaseDatabase.instance.reference();
    // db.child('users').child('${_currentUser.uid}').set({
    //   'name': event.name,
    //   'email': event.email,
    //   'photoURL': _currentUser.photoURL,
    //   'full-paid': false,
    //   'ads-paid': false,
    // });

    await _reference.doc(user.uid).set(user.toMap());
  }

  static Future<UserModel> getUserFromDB(String userID) async {
    final DocumentSnapshot snapshot = await _reference.doc(userID).get();
    return UserModel.fromMap(snapshot.data() as Map<String, dynamic>);
  }

  /// If no document exists yet, the update will fail.
  static Future<void> updateUser(UserModel user) async {
    await _reference.doc(user.uid).update(user.toMap());
  }

  // static Future<DateTime> getUserCreatedDate(String userID) async {
  //   final DocumentSnapshot<Map<String, dynamic>> snapshot =
  //       await _reference.doc(userID).get() as DocumentSnapshot<Map<String, dynamic>>;
  //   DateTime date = DateTime.fromMillisecondsSinceEpoch(snapshot.data()!['createdAt']);

  //   return date;
  // }
}
