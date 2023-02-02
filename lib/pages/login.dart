import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../models/firebaseModel.dart';
import '../models/signInModel.dart';
import '../pages/splash.dart';

class Login extends StatelessWidget {
  final SignInModel _signInModel = SignInModel();
  final FirebaseModel _firebaseModel = FirebaseModel();

  void _displayAlert(BuildContext context) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
            title: const Text('ERROR'),
            content: const Text('Unable To Login'),
            elevation: 40,
            actions: <Widget>[
              TextButton(
                onPressed: () => Navigator.pop(context),
                //  color: Theme.of(context).primaryColor,
                child: const Text('Ok'),
              )
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
            Colors.lightBlue[200],
            Colors.white,
            Colors.white,
            Colors.white,
            Colors.greenAccent[100],
          ])),
      //bolor: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.all(25.0),
            child: Hero(
              tag: "sans",
              child: CircleAvatar(
                backgroundColor: Colors.white,
                maxRadius: 140,
                child: const Image(
                  height: 250,
                  width: 250,
                  image: AssetImage('assets/sanskritivelogo.jpeg'),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Center(
              child: MaterialButton(
                minWidth: MediaQuery.of(context).size.width * 0.7,
                splashColor: Colors.red,
                padding: const EdgeInsets.all(10),
                shape: const StadiumBorder(
                  side: BorderSide(
                    color: Colors.grey,
                    width: 2,
                  ),
                ),
                onPressed: () async {
                  try {
                    User user = await _signInModel.signInGoogle();
                    await _firebaseModel.uploadUserData(user);
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => Splash(),
                      ),
                    );
                  } catch (e) {
                    _displayAlert(context);
                  }
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Image.asset(
                      'assets/google_logo.png',
                      width: 20,
                      height: 30,
                    ),
                    const SizedBox(
                      width: 6,
                    ),
                    const Text(
                      'Login with Google',
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
