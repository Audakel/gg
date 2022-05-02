import 'dart:io';
import 'dart:ui';
import 'package:goddessGuild/Screen/Bottom_Nav_Bar/bottomNavBar.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:path/path.dart';
import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:date_format/date_format.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';
//import 'package:currency_text_input_formatter/currency_text_input_formatter.dart';
import 'package:firebase_auth/firebase_auth.dart';


// Create a Form widget.
class MyCustomForm extends StatefulWidget {
  const MyCustomForm({Key key}) : super(key: key);

  @override
  MyCustomFormState createState() {
    return MyCustomFormState();
  }
}

// Create a corresponding State class.
// This class holds data related to the form.
class MyCustomFormState extends State<MyCustomForm> {
  // Create a global key that uniquely identifies the Form widget
  // and allows validation of the form.
  //
  // Note: This is a GlobalKey<FormState>,
  // not a GlobalKey<MyCustomFormState>.
  final _formKey = GlobalKey<FormState>();

  bool checkbox1 = true;
  bool checkbox2 = false;
  String gender = 'male';
  String dropdownValue = 'A';
  DateTime date = DateTime.now();
  TimeOfDay time = TimeOfDay.now();
  DateTime selectedDate = DateTime.now();
  TimeOfDay selectedTime = TimeOfDay(hour: 00, minute: 00);

  TextEditingController titleController = new TextEditingController();
  TextEditingController descriptionController = new TextEditingController();
  TextEditingController attendanceController = new TextEditingController();
  TextEditingController goddessController = new TextEditingController();
  TextEditingController addressController = new TextEditingController();
  TextEditingController zipController = new TextEditingController();
  TextEditingController priceController = new TextEditingController();
  TextEditingController dateController = TextEditingController();
  TextEditingController timeStartController = new TextEditingController();
  TextEditingController timeEndController = new TextEditingController();

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
        dateController.text = DateFormat.yMd().format(selectedDate);
      });
  }

  Future<Null> _selectTime(BuildContext context, TextEditingController controller) async {
    final TimeOfDay picked = await showTimePicker(
      context: context,
      initialTime: selectedTime,
    );
    if (picked != null)
      setState(() {
        selectedTime = picked;
        controller.text = formatDate(
            DateTime(2019, 08, 1, selectedTime.hour, selectedTime.minute),
            [hh, ':', nn, " ", am]).toString();
      });
  }
