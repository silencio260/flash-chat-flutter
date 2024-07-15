import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flash_chat/components/roundedButtton.dart';
import 'login_screen.dart';
import 'registration_screen.dart';
import 'package:flash_chat/piracy_checker.dart';

class WelcomeScreen extends StatefulWidget {
  static String id = 'welcome_screen';

  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> with SingleTickerProviderStateMixin {
  AnimationController controller;
  Animation animation;
  bool isPirated;
  String downloadSource;

  @override
  void initState() {
    initPiracy();
    super.initState();
    controller = AnimationController(
      duration: Duration(seconds: 1),
      vsync: this,
    );

    animation = ColorTween(begin: Colors.red, end: Colors.blue).animate(controller);

    controller.addListener(() {
      setState(() {
//        print(animation.value);
      });
    });
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  void initPiracy() async {
//    bool p = await PiracyChecker();
    setState(() async {
      if (!kDebugMode) {
        isPirated = await PiracyChecker();
        downloadSource = source;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Row(
              children: <Widget>[
                Hero(
                  tag: 'logo',
                  child: Container(
                    child: Image.asset('images/logo.png'),
                    height: 80.0,
                  ),
                ),
                TyperAnimatedTextKit(
                  text: ['Flash News'],
                  textStyle: TextStyle(
                    fontSize: 40.0,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 48.0,
            ),
            RoundedButton(
              title: 'Log In',
              colour: Colors.lightBlueAccent,
              onPressed: isPirated == true
                  ? null
                  : () {
                      Navigator.pushNamed(context, LoginScreen.id);
                    },
            ),
            RoundedButton(
              title: 'Register',
              colour: Colors.blueAccent,
              onPressed: isPirated == true
                  ? null
                  : () {
                      Navigator.pushNamed(context, RegistrationScreen.id);
                    },
            ),
            Container(
                child: isPirated == true
                    ? Text(
                        " $downloadSource! This App Was Pirated Please Download From The APPStore of PlayStore",
                        style: TextStyle(color: Colors.red))
                    : Text(
                        "This App Was downloaded From PlayStore",
                        style: TextStyle(color: Colors.green),
                      )),
          ],
        ),
      ),
    );
  }
}
