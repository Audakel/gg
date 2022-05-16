import 'package:goddessGuild/Library/intro_views_flutter-2.4.0/lib/Models/page_view_model.dart';
import 'package:goddessGuild/Library/intro_views_flutter-2.4.0/lib/intro_views_flutter.dart';
import 'package:flutter/material.dart';
import 'ChoseLoginOrSignup.dart';

class onBoarding extends StatefulWidget {
  @override
  _onBoardingState createState() => _onBoardingState();
}

var _fontHeaderStyle = TextStyle(
    color: Colors.white,
    fontFamily: "Arial",
    fontSize: 24.0,
    fontWeight: FontWeight.w800,
    letterSpacing: 1.5);

var _fontDescriptionStyle = TextStyle(
    color: Colors.white,
    fontFamily: "Sans",
    fontSize: 17.0,
    fontWeight: FontWeight.w400);

///
/// Page View Model for on boarding
///
final pages = [
  new PageViewModel(
      pageColor: Colors.black,
      iconColor: Colors.black,
      bubbleBackgroundColor: Colors.black,
      title: Text(
        'Safety',
        style: _fontHeaderStyle,
      ),
      body: Container(
        height: 500.0,
        child: Text(
            'Everyone is background checked, rated and reviewed. Private security '
                'at all events. Masquerade ball masks for anonymity. Everyone is treated'
                'with dignity and respect',
            textAlign: TextAlign.center,
            style: _fontDescriptionStyle
        ),
      ),
      mainImage: Image.asset(
        'assets/image/masks/1.jpg',
        alignment: Alignment.center,
      )),
  new PageViewModel(
      pageColor: Colors.white,
      iconColor: Colors.black,
      bubbleBackgroundColor: Colors.black,
      title: Text(
        'Fantasy',
        style: _fontHeaderStyle.copyWith(
          color: Colors.black,
        )
      ),
      body: Container(
        height: 250.0,
        child: Text(
            'Dancers are given a platform where their creativity shines. '
                'Patrons get to experience a magical, fantasy world. '
                'Each event is a unique experience.',
            textAlign: TextAlign.center,
            style: _fontDescriptionStyle.copyWith(
              color: Colors.black,
            ),
        ),
      ),
      mainImage: Image.asset(
        'assets/icon/masks/2.png',
        height: 285.0,
        width: 285.0,
        alignment: Alignment.center,
      )
  ),
  new PageViewModel(
      pageColor: Colors.black,
      iconColor: Colors.black,
      bubbleBackgroundColor: Colors.black,
      title: Text(
        'Dance Dance Révolution',
        style: _fontHeaderStyle,
      ),
      body: Container(
        height: 250.0,
        child: Text(
                'Level up the adult industry with new technology '
                    'and bring conscious, tantric ideology '
                    'into the next generation of elite '
                    'decentralized gentlemen clubs',
            textAlign: TextAlign.center,
            style: _fontDescriptionStyle),
      ),
      mainImage: Image.asset(
        'assets/image/masks/2.jpg',
        height: 285.0,
        width: 285.0,
        alignment: Alignment.center,
      )),
];

class _onBoardingState extends State<onBoarding> {
  @override
  Widget build(BuildContext context) {
    return IntroViewsFlutter(
      pages,
      pageButtonsColor: Colors.black45,
      skipText: Text(
        "SKIP",
        style: _fontDescriptionStyle.copyWith(
            color: Color(0xFF928CEF),
            fontWeight: FontWeight.w800,
            letterSpacing: 1.0,
            fontSize: 17.0),
      ),
      doneText: Text(
        "DONE",
        style: _fontDescriptionStyle.copyWith(
            color: Color(0xFF928CEF),
            fontWeight: FontWeight.w800,
            letterSpacing: 1.0,
            fontSize: 17.0),
      ),
      onTapDoneButton: () {
        Navigator.of(context).pushReplacement(PageRouteBuilder(
          pageBuilder: (_, __, ___) => new ChoseLogin(),
          transitionsBuilder:
              (_, Animation<double> animation, __, Widget widget) {
            return Opacity(
              opacity: animation.value,
              child: widget,
            );
          },
          transitionDuration: Duration(milliseconds: 1500),
        ));
      },
    );
  }
}
