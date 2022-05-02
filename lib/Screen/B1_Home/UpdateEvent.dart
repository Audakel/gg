import 'package:flutter/material.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:intl/intl.dart';
import 'package:path/path.dart';
import 'dart:async';
import 'package:date_format/date_format.dart';

class updateEvent extends StatefulWidget {
  String list;
  final String title, userId, category, imageUrl, desc, time, place, id, date;
  updateEvent(
      {this.id,
      this.category,
      this.desc,
      this.imageUrl,
      this.list,
      this.time,
      this.date,
      this.place,
      this.title,
      this.userId});

  @override
  _updateEventState createState() => _updateEventState();
}

class _updateEventState extends State<updateEvent> {
  String _title,
      _time,
      _price,
      _place,
      _desc1,
      _desc2,
      _desc3,
      _date,
      _country,
      _category;

  TextEditingController titleController = new TextEditingController();
  TextEditingController timeController = new TextEditingController();
  TextEditingController priceController = new TextEditingController();
  TextEditingController placeController = new TextEditingController();
  TextEditingController imageController = new TextEditingController();
  TextEditingController countryController = new TextEditingController();
  TextEditingController categoryController = new TextEditingController();

  TextEditingController desc1Controller = new TextEditingController();

  String _setTime, _setDate;

  String _hour, _minute;

  String dateTime;

  DateTime selectedDate = DateTime.now();

  TimeOfDay selectedTime = TimeOfDay(hour: 00, minute: 00);
  String profilePicUrl;
  bool imageUpload = false;
  TextEditingController _dateController = TextEditingController();
  TextEditingController _timeController = TextEditingController();

  var _imageVar;

  File _image;
  String filename;

  @override
  void initState() {
    if (_imageVar == null) {
      setState(() {
        _imageVar = widget.imageUrl;
      });
    }
    titleController = TextEditingController(text: widget.title);
    _time = widget.time;
    placeController = TextEditingController(text: widget.place);
    _date = widget.date;
    categoryController = TextEditingController(text: widget.category);
    desc1Controller = TextEditingController(text: widget.desc);

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
    FirebaseStorage storage = FirebaseStorage.instance;

    Reference ref = storage.ref().child("image1" + DateTime.now().toString());
    UploadTask uploadTask = ref.putFile(_image);

    // Waits till the file is uploaded then stores the download url
    // Uri location = (await uploadTask.).downloadUrl;
    // TaskSnapshot taskSnapshot =
    //     await ref.putFile(_image).whenComplete(() => ref.getDownloadURL());
    // print("dsad" + taskSnapshot.ref.getDownloadURL().toString());

    String image = "dsadas";
    FirebaseStorage.instance
        .refFromURL(image)
        .getDownloadURL()
        .then((url) async {
      print("irl " + url);
    });

    uploadTask.then((res) {
      String linkPP = res.ref.getDownloadURL().toString();
      print(linkPP);
      // print('File Uploaded');
      profilePicUrl = res.toString();
      if (profilePicUrl == null) {
        imageUpload = false;
      }
      setState(() {
        profilePicUrl = res.toString();
      });

      print("download urls = $linkPP");
      return linkPP;
    });
    // String fileName = basename(_image.path);
    // StorageReference firebaseStorageRef =
    //     FirebaseStorage.instance.ref().child(fileName);
    // StorageUploadTask uploadTask = firebaseStorageRef.putFile(_image);
    // var dowurl = await (await uploadTask.onComplete).ref.getDownloadURL();
    // _imageVar = dowurl.toString();
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
    FirebaseStorage storage = FirebaseStorage.instance;

    Reference ref = storage.ref().child("image1" + DateTime.now().toString());
    UploadTask uploadTask = ref.putFile(_image);

    // Waits till the file is uploaded then stores the download url
    // Uri location = (await uploadTask.).downloadUrl;
    // TaskSnapshot taskSnapshot =
    //     await ref.putFile(_image).whenComplete(() => ref.getDownloadURL());
    // print("dsad" + taskSnapshot.ref.getDownloadURL().toString());

    String image = "dsadas";
    FirebaseStorage.instance
        .refFromURL(image)
        .getDownloadURL()
        .then((url) async {
      print("irl " + url);
    });

    uploadTask.then((res) {
      String linkPP = res.ref.getDownloadURL().toString();
      print(linkPP);
      // print('File Uploaded');
      profilePicUrl = res.toString();
      if (profilePicUrl == null) {
        imageUpload = false;
      }
      setState(() {
        profilePicUrl = res.toString();
      });

      print("download urls = $linkPP");
      return linkPP;
    });
  }

