import 'dart:io';
import 'package:flutter/material.dart';
import 'package:goddessGuild/db_service.dart';
import 'package:goddessGuild/models.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:async';
import 'package:goddessGuild/constants.dart';

class updateProfile extends StatefulWidget {
  updateProfile();
  _updateProfileState createState() => _updateProfileState();
}

class _updateProfileState extends State<updateProfile> {
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController cityController = TextEditingController();

  ImagePicker _picker = ImagePicker();
  File photoLocal = null;

  String network_photo = EMPTY_PROFILE;

  GGUser ggUser;

  void getUserInfo() async {
    ggUser = await getGGUser();

    nameController.text = ggUser.name;
    emailController.text = ggUser.email;
    cityController.text = ggUser.city;
    network_photo = ggUser.profile_photo;

    setState(() {});
  }

  @override
  void initState() {
    getUserInfo();

    super.initState();
  }

  Future pickImage({source = ImageSource.gallery}) async {
    // ImageSource.gallery
    // ImageSource.camera
    final pickedFile = await _picker.getImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      photoLocal = File(pickedFile.path);
      network_photo = await uploadFileToDB(photoLocal, "user_profile");
    } else {
      print('No image selected.');
    }

    setState(() {});
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
                    child: Stack(
                            children: <Widget>[
                              CircleAvatar(
                                backgroundColor: Colors.blueAccent,
                                radius: 170.0,
                                backgroundImage:
                                    NetworkImage(network_photo),
                              ),
                              Align(
                                alignment: Alignment.bottomRight,
                                child: InkWell(
                                  onTap: () {
                                    pickImage();
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
              padding: const EdgeInsets.only(top: 10, bottom: 10, left: 20.0, right: 20.0),
              child: TextFormField(
                controller: nameController,
                keyboardType: TextInputType.text,
                decoration: InputDecoration(labelText: 'Name', border: OutlineInputBorder()),
                validator: (value) => (value == null ? 'Cannot be empty' : null),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 10, bottom: 10, left: 20.0, right: 20.0),
              child: TextFormField(
                controller: emailController,
                keyboardType: TextInputType.text,
                decoration: InputDecoration(labelText: 'Email', border: OutlineInputBorder()),
                validator: (value) => (value == null ? 'Cannot be empty' : null),
              ),
            ),

            Padding(
              padding: const EdgeInsets.only(top: 10, bottom: 10, left: 20.0, right: 20.0),
              child: TextFormField(
                controller: cityController,
                keyboardType: TextInputType.text,
                decoration: InputDecoration(labelText: 'City', border: OutlineInputBorder()),
                validator: (value) => (value == null ? 'Cannot be empty' : null),
              ),
            ),


            SizedBox(
              height: 40.0,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 15.0, right: 15.0),
              child: InkWell(
                onTap: () async {
                  ggUser.name = nameController.text;
                  ggUser.email = emailController.text;
                  ggUser.city = cityController.text;
                  ggUser.profile_photo = network_photo;

                  await updateGGUser(ggUser).catchError((err) {
                    print(err);
                  });

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
