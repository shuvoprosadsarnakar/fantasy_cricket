import 'package:fantasy_cricket/resources/colours/color_pallate.dart';
import 'package:fantasy_cricket/pages/home/home.dart';
import 'package:flutter/material.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Padding(
      padding: const EdgeInsets.fromLTRB(45, 0, 45, 0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.all(4.0),
            child: Text(
              "Phone",
              style: TextStyle(color: ColorPallate.ebonyClay, fontSize: 20),
            ),
          ),
          Container(
            decoration: BoxDecoration(
                color: ColorPallate.mercury,
                borderRadius: BorderRadius.all(Radius.circular(10))),
            child: Padding(
              padding: EdgeInsets.fromLTRB(8, 6, 8, 6),
              child: TextFormField(
                cursorColor: Colors.black38,
                decoration: InputDecoration(
                  labelStyle: TextStyle(fontSize: 16),
                  border: InputBorder.none,
                  hintStyle: TextStyle(fontSize: 16),
                  hintText: 'Enter phone 017xxxxxxxx',
                ),
              ),
            ),
          ),
          SizedBox(height: 14),
          Padding(
            padding: const EdgeInsets.all(4.0),
            child: Text(
              "Password",
              style: TextStyle(color: ColorPallate.ebonyClay, fontSize: 20),
            ),
          ),
          Container(
            decoration: BoxDecoration(
                color: ColorPallate.mercury,
                borderRadius: BorderRadius.all(Radius.circular(10))),
            child: Padding(
              padding: EdgeInsets.fromLTRB(8, 6, 8, 6),
              child: TextFormField(
                cursorColor: Colors.black38,
                decoration: InputDecoration(
                  labelStyle: TextStyle(fontSize: 16),
                  border: InputBorder.none,
                  hintStyle: TextStyle(fontSize: 16),
                  hintText: 'Enter password',
                ),
              ),
            ),
          ),
          SizedBox(height: 18),
          TextButton(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                'Login',
                style: TextStyle(fontSize: 20),
              ),
            ),
            style: TextButton.styleFrom(
              shape: RoundedRectangleBorder(
                  borderRadius: new BorderRadius.circular(10)),
              primary: Colors.white,
              backgroundColor: ColorPallate.pomegranate,
            ),
            onPressed: () {
              print('Login button Pressed');
              Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => Home()),
            );
            },
          )
        ],
      ),
    ));
  }
}