  Future<Null> _selectTime(BuildContext context) async {
    final TimeOfDay picked = await showTimePicker(
      context: context,
      initialTime: selectedTime,
    );
    if (picked != null)
      setState(() {
        selectedTime = picked;
        _hour = selectedTime.hour.toString();
        _minute = selectedTime.minute.toString();
        _time = _hour + ' : ' + _minute;
        _timeController.text = _time;
        _timeController.text = formatDate(
            DateTime(2019, 08, 1, selectedTime.hour, selectedTime.minute),
            [hh, ':', nn, " ", am]).toString();
      });
  }

  Future<Null> _selectDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        initialDatePickerMode: DatePickerMode.day,
        firstDate: DateTime(2015),
        lastDate: DateTime(2101));
    if (picked != null)
      setState(() {
        selectedDate = picked;
        _dateController.text = DateFormat.yMd().format(selectedDate);
      });
  }

  updateData() async {
    await FirebaseFirestore.instance
        .collection("users")
        .doc(widget.userId)
        .collection('event')
        .doc(widget.list.toString())
        .update({
      "imageUrl": _imageVar.toString(),
      "title": titleController.text,
      "time": _timeController.text,
      "place": placeController.text,
      "date": _dateController.text,
      "desc1": desc1Controller.text,
      "category": categoryController.text,
      "price": "Price"
    });
  }

  updateData2() async {
    await FirebaseFirestore.instance
        .collection("event")
        .doc(widget.list.toString())
        .update({
      "imageUrl": _imageVar.toString(),
      "title": titleController.text,
      "time": _timeController.text,
      "place": placeController.text,
      "date": _dateController.text,
      "desc1": desc1Controller.text,
      "category": categoryController.text,
      "price": "Price"
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        centerTitle: true,
        title: Text(
          "Update Event",
          style: TextStyle(fontFamily: "Sofia", fontWeight: FontWeight.w400),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(top: 20.0, right: 20.0, left: 20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _image == null
                  ? new Stack(
                      children: <Widget>[
                        Container(
                          height: 240.0,
                          width: double.infinity,
                          decoration: BoxDecoration(
                              image: DecorationImage(
                                  image: NetworkImage(widget.imageUrl))),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 200.0),
                          child: Align(
                            alignment: Alignment.bottomRight,
                            child: InkWell(
                              onTap: () {
                                selectPhoto();
                              },
                              child: Container(
                                height: 55.0,
                                width: 55.0,
                                decoration: BoxDecoration(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(50.0)),
                                  color: Colors.blueAccent,
                                ),
                                child: Center(
                                  child: Icon(
                                    Icons.camera_alt,
                                    color: Colors.white,
                                    size: 22.0,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    )
                  : Container(
                      height: 240.0,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        image: DecorationImage(image: FileImage(_image)),
                      )),
              SizedBox(
                height: 30.0,
              ),
              Text(
                "Title",
                style: TextStyle(
                    fontFamily: "Sofia",
                    fontWeight: FontWeight.w700,
                    fontSize: 16.5),
              ),
              SizedBox(
                height: 5.0,
              ),
              Theme(
                data: ThemeData(accentColor: Colors.deepPurpleAccent),
                child: TextFormField(
                  validator: (input) {
                    if (input.isEmpty) {
                      return 'Please input your title';
                    }
                  },
                  maxLines: 2,
                  onSaved: (input) => _title = input,
                  controller: titleController,
                  keyboardType: TextInputType.text,
                  textCapitalization: TextCapitalization.words,
                  style: TextStyle(
                      fontFamily: "WorkSansSemiBold",
                      fontSize: 16.0,
                      color: Colors.black),
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                        borderSide: BorderSide(
                            width: 0.5,
                            color: Colors.black12.withOpacity(0.01))),
                    contentPadding: EdgeInsets.all(13.0),
                    hintText: "Input your title",
                    hintMaxLines: 2,
                    hintStyle: TextStyle(fontFamily: "Sans", fontSize: 15.0),
                  ),
                ),
              ),
              SizedBox(
                height: 20.0,
              ),
              Text(
                "Time",
                style: TextStyle(
                    fontFamily: "Sofia",
                    fontWeight: FontWeight.w700,
                    fontSize: 16.5),
              ),
              SizedBox(
                height: 5.0,
              ),
              Theme(
                data: ThemeData(accentColor: Colors.deepPurpleAccent),
                child: InkWell(
                  onTap: () {
                    _selectTime(context);
                  },
                  child: Container(
                    //  margin: EdgeInsets.only(top: 30),
                    width: double.infinity,
                    height: 55.0,
                    alignment: Alignment.center,
                    //  decoration: BoxDecoration(color: Colors.grey[200]),
                    child: TextFormField(
                      style: TextStyle(
                        fontSize: 18,
                        fontFamily: "Sofia",
                      ),
                      textAlign: TextAlign.left,
                      onSaved: (String val) {
                        _setTime = val;
                      },
                      enabled: false,
                      keyboardType: TextInputType.text,
                      controller: _timeController,
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.all(13.0),
                        hintText: "Time",
                        hintStyle:
                            TextStyle(fontFamily: "Sofia", fontSize: 18.0),
                        border: OutlineInputBorder(
                            borderSide: BorderSide(
                                width: 0.5,
                                color: Colors.black12.withOpacity(0.1))),
                        // labelText: 'Time',
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 20.0,
              ),
              Text(
                "Place",
                style: TextStyle(
                    fontFamily: "Sofia",
                    fontWeight: FontWeight.w700,
                    fontSize: 16.5),
              ),
              SizedBox(
                height: 5.0,
              ),
              Theme(
                data: ThemeData(accentColor: Colors.deepPurpleAccent),
                child: TextFormField(
                  validator: (input) {
                    if (input.isEmpty) {
                      return 'Please input your place';
                    }
                  },
                  maxLines: 2,
                  onSaved: (input) => _place = input,
                  controller: placeController,
                  keyboardType: TextInputType.text,
                  textCapitalization: TextCapitalization.words,
                  style: TextStyle(
                      fontFamily: "WorkSansSemiBold",
                      fontSize: 16.0,
                      color: Colors.black),
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                        borderSide: BorderSide(
                            width: 0.5,
                            color: Colors.black12.withOpacity(0.01))),
                    contentPadding: EdgeInsets.all(13.0),
                    hintText: "Input your place",
                    hintMaxLines: 2,
                    hintStyle: TextStyle(fontFamily: "Sans", fontSize: 15.0),
                  ),
                ),
              ),
              SizedBox(
                height: 20.0,
              ),
              Text(
                "Date",
                style: TextStyle(
                    fontFamily: "Sofia",
                    fontWeight: FontWeight.w700,
                    fontSize: 16.5),
              ),
              SizedBox(
                height: 5.0,
              ),
              Theme(
                data: ThemeData(accentColor: Colors.deepPurpleAccent),
                child: InkWell(
                  onTap: () {
                    _selectDate(context);
                  },
                  child: Container(
                    //  margin: EdgeInsets.only(top: 30),
                    width: double.infinity,
                    height: 55.0,
                    alignment: Alignment.center,
                    //  decoration: BoxDecoration(color: Colors.grey[200]),
                    child: TextFormField(
                      style: TextStyle(
                        fontSize: 18,
                        fontFamily: "Sofia",
                      ),
                      textAlign: TextAlign.left,
                      onSaved: (String val) {
                        _setTime = val;
                      },
                      enabled: false,
                      keyboardType: TextInputType.text,
                      controller: _dateController,
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.all(13.0),
                        hintText: "Date",
                        hintStyle:
                            TextStyle(fontFamily: "Sofia", fontSize: 18.0),
                        border: OutlineInputBorder(
                            borderSide: BorderSide(
                                width: 0.5,
                                color: Colors.black12.withOpacity(0.1))),
                        // labelText: 'Time',
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 20.0,
              ),
              Text(
                "Category",
                style: TextStyle(
                    fontFamily: "Sofia",
                    fontWeight: FontWeight.w700,
                    fontSize: 16.5),
              ),
              SizedBox(
                height: 5.0,
              ),
              Theme(
                data: ThemeData(accentColor: Colors.deepPurpleAccent),
                child: TextFormField(
                  validator: (input) {
                    if (input.isEmpty) {
                      return 'Please input your category';
                    }
                  },
                  maxLines: 2,
                  onSaved: (input) => _category = input,
                  controller: categoryController,
                  keyboardType: TextInputType.text,
                  textCapitalization: TextCapitalization.words,
                  style: TextStyle(
                      fontFamily: "WorkSansSemiBold",
                      fontSize: 16.0,
                      color: Colors.black),
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                        borderSide: BorderSide(
                            width: 0.5,
                            color: Colors.black12.withOpacity(0.01))),
                    contentPadding: EdgeInsets.all(13.0),
                    hintText: "Input your category",
                    hintMaxLines: 2,
                    hintStyle: TextStyle(fontFamily: "Sans", fontSize: 15.0),
                  ),
                ),
              ),
              SizedBox(
                height: 20.0,
              ),
              Text(
                "Description",
                style: TextStyle(
                    fontFamily: "Sofia",
                    fontWeight: FontWeight.w700,
                    fontSize: 16.5),
              ),
              SizedBox(
                height: 5.0,
              ),
              Theme(
                data: ThemeData(accentColor: Colors.deepPurpleAccent),
                child: TextFormField(
                  validator: (input) {
                    if (input.isEmpty) {
                      return 'Please input your description';
                    }
                  },
                  maxLines: 8,
                  onSaved: (input) => _desc1 = input,
                  controller: desc1Controller,
                  keyboardType: TextInputType.text,
                  textCapitalization: TextCapitalization.words,
                  style: TextStyle(
                      fontFamily: "WorkSansSemiBold",
                      fontSize: 16.0,
                      color: Colors.black),
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                        borderSide: BorderSide(
                            width: 0.5,
                            color: Colors.black12.withOpacity(0.01))),
                    contentPadding: EdgeInsets.all(13.0),
                    hintText: "Input your description",
                    hintMaxLines: 2,
                    hintStyle: TextStyle(fontFamily: "Sans", fontSize: 15.0),
                  ),
                ),
              ),
              SizedBox(
                height: 30.0,
              ),
              InkWell(
                onTap: () async {
                  confirmDialog(context);
                  updateData();
                  updateData2();
                },
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.only(
                        left: 20.0, right: 20.0, bottom: 20.0),
                    child: Container(
                      height: 55.0,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: Colors.deepPurpleAccent,
                        borderRadius: BorderRadius.all(Radius.circular(50.0)),
                      ),
                      child: Center(
                        child: Text(
                          "Update",
                          style: TextStyle(
                              fontFamily: "Sofia",
                              color: Colors.white,
                              fontSize: 17.0),
                        ),
                      ),
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

void confirmDialog(BuildContext context) async {
  showDialog(
    context: context,
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
                      Navigator.of(context).pop();
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
            "Update Event Succes",
            style: TextStyle(fontSize: 17.0),
          ),
        )),
      ],
    ),
  );
}
