import 'dart:async';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:goddessGuild/Library/loader_animation/dot.dart';
import 'package:goddessGuild/Library/loader_animation/loader.dart';
import 'package:goddessGuild/Screen/Bottom_Nav_Bar/bottomNavBar.dart';
import 'package:goddessGuild/constants.dart';
import 'package:goddessGuild/db_service.dart';
import 'package:goddessGuild/models.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'login.dart';

class ErrMsg extends StatelessWidget {
  final String msg;

  ErrMsg(this.msg);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text("Error"),
      content: Text(msg),
      actions: <Widget>[
        FlatButton(
          child: Text("Close"),
          onPressed: () {
            Navigator.of(context).pop();
          },
        )
      ],
    );
  }
}

class LoaderSpinner extends StatelessWidget {
  AnimationController _controller;
  Animation<Color> _colorTween;
  BuildContext context;

  LoaderSpinner({this.context});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: AnimatedBuilder(
        animation: _colorTween,
        builder: (BuildContext _, Widget __) {
          return Container(
            width: 300,
            height: 300,
            color: _colorTween.value,
          );
        },
      ),
    );
  }

  void dispose() {
    _controller.dispose();
  }

  void initState() {
    _controller = AnimationController(duration: Duration(seconds: 3), vsync: null);
    _controller.repeat(reverse: true);

    _colorTween = ColorTween(begin: Colors.deepOrange, end: Colors.deepPurple).animate(_controller);
  }
}

class signUp extends StatefulWidget {
  @override
  _signUpState createState() => _signUpState();
}

class _signUpState extends State<signUp> {
  bool _isSelected = false;
  bool imageUpload = true;
  bool isLoading = false;
  String city_dropdown;
  String user_type_dropdown;

  final GlobalKey<FormState> _registerFormKey = GlobalKey<FormState>();
  String _email, _pass, _pass2, _name, _refered_by, _city;
  TextEditingController signupEmailController = new TextEditingController();
  TextEditingController refered_by_controller = new TextEditingController();
  TextEditingController signupCityController = new TextEditingController();
  TextEditingController signupNameController = new TextEditingController();
  TextEditingController signupPasswordController = new TextEditingController();
  TextEditingController signupConfirmPasswordController = new TextEditingController();

  File _photoLocal = null;

  String _photoDB = null;
  final ImagePicker _picker = ImagePicker();
  bool _obscureTextSignup = true;

  bool _obscureTextSignupConfirm = true;

