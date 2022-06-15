import 'dart:async';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'Screen/Bottom_Nav_Bar/bottomNavBar.dart';
import 'Screen/Login/OnBoarding.dart';
import 'dart:io' show Platform;
import 'package:firebase_core/firebase_core.dart';

// TODO :: swap EVENT_TYPES enum for this
// extension ParseToString on EVENT_TYPES {
//   String toShortString() {
//     return this.toString().split('.').last;
//   }
// }
//
// main() {
//   Day monday = Day.monday;
//   print(monday.toShortString()); //prints 'monday'
// }

const EVENT_TYPES = <String>[
  "Bachelor Party",
  "Bachelorette Party",
  "Stripclub", // #2 dont change order
  "Concert",
  "Boat Party",
  "Birthday Party",
  "After Party",
  "Other"
];

const EVENT_LEVELS = <String>[
  "Level 0: Nothing",
  "Level 1: Stripclub",
  "Level 2: Gala",
  "Level 3: Temple",
];

const SUPPORTED_CITIES = <String>[
  "Austin",
  "Dallas",
  "Houston",
];

const USER_TYPE = <String>[
  "Dancer",
  "Patron",
];

const String COMPANY_NAME = "_goddessGuild()";
const String DB_EVENT_PIC_PATH = "file/event_pic/";
const String EMPTY_PROFILE = "https://firebasestorage.googleapis.com/v0/b/event-f3833.appspot.com/o/emptyProfilePicture.png?alt=media&token=c129b8c2-3e0e-4c26-95d1-fb767fdd7259";