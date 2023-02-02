import 'package:flutter/material.dart';


class RoundButton extends StatelessWidget {
  const RoundButton({this.title, this.color1, this.color2, @required this.onPressed});

  final String title;
  final Color color1;
  final Function onPressed;
  final Color color2;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 16.0),
      child: Material(
        shadowColor: Colors.white,
        elevation: 15.0,
        // color: color,

        borderRadius: BorderRadius.circular(40.0),
        child: Container(
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(40),
              gradient: LinearGradient(
                colors: [color1, color2],
              )),
          child: MaterialButton(
            //padding: EdgeInsets.only(left: 15,right: 15),
            onPressed: onPressed,
            minWidth: 200,
            height: 42.0,
            child: Text(
              title,
              style: TextStyle(
                color: Colors.white,
              ),
            ),
          ),
        ),
      ),
    );
  }
}