  @override
  void initState() {
    city_dropdown = SUPPORTED_CITIES[0];
    user_type_dropdown = USER_TYPE[0];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    ScreenUtil.instance = ScreenUtil.getInstance()..init(context);
    ScreenUtil.instance = ScreenUtil(width: 750, height: 1334, allowFontScaling: true);

    return new Scaffold(
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset: true,
      body: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: <Widget>[
              Padding(
                padding: EdgeInsets.only(top: 20.0),
                child: Image.asset(
                  "assets/image/image_01.png",
                  height: 250.0,
                ),
              ),
              Expanded(
                child: Container(),
              ),
              Image.asset("assets/image/image_02.png")
            ],
          ),
          SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.only(left: 28.0, right: 28.0, top: 100.0),
              child: Column(
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      SizedBox(height: 20.0),
                      Text(COMPANY_NAME,
                          style: TextStyle(
                              fontFamily: "Sofia",
                              fontSize: ScreenUtil.getInstance().setSp(60),
                              letterSpacing: 1.2,
                              color: Colors.black87,
                              fontWeight: FontWeight.bold))
                    ],
                  ),
                  SizedBox(
                    height: ScreenUtil.getInstance().setHeight(180),
                  ),
                  Container(
                    width: double.infinity,
                    decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(8.0), boxShadow: [
                      BoxShadow(color: Colors.black12.withOpacity(0.08), offset: Offset(0.0, 15.0), blurRadius: 15.0),
                      BoxShadow(color: Colors.black12.withOpacity(0.01), offset: Offset(0.0, -10.0), blurRadius: 10.0),
                    ]),
                    child: Padding(
                      padding: EdgeInsets.only(left: 0.0, right: 0.0, top: 0.0),
                      child: Form(
                        key: _registerFormKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Container(
                              width: 120.0,
                              height: 45.0,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.only(bottomRight: Radius.circular(80.0)),
                                color: Color(0xFFD898F8),
                              ),
                              child: Center(
                                child: Text("Signup",
                                    style: TextStyle(
                                        fontSize: ScreenUtil.getInstance().setSp(32),
                                        fontFamily: "Sofia",
                                        fontWeight: FontWeight.w600,
                                        color: Colors.white,
                                        letterSpacing: .63)),
                              ),
                            ),
                            SizedBox(
                              height: ScreenUtil.getInstance().setHeight(30),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 20.0, right: 20.0),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Center(
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: <Widget>[
                                        Container(
                                          height: 100.0,
                                          width: 100.0,
                                          decoration: BoxDecoration(
                                              borderRadius: BorderRadius.all(Radius.circular(50.0)),
                                              color: Colors.blueAccent,
                                              boxShadow: [BoxShadow(color: Colors.black12.withOpacity(0.1), blurRadius: 10.0, spreadRadius: 4.0)]),
                                          child: _photoLocal == null
                                              ? new Stack(
                                                  children: <Widget>[
                                                    CircleAvatar(
                                                      backgroundColor: Colors.blueAccent,
                                                      radius: 400.0,
                                                      backgroundImage: AssetImage(
                                                        "assets/image/emptyProfilePicture.png",
                                                      ),
                                                    ),
                                                    Align(
                                                      alignment: Alignment.bottomRight,
                                                      child: InkWell(
                                                        onTap: () {
                                                          pickImage();
                                                        },
                                                        child: Container(
                                                          height: 30.0,
                                                          width: 30.0,
                                                          decoration: BoxDecoration(
                                                            borderRadius: BorderRadius.all(Radius.circular(50.0)),
                                                            color: Colors.blueAccent,
                                                          ),
                                                          child: Center(
                                                            child: Icon(
                                                              Icons.add,
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
                                                  backgroundImage: new FileImage(_photoLocal),
                                                  radius: 220.0,
                                                ),
                                        ),
                                        SizedBox(
                                          height: 10.0,
                                        ),
                                        Text(
                                          "Photo Profile",
                                          style: TextStyle(fontFamily: "Sofia", fontWeight: FontWeight.w600),
                                        ),
                                      ],
                                    ),
                                  ),
                                  SizedBox(
                                    height: 10.0,
                                  ),
                                  Text("Name",
                                      style: TextStyle(
                                          fontFamily: "Sofia",
                                          fontSize: ScreenUtil.getInstance().setSp(30),
                                          letterSpacing: .9,
                                          fontWeight: FontWeight.w600)),
                                  TextFormField(
                                    validator: (input) {
                                      if (input.isEmpty) {
                                        return 'Please input your name';
                                      }
                                    },
                                    onSaved: (input) => _name = input,
                                    controller: signupNameController,
                                    keyboardType: TextInputType.text,
                                    textCapitalization: TextCapitalization.words,
                                    style: TextStyle(fontFamily: "WorkSofiaSemiBold", fontSize: 16.0, color: Colors.black),
                                    decoration: InputDecoration(
                                      border: InputBorder.none,
                                      icon: Icon(
                                        FontAwesomeIcons.user,
                                        size: 19.0,
                                        color: Colors.black45,
                                      ),
                                      hintText: "Your name at events",
                                      hintStyle: TextStyle(fontFamily: "Sofia", fontSize: 15.0),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 10.0,
                                  ),
                                  Text("Referred by",
                                      style: TextStyle(
                                          fontFamily: "Sofia",
                                          fontSize: ScreenUtil.getInstance().setSp(30),
                                          letterSpacing: .9,
                                          fontWeight: FontWeight.w600)),
                                  TextFormField(
                                    validator: (input) {
                                      if (input.isEmpty) {
                                        return 'Who referred you?';
                                      }
                                    },
                                    onSaved: (input) => _refered_by = input,
                                    controller: refered_by_controller,
                                    keyboardType: TextInputType.text,
                                    textCapitalization: TextCapitalization.words,
                                    style: TextStyle(fontFamily: "WorkSofiaSemiBold", fontSize: 16.0, color: Colors.black),
                                    decoration: InputDecoration(
                                      border: InputBorder.none,
                                      icon: Icon(
                                        FontAwesomeIcons.mask,
                                        size: 19.0,
                                        color: Colors.black45,
                                      ),
                                      hintText: "Their username or code",
                                      hintStyle: TextStyle(fontFamily: "Sofia", fontSize: 15.0),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 10.0,
                                  ),
                                  Text("City",
                                      style: TextStyle(
                                          fontFamily: "Sofia",
                                          fontSize: ScreenUtil.getInstance().setSp(30),
                                          letterSpacing: .9,
                                          fontWeight: FontWeight.w600)),
                                  DropdownButtonFormField(
                                    items: SUPPORTED_CITIES.map<DropdownMenuItem<String>>((String value) {
                                      return DropdownMenuItem<String>(
                                        value: value,
                                        child: Text(value),
                                      );
                                    }).toList(),
                                    onChanged: (String newValue) {
                                      setState(() {
                                        city_dropdown = newValue;
                                      });
                                    },
                                    decoration: InputDecoration(
                                      border: InputBorder.none,
                                      icon: Icon(
                                        FontAwesomeIcons.city,
                                        size: 19.0,
                                        color: Colors.black45,
                                      ),
                                      hintText: "City",
                                      hintStyle: TextStyle(fontFamily: "Sofia", fontSize: 15.0),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 10.0,
                                  ),
                                  Text("I am a ",
                                      style: TextStyle(
                                          fontFamily: "Sofia",
                                          fontSize: ScreenUtil.getInstance().setSp(30),
                                          letterSpacing: .9,
                                          fontWeight: FontWeight.w600)
                                  ),
                                  SizedBox(
                                    height: 10.0,
                                  ),
                                  DropdownButtonFormField(
                                    items: USER_TYPE.map<DropdownMenuItem<String>>((String value) {
                                      return DropdownMenuItem<String>(
                                        value: value,
                                        child: Text(value),
                                      );
                                    }).toList(),
                                    onChanged: (String newValue) {
                                      setState(() {
                                        user_type_dropdown = newValue;
                                      });
                                    },
                                    decoration: InputDecoration(
                                      border: InputBorder.none,
                                      icon: Icon(
                                        FontAwesomeIcons.deviantart,
                                        size: 19.0,
                                        color: Colors.black45,
                                      ),
                                      hintText: "User Type",
                                      hintStyle: TextStyle(fontFamily: "Sofia", fontSize: 15.0),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 10.0,
                                  ),
                                  Text("Email",
                                      style: TextStyle(
                                          fontFamily: "Sofia",
                                          fontSize: ScreenUtil.getInstance().setSp(30),
                                          letterSpacing: .9,
                                          fontWeight: FontWeight.w600)),
                                  TextFormField(
                                    validator: (input) {
                                      if (input.isEmpty) {
                                        return 'Please input your email';
                                      }
                                    },
                                    onSaved: (input) => _email = input,
                                    controller: signupEmailController,
                                    keyboardType: TextInputType.emailAddress,
                                    style: TextStyle(fontFamily: "WorkSofiaSemiBold", fontSize: 16.0, color: Colors.black),
                                    decoration: InputDecoration(
                                      border: InputBorder.none,
                                      icon: Icon(
                                        FontAwesomeIcons.envelope,
                                        color: Colors.black45,
                                        size: 18.0,
                                      ),
                                      hintText: "Email Address",
                                      hintStyle: TextStyle(fontFamily: "Sofia", fontSize: 16.0),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 10.0,
                                  ),
                                  Text("Password",
                                      style: TextStyle(
                                          fontFamily: "Sofia",
                                          fontSize: ScreenUtil.getInstance().setSp(30),
                                          letterSpacing: .9,
                                          fontWeight: FontWeight.w600)),
                                  TextFormField(
                                    controller: signupPasswordController,
                                    obscureText: _obscureTextSignup,
                                    validator: (input) {
                                      if (input.isEmpty) {
                                        return 'Please input your password';
                                      }
                                    },
                                    onSaved: (input) => _pass = input,
                                    style: TextStyle(fontFamily: "WorkSofiaSemiBold", fontSize: 16.0, color: Colors.black45),
                                    decoration: InputDecoration(
                                      border: InputBorder.none,
                                      icon: Icon(
                                        FontAwesomeIcons.lock,
                                        color: Colors.black45,
                                        size: 18.0,
                                      ),
                                      hintText: "Password",
                                      hintStyle: TextStyle(fontFamily: "Sofia", fontSize: 16.0),
                                      suffixIcon: GestureDetector(
                                        onTap: () {
                                          _toggleSignup();
                                        },
                                        child: Icon(
                                          FontAwesomeIcons.eye,
                                          size: 15.0,
                                          color: Colors.black,
                                        ),
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 10.0,
                                  ),
                                  SizedBox(
                                    height: ScreenUtil.getInstance().setHeight(35),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: ScreenUtil.getInstance().setHeight(40)),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Row(
                        children: <Widget>[
                          SizedBox(
                            width: 12.0,
                          ),
                          GestureDetector(
                            onTap: _radio,
                            child: radioButton(_isSelected),
                          ),
                          SizedBox(
                            width: 8.0,
                          ),
                          Text("Remember me", style: TextStyle(fontWeight: FontWeight.w600, fontSize: 12, fontFamily: "Poppins-Medium"))
                        ],
                      ),
                      InkWell(
                        child: isLoading
                            ? Container(
                                width: ScreenUtil.getInstance().setWidth(330),
                                height: ScreenUtil.getInstance().setHeight(100),
                                child:
                                    //SpinKitPumpingHeart(color: Color(0xFFD898F8)))
                                    SpinKitPumpingHeart(
                                  //FadingCircle(
                                  //color: Color(0xFFD898F8),
                                  itemBuilder: (BuildContext context, int index) {
                                    return DecoratedBox(
                                      decoration: BoxDecoration(
                                        color: index.isEven ? Color(0xFFD898F8) : Color(0xFF8189EC),
                                      ),
                                    );
                                  },
                                ))
                            : Container(
                                width: ScreenUtil.getInstance().setWidth(330),
                                height: ScreenUtil.getInstance().setHeight(100),
                                decoration: BoxDecoration(
                                    gradient: LinearGradient(colors: [Color(0xFFD898F8), Color(0xFF8189EC)]),
                                    borderRadius: BorderRadius.circular(6.0),
                                    boxShadow: [BoxShadow(color: Color(0xFF6078ea).withOpacity(.3), offset: Offset(0.0, 8.0), blurRadius: 8.0)]),
                                child: Material(
                                  color: Colors.transparent,
                                  child: InkWell(
                                    onTap: () async {
                                      setState(() {
                                        isLoading = true;
                                      });

                                      /////////
                                      final formState = _registerFormKey.currentState;

                                      if (!formState.validate()) {
                                        //errMsg(context, "Missing field");
                                        setState(() {
                                          isLoading = false;
                                        });
                                      } else {
                                        formState.save();
                                        var signupErr = false;
                                        GGUser ggUser;

                                        UserCredential result = await FirebaseAuth.instance
                                            .createUserWithEmailAndPassword(
                                                email: signupEmailController.text, password: signupPasswordController.text)
                                            .catchError((err) {
                                          print(err);
                                          errMsg(context, err.toString());
                                          signupErr = true;
                                          setState(() {
                                            isLoading = false;
                                          });
                                        });

                                        if (!signupErr) {
                                          _photoDB = await uploadFileToDB(_photoLocal, "user_profile");

                                          ggUser = GGUser(
                                              name: signupNameController.text,
                                              email: signupEmailController.text,
                                              referred_by: refered_by_controller.text,
                                              city: city_dropdown,
                                              user_type: user_type_dropdown,
                                              level: 0,
                                              rating: 5.0,
                                              profile_photo: _photoDB == null ? EMPTY_PROFILE : _photoDB.toString());

                                          await addNewUserInfo(ggUser).catchError((err) {
                                            print(err);
                                            errMsg(context, err.toString());
                                          });

                                          SharedPreferences gg_prefs = await SharedPreferences.getInstance();

                                          gg_prefs.setString("username", ggUser.name);
                                          gg_prefs.setString("user_type", ggUser.user_type);
                                          gg_prefs.setString("uid", ggUser.uid);
                                          gg_prefs.setString("city", ggUser.city);

                                          Navigator.of(context).pushReplacement(PageRouteBuilder(
                                              pageBuilder: (_, __, ___) => new bottomNavBar(
                                                    idUser: getUID(),
                                                  )));
                                        }
                                      }
                                    },
                                    child: Center(
                                      child: Text("SIGNUP",
                                          style: TextStyle(color: Colors.white, fontFamily: "Poppins-Bold", fontSize: 18, letterSpacing: 1.0)),
                                    ),
                                  ),
                                ),
                              ),
                      )
                    ],
                  ),
                  SizedBox(
                    height: ScreenUtil.getInstance().setHeight(40),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      horizontalLine(),
                      Text("Have Account?", style: TextStyle(fontSize: 13.0, fontFamily: "Sofia")),
                      horizontalLine()
                    ],
                  ),
                  SizedBox(
                    height: ScreenUtil.getInstance().setHeight(30),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[],
                  ),
                  SizedBox(
                    height: ScreenUtil.getInstance().setHeight(0),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      InkWell(
                        onTap: () {
                          Navigator.of(context).pushReplacement(PageRouteBuilder(pageBuilder: (_, __, ___) => login()));
                        },
                        child: Container(
                          height: 50.0,
                          width: 300.0,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(40.0)),
                            border: Border.all(color: Color(0xFFD898F8), width: 1.0),
                          ),
                          child: Center(
                            child: Text("SignIn",
                                style: TextStyle(
                                    color: Color(0xFFD898F8), fontWeight: FontWeight.w300, letterSpacing: 1.4, fontSize: 15.0, fontFamily: "Sofia")),
                          ),
                        ),
                      )
                    ],
                  ),
                  SizedBox(
                    height: 40.0,
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  void errMsg(BuildContext context, String msg) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return ErrMsg(msg);
        });
  }

  Widget horizontalLine() => Padding(
        padding: EdgeInsets.symmetric(horizontal: 5.0),
        child: Container(
          width: ScreenUtil.getInstance().setWidth(120),
          height: 1.0,
          color: Colors.black26.withOpacity(.2),
        ),
      );

  Future pickImage({source = ImageSource.gallery}) async {
    // ImageSource.gallery
    // ImageSource.camera
    final pickedFile = await _picker.getImage(source: ImageSource.gallery);

    setState(() {
      if (pickedFile != null) {
        _photoLocal = File(pickedFile.path);
      } else {
        print('No image selected.');
      }
    });
  }

  Widget radioButton(bool isSelected) => Container(
        width: 16.0,
        height: 16.0,
        padding: EdgeInsets.all(2.0),
        decoration: BoxDecoration(shape: BoxShape.circle, border: Border.all(width: 2.0, color: Colors.black)),
        child: isSelected
            ? Container(
                width: double.infinity,
                height: double.infinity,
                decoration: BoxDecoration(shape: BoxShape.circle, color: Colors.black),
              )
            : Container(),
      );

  ///
  /// Response file from image picker
  ///
  Future<void> retrieveLostData() async {
    final LostDataResponse response = await ImagePicker.retrieveLostData();
    if (response == null) {
      return;
    }
    if (response.file != null) {
      setState(() {
        if (response.type == RetrieveType.video) {
        } else {}
      });
    } else {}
  }

  void _radio() {
    setState(() {
      _isSelected = !_isSelected;
    });
  }

  ///
  /// Show password
  ///
  void _toggleSignup() {
    setState(() {
      _obscureTextSignup = !_obscureTextSignup;
    });
  }

  ///
  /// Show password
  ///
  void _toggleSignupConfirm() {
    setState(() {
      _obscureTextSignupConfirm = !_obscureTextSignupConfirm;
    });
  }
}
