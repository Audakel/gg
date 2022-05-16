import 'package:goddessGuild/Screen/Bottom_Nav_Bar/bottomNavBar.dart';
import 'package:flutter/material.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:path/path.dart';
import 'dart:async';

class updateProfile extends StatefulWidget {
  String name, password, country, profile_photo, uid, city;
  updateProfile(
      {this.country, this.name, this.profile_photo, this.uid, this.city});

  _updateProfileState createState() => _updateProfileState();
}

class _updateProfileState extends State<updateProfile> {
  TextEditingController nameController, countryController, cityController;
  String name = "";
  String country = "";
  String city = "";
  var profilePicUrl;

  File _image;
  String filename;

  @override
  void initState() {
    if (profilePicUrl == null) {
      setState(() {
        profilePicUrl = widget.profile_photo;
      });
    }
    nameController = TextEditingController(text: widget.name);
    countryController = TextEditingController(text: widget.country);
    cityController = TextEditingController(text: widget.city);
    // TODO: implement initState
    super.initState();
  }

  Future getImage() async {
    var image = await ImagePicker.pickImage(source: ImageSource.gallery);

    setState(() {
      _image = image;
      print('Image Path $_image');
    });
  }

  Future uploadPic(BuildContext context) async {
    // String fileName = basename(_image.path);
    // StorageReference firebaseStorageRef =
    //     FirebaseStorage.instance.ref().child(fileName);
    // StorageUploadTask uploadTask = firebaseStorageRef.putFile(_image);
    // var dowurl = await (await uploadTask.onComplete).ref.getDownloadURL();
    // profilePicUrl = dowurl.toString();
    // setState(() {
    //   print("Profile Picture uploaded");
    //   Scaffold.of(context)
    //       .showSnackBar(SnackBar(content: Text('Profile Picture Uploaded')));
    // });
  }

  Future selectPhoto() async {
    await ImagePicker.pickImage(source: ImageSource.gallery).then((image) {
      setState(() {
        _image = image;
        filename = basename(_image.path);
        uploadImage();
      });
    });
  }

  Future uploadImage() async {
    // StorageReference firebaseStorageRef =
    //     FirebaseStorage.instance.ref().child(filename);

    // StorageUploadTask uploadTask = firebaseStorageRef.putFile(_image);

    // var dowurl = await (await uploadTask.onComplete).ref.getDownloadURL();
    // await uploadTask.onComplete;
    // print('File Uploaded');
    // profilePicUrl = dowurl.toString();
    // setState(() {
    //   profilePicUrl = dowurl.toString();
    // });
    // print("download url = $profilePicUrl");
    // return profilePicUrl;
  }

