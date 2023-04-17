import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:notable/services/auth_service.dart';

import '../constants.dart';

//my database class containing CRUD methods
class Db {
  //instantiate firebasefirestore
  final CollectionReference users =
      firestore.collection('users/${AuthService().userId}/notes');

  //create new note
  Future createNote(String title, String note, int colorid, String time) async {
    await users
        .add({'title': title, 'note': note, 'colorid': colorid, 'time': time});
  }

  //update existing note
  Future updateNote(
      String docId, String title, String note, int colorid, String time) async {
    await users.doc(docId).update(
        {'title': title, 'note': note, 'colorid': colorid, 'time': time});
  }

  //delete note
  Future deleteNote(String docId) async {
    await users.doc(docId).delete();
  }

  static final Db _shared = Db._sharedInstance();
  Db._sharedInstance();
  factory Db() => _shared;
}
