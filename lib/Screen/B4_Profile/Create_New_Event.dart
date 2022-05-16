//import 'dart:html';
import 'dart:io';
import 'dart:ui';
import 'package:goddessGuild/Screen/Bottom_Nav_Bar/bottomNavBar.dart';
import 'package:goddessGuild/constants.dart';
import 'package:goddessGuild/models.dart';
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
import 'package:goddessGuild/db_service.dart';

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
  String category_dropdown = EVENT_TYPES[0];
  DateTime date = DateTime.now();
  TimeOfDay time = TimeOfDay.now();
  DateTime selectedDate = DateTime.now();
  TimeOfDay selectedTime = TimeOfDay(hour: 00, minute: 00);
  int ticketPrice = 0;

  TextEditingController titleController = new TextEditingController();
  TextEditingController descriptionController = new TextEditingController();
  TextEditingController attendanceController = new TextEditingController();
  TextEditingController goddessController = new TextEditingController();
  TextEditingController addressController = new TextEditingController();
  TextEditingController zipController = new TextEditingController();
  TextEditingController phoneController = new TextEditingController();
  TextEditingController priceController = new TextEditingController();
  TextEditingController dateController = TextEditingController();
  TextEditingController timeStartController = new TextEditingController();
  TextEditingController timeEndController = new TextEditingController();
  TextEditingController imageController = new TextEditingController();

  File _photoLocal;
  String _photoDB;
  final ImagePicker _picker = ImagePicker();

  Future imgFromSource({source = ImageSource.gallery}) async {
    // ImageSource.gallery
    // ImageSource.camera
    final pickedFile = await _picker.getImage(source: source);

    setState(() {
      if (pickedFile != null) {
        _photoLocal = File(pickedFile.path);
      } else {
        print('No image selected.');
      }
    });

    _photoDB = await uploadFileToDB(_photoLocal, "event_pic");
  }

  Future<Null> selectDate(BuildContext context) async {
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

  Future<Null> selectTime(BuildContext context, TextEditingController controller) async {
    final TimeOfDay picked = await showTimePicker(
      context: context,
      initialTime: selectedTime,
    );
    if (picked != null)
      setState(() {
        selectedTime = picked;
        controller.text =
            formatDate(DateTime(1, 1, 1, selectedTime.hour, selectedTime.minute), [hh, ':', nn, " ", am]).toString();
      });
  }

// Create uuid object

  void _showPicker(context) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc) {
          return SafeArea(
            child: Container(
              child: new Wrap(
                children: <Widget>[
                  new ListTile(
                      leading: new Icon(Icons.photo_library),
                      title: new Text('Gallery'),
                      onTap: () {
                        imgFromSource();
                        Navigator.of(context).pop();
                      }),
                  new ListTile(
                    leading: new Icon(Icons.photo_camera),
                    title: new Text('Camera'),
                    onTap: () {
                      imgFromSource(source: ImageSource.camera);
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              ),
            ),
          );
        });
  }

  void saveEvent(String v4) {
    addGGEvent(GGEvent(
      image_url: _photoDB,
      title: titleController.text,
      time_start: timeStartController.text,
      time_end: timeEndController.text,
      address: addressController.text,
      zip: int.parse(zipController.text),
      phone: phoneController.text,
      date: dateController.text,
      desc1: descriptionController.text,
      category: category_dropdown,
      doc_id: v4,
      price: ticketPrice, //int.parse(priceController.text),
      club_level: 1, // Hardcoded for now
      goddesses_needed: int.parse(goddessController.text),
      guests_expected: int.parse(attendanceController.text),
    ));
  }

  @override
  Widget build(BuildContext context) {
    var uuid = Uuid();
    var v4 = uuid.v4(); // -> '110ec58a-a0f2-4ac4-8393-c866d813b8d1'
    final spacing = 20.0;

    final FirebaseAuth auth = FirebaseAuth.instance;
    final User user = auth.currentUser;
    final uid = user.uid;

    return Form(
        key: _formKey,
        child: SingleChildScrollView(
            padding: EdgeInsets.all(10.0),
            child: Column(children: [
              SizedBox(height: spacing),
              Container(
                alignment: Alignment.centerLeft,
                child: Column(children: [
                  Text(
                    'Event Type',
                    textAlign: TextAlign.left,
                  ),
                  DropdownButton<String>(
                    value: category_dropdown,
                    onChanged: (String newValue) {
                      setState(() {
                        category_dropdown = newValue;
                      });
                    },
                    items: EVENT_TYPES.map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                  )
                ]),
              ),
              SizedBox(height: spacing),
              TextFormField(
                controller: titleController,
                keyboardType: TextInputType.text,
                decoration: InputDecoration(labelText: 'Event Title', border: OutlineInputBorder()),
                validator: (value) => (value == null ? 'Cannot be empty' : null),
              ),
              SizedBox(height: spacing),
              TextFormField(
                controller: descriptionController,
                keyboardType: TextInputType.text,
                decoration: InputDecoration(labelText: 'Event Description', border: OutlineInputBorder()),
                validator: (value) => (value == null ? 'Cannot be empty' : null),
                maxLines: 5,
                minLines: 3,
              ),
              SizedBox(height: spacing),
              TextFormField(
                controller: attendanceController,
                keyboardType: TextInputType.number,
                validator: (value) => (value == null ? 'Cannot be empty' : null),
                decoration: InputDecoration(labelText: 'Your Crews Estimated Attendance', border: OutlineInputBorder()),
              ),
              SizedBox(height: spacing),
              TextFormField(
                controller: goddessController,
                keyboardType: TextInputType.number,
                validator: (value) => (value == null ? 'Cannot be empty' : null),
                decoration:
                    InputDecoration(labelText: 'Min Number Of Goddess Praying For', border: OutlineInputBorder()),
              ),
              SizedBox(height: spacing),
              TextFormField(
                controller: dateController,
                validator: (value) => (value == null ? 'Cannot be empty' : null),
                decoration: InputDecoration(labelText: 'Date of Gala', border: OutlineInputBorder()),
                onTap: () async {
                  FocusScope.of(context).requestFocus(new FocusNode());
                  selectDate(context);
                },
              ),
              SizedBox(height: spacing),
              TextFormField(
                controller: timeStartController,
                validator: (value) => (value == null ? 'Cannot be empty' : null),
                decoration: InputDecoration(labelText: 'Start Time', border: OutlineInputBorder()),
                onTap: () async {
                  FocusScope.of(context).requestFocus(new FocusNode());
                  selectTime(context, timeStartController);
                },
              ),
              SizedBox(height: spacing),
              TextFormField(
                controller: timeEndController,
                validator: (value) => (value == null ? 'Cannot be empty' : null),
                decoration: InputDecoration(labelText: 'End Time', border: OutlineInputBorder()),
                onTap: () async {
                  FocusScope.of(context).requestFocus(new FocusNode());
                  selectTime(context, timeEndController);
                },
              ),
              SizedBox(height: spacing),
              TextFormField(
                controller: addressController,
                validator: (value) => (value == null ? 'Cannot be empty' : null),
                keyboardType: TextInputType.text,
                decoration: InputDecoration(labelText: 'Event Address', border: OutlineInputBorder()),
              ),
              SizedBox(height: spacing),
              TextFormField(
                controller: zipController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(labelText: 'Zip Code', border: OutlineInputBorder()),
                validator: (value) {
                  if (value.length < 5) {
                    return 'Please enter 5 digit zip';
                  }
                  return null;
                },
              ),
              SizedBox(height: spacing),
              TextFormField(
                controller: phoneController,
                validator: (value) => (value == null ? 'Cannot be empty' : null),
                keyboardType: TextInputType.phone,
                decoration: InputDecoration(labelText: 'Phone (Textable)', border: OutlineInputBorder()),
              ),
              SizedBox(height: spacing),
              (category_dropdown == EVENT_TYPES[2] // "Stripclub"
                  ? TextFormField(
                      controller: priceController,
                      onChanged: (String newValue) {
                        setState(() {
                          ticketPrice = int.parse(priceController.text);
                        });
                      },
                      validator: (value) => (value == null ? 'Cannot be empty' : null),
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(labelText: 'Ticket Price (\$)', border: OutlineInputBorder()),
                    )
                  : SizedBox(height: 1.0)),
              SizedBox(height: 20.0),
              Text('Select an image of your event space (Nicer = better)'),
              SizedBox(height: 20.0),
              GestureDetector(
                onTap: () {
                  _showPicker(context);
                },
                child: CircleAvatar(
                  radius: 80,
                  child: _photoLocal != null
                      ? ClipRRect(
                          borderRadius: BorderRadius.circular(200),
                          child: Image.file(_photoLocal),
                        )
                      : Container(
                          decoration: BoxDecoration(color: Colors.grey[200], borderRadius: BorderRadius.circular(50)),
                          width: 100,
                          height: 100,
                          child: Icon(
                            Icons.camera_alt,
                            color: Colors.grey[800],
                          ),
                        ),
                ),
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
                  _formKey.currentState.save();
                  // Validate returns true if the form is valid, or false otherwise.
                  if (_formKey.currentState.validate()) {
                    setState(() {
                      saveEvent(v4);
                      Navigator.of(context).pushAndRemoveUntil(
                          MaterialPageRoute(
                              builder: (context) => bottomNavBar(
                                    idUser: uid,
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
                              TextButton(
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
                child: const Text('Request Goddesses'),
              ),
            ])));
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