  updateData() async {
    await FirebaseFirestore.instance
        .collection('user')
        .doc(widget.uid)
        .update({
      "name": nameController.text,
      "country": countryController.text,
      'profile_photo': profilePicUrl.toString(),
      "city": cityController.text
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: InkWell(
            onTap: () {
              Navigator.pop(context);
            },
            child: Icon(Icons.arrow_back)),
        elevation: 0.0,
        title: Text("Edit Profile",
            style: TextStyle(
              fontFamily: "Poppins",
              fontSize: 17.0,
            )),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            SizedBox(
              height: 30.0,
            ),
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Container(
                    height: 140.0,
                    width: 140.0,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(80.0)),
                        color: Colors.blueAccent,
                        boxShadow: [
                          BoxShadow(
                              color: Colors.black12.withOpacity(0.1),
                              blurRadius: 10.0,
                              spreadRadius: 4.0)
                        ]),
                    child: _image == null
                        ? new Stack(
                            children: <Widget>[
                              CircleAvatar(
                                backgroundColor: Colors.blueAccent,
                                radius: 170.0,
                                backgroundImage:
                                    NetworkImage(widget.profile_photo),
                              ),
                              Align(
                                alignment: Alignment.bottomRight,
                                child: InkWell(
                                  onTap: () {
                                    selectPhoto();
                                  },
                                  child: Container(
                                    height: 45.0,
                                    width: 45.0,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(50.0)),
                                      color: Colors.blueAccent,
                                    ),
                                    child: Center(
                                      child: Icon(
                                        Icons.camera_alt,
                                        color: Colors.white,
                                        size: 18.0,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          )
                        : new CircleAvatar(
                            backgroundImage: new FileImage(_image),
                            radius: 220.0,
                          ),
                  ),
                  SizedBox(
                    height: 10.0,
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 50.0,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 20.0, right: 20.0),
              child: Container(
                height: 50.0,
                width: double.infinity,
                decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                          blurRadius: 10.0,
                          color: Colors.black12.withOpacity(0.1)),
                    ],
                    color: Colors.white,
                    borderRadius: BorderRadius.all(Radius.circular(40.0))),
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 15.0, right: 15.0),
                    child: Theme(
                      data: ThemeData(
                        highlightColor: Colors.white,
                        hintColor: Colors.white,
                      ),
                      child: TextFormField(
                          controller: nameController,
                          decoration: InputDecoration(
                            hintText: 'Name',
                            enabledBorder: new UnderlineInputBorder(
                              borderSide: BorderSide(
                                  color: Colors.white,
                                  width: 1.0,
                                  style: BorderStyle.none),
                            ),
                          )),
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 30.0,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 20.0, right: 20.0),
              child: Container(
                height: 50.0,
                width: double.infinity,
                decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                          blurRadius: 10.0,
                          color: Colors.black12.withOpacity(0.1)),
                    ],
                    color: Colors.white,
                    borderRadius: BorderRadius.all(Radius.circular(40.0))),
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 15.0, right: 15.0),
                    child: Theme(
                      data: ThemeData(
                        highlightColor: Colors.white,
                        hintColor: Colors.white,
                      ),
                      child: TextFormField(
                          controller: countryController,
                          decoration: InputDecoration(
                            hintText: 'country',
                            enabledBorder: new UnderlineInputBorder(
                              borderSide: BorderSide(
                                  color: Colors.white,
                                  width: 1.0,
                                  style: BorderStyle.none),
                            ),
                          )),
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 30.0,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 20.0, right: 20.0),
              child: Container(
                height: 50.0,
                width: double.infinity,
                decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                          blurRadius: 10.0,
                          color: Colors.black12.withOpacity(0.1)),
                    ],
                    color: Colors.white,
                    borderRadius: BorderRadius.all(Radius.circular(40.0))),
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 15.0, right: 15.0),
                    child: Theme(
                      data: ThemeData(
                        highlightColor: Colors.white,
                        hintColor: Colors.white,
                      ),
                      child: TextFormField(
                          controller: cityController,
                          decoration: InputDecoration(
                            hintText: 'City',
                            enabledBorder: new UnderlineInputBorder(
                              borderSide: BorderSide(
                                  color: Colors.white,
                                  width: 1.0,
                                  style: BorderStyle.none),
                            ),
                          )),
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 80.0,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 15.0, right: 15.0),
              child: InkWell(
                onTap: () {
                  updateData();
                  //  uploadImage();
                  _showDialog(context);
                },
                child: Container(
                  height: 50.0,
                  width: double.infinity,
                  child: Center(
                    child: Text("Update Profile",
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                            fontFamily: "Poppins")),
                  ),
                  decoration: BoxDecoration(
                    color: Colors.deepPurpleAccent,
                    borderRadius: BorderRadius.all(Radius.circular(40.0)),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Card Popup if success payment
_showDialog(BuildContext ctx) {
  showDialog(
    context: ctx,
    barrierDismissible: true,
    builder: (BuildContext context) => SimpleDialog(
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Padding(
                padding: EdgeInsets.only(left: 10.0),
                child: InkWell(
                    onTap: () {
                      Navigator.of(ctx).pop();
                    },
                    child: Icon(
                      Icons.close,
                      size: 30.0,
                    ))),
            SizedBox(
              width: 10.0,
            )
          ],
        ),
        Container(
            padding: EdgeInsets.only(top: 30.0, right: 60.0, left: 60.0),
            color: Colors.white,
            child: Icon(
              Icons.check_circle,
              size: 150.0,
              color: Colors.green,
            )),
        Center(
            child: Padding(
          padding: const EdgeInsets.only(top: 16.0),
          child: Text(
            "Succes",
            style: TextStyle(fontWeight: FontWeight.w700, fontSize: 22.0),
          ),
        )),
        Center(
            child: Padding(
          padding: const EdgeInsets.only(top: 30.0, bottom: 40.0),
          child: Text(
            "Edit Data Succes",
            style: TextStyle(fontSize: 17.0),
          ),
        )),
      ],
    ),
  );
}