// Create uuid object


  void saveEvent(String v4, String uid) {
    FirebaseFirestore.instance
        .runTransaction((Transaction transaction) async {

      FirebaseFirestore.instance
          .collection('event')
          .doc(v4)
          .set({
            "imageUrl": 0, //PicUrl.toString(),
            "title": titleController.text,
            "time": timeStartController.text,
            "timeEnd": timeEndController.text,
            "address": addressController.text,
            "zip": zipController.text,
            "date": dateController.text,
            "desc1": descriptionController.text,
            "category": dropdownValue,
            "id": v4,
            "uid": uid,
            "price": priceController.text,
            "clubLevel": 1,
            "creationDate": DateTime.now().millisecondsSinceEpoch,
      });
    });
  }



  @override
  Widget build(BuildContext context) {
    var uuid = Uuid();
    // Generate a v4 (random) id
    var v4 = uuid.v4(); // -> '110ec58a-a0f2-4ac4-8393-c866d813b8d1'

    final FirebaseAuth auth = FirebaseAuth.instance;
    final User user = auth.currentUser;
    final uid = user.uid;

    return Scaffold(
        body: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Container(
              padding: EdgeInsets.all(10.0),
              child: Column(children: [
                SizedBox(height: 10.0),
                TextFormField(
                  controller: titleController,
                  keyboardType: TextInputType.text,
                  decoration: InputDecoration(
                      labelText: 'Event Title',
                      border: OutlineInputBorder()
                  ),
            ),
                SizedBox(height: 10.0),
                TextFormField(
                  controller: descriptionController,
                  keyboardType: TextInputType.text,
                  decoration: InputDecoration(
                      labelText: 'Event Description',
                      border: OutlineInputBorder()
                  ),
                  maxLines: 5,
                  minLines: 3,
                ),
                SizedBox(height: 10.0),
                TextFormField(
                  controller: attendanceController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                      labelText: 'Your Crews Estimated Attendance',
                      border: OutlineInputBorder()
                  ),
                ),
                SizedBox(height: 10.0),
                TextFormField(
                  controller: goddessController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                      labelText: 'Minimum Number Of Goddess Hoped For',
                      border: OutlineInputBorder()
                  ),
                ),
                SizedBox(height: 10.0),
                TextFormField(
                  controller: dateController,
                  decoration: InputDecoration(
                      labelText: 'Date of Gala',
                      border: OutlineInputBorder()
                  ),
                  onTap: () async {
                    FocusScope.of(context).requestFocus(new FocusNode());
                    _selectDate(context);
                  },
                ),
                SizedBox(height: 10.0),
                TextFormField(
                  controller: timeStartController,
                  decoration: InputDecoration(
                      labelText: 'Start Time',
                      border: OutlineInputBorder()
                  ),
                  onTap: () async {
                    FocusScope.of(context).requestFocus(new FocusNode());
                    _selectTime(context, timeStartController);
                  },
                ),
                SizedBox(height: 10.0),
                TextFormField(
                  controller: timeEndController,
                  decoration: InputDecoration(
                      labelText: 'End Time',
                      border: OutlineInputBorder()
                  ),
                  onTap: () async {
                    FocusScope.of(context).requestFocus(new FocusNode());
                    _selectTime(context, timeEndController);
                  },
                ),
                SizedBox(height: 10.0),
                TextFormField(
                  controller: addressController,
                  keyboardType: TextInputType.text,
                  decoration: InputDecoration(
                      labelText: 'Event Address',
                      border: OutlineInputBorder()
                  ),
                ),
                SizedBox(height: 10.0),
                TextFormField(
                  controller: zipController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                      labelText: 'Zip Code',
                      border: OutlineInputBorder()
                  ),
                ),
                SizedBox(height: 10.0),
                TextFormField(
                  controller: priceController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                      labelText: 'Ticket Price (\$)',
                      border: OutlineInputBorder()
                  ),
                ),
                SizedBox(height: 20.0),
                Container(
                  alignment: Alignment.centerLeft,
                  child: Column(children: [
                    Text('Event Type'),
                    DropdownButton<String>(
                      value: dropdownValue = "Bachelor Party",
                      onChanged: (String newValue) {
                        setState(() {
                          dropdownValue = newValue;
                        });
                      },
                      items: <String>["Bachelor Party", "Bachelorette Party",
                        "Concert", "Stripclub", "Other"]
                          .map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                    )
                  ]),

                ),
                SizedBox(height: 20.0),

                Row(children: [
                  SizedBox(
                    child: Checkbox(
                      value: checkbox1,
                      onChanged: (value) {
                        //value may be true or false
                        setState(() {
                          checkbox1 = !checkbox1;
                        });
                      },
                    ),
                  ),
                  SizedBox(width: 10.0),
                  Text('I am over 21 years old')
                ]),
                Row(children: [
                  SizedBox(
                    child: Checkbox(
                      value: checkbox2,
                      onChanged: (value) {
                        //value may be true or false
                        setState(() {
                          checkbox2 = !checkbox2;
                        });
                      },
                    ),
                  ),
                  SizedBox(width: 10.0),
                  Text('I agree to terms and conditions')
                ]),

                ElevatedButton(
                  onPressed: () {
                    saveEvent(v4, uid);
                    // Validate returns true if the form is valid, or false otherwise.
                    if (_formKey.currentState.validate()) {

                    }
                  },
                  child: const Text('Request Goddesses'),
                ),

              ])
          ),
        )
    );
  }
}

