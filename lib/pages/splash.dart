import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/data.dart';

import '../bottomNavigation.dart';
import '../models/dataModel.dart';
import '../models/firebaseModel.dart';
import 'login.dart';

class Splash extends StatefulWidget {
  @override
  _SplashState createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  FirebaseModel firebaseModel = FirebaseModel();
  final Image img = Image(
    image: const AssetImage(
      'assets/sanskritivelogo.jpeg',
    ),
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: AnimatedContainer(
          //transform: Matrix4(Arg),
          //  color: Colors.white,
          curve: Curves.easeInOut,
          duration: Duration(seconds: 3),
          child: Hero(
            tag: "sans",
            child: Image(
              image: AssetImage('assets/sanskritivelogo.jpeg'),
            ),
          ),
        ),
      ),
    );
  }

  void _navigationCondition() async {
    try {
      print('i/m here');
      await firebaseModel.initializeFirebase();
      _conditionVerification();
      print('Success in firebase');
    } catch (e) {
      _conditionVerification();
      print('firebase not set up correctly');
      print('the error in splash is ${e.toString()}');
    }
  }

  void _conditionVerification() async {
    User user = FirebaseAuth.instance.currentUser;
    try {
      print('user id is ' + user.uid);
      firebaseModel.initializeCollection(user.uid);
      DataModel dataModel = await firebaseModel.getUserDataFromCloud(user.uid);
      Provider.of<Data>(context, listen: false)
          .storeReceivedForMe(dataModel.receivedForMe);
      Provider.of<Data>(context, listen: false)
          .storeSentByMe(dataModel.sentByMe);
      _navigateToHome();
    } catch (e) {
      _navigateToLogin();
    }
  }

  _navigateToLogin() {
    Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (context) => Login(),
        ),
        (route) => false);
  }

  _navigateToHome() {
    Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (context) => BottomPanel(),
        ),
        (route) => false);
  }

  @override
  void initState() {
    super.initState();
    _navigationCondition();
  }
}
