import 'package:goddessGuild/models.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'dart:io';
import 'package:uuid/uuid.dart';

final FirebaseFirestore _db = FirebaseFirestore.instance;
final FirebaseAuth auth = FirebaseAuth.instance;
final storageRef = FirebaseStorage.instance.ref();
final User user = auth.currentUser;
final uid = user.uid;

var EVENT = "event";
var EVENT_GODDESS = "goddess";
var EVENT_PATRON = "patron";

var USER = "user";
var USER_ATTEND = "attend";
var USER_BLESS = "bless";



String getUID() => uid;

// Create uuid object
var uidv4 = Uuid();

Future<String> uploadFileToDB(File file_path, storage_dir) async {
  // "event_pics"
  var ref = storageRef.child(storage_dir + "/" + uidv4.v4());
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

  await FirebaseFirestore.instance.collection(USER).doc(uid).set(ggUser.toMap());
}


Future<void> addGoddessToEvent(String event_id) async {
  GGUser ggUser = await getGGUser();
  GGEvent ggEvent = await getGGEvent(event_id);

  await _db
      .collection(EVENT)
      .doc(event_id)
      .collection(EVENT_GODDESS)
      .doc(uid)
      .set({
        "name": ggUser.name,
        "profile_photo": ggUser.profile_photo,
      });

  await _db
      .collection(USER)
      .doc(uid)
      .collection(USER_BLESS)
      .doc(event_id)
      .set({
        "event_name": ggEvent.title,
        "event_photo": ggEvent.image_url,
      });
}

Future<void> addPatronToEvent(String event_id) async {
  await _db
      .collection(EVENT)
      .doc(event_id)
      .collection(EVENT_PATRON)
      .doc(uid)
      .set({"rated": 5, "reviewed": "none"});

  await _db
      .collection(USER)
      .doc(uid)
      .collection(USER_ATTEND)
      .doc(event_id);
}

Future<void> addGGEvent(GGEvent ggEvent) async {
  ggEvent.uid = uid;
  ggEvent.creation_date = DateTime.now().millisecondsSinceEpoch;

  await _db.collection(EVENT).doc(ggEvent.doc_id).set(ggEvent.toMap());
}

Future<void> updateGGEvent(GGEvent ggEvent) async {
  await _db.collection(EVENT).doc(ggEvent.doc_id).update(ggEvent.toMap());
}

Future<void> deleteGGEvent(String documentId) async {
  await _db.collection(EVENT).doc(documentId).delete();
}

Future<void> deleteGoddessFromEvent(String event_id) async {
  // TODO this will rm all reviews ...
  await _db
      .collection(EVENT)
      .doc(event_id)
      .collection(EVENT_GODDESS)
      .doc(uid)
      .delete();

  await _db
      .collection(USER)
      .doc(uid)
      .collection(USER_BLESS)
      .doc(event_id)
      .delete();
}

Future<GGUser> getGGUser({user_id: null}) async {
  DocumentSnapshot dSnap = await _db
      .collection(USER).doc(user_id == null ? getUID() : user_id).get();
  return GGUser.fromDocumentSnapshot(dSnap);
}

Future<GGEvent> getGGEvent(String event_id) async {
  DocumentSnapshot dSnap = await _db.collection(EVENT).doc(event_id).get();
  return GGEvent.fromDocumentSnapshot(dSnap);
}

Future<List<GGEvent>> getAllGGEvents() async {
  QuerySnapshot qSnap = await _db.collection(EVENT).get();
  return qSnap.docs.map((docSnapshot) => GGEvent.fromDocumentSnapshot(docSnapshot)).toList();
}

Future<List<QueryDocumentSnapshot>> getAllGoddessesAtEvent(String event_id) async {
  final QuerySnapshot qSnap = await _db
      .collection(EVENT)
      .doc(event_id)
      .collection(EVENT_GODDESS)
      .get();

  return qSnap.docs;
}

// List of events goddess is working
Future<List<GGEvent>> getAllEventsOfAGoddess({goddess_id: null}) async {
  final QuerySnapshot qSnap = await _db
      .collection(USER)
      .doc(goddess_id == null ? getUID() : goddess_id)
      .collection(USER_BLESS)
      .get();

  return qSnap.docs.map((docSnapshot) => GGEvent.fromDocumentSnapshot(docSnapshot)).toList();

}

// Given an event check if current goddess is at it
Future<bool> isGoddessWithEvent(String event_id) async {
  DocumentSnapshot dSnap = await _db
      .collection(USER)
      .doc(getUID())
      .collection(USER_BLESS)
      .doc(event_id)
      .get();

  return dSnap.exists;
}