class NewEventForm extends StatelessWidget {
  const NewEventForm({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    const appTitle = 'Create A Goddess Moment';

    return MaterialApp(
      title: appTitle,
      home: Scaffold(
        appBar: AppBar(
          title: const Text(appTitle),
        ),
        body: const MyCustomForm(),
      ),
    );
  }
}
/**
class EventForm extends StatefulWidget {
  String uid;
  EventForm({this.uid});

  @override
  MyEventForm createState() => MyEventForm();
}


class MyEventForm extends State<EventForm> {
  @override
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String _title,
      _time,
      _price,
      _address,
      _desc1,
      _desc2,
      _desc3,
      _date,
      _country,
      _category,
      _level,
      _timeEnd,
      _zip;

  TextEditingController titleController = new TextEditingController();
  TextEditingController timeController = new TextEditingController();
  TextEditingController priceController = new TextEditingController();
  TextEditingController placeController = new TextEditingController();
  TextEditingController imageController = new TextEditingController();
  TextEditingController countryController = new TextEditingController();
  TextEditingController categoryController = new TextEditingController();
  TextEditingController desc1Controller = new TextEditingController();
  TextEditingController zipController = new TextEditingController();

  //CurrencyTextInputFormatter currencyFormatter = new CurrencyTextInputFormatter();

  String _setTime, _setTimeEnd, _setDate;

  String _hour, _minute;

  String dateTime;

  DateTime selectedDate = DateTime.now();

  TimeOfDay selectedTime = TimeOfDay(hour: 00, minute: 00);

  TextEditingController _dateController = TextEditingController();
  TextEditingController _timeController = TextEditingController();
  TextEditingController _timeEndController = TextEditingController();

  var PicUrl;

  File _image;
  String filename;

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
    // PicUrl = dowurl.toString();
    // setState(() {
    //   print(" Picture uploaded");
    //   Scaffold.of(context)
    //       .showSnackBar(SnackBar(content: Text(' Picture Uploaded')));
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
    // PicUrl = dowurl.toString();
    // setState(() {
    //   PicUrl = dowurl.toString();
    // });
    // print("download url = $PicUrl");
    // return PicUrl;
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

  Future<Null> _selectTimeEnd(BuildContext context) async {
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
        _timeEndController.text = _time;
        _timeEndController.text = formatDate(
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

  List _listOccassion = ["Bachelor Party", "Bachelorette Party",
    "Concert", "Stripclub", "Other"];
  String _occasion;

// *************************************************

  @override
  Widget build(BuildContext context) {
    // Build a Form widget using the _formKey created above.
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextFormField(
            // The validator receives the text that the user has entered.
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter some text';
              }
              return null;
            },
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16.0),
            child: ElevatedButton(
              onPressed: () {
                // Validate returns true if the form is valid, or false otherwise.
                if (_formKey.currentState!.validate()) {
                  // If the form is valid, display a snackbar. In the real world,
                  // you'd often call a server or save the information in a database.
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Processing Data')),
                  );
                }
              },
              child: const Text('Submit'),
            ),
          ),
        ],
      ),
    );
  }

   Widget build(BuildContext context) {
    // Create uuid object
    var uuid = Uuid();

    // Generate a v4 (random) id
    var v4 = uuid.v4(); // -> '110ec58a-a0f2-4ac4-8393-c866d813b8d1'

    final FirebaseAuth auth = FirebaseAuth.instance;
    final User user = auth.currentUser;
    final uid = user.uid;

    void saveEvent(String v4, String uid) {
      FirebaseFirestore.instance
          .runTransaction((Transaction transaction) async {
            //SharedPreferences prefs;
            //prefs = await SharedPreferences.getInstance();


            FirebaseFirestore.instance
                .collection('event')
                .doc(v4)
                .set({
                  "imageUrl": PicUrl.toString(),
                  "title": _title,
                  "time": _timeController.text,
                  "timeEnd": _timeEndController.text,
                  "address": _address,
                  "zip": _zip,
                  "date": _dateController.text,
                  "desc1": _desc1,
                  "category": _occasion,
                  "id": v4,
                  "uid": uid,
                  "price": _price,
                  "clubLevel": 1,
                  "creationDate": DateTime.now().millisecondsSinceEpoch,
            });
      });
    }

    //return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          "Create A Goddess Moment",
          style: TextStyle(fontFamily: "Sofia", fontWeight: FontWeight.w400),
        ),
      ),
      body: SingleChildScrollView(
        child: Form(
          key: form,
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
                                    image: NetworkImage(
                                        "https://www.generationsforpeace.org/wp-content/uploads/2018/03/empty.jpg"))),
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
                      hintText: "Input your catchy title",
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
                          hintText: "Select Time",
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
                  "End Time",
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
                      _selectTimeEnd(context);
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
                          _setTimeEnd = val;
                        },
                        enabled: false,
                        keyboardType: TextInputType.text,
                        controller: _timeEndController,
                        decoration: InputDecoration(
                          contentPadding: EdgeInsets.all(13.0),
                          hintText: "Select End Time",
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
                        return 'Please input the address';
                      }
                    },
                    maxLines: 2,
                    onSaved: (input) => _address = input,
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
                          hintText: "Select Date",
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
                Padding(
                  padding: const EdgeInsets.only(top: 10.0),
                  child: Container(
                    height: 50.0,
                    width: double.infinity,
                    decoration: BoxDecoration(
                        border: Border.all(width: 1.0, color: Colors.black26),
                        boxShadow: [
                          BoxShadow(
                              blurRadius: 10.0,
                              color: Colors.black12.withOpacity(0.01)),
                        ],
                        borderRadius: BorderRadius.all(Radius.circular(5.0))),
                    child: Padding(
                      padding: const EdgeInsets.only(left: 15.0, right: 15.0),
                      child: DropdownButton(
                        hint: Text(
                          "Category Event",
                          style: TextStyle(
                              fontFamily: "Sofia",
                              color: Colors.black,
                              fontSize: 16.0),
                        ),
                        underline: Container(),
                        style:
                            TextStyle(fontFamily: "Sofia", color: Colors.black),
                        value: _occasion,
                        items: _listOccassion.map((value) {
                          return DropdownMenuItem(
                            child: Text(value),
                            value: value,
                          );
                        }).toList(),
                        onChanged: (value) {
                          setState(() {
                            _occasion = value;
                          });
                        },
                      ),
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
                  height: 20.0,
                ),
                Text(
                  "Ticket Price (\$) ",
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
                        return 'Please input your ticket price';
                      }
                    },
                    maxLines: 1,
                    onSaved: (input) => _price = input,
                    controller: priceController,

                    //initialValue: currencyFormatter.format('100'),
                    //inputFormatters: [CurrencyTextInputFormatter()],
                    keyboardType: TextInputType.number,

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
                      hintText: "Input your ticket price",
                      hintMaxLines: 1,
                      hintStyle: TextStyle(fontFamily: "Sans", fontSize: 15.0),
                    ),
                  ),
                ),


                SizedBox(
                  height: 30.0,
                ),
                InkWell(
                  onTap: () async {
                    // addData();
                    final formState = form.currentState;

                    if (formState.validate()) {
                      formState.save();
                      setState(() {
                        saveEvent(v4, uid);
                        Navigator.of(context).pushAndRemoveUntil(
                            MaterialPageRoute(
                                builder: (context) => bottomNavBar(
                                      idUser: widget.uid,
                                    )),
                            (Route<dynamic> route) => false);
                      });
                    } else {
                      showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: Text("Error"),
                              content: Text("Please input your information"),
                              actions: <Widget>[
                                FlatButton(
                                  child: Text("Close"),
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                )
                              ],
                            );
                          });
                    }
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
                            "Submit",
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
            "Create Event Succes",
            style: TextStyle(fontSize: 17.0),
          ),
        )),
      ],
    ),
  );
}

    */
