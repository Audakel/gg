import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class GGEvent {
  String image_url;
  String title;
  String time_start;
  String time_end;
  String address;
  int zip;
  String phone;
  String date;
  String desc1;
  String category;
  String uid;
  String doc_id;
  int price;
  int club_level;
  int goddesses_needed;
  int guests_expected;
  int creation_date;

  GGEvent({
    this.image_url,
    this.title,
    this.time_start,
    this.time_end,
    this.address,
    this.zip,
    this.phone,
    this.date,
    this.desc1,
    this.category,
    this.doc_id,
    this.uid,
    this.price,
    this.club_level,
    this.goddesses_needed,
    this.guests_expected,
    this.creation_date,
  });

  Map<String, dynamic> toMap() {
    return {
      'image_url': image_url,
      'title': title,
      'time_start': time_start,
      'time_end': time_end,
      'address': address,
      'zip': zip,
      'phone': phone,
      'date': date,
      'desc1': desc1,
      'category': category,
      'doc_id': doc_id,
      'uid': uid,
      'price': price,
      'club_level': club_level,
      'goddesses_needed': goddesses_needed,
      'guests_expected': guests_expected,
      'creation_date': creation_date,
    };
  }

  GGEvent.fromMap(Map<String, dynamic> map)
      : image_url = map["image_url"],
        title = map["title"],
        time_start = map["time_start"],
        time_end = map["time_end"],
        address = map["address"],
        zip = map["cityName"],
        phone = map["phone"],
        date = map["date"],
        desc1 = map["desc1"],
        category = map["category"],
        doc_id = map["doc_id"],
        uid = map["uid"],
        price = map["price"],
        club_level = map["club_level"],
        goddesses_needed = map["goddesses_needed"],
        guests_expected = map["guests_expected"],
        creation_date = map["creation_date"];

  GGEvent.fromDocumentSnapshot(DocumentSnapshot doc)
      : image_url = doc.data()["image_url"],
        title = doc.data()["title"],
        time_start = doc.data()["time_start"],
        time_end = doc.data()["time_end"],
        address = doc.data()["address"],
        zip = doc.data()["cityName"],
        phone = doc.data()["phone"],
        date = doc.data()["date"],
        desc1 = doc.data()["desc1"],
        category = doc.data()["category"],
        doc_id = doc.data()["doc_id"],
        uid = doc.data()["uid"],
        price = doc.data()["price"],
        club_level = doc.data()["club_level"],
        goddesses_needed = doc.data()["goddesses_needed"],
        guests_expected = doc.data()["guests_expected"],
        creation_date = doc.data()["creation_date"];
}

class GGUser {
  String uid;
  String name;
  String email;
  String password;
  String country;
  String city;
  int level;
  double rating;
  String profile_photo;
  int creation_date;

  GGUser({
    this.uid,
    this.name,
    this.email,
    this.password,
    this.country,
    this.city,
    this.level,
    this.rating,
    this.profile_photo,
    this.creation_date,
  });

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'name': name,
      'email': email,
      'password': password,
      'country': country,
      'city': city,
      'level': level,
      'rating': rating,
      'profile_photo': profile_photo,
      'creation_date': creation_date,
    };
  }

  GGUser.fromMap(Map<String, dynamic> map) :
        uid = map["uid"],
        name = map["name"],
        email = map["email"],
        password = map["password"],
        country = map["country"],
        city = map["city"],
        level = map["level"],
        rating = map["rating"],
        profile_photo = map["profile_photo"],
        creation_date = map["creation_date"];

  GGUser.fromDocumentSnapshot(DocumentSnapshot doc) :
        uid = doc.data()["uid"],
        name = doc.data()["name"],
        email = doc.data()["email"],
        password = doc.data()["password"],
        country = doc.data()["country"],
        city = doc.data()["city"],
        level = doc.data()["level"],
        rating = doc.data()["rating"],
        profile_photo = doc.data()["profile_photo"],
        creation_date = doc.data()["creation_date"];
}


class GGReview {

  int rating;
  String review;
  String author_name;
  String author_id;
  String author_profile_pic;
  String reviewee_name;
  String reviewee_id;
  String reviewee_profile_pic;
  int creation_date;

  GGReview({
    this.rating,
    this.review,
    this.author_name,
    this.author_id,
    this.author_profile_pic,
    this.reviewee_name,
    this.reviewee_id,
    this.reviewee_profile_pic,
    this.creation_date,
  });

  // Map<String, dynamic> toMap() {return {};}

  //GGReview.fromMap(Map<String, dynamic> map) :

  //GGReview.fromDocumentSnapshot(DocumentSnapshot doc) :

}

