import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'dart:convert';

import '../component/loginForm.dart';
import '../component/signupForm.dart';

class SignupPage extends StatelessWidget {
  const SignupPage({super.key});

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
        child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Container(
          padding: const EdgeInsets.fromLTRB(24, 0, 0, 24),
          alignment: Alignment.centerLeft,
          child: const Text(
            "MooTube",
            style: TextStyle(
                color: Colors.white,
                fontFamily: 'Gugi',
                fontWeight: FontWeight.bold,
                fontSize: 46),
            textAlign: TextAlign.left,
          ),
        ),
        Center(
          child: Padding(padding: EdgeInsets.all(24.0), child: SignupForm()),
        ),
      ],
    ));
  }
}
