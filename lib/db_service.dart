import 'package:goddessGuild/models.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'dart:io';
import 'package:uuid/uuid.dart';
import 'package:shared_preferences/shared_preferences.dart';


final FirebaseFirestore _db = FirebaseFirestore.instance;
final FirebaseAuth _auth = FirebaseAuth.instance;
final _storageRef = FirebaseStorage.instance.ref();
final User _user = _auth.currentUser;
final uid = _user.uid;

var _EVENT = "event";
var _EVENT_GODDESS = "goddess";
var _EVENT_PATRON = "patron";
var _USER = "user";
var _USER_ATTEND = "attend";
var _USER_BLESS = "bless";

String getUID() => uid;
var _uidv4 = Uuid();



Future<String> uploadFileToDB(File file_path, storage_dir) async {
  // "event_pics"
  var ref = _storageRef.child(storage_dir + "/" + _uidv4.v4());
  String download_url;

  try {
    await ref.putFile(file_path);
    download_url = await ref.getDownloadURL();
  } catch (e) {
    print('_photoLocal error occured');
  }

  return download_url;
}

Future<void> addNewUserInfo(GGUser ggUser) async {
  ggUser.uid = uid;
  ggUser.creation_date = DateTime.now().millisecondsSinceEpoch;

  await FirebaseFirestore.instance.collection(_USER).doc(uid).set(ggUser.toMap());
}


Future<void> addGoddessToEvent(String event_id) async {
  GGUser ggUser = await getGGUser();
  GGEvent ggEvent = await getGGEvent(event_id);

  await _db
      .collection(_EVENT)
      .doc(event_id)
      .collection(_EVENT_GODDESS)
      .doc(uid)
      .set({
        "name": ggUser.name,
        "profile_photo": ggUser.profile_photo,
      });

  await _db
      .collection(_USER)
      .doc(uid)
      .collection(_USER_BLESS)
      .doc(event_id)
      .set(ggEvent.toMap());
}

Future<void> addPatronToEvent(String event_id) async {
  GGUser ggUser = await getGGUser();
  GGEvent ggEvent = await getGGEvent(event_id);

  await _db
      .collection(_EVENT)
      .doc(event_id)
      .collection(_EVENT_PATRON)
      .doc(uid)
      .set({
        "name": ggUser.name,
        "profile_photo": ggUser.profile_photo,
      });

  await _db
      .collection(_USER)
      .doc(uid)
      .collection(_USER_ATTEND)
      .doc(event_id)
      .set(ggEvent.toMap());
}


Future<void> addGGEvent(GGEvent ggEvent) async {
  ggEvent.uid = uid;
  ggEvent.creation_date = DateTime.now().millisecondsSinceEpoch;

  await _db.collection(_EVENT).doc(ggEvent.doc_id).set(ggEvent.toMap());
}

Future<void> updateGGEvent(GGEvent ggEvent) async {
  // TODO :: fix uid stamping shit
  ggEvent.uid = uid;
  await _db.collection(_EVENT).doc(ggEvent.doc_id).update(ggEvent.toMap());
}

Future<void> updateGGUser(GGUser ggUser) async {
  // TODO :: fix uid stamping shit
  await _db.collection(_USER).doc(ggUser.uid).update(ggUser.toMap());
}

// TODO :: Delete all the events under users
Future<void> deleteGGEvent(String documentId) async {
  await _db.collection(_EVENT).doc(documentId).delete();
}

Future<void> deleteGoddessFromEvent(String event_id) async {
  // TODO this will rm all reviews ...
  await _db
      .collection(_EVENT)
      .doc(event_id)
      .collection(_EVENT_GODDESS)
      .doc(uid)
      .delete();

  await _db
      .collection(_USER)
      .doc(uid)
      .collection(_USER_BLESS)
      .doc(event_id)
      .delete();
}

Future<void> deletePatronFromEvent(String event_id) async {
  // TODO this will rm all reviews ...
  await _db
      .collection(_EVENT)
      .doc(event_id)
      .collection(_EVENT_PATRON)
      .doc(uid)
      .delete();

  await _db
      .collection(_USER)
      .doc(uid)
      .collection(_USER_ATTEND)
      .doc(event_id)
      .delete();
}


Future<GGUser> getGGUser({user_id: null}) async {
  DocumentSnapshot dSnap = await _db
      .collection(_USER).doc(user_id == null ? getUID() : user_id).get();
  return GGUser.fromDocumentSnapshot(dSnap);
}

Future<GGEvent> getGGEvent(String event_id) async {
  DocumentSnapshot dSnap = await _db.collection(_EVENT).doc(event_id).get();
  return GGEvent.fromDocumentSnapshot(dSnap);
}

Future<List<GGEvent>> getAllGGEvents({event_filter: null}) async {
  QuerySnapshot qSnap;

  if (event_filter == null){
    qSnap = await _db.collection(_EVENT).get();
  }
  else{
    qSnap = await _db.collection(_EVENT)
        .where("category", isEqualTo: event_filter)
        .get();
  }

  return qSnap.docs.map((docSnapshot) => GGEvent.fromDocumentSnapshot(docSnapshot)).toList();
}

Future<List<GGUser>> getAllPatronsAtEvent(String event_id) async {
  final QuerySnapshot qSnap = await _db
      .collection(_EVENT)
      .doc(event_id)
      .collection(_EVENT_PATRON)
      .get();

  return qSnap.docs.map((docSnapshot) => GGUser.fromDocumentSnapshot(docSnapshot)).toList();
}

Future<List<QueryDocumentSnapshot>> getAllGoddessesAtEvent(String event_id) async {
  final QuerySnapshot qSnap = await _db
      .collection(_EVENT)
      .doc(event_id)
      .collection(_EVENT_GODDESS)
      .get();

  return qSnap.docs;
}

// List of events goddess is working
Future<List<GGEvent>> getAllWorkedEventsOfAGoddess({goddess_id: null}) async {
  final QuerySnapshot qSnap = await _db
      .collection(_USER)
      .doc(goddess_id == null ? getUID() : goddess_id)
      .collection(_USER_BLESS)
      .get();

  return qSnap.docs.map((docSnapshot) => GGEvent.fromDocumentSnapshot(docSnapshot)).toList();

}
// List of events goddess is working
Future<List<GGEvent>> getUserCreatedEvents({goddess_id: null}) async {
  final QuerySnapshot qSnap = await _db
      .collection(_EVENT)
      .where("uid", isEqualTo: goddess_id == null ? getUID() : goddess_id)
      .get();

  return qSnap.docs.map((docSnapshot) => GGEvent.fromDocumentSnapshot(docSnapshot)).toList();

}

// Given an event check if current goddess is at it
Future<bool> isGoddessWithEvent(String event_id) async {
  DocumentSnapshot dSnap = await _db
      .collection(_USER)
      .doc(getUID())
      .collection(_USER_BLESS)
      .doc(event_id)
      .get();

  return dSnap.exists;
}

// Given an event check if current goddess is at it
Future<bool> isPatronWithEvent(String event_id) async {
  DocumentSnapshot dSnap = await _db
      .collection(_USER)
      .doc(getUID())
      .collection(_USER_ATTEND)
      .doc(event_id)
      .get();

  return dSnap.exists;
}